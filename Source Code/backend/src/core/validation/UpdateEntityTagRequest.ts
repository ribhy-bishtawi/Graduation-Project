import { IsNotEmpty, IsArray, IsNumber } from 'class-validator';
export class UpdateEntityTagRequest {
  @IsNotEmpty()
  @IsArray()
  @IsNumber({}, { each: true })
  tagIds: number[];
}
