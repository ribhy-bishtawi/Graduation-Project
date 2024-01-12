import { City } from '@/core/entitys/city.entity';
import { IsString, IsNotEmpty } from 'class-validator';

export class CreateCityRequest extends City {
  @IsString()
  @IsNotEmpty()
  override arabicName: string;

  @IsString()
  @IsNotEmpty()
  override englishName: string;
}
