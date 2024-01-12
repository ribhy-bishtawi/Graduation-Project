import { Entity } from '@/core/entitys/entity.entity';
import { IsIn, IsNotEmpty, IsString } from 'class-validator';

export class UpdateEntityStatusRequest extends Entity {
  @IsNotEmpty()
  @IsString()
  @IsIn(['hidden', 'published'])
  override status: 'hidden' | 'published';
}
