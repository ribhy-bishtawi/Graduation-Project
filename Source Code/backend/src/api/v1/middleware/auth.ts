import { Request, Response, NextFunction } from 'express';
import asyncHandler from 'express-async-handler';
import { ApiError } from '@/core/base/apiError';
import { verifyToken } from '@/api/v1/helpers/jwt';
import { RequestWithUser, payloadData } from '@/api/v1/helpers/types';

export const authenticate = asyncHandler(
  async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    //  Get JWT token from Authorization header
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (!token) {
      next(new ApiError('Authentication failed: missing token', 401));
    }

    //  Verify JWT token
    const decoded: payloadData = verifyToken(token as string) as payloadData;
    if (!decoded) {
      next(new ApiError('Authentication failed: failed to verify token', 401));
    }

    // extend the request object with the user object
    (req as RequestWithUser).user = {
      id: decoded.id,
      userName: decoded.userName,
      type: decoded.type,
    };

    next();
  }
);

export const allowedTo =
  (...types: string[]) =>
  async (req: Request, _res: Response, next: NextFunction) => {
    const user = (req as RequestWithUser).user;

    if (!types.includes(user.type)) {
      return next(
        new ApiError('You are not allowed to access this route', 403)
      );
    }
    next();
  };
