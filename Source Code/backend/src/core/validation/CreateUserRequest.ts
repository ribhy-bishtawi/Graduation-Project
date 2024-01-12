import { User } from '@/core/entitys/user.entity';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsIn,
  Matches,
} from 'class-validator';

export class CreateUserRequest extends User {
  @IsString()
  @IsNotEmpty()
  @Matches(/^\S+$/, { message: 'Username cannot contain spaces' })
  override userName: string;

  @IsString()
  @IsOptional()
  @Matches(/^[\w\S]{6,}$/, {
    message:
      'Password must be at least 6 characters long and accept letters, numbers, and special characters',
  })
  override password: string;

  @IsNotEmpty()
  @IsIn(['treesal', 'super_admin', 'store_owner', 'admin', 'customer'])
  override type: string;

  @IsString()
  @IsOptional()
  override fullName: string;

  @IsString()
  @IsOptional()
  override profileImage: string;

  @IsString()
  @IsOptional()
  override googleId: string;

  @IsString()
  @IsOptional()
  override facebookId: string;

  @IsString()
  @IsOptional()
  override appleId: string;

  @IsString()
  @IsOptional()
  override phoneNumber: string;

  @IsString()
  @IsOptional()
  override email: string;
}
