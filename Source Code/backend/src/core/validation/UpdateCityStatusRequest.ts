import { City } from '@/core/entitys/city.entity';
import { IsIn, IsNotEmpty, IsString } from 'class-validator';

export class UpdateCityStatusRequest extends City {
  @IsNotEmpty()
  @IsString()
  @IsIn(['hidden', 'published'])
  override status: 'hidden' | 'published';
}
