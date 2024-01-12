import { Router, Request, Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import asyncHandler from 'express-async-handler';
import bcrypt from 'bcrypt';
import { ApiError } from '@/core/base/apiError';
import { UserUseCase } from '@/core/usecase/user.usecase';
import { UserRepository } from '@/db/prisma/userRepository';
import { signToken } from '@/api/v1/helpers/jwt';
import { validateRequest } from '@/api/v1/middleware/validate';
import { CreateUserRequest } from '@/core/validation/CreateUserRequest';
import { authenticate, allowedTo } from '@/api/v1/middleware/auth';
import { RequestWithUser } from '@/api/v1/helpers/types';
import { CreateAdminRequest } from '@/core/validation/CreateAdminRequest';
import { UpdatePasswordRequest } from '@/core/validation/UpdatePasswordRequest';
import { SmsUsecase } from '@/core/usecase/sms.usecase';
export function UserRoute(prisma: PrismaClient): Router {
  const router = Router();

  const userUseCase = new UserUseCase(new UserRepository(prisma));
  const smsUsecase = new SmsUsecase();

  // User Register
  router.post(
    '/register',
    authenticate,
    allowedTo('admin', 'super_admin', 'treesal'),
    validateRequest(CreateUserRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const {
        userName,
        fullName,
        profileImage,
        googleId,
        facebookId,
        appleId,
        type,
        phoneNumber,
        email,
        password,
      } = req.body;

      // Validate userName
      if (userName) {
        const checkUserName = await userUseCase.getUserByUserName(userName);
        if (checkUserName) {
          return next(new ApiError('User name already exists', 409));
        }
      }

      // Validate phoneNumber
      if (phoneNumber) {
        const checkPhoneNumber = await userUseCase.getUserByPhoneNumber(
          phoneNumber
        );
        if (checkPhoneNumber) {
          return next(new ApiError('Phone number already exists', 409));
        }
      }

      let hashedPassword = null;

      if (password) {
        hashedPassword = await bcrypt.hash(password, 10);
      }

      const createdUserId = await userUseCase.createUser({
        userName,
        fullName: fullName,
        profileImage: profileImage,
        googleId: googleId,
        facebookId: facebookId,
        appleId: appleId,
        type,
        phoneNumber: phoneNumber,
        email: email,
        password: hashedPassword,
      });

      res.status(201).json({
        id: createdUserId,
      });
    })
  );

  router.post(
    '/registerAdmin',
    authenticate,
    allowedTo('super_admin', 'treesal'),
    validateRequest(CreateAdminRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { userName, fullName, profileImage, phoneNumber, email, password } =
        req.body;

      // Validate userName
      if (userName) {
        const checkUserName = await userUseCase.getUserByUserName(userName);
        if (checkUserName) {
          return next(new ApiError('User name already exists', 409));
        }
      }

      // Validate phoneNumber
      if (phoneNumber) {
        const checkPhoneNumber = await userUseCase.getUserByPhoneNumber(
          phoneNumber
        );
        if (checkPhoneNumber) {
          return next(new ApiError('Phone number already exists', 409));
        }
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      const createdUserId = await userUseCase.createUser({
        userName,
        fullName: fullName,
        profileImage: profileImage,
        type: 'admin',
        phoneNumber: phoneNumber,
        email: email,
        password: hashedPassword,
      });

      res.status(201).json({
        id: createdUserId,
      });
    })
  );

  // Login user
  router.post(
    '/login',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { userName, password } = req.body;

      const user = await userUseCase.getUserByUserName(userName);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      const isMatch = await bcrypt.compare(password, user.password as string);
      if (!isMatch) {
        return next(new ApiError('Incorrect password', 400));
      }

      // Sign token
      const token = signToken({
        id: user.id,
        userName: user.userName,
        type: user.type,
      });

      if (token === '') {
        return next(new ApiError('JWT_SECRET is not set', 500));
      }

      res.status(200).json({
        userId: user.id,
        userName: user.userName,
        token,
        role: user.type,
      });
    })
  );

  // Login user with phone number and otp

  router.post(
    '/login-otp',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { phoneNumber } = req.body;

      const user = await userUseCase.getUserByPhoneNumber(phoneNumber);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      // Generate a random 6-digit OTP
      const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
      const hashedOtp = await bcrypt.hash(otpCode, 10);
      const otpExpiry = new Date(Date.now() + 10 * 60 * 1000); // Set OTP expiry to 10 minutes

      // set otpCode and otpExpiry
      await userUseCase.updateUser(user.id, {
        userName: user.userName,
        fullName: user.fullName,
        profileImage: user.profileImage,
        googleId: user.googleId,
        facebookId: user.facebookId,
        appleId: user.appleId,
        type: user.type,
        phoneNumber: user.phoneNumber,
        email: user.email,
        password: user.password,
        otpCode: hashedOtp,
        otpExpiry,
      });

      const message = `Your OTP code is : ${otpCode}`;

      await smsUsecase.sendSms(message, phoneNumber);

      res.status(200).json({ message: 'OTP sent successfully' });
    })
  );

  router.post(
    '/verify-otp',
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const { phoneNumber, otpCode } = req.body;

      const user = await userUseCase.getUserByPhoneNumber(phoneNumber);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      const isMatch = await bcrypt.compare(otpCode, user.otpCode as string);
      if (!isMatch) {
        return next(new ApiError('Incorrect OTP', 400));
      }

      if (user.otpExpiry && user.otpExpiry < new Date()) {
        return next(new ApiError('OTP expired', 400));
      }

      // set otpCode and otpExpiry to null
      await userUseCase.updateUser(user.id, {
        userName: user.userName,
        fullName: user.fullName,
        profileImage: user.profileImage,
        googleId: user.googleId,
        facebookId: user.facebookId,
        appleId: user.appleId,
        type: user.type,
        phoneNumber: user.phoneNumber,
        email: user.email,
        password: user.password,
        otpCode: null,
        otpExpiry: null,
      });

      // Sign token
      const token = signToken({
        id: user.id,
        userName: user.userName,
        type: user.type,
      });

      if (token === '') {
        return next(new ApiError('JWT_SECRET is not set', 500));
      }

      res.status(200).json({
        userId: user.id,
        userName: user.userName,
        token,
        role: user.type,
      });
    })
  );

  // Get All users
  router.get(
    '/',
    authenticate,
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const pageNumber = Number(req.query.pageNumber) || 1;
      const pageSize = Number(req.query.pageSize) || 10;
      const filters = {
        id: Number(req.query.id),
        userName: req.query.userName?.toString(),
      };
      const sort = {
        field: req.query.sortField?.toString(),
        order: req.query.sortOrder?.toString(),
      };
      // Validation
      const checkValidation = await userUseCase.validateParameters(
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
      const { users, totalUsers } = await userUseCase.getAllUsers(
        limit,
        offset,
        filters,
        sort
      );

      // Meta data
      const metaData = {
        page: pageNumber,
        pageSize: limit,
        total: totalUsers,
        totalPages: Math.ceil(totalUsers / limit),
      };

      res.status(200).json({ users, metaData });
    })
  );

  // Get user by id
  router.get(
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

      const user = await userUseCase.getUserById(id);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      res.status(200).json({
        id: user.id,
        userName: user.userName,
        fullName: user.fullName,
        profileImage: user.profileImage,
        googleId: user.googleId,
        facebookId: user.facebookId,
        appleId: user.appleId,
        type: user.type,
        phoneNumber: user.phoneNumber,
        email: user.email,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      });
    })
  );

  // update user by id
  router.put(
    '/:id',
    authenticate,
    validateRequest(CreateUserRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const id = Number(req.params.id);

      const {
        userName,
        fullName,
        profileImage,
        googleId,
        facebookId,
        appleId,
        type,
        phoneNumber,
        email,
        password,
      } = req.body;

      // Validate id should be a number and greater than 0
      if (isNaN(id) || id <= 0) {
        return next(
          new ApiError('Id should be a number and greater than 0!', 400)
        );
      }

      const user = await userUseCase.getUserById(id);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      const loggedUser = (req as RequestWithUser).user;
      if (user.type !== 'treesal' || loggedUser.id !== id) {
        return next(new ApiError('Unauthorized', 403));
      }

      // Validate userName
      if (userName) {
        if (userName !== user.userName) {
          const checkUserName = await userUseCase.getUserByUserName(userName);
          if (checkUserName) {
            return next(new ApiError('User name already exists', 409));
          }
        }
      }

      // Validate phoneNumber
      if (phoneNumber) {
        if (phoneNumber !== user.phoneNumber) {
          const checkPhoneNumber = await userUseCase.getUserByPhoneNumber(
            phoneNumber
          );
          if (checkPhoneNumber) {
            return next(new ApiError('Phone number already exists', 409));
          }
        }
      }

      let hashedPassword = null;

      if (password) {
        hashedPassword = await bcrypt.hash(password, 10);
      }

      await userUseCase.updateUser(id, {
        userName,
        fullName,
        profileImage,
        googleId,
        facebookId,
        appleId,
        type,
        phoneNumber,
        email,
        password: hashedPassword,
      });

      res.status(204).json();
    })
  );

  router.put(
    '/:id/resetPassword',
    authenticate,
    validateRequest(UpdatePasswordRequest),
    asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
      const userId = Number(req.params.id);
      const password = req.body.password;
      const loggedUser = (req as RequestWithUser).user;

      // check that user id is a number and greater than 0
      if (isNaN(userId) || userId <= 0) {
        return next(
          new ApiError('User id should be a number and greater than 0!', 400)
        );
      }

      // check if user exists
      const user = await userUseCase.getUserById(userId);

      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      // check for authorization
      // each type change only his password and the type below him

      if (user.type === 'treesal' && loggedUser.id !== userId) {
        return next(new ApiError('Unauthorized', 403));
      } else if (
        user.type === 'super_admin' &&
        loggedUser.id !== userId &&
        loggedUser.type !== 'treesal'
      ) {
        return next(new ApiError('Unauthorized', 403));
      } else if (
        user.type === 'admin' &&
        loggedUser.id !== userId &&
        loggedUser.type !== 'super_admin' &&
        loggedUser.type !== 'treesal'
      ) {
        return next(new ApiError('Unauthorized', 403));
      } else if (
        user.type === 'store_owner' &&
        loggedUser.id !== userId &&
        loggedUser.type !== 'admin' &&
        loggedUser.type !== 'super_admin' &&
        loggedUser.type !== 'treesal'
      ) {
        return next(new ApiError('Unauthorized', 403));
      } else if (
        user.type === 'customer' &&
        loggedUser.id !== userId &&
        loggedUser.type !== 'admin' &&
        loggedUser.type !== 'super_admin' &&
        loggedUser.type !== 'treesal'
      ) {
        return next(new ApiError('Unauthorized', 403));
      }

      // hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // update password
      await userUseCase.updatePassword(userId, hashedPassword);

      res.status(204).json();
    })
  );

  // Delete user by id
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

      const user = await userUseCase.getUserById(id);
      if (!user) {
        return next(new ApiError('User not found', 404));
      }

      const loggedUser = (req as RequestWithUser).user;
      if (user.type !== 'treesal' || loggedUser.id !== id) {
        return next(new ApiError('Unauthorized', 403));
      }

      await userUseCase.deleteUser(id);

      res.status(204).json();
    })
  );

  return router;
}
