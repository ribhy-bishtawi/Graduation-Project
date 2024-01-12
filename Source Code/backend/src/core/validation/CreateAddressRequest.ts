import { IsString, IsNotEmpty, IsNumber } from 'class-validator';
import { Address } from '@/core/entitys/address.entity';

export class CreateAddressRequest extends Address {
  @IsNotEmpty()
  @IsString()
  override arabicName: string;

  @IsNotEmpty()
  @IsString()
  override englishName: string;

  @IsNumber()
  @IsNotEmpty()
  override lat: number;

  @IsNumber()
  @IsNotEmpty()
  override long: number;

  @IsNumber()
  @IsNotEmpty()
  override entityId: number;
}
