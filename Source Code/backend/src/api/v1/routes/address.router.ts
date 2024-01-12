import asyncHandler from 'express-async-handler';
import { Request, Response, NextFunction, Router } from 'express';
import { PrismaClient } from '@prisma/client';

import { ApiError } from '@/core/base/apiError';
import { AddressUsecase } from '@/core/usecase/address.usecase';
import { AddressRepository } from '@/db/prisma/addressRepository';
import { EntityUseCase } from '@/core/usecase/entity.usecase';
import { EntityRepository } from '@/db/prisma/entityRepository';
import { validateRequest } from '@/api/v1/middleware/validate';
import { CreateAddressRequest } from '@/core/validation/CreateAddressRequest';
import { authenticate } from '@/api/v1/middleware/auth';
import { AddressTagUseCase } from '@/core/usecase/addressTag.usecase';
import { AddressTagRepository } from '@/db/prisma/addressTagRepository';
import { TagUseCase } from '@/core/usecase/tag.usecase';
import { TagRepository } from '@/db/prisma/tagRepository';
import { UpdateAddressTagRequest } from '@/core/validation/UpdateAddressTagRequest';
import { RequestWithUser } from '@/api/v1/helpers/types';
import { AlgoliaUseCase } from '@/core/usecase/algolia.usecase';

export function AddressRoute(prisma: PrismaClient) {
  const router = Router();

  const addressUseCase = new AddressUsecase(new AddressRepository(prisma));
  const entityUseCase = new EntityUseCase(new EntityRepository(prisma));
  const addressTagUseCase = new AddressTagUseCase(
    new AddressTagRepository(prisma)
  );
  const tagUseCase = new TagUseCase(new TagRepository(prisma));
  const algoliaUseCase = new AlgoliaUseCase(prisma);

  // Create address
  router.post(
    '/',
    authenticate,
    validateRequest(CreateAddressRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { arabicName, englishName, lat, long, entityId } = req.body;

      // Validate entity exists
      const entity = await entityUseCase.getEntityById(entityId);
      if (!entity) {
        return next(new ApiError('Entity not found', 404));
      }

      // validate auth
      const loggedUser = (req as RequestWithUser).user;
      const allowedTypes = ['admin', 'super_admin', 'treesal'];

      if (
        !allowedTypes.includes(loggedUser.type) &&
        loggedUser.id !== entity.ownerId
      ) {
        return next(
          new ApiError('You are not allowed to access this route', 403)
        );
      }

      const id = await addressUseCase.createAddress({
        arabicName,
        englishName,
        lat,
        long,
        entityId,
      });

      // Update entity in algolia
      await algoliaUseCase.updateEntityToAlgolia(entityId);

      res.status(201).json({ id });
    })
  );

  // Get all addresses
  router.get(
    '/',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const pageNumber = Number(req.query.pageNumber) || 1;
      const pageSize = Number(req.query.pageSize) || 10;
      const filters = {
        id: Number(req.query.id),
        arabicName: req.query.arabicName?.toString(),
        englishName: req.query.englishName?.toString(),
        entityId: Number(req.query.entityId),
      };
      const sort = {
        field: req.query.sortField?.toString(),
        order: req.query.sortOrder?.toString(),
      };

      // Validation
      const checkValidation = await addressUseCase.validateParameters(
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

      const { addresses, totalAddresses } =
        await addressUseCase.getAllAddresses(limit, offset, filters, sort);

      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totalAddresses,
        totalPages: Math.ceil(totalAddresses / limit),
      };

      res.status(200).json({
        addresses,
        metaData,
      });
    })
  );

  // Get address by id
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

      // Validate that address exists
      const address = await addressUseCase.getAddressById(id);
      if (!address) {
        throw new ApiError('Address not found', 404);
      }

      // Get address tags by address id
      const addressTags = await addressTagUseCase.getAddressTagsByAddressId(id);

      // Add tags to address object
      const addressWithTags = {
        ...address,
        tags:
          addressTags.length > 0
            ? addressTags.map(addressTag => addressTag.tag)
            : [],
      };

      res.status(200).json(addressWithTags);
    })
  );

  // Update address by id
  router.put(
    '/:id',
    authenticate,
    validateRequest(CreateAddressRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { arabicName, englishName, lat, long, entityId } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate address exists
      const address = await addressUseCase.getAddressById(id);
      if (!address) {
        return next(new ApiError('Address not found', 404));
      }

      // validate auth
      const entity = await entityUseCase.getEntityById(address.entityId);
      const loggedUser = (req as RequestWithUser).user;
      const allowedTypes = ['admin', 'super_admin', 'treesal'];

      if (
        !allowedTypes.includes(loggedUser.type) &&
        loggedUser.id !== entity?.ownerId
      ) {
        return next(
          new ApiError('You are not allowed to access this route', 403)
        );
      }

      // Validate entity exists only if entityId is changed
      if (entityId !== address.entityId) {
        const newEntity = await entityUseCase.getEntityById(entityId);
        if (!newEntity) {
          return next(new ApiError('Entity not found', 404));
        }
      }

      await addressUseCase.updateAddressById(id, {
        arabicName,
        englishName,
        lat,
        long,
        entityId,
      });

      // Update entity in algolia
      await algoliaUseCase.updateEntityToAlgolia(entityId);

      res.status(204).send();
    })
  );

  // Update address tags
  router.put(
    '/:id/tags',
    authenticate,
    validateRequest(UpdateAddressTagRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { tagIds } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate address exists
      const address = await addressUseCase.getAddressById(id);
      if (!address) {
        return next(new ApiError('Address not found', 404));
      }

      // validate auth
      const entity = await entityUseCase.getEntityById(address.entityId);
      const loggedUser = (req as RequestWithUser).user;
      const allowedTypes = ['admin', 'super_admin', 'treesal'];

      if (
        !allowedTypes.includes(loggedUser.type) &&
        loggedUser.id !== entity?.ownerId
      ) {
        return next(
          new ApiError('You are not allowed to access this route', 403)
        );
      }

      // Delete all address tags
      await addressTagUseCase.deleteByAddressId(id);

      // Insert new records in address_tag table
      for (const tagId of tagIds) {
        const tag = await tagUseCase.getTagById(tagId);
        if (tag) {
          await addressTagUseCase.createAddressTag({
            addressId: id,
            tagId,
          });
        }
      }

      // Update entity in algolia
      await algoliaUseCase.updateEntityToAlgolia(address.entityId);

      res.status(204).send();
    })
  );

  // Delete address by id
  router.delete(
    '/:id',
    authenticate,
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate address exists
      const address = await addressUseCase.getAddressById(id);
      if (!address) {
        return next(new ApiError('Address not found', 404));
      }

      // validate auth
      const entity = await entityUseCase.getEntityById(address.entityId);
      const loggedUser = (req as RequestWithUser).user;
      const allowedTypes = ['admin', 'super_admin', 'treesal'];

      if (
        !allowedTypes.includes(loggedUser.type) &&
        loggedUser.id !== entity?.ownerId
      ) {
        return next(
          new ApiError('You are not allowed to access this route', 403)
        );
      }

      await addressUseCase.deleteAddressById(id);

      // Update entity in algolia
      await algoliaUseCase.updateEntityToAlgolia(address.entityId);

      res.status(204).send();
    })
  );

  return router;
}
