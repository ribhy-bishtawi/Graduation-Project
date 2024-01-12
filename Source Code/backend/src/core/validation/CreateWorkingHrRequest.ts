import { WorkingHr } from '@/core/entitys/workingHr.entity';
import { IsNumber, IsNotEmpty, IsOptional } from 'class-validator';

export class CreateWorkingHrRequest extends WorkingHr {
  @IsNumber()
  @IsNotEmpty()
  override entityId: number;

  @IsNumber()
  @IsNotEmpty()
  override day: number;

  @IsNumber()
  @IsOptional()
  override openTime: number | null;

  @IsNumber()
  @IsOptional()
  override closeTime: number | null;
}
