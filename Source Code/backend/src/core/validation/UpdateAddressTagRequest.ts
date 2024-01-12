import { IsNotEmpty, IsArray, IsNumber } from 'class-validator';
export class UpdateAddressTagRequest {
  @IsNotEmpty()
  @IsArray()
  @IsNumber({}, { each: true })
  tagIds: number[];
}
