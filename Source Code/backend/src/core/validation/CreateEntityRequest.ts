import { Entity } from '@/core/entitys/entity.entity';
import {
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class CreateEntityRequest extends Entity {
  @IsNotEmpty()
  @IsString()
  override arabicName: string;

  @IsNotEmpty()
  @IsString()
  override englishName: string;

  @IsOptional()
  @IsString()
  override facebookLink: string | null;

  @IsOptional()
  @IsString()
  override instagramLink: string | null;

  @IsOptional()
  @IsString()
  override tiktokLink: string | null;

  @IsNotEmpty()
  @IsNumber()
  override cityId: number;

  @IsOptional()
  @IsString()
  override profileImage: string | null;

  @IsOptional()
  @IsString()
  override contactNumber: string | null;

  @IsOptional()
  @IsString()
  override contactName: string | null;

  @IsNotEmpty()
  @IsString()
  @IsIn(['store', 'publicPlace', 'bankBranch'])
  override type: 'store' | 'publicPlace' | 'bankBranch';

  @IsOptional()
  @IsString()
  override arabicDescription: string | null;

  @IsOptional()
  @IsString()
  override englishDescription: string | null;

  @IsOptional()
  @IsString()
  override commercialId: string | null;

  @IsOptional()
  @IsNumber()
  override ownerId: number | null;
}
