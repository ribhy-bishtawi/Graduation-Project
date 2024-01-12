import { NextFunction, Request, Response, Router } from 'express';
import { PrismaClient } from '@prisma/client';
import asyncHandler from 'express-async-handler';
import { authenticate, allowedTo } from '@/api/v1/middleware/auth';
import { ApiError } from '@/core/base/apiError';
import { EntityUseCase } from '@/core/usecase/entity.usecase';
import { EntityCategoryUseCase } from '@/core/usecase/entityCategory.usecase';
import { EntityCategoryRepository } from '@/db/prisma/entityCategoryRepository';
import { EntityRepository } from '@/db/prisma/entityRepository';
import { CityUseCase } from '@/core/usecase/city.usecase';
import { CityRepository } from '@/db/prisma/cityRepository';
import { UserUseCase } from '@/core/usecase/user.usecase';
import { UserRepository } from '@/db/prisma/userRepository';
import { validateRequest } from '@/api/v1/middleware/validate';
import { CreateEntityRequest } from '@/core/validation/CreateEntityRequest';
import { UpdateEntityStatusRequest } from '@/core/validation/UpdateEntityStatusRequest';
import { CategoryUseCase } from '@/core/usecase/category.usecase';
import { CategoryRepository } from '@/db/prisma/categoryRepository';
import { UpdateEntityCategoryRequest } from '@/core/validation/UpdateEntityCategoryRequest';
import { EntityTagUseCase } from '@/core/usecase/entityTag.usecase';
import { EntityTagRepository } from '@/db/prisma/entityTagRepository';
import { TagUseCase } from '@/core/usecase/tag.usecase';
import { TagRepository } from '@/db/prisma/tagRepository';
import { UpdateEntityTagRequest } from '@/core/validation/UpdateEntityTagRequest';
import { AdUseCase } from '@/core/usecase/ad.usecase';
import { AdRepository } from '@/db/prisma/adRepository';
import { AddressUsecase } from '@/core/usecase/address.usecase';
import { AddressRepository } from '@/db/prisma/addressRepository';
import { WorkingHrUseCase } from '@/core/usecase/workingHr.usecase';
import { WorkingHrRepository } from '@/db/prisma/workingHrRepository';
import { EntityImageUseCase } from '@/core/usecase/entityImage.usecase';
import { EntityImageRepository } from '@/db/prisma/entityImageRepository';
import { AddressTagUseCase } from '@/core/usecase/addressTag.usecase';
import { AddressTagRepository } from '@/db/prisma/addressTagRepository';
import { RequestWithUser } from '@/api/v1/helpers/types';
import { AlgoliaUseCase } from '@/core/usecase/algolia.usecase';

