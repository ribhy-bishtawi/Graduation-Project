import { Router, Request, Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import asyncHandler from 'express-async-handler';
import { ApiError } from '@/core/base/apiError';
import { validateRequest } from '@/api/v1/middleware/validate';
import { CategoryUseCase } from '@/core/usecase/category.usecase';
import { CategoryRepository } from '@/db/prisma/categoryRepository';
import { CreateCategoryRequest } from '@/core/validation/CreateCategoryRequest';
import { authenticate, allowedTo } from '@/api/v1/middleware/auth';
import { EntityCategoryUseCase } from '@/core/usecase/entityCategory.usecase';
import { EntityCategoryRepository } from '@/db/prisma/entityCategoryRepository';
import { AlgoliaUseCase } from '@/core/usecase/algolia.usecase';

export function CategoryRoute(prisma: PrismaClient): Router {
  const router = Router();

  const categoryUsecase = new CategoryUseCase(new CategoryRepository(prisma));
  const entityCategoryUsecase = new EntityCategoryUseCase(
    new EntityCategoryRepository(prisma)
  );

  const algoliaUseCase = new AlgoliaUseCase(prisma);

  router.post(
    '/',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateCategoryRequest),
    asyncHandler(async (req: Request, res: Response) => {
      const { arabicName, englishName } = req.body;

      const categoryId = await categoryUsecase.createCategory({
        arabicName,
        englishName,
      });

      res.status(201).json({
        id: categoryId,
      });
    })
  );

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
      const checkValidation = await categoryUsecase.validateParameters(
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

      const { categories, totalCategories } =
        await categoryUsecase.getAllCategories(limit, offset, filters, sort);

      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totalCategories,
        totalPages: Math.ceil(totalCategories / limit),
      };

      res.status(200).json({
        categories,
        metaData,
      });
    })
  );

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

      // Add the count of entities that have this category
      const EntityCount = await entityCategoryUsecase.countByCategoryId(id);

      const category = await categoryUsecase.getCategoryById(id);

      if (!category) {
        return next(new ApiError('Category does not exist!', 404));
      }

      // Update visit count

      await categoryUsecase.updateCategoryVisitCountById(id);

      res.status(200).json({
        ...category,
        EntityCount,
      });
    })
  );

  router.put(
    '/:id',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateCategoryRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { arabicName, englishName } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      const category = await categoryUsecase.getCategoryById(id);

      if (!category) {
        return next(new ApiError('Category does not exist!', 404));
      }

      await categoryUsecase.updateCategoryById({
        id,
        arabicName,
        englishName,
      });

      // get entity category by category id
      const entityCategories =
        await entityCategoryUsecase.getEntityCategoryByCategoryId(id);

      // get entity ids from entity category
      const entityIds = entityCategories.map(entityCategory => {
        return entityCategory.entityId;
      });

      // update entities to algolia
      for (const entityId of entityIds) {
        if (entityId) {
          await algoliaUseCase.updateEntityToAlgolia(entityId);
        }
      }

      res.status(204).send();
    })
  );

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

      // Validate category exists
      const category = await categoryUsecase.getCategoryById(id);

      if (!category) {
        return next(new ApiError('Category does not exist!', 404));
      }

      // get entity category by category id
      const entityCategories =
        await entityCategoryUsecase.getEntityCategoryByCategoryId(id);

      // get entity ids from entity category
      const entityIds = entityCategories.map(entityCategory => {
        return entityCategory.entityId;
      });

      // update entities to algolia
      for (const entityId of entityIds) {
        if (entityId) {
          await algoliaUseCase.updateEntityToAlgolia(entityId);
        }
      }

      // Delete all records from entity_category table that have this category

      await entityCategoryUsecase.deleteByCategoryId(id);

      // Delete category
      await categoryUsecase.deleteCategory(id);

      res.status(204).send();
    })
  );

  return router;
}
