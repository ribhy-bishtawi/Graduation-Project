import { IsNotEmpty, IsString, Matches } from 'class-validator';

export class UpdatePasswordRequest {
  @IsNotEmpty()
  @IsString()
  @Matches(/^[\w\S]{6,}$/, {
    message:
      'Password must be at least 6 characters long and accept letters, numbers, and special characters',
  })
  password: string;
}
