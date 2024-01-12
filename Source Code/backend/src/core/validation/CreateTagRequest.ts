import { Tag } from '@/core/entitys/tag.entity';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateTagRequest extends Tag {
  @IsString()
  @IsNotEmpty()
  override arabicName: string;

  @IsString()
  @IsNotEmpty()
  override englishName: string;
}
