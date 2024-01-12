import asyncHandler from 'express-async-handler';
import { Request, Response, NextFunction, Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { validateRequest } from '@/api/v1/middleware/validate';
import { ApiError } from '@/core/base/apiError';
import { authenticate } from '@/api/v1/middleware/auth';
import { WorkingHrUseCase } from '@/core/usecase/workingHr.usecase';
import { WorkingHrRepository } from '@/db/prisma/workingHrRepository';
import { CreateWorkingHrRequest } from '@/core/validation/CreateWorkingHrRequest';
import { EntityUseCase } from '@/core/usecase/entity.usecase';
import { EntityRepository } from '@/db/prisma/entityRepository';
import { RequestWithUser } from '@/api/v1/helpers/types';

export function WorkingHrRoute(prisma: PrismaClient) {
  const router = Router();

  const workingHrUseCase = new WorkingHrUseCase(
    new WorkingHrRepository(prisma)
  );
  const entityUseCase = new EntityUseCase(new EntityRepository(prisma));

  // Create workingHr
  router.post(
    '/',
    authenticate,
    validateRequest(CreateWorkingHrRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { entityId, day, openTime, closeTime } = req.body;

      // Check if entity exists

      const entity = await entityUseCase.getEntityById(entityId);
      if (!entity) {
        return next(new ApiError('Entity does not exist!', 404));
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

      // Validate day
      if (day < 0 || day > 6) {
        return next(new ApiError('Day should be between 0 and 6!', 400));
      }

      // Validate openTime
      if (openTime && (openTime < 0 || openTime > 23)) {
        return next(new ApiError('OpenTime should be between 0 and 23!', 400));
      }

      // Validate closeTime
      if (closeTime && (closeTime < 0 || closeTime > 23)) {
        return next(new ApiError('CloseTime should be between 0 and 23!', 400));
      }

      // Validate openTime and closeTime
      if (openTime && closeTime && openTime > closeTime) {
        return next(
          new ApiError('OpenTime should be less than CloseTime!', 400)
        );
      }

      const id = await workingHrUseCase.createWorkingHr({
        entityId,
        day,
        openTime,
        closeTime,
      });

      res.status(201).json({ id });
    })
  );

  // Get all workingHrs for an entity
  router.get(
    '/:entityId',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const entityId = Number(req.params.entityId);

      // Validate entityId should be a number and greater than 0
      if (isNaN(entityId) || entityId <= 0) {
        return next(
          new ApiError('entityId should be a number and greater than 0!', 400)
        );
      }

      // Check if entity exists
      const entity = await entityUseCase.getEntityById(entityId);
      if (!entity) {
        return next(new ApiError('Entity does not exist!', 404));
      }

      const workingHrs = await workingHrUseCase.getWorkingHrByEntityId(
        entityId
      );

      res.status(200).json({ workingHrs });
    })
  );

  // Update workingHr
  router.put(
    '/:id',
    authenticate,
    validateRequest(CreateWorkingHrRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);
      const { entityId, day, openTime, closeTime } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      // Validate workingHr exists
      const workingHr = await workingHrUseCase.getWorkingHrById(id);
      if (!workingHr) {
        return next(new ApiError('WorkingHr does not exist!', 404));
      }

      // validate auth
      const entity = await entityUseCase.getEntityById(workingHr.entityId);
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
      if (entityId !== workingHr.entityId) {
        const newEntity = await entityUseCase.getEntityById(entityId);
        if (!newEntity) {
          return next(new ApiError('Entity not found', 404));
        }
      }

      // Validate day
      if (day < 0 || day > 6) {
        return next(new ApiError('Day should be between 0 and 6!', 400));
      }

      // Validate openTime
      if (openTime && (openTime < 0 || openTime > 23)) {
        return next(new ApiError('OpenTime should be between 0 and 23!', 400));
      }

      // Validate closeTime
      if (closeTime && (closeTime < 0 || closeTime > 23)) {
        return next(new ApiError('CloseTime should be between 0 and 23!', 400));
      }

      // Validate openTime and closeTime
      if (openTime && closeTime && openTime > closeTime) {
        return next(
          new ApiError('OpenTime should be less than CloseTime!', 400)
        );
      }

      await workingHrUseCase.updateWorkingHrById(id, {
        entityId,
        day,
        openTime,
        closeTime,
      });

      res.status(204).json();
    })
  );

  // Delete workingHr
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

      // Validate workingHr exists
      const workingHr = await workingHrUseCase.getWorkingHrById(id);
      if (!workingHr) {
        return next(new ApiError('WorkingHr does not exist!', 404));
      }

      await workingHrUseCase.deleteWorkingHrById(id);

      res.status(204).json();
    })
  );

  return router;
}
