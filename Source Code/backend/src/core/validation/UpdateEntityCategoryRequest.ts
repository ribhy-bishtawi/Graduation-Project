import { IsNotEmpty, IsArray, IsNumber } from 'class-validator';

export class UpdateEntityCategoryRequest {
  @IsNotEmpty()
  @IsArray()
  @IsNumber({}, { each: true })
  categoryIds: number[];
}
