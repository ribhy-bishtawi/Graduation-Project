import asyncHandler from 'express-async-handler';
import { Request, Response, NextFunction, Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticate, allowedTo } from '@/api/v1/middleware/auth';
import { ApiError } from '@/core/base/apiError';
import { TagUseCase } from '@/core/usecase/tag.usecase';
import { TagRepository } from '@/db/prisma/tagRepository';
import { EntityTagUseCase } from '@/core/usecase/entityTag.usecase';
import { EntityTagRepository } from '@/db/prisma/entityTagRepository';
import { AddressTagUseCase } from '@/core/usecase/addressTag.usecase';
import { AddressTagRepository } from '@/db/prisma/addressTagRepository';
import { validateRequest } from '@/api/v1/middleware/validate';
import { CreateTagRequest } from '@/core/validation/CreateTagRequest';
import { AlgoliaUseCase } from '@/core/usecase/algolia.usecase';

export function TagRoute(prisma: PrismaClient) {
  const router = Router();

  const tagUseCase = new TagUseCase(new TagRepository(prisma));
  const entityTagUseCase = new EntityTagUseCase(
    new EntityTagRepository(prisma)
  );
  const addressTagUseCase = new AddressTagUseCase(
    new AddressTagRepository(prisma)
  );

  const algoliaUseCase = new AlgoliaUseCase(prisma);

  // Create tag
  router.post(
    '/',
    authenticate,
    allowedTo('store_owner', 'admin', 'super_admin', 'treesal'),
    validateRequest(CreateTagRequest),
    asyncHandler(async (req: Request, res: Response) => {
      const { arabicName, englishName } = req.body;

      const id = await tagUseCase.createTag({ arabicName, englishName });

      res.status(201).json({ id });
    })
  );

  // Get all tags
  router.get(
    '/',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const pageNumber = Number(req.query.pageNumber) || 1;
      const pageSize = Number(req.query.pageSize) || 10;
      const filters = {
        id: Number(req.query.id),
        arabicName: req.query.arabicName?.toString(),
        englishName: req.query.englishName?.toString(),
      };
      const sort = {
        field: req.query.sortField?.toString(),
        order: req.query.sortOrder?.toString(),
      };

      // Validation
      const checkValidation = await tagUseCase.validateParameters(
        pageNumber,
        pageSize,
        filters,
        sort
      );
      if (checkValidation !== 'OK') {
        return next(new ApiError(checkValidation, 400));
      }

      // Get limit and offset for pagination
      const limit = Number(pageSize);
      const offset = (Number(pageNumber) - 1) * limit;

      const { tags, totaltags } = await tagUseCase.getAllTags(
        limit,
        offset,
        filters,
        sort
      );

      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totaltags,
        totalPages: Math.ceil(totaltags / limit),
      };

      res.status(200).json({
        tags,
        metaData,
      });
    })
  );

  // Get tag by id
  router.get(
    '/:id',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate tag exists
      const tag = await tagUseCase.getTagById(id);
      if (!tag) {
        return next(new ApiError('Tag does not exist!', 404));
      }

      // Get the count of entities that have this tag
      const entityTagsCount = await entityTagUseCase.countAllEntityTagsByTagId(
        id
      );

      // Get the count of addresses that have this tag
      const addressTagsCount =
        await addressTagUseCase.countAllAddressTagsByTagId(id);

      // Add entityTagsCount and addressTagsCount to tag object
      tag.entityTagsCount = entityTagsCount;
      tag.addressTagsCount = addressTagsCount;

      res.status(200).json(tag);
    })
  );

  // Update tag by id
  router.put(
    '/:id',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateTagRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { arabicName, englishName } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate tag exists
      const tag = await tagUseCase.getTagById(id);
      if (!tag) {
        return next(new ApiError('Tag does not exist!', 404));
      }

      // Update tag
      await tagUseCase.updateTagById(id, {
        arabicName,
        englishName,
      });

      // --------------------------------------------------------
      // Algolia

      // get addressTags by tag id
      const addressTags = await addressTagUseCase.getAddressTagsByTagId(id);

      // get entityTags by tag id
      const entityTags = await entityTagUseCase.getEntityTagsByTagId(id);

      // get all entities ids that have this tag
      const entitysIdsFromEntityTag = entityTags.map(
        entityTag => entityTag.entityId
      );

      const entitysIdsFromAddressTag = addressTags.map(
        addressTag => addressTag.address?.entityId
      );

      // get all entities ids that have this tag
      const entitysIds = [
        ...new Set([...entitysIdsFromEntityTag, ...entitysIdsFromAddressTag]),
      ];

      // Update entities in algolia
      for (const entityId of entitysIds) {
        if (entityId) {
          await algoliaUseCase.updateEntityToAlgolia(entityId);
        }
      }

      // --------------------------------------------------------

      res.status(204).send();
    })
  );

  // Delete tag by id
  router.delete(
    '/:id',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate tag exists
      const tag = await tagUseCase.getTagById(id);
      if (!tag) {
        return next(new ApiError('Tag does not exist!', 404));
      }

      // --------------------------------------------------------
      // Algolia

      // get addressTags by tag id
      const addressTags = await addressTagUseCase.getAddressTagsByTagId(id);

      // get entityTags by tag id
      const entityTags = await entityTagUseCase.getEntityTagsByTagId(id);

      // get all entities ids that have this tag
      const entitysIdsFromEntityTag = entityTags.map(
        entityTag => entityTag.entityId
      );

      const entitysIdsFromAddressTag = addressTags.map(
        addressTag => addressTag.address?.entityId
      );

      // get all entities ids that have this tag
      const entitysIds = [
        ...new Set([...entitysIdsFromEntityTag, ...entitysIdsFromAddressTag]),
      ];

      // Update entities in algolia
      for (const entityId of entitysIds) {
        if (entityId) {
          await algoliaUseCase.updateEntityToAlgolia(entityId);
        }
      }

      // --------------------------------------------------------

      // Delete all entities that have this tag
      await entityTagUseCase.deleteEntityTagByTagId(id);

      // Delete all addresses that have this tag
      await addressTagUseCase.deleteAddressTagByTagId(id);

      // Delete tag
      await tagUseCase.deleteTagById(id);

      res.status(204).send();
    })
  );

  return router;
}