export function EntityRoute(prisma: PrismaClient): Router {
  const router = Router();

  const entityUsecase = new EntityUseCase(new EntityRepository(prisma));
  const cityUsecase = new CityUseCase(new CityRepository(prisma));
  const userUsecase = new UserUseCase(new UserRepository(prisma));
  const entityCategoryUsecase = new EntityCategoryUseCase(
    new EntityCategoryRepository(prisma)
  );
  const categoryUsecase = new CategoryUseCase(new CategoryRepository(prisma));
  const entityTagUsecase = new EntityTagUseCase(
    new EntityTagRepository(prisma)
  );
  const tagUsecase = new TagUseCase(new TagRepository(prisma));

  const adUsecase = new AdUseCase(new AdRepository(prisma));
  const addressUsecase = new AddressUsecase(new AddressRepository(prisma));
  const workingHrUseCase = new WorkingHrUseCase(
    new WorkingHrRepository(prisma)
  );

  const entityImageUseCase = new EntityImageUseCase(
    new EntityImageRepository(prisma)
  );

  const addressTagUseCase = new AddressTagUseCase(
    new AddressTagRepository(prisma)
  );

  const algoliaUseCase = new AlgoliaUseCase(prisma);

  // Create entity
  router.post(
    '/',
    authenticate,
    allowedTo('store_owner', 'admin', 'super_admin', 'treesal'),
    validateRequest(CreateEntityRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const {
        arabicName,
        englishName,
        facebookLink,
        instagramLink,
        tiktokLink,
        cityId,
        profileImage,
        contactNumber,
        contactName,
        type,
        arabicDescription,
        englishDescription,
        commercialId,
        ownerId,
      } = req.body;

      // Validate if city exists
      const city = await cityUsecase.getCityById(cityId);
      if (!city) {
        return next(new ApiError(`City with id ${cityId} not found`, 404));
      }

      // Validate if owner exists
      const owner = await userUsecase.getUserById(ownerId);
      if (!owner) {
        return next(new ApiError(`User with id ${ownerId} not found`, 404));
      }

      const id = await entityUsecase.createEntity({
        arabicName,
        englishName,
        facebookLink,
        instagramLink,
        tiktokLink,
        cityId,
        profileImage,
        contactNumber,
        contactName,
        type,
        arabicDescription,
        englishDescription,
        commercialId,
        ownerId,
      });

      // create entity record in algolia
      await algoliaUseCase.uploadEntityToAlgolia(id);

      res.status(201).json({ id });
    })
  );

  // Get all entities
  router.get(
    '/',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const pageNumber = Number(req.query.pageNumber) || 1;
      const pageSize = Number(req.query.pageSize) || 10;
      const filters = {
        id: Number(req.query.id),
        arabicName: req.query.arabicName?.toString(),
        englishName: req.query.englishName?.toString(),
        status: req.query.status?.toString(),
        type: req.query.type?.toString(),
        commercialId: req.query.commercialId?.toString(),
      };
      const sort = {
        field: req.query.sortField?.toString(),
        order: req.query.sortOrder?.toString(),
      };

      // Validation
      const checkValidation = await entityUsecase.validateParameters(
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

      const { entitys, totalEntitys } = await entityUsecase.getAllEntitys(
        limit,
        offset,
        filters,
        sort
      );

      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totalEntitys,
        totalPages: Math.ceil(totalEntitys / limit),
      };

      res.status(200).json({
        entitys,
        metaData,
      });
    })
  );

  // Get entity by id
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

      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError('Entity not found!', 404));
      }

      // Get entity categorys by entity id
      const entityCategorys =
        await entityCategoryUsecase.getEntityCategoryByEntityId(id);

      // Get entity tags by entity id
      const entityTags = await entityTagUsecase.getEntityTagsByEntityId(id);

      // Add categorys to entity object
      const entityWithCategory = {
        ...entity,
        categories:
          entityCategorys.length > 0
            ? entityCategorys.map(entityCategory => {
                return entityCategory.category;
              })
            : [],
        tags:
          entityTags.length > 0
            ? entityTags.map(entityTag => {
                return entityTag.tag;
              })
            : [],
      };

      // Increase visit count by 1
      await entityUsecase.increaseVisitCount(id);

      res.status(200).json(entityWithCategory);
    })
  );

  // Update Entity
  router.put(
    '/:id',
    validateRequest(CreateEntityRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const {
        arabicName,
        englishName,
        facebookLink,
        instagramLink,
        tiktokLink,
        cityId,
        profileImage,
        contactNumber,
        contactName,
        type,
        arabicDescription,
        englishDescription,
        commercialId,
        ownerId,
      } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError(`Entity with id ${id} not found`, 404));
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
      // Validate if city exists
      const city = await cityUsecase.getCityById(cityId);
      if (!city) {
        return next(new ApiError(`City with id ${cityId} not found`, 404));
      }

      // Validate if owner exists
      const owner = await userUsecase.getUserById(ownerId);
      if (!owner) {
        return next(new ApiError(`User with id ${ownerId} not found`, 404));
      }

      await entityUsecase.UpdateEntityById(id, {
        arabicName,
        englishName,
        facebookLink,
        instagramLink,
        tiktokLink,
        cityId,
        profileImage,
        contactNumber,
        contactName,
        type,
        arabicDescription,
        englishDescription,
        commercialId,
        ownerId,
      });

      // update entity record in algolia
      await algoliaUseCase.updateEntityToAlgolia(id);

      res.status(204).send();
    })
  );

  // Update entity status by id
  router.put(
    '/status/:id',
    authenticate,
    validateRequest(UpdateEntityStatusRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { status } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError(`Entity with id ${id} not found`, 404));
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

      // Update entity status if it's different
      if (status != entity.status) {
        await entityUsecase.UpdateEntityStatus(id, status);
      }

      res.status(204).send();
    })
  );

  router.put(
    '/:id/categories',
    authenticate,
    validateRequest(UpdateEntityCategoryRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { categoryIds } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError(`Entity with id ${id} not found`, 404));
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

      // Delete all records from entity_category table for this entity
      await entityCategoryUsecase.deleteByEntityId(id);

      // Insert new records in entity_category table
      for (const categoryId of categoryIds) {
        const category = await categoryUsecase.getCategoryById(categoryId);

        if (category) {
          await entityCategoryUsecase.createEntityCategory({
            entityId: id,
            categoryId: categoryId,
          });
        }
      }

      // update entity record in algolia
      await algoliaUseCase.updateEntityToAlgolia(id);

      res.status(204).send();
    })
  );

  router.put(
    '/:id/tags',
    authenticate,
    validateRequest(UpdateEntityTagRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { tagIds } = req.body;
      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }
      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError(`Entity with id ${id} not found`, 404));
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

      // Delete all records from entity_tag table for this entity
      await entityTagUsecase.deleteByEntityId(id);
      // Insert new records in entity_tag table
      for (const tagId of tagIds) {
        const tag = await tagUsecase.getTagById(tagId);

        if (tag) {
          await entityTagUsecase.createEntityTag({
            entityId: id,
            tagId,
          });
        }
      }

      // update entity record in algolia
      await algoliaUseCase.updateEntityToAlgolia(id);

      res.status(204).send();
    })
  );

  // Delete entity by id
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

      // Validate that entity exists
      const entity = await entityUsecase.getEntityById(id);
      if (!entity) {
        return next(new ApiError(`Entity with id ${id} not found`, 404));
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

      // delete all records from entity_category table for this entity
      await entityCategoryUsecase.deleteByEntityId(id);

      // delete all records from entity_tag table for this entity

      await entityTagUsecase.deleteByEntityId(id);

      // delete all records from ad table for this entity

      await adUsecase.deleteAdsByEntityId(id);

      // delete all records from working_hr table for this entity

      await workingHrUseCase.deleteWorkingHrByEntityId(id);

      // delete all records from entity_image table for this entity

      await entityImageUseCase.deleteByEntityId(id);

      // delete all records from address table for this entity

      const addresses = await addressUsecase.getAddressesByEntityId(id);
      for (const address of addresses) {
        await addressTagUseCase.deleteByAddressId(address.id as number);
        await addressUsecase.deleteAddressById(address.id as number);
      }

      // Delete entity
      await entityUsecase.deleteEntityById(id);

      // delete entity record from algolia
      await algoliaUseCase.deleteEntityFromAlgolia(id);

      res.status(204).send();
    })
  );

  return router;
}
