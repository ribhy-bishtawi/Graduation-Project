import asyncHandler from 'express-async-handler';
import { Request, Response, NextFunction, Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { ApiError } from '@/core/base/apiError';
import { validateRequest } from '@/api/v1/middleware/validate';
import { authenticate, allowedTo } from '@/api/v1/middleware/auth';
import { CityUseCase } from '@/core/usecase/city.usecase';
import { CityRepository } from '@/db/prisma/cityRepository';
import { CreateCityRequest } from '@/core/validation/CreateCityRequest';
import { UpdateCityStatusRequest } from '@/core/validation/UpdateCityStatusRequest';
import { EntityUseCase } from '@/core/usecase/entity.usecase';
import { EntityRepository } from '@/db/prisma/entityRepository';
import { AlgoliaUseCase } from '@/core/usecase/algolia.usecase';

export function CityRoute(prisma: PrismaClient) {
  const router = Router();

  const cityUseCase = new CityUseCase(new CityRepository(prisma));
  const entityUseCase = new EntityUseCase(new EntityRepository(prisma));
  const algoliaUseCase = new AlgoliaUseCase(prisma);

  // Create city
  router.post(
    '/',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateCityRequest),
    asyncHandler(async (req: Request, res: Response) => {
      const { arabicName, englishName } = req.body;
      const id = await cityUseCase.createCity({
        arabicName,
        englishName,
        status: 'hidden',
      });

      res.status(201).json({ id });
    })
  );

  // Get All cities
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
      };
      const sort = {
        field: req.query.sortField?.toString(),
        order: req.query.sortOrder?.toString(),
      };
      // Validation
      const checkValidation = await cityUseCase.validateParameters(
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
      const { cities, totalCities } = await cityUseCase.getAllCities(
        limit,
        offset,
        filters,
        sort
      );
      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totalCities,
        totalPages: Math.ceil(totalCities / limit),
      };
      res.status(200).json({
        cities,
        metaData,
      });
    })
  );

  // Get city by id
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

      const city = await cityUseCase.getCityById(id);

      // Validate city exists
      if (!city) {
        return next(new ApiError('City does not exist!', 404));
      }
      res.status(200).json(city);
    })
  );

  // Update city by id
  router.put(
    '/:id',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateCityRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { arabicName, englishName } = req.body;
      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      const city = await cityUseCase.getCityById(id);

      if (!city) {
        return next(new ApiError('City does not exist!', 404));
      }

      await cityUseCase.updateCityById(id, {
        arabicName,
        englishName,
      });

      // get all entities that use this city
      const entities = await entityUseCase.getEnitiesByCityId(id);

      // update entities in algolia
      for (const entity of entities) {
        await algoliaUseCase.updateEntityToAlgolia(entity.id);
      }

      res.status(204).send();
    })
  );

  // Update city status by id
  router.put(
    '/status/:id',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(UpdateCityStatusRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { status } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate city exists
      const city = await cityUseCase.getCityById(id);
      if (!city) {
        return next(new ApiError('City does not exist!', 404));
      }

      if (status != city.status) {
        await cityUseCase.updateCityStatus(id, status);
      }

      res.status(204).send();
    })
  );

  // Delete city by id
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

      const city = await cityUseCase.getCityById(id);

      if (!city) {
        return next(new ApiError('City does not exist!', 404));
      }

      //  Check if city is used in entity table before deleting it
      const entities = await entityUseCase.getEnitiesByCityId(id);

      if (entities.length > 0) {
        return next(
          new ApiError(
            'City cannot be deleted because it is used in entity table!',
            409
          )
        );
      }

      await cityUseCase.deleteCityById(id);
      res.status(204).send();
    })
  );

  return router;
}
