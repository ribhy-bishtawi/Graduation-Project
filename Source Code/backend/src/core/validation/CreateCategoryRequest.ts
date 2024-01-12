import { IsString, IsNotEmpty } from 'class-validator';
import { Category } from '@/core/entitys/category.entity';

export class CreateCategoryRequest extends Category {
  @IsString()
  @IsNotEmpty()
  override arabicName: string;

  @IsString()
  @IsNotEmpty()
  override englishName: string;
}
