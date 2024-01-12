import { User } from '@/core/entitys/user.entity';
import { IsString, IsNotEmpty, IsOptional, Matches } from 'class-validator';

export class CreateAdminRequest extends User {
  @IsString()
  @IsNotEmpty()
  @Matches(/^\S+$/, { message: 'Username cannot contain spaces' })
  override userName: string;

  @IsString()
  @IsNotEmpty()
  @Matches(/^[\w\S]{6,}$/, {
    message:
      'Password must be at least 6 characters long and accept letters, numbers, and special characters',
  })
  override password: string;

  @IsString()
  @IsOptional()
  override fullName: string;

  @IsString()
  @IsOptional()
  override profileImage: string;

  @IsString()
  @IsOptional()
  override phoneNumber: string;

  @IsString()
  @IsOptional()
  override email: string;
}
