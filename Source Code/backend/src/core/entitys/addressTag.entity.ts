import { Tag } from '@/core/entitys/tag.entity';
import { Address } from '@/core/entitys/address.entity';

export class AddressTag {
  id: number;
  addressId: number;
  tagId: number;
  createdAt?: Date;
  updatedAt?: Date;
  tag?: Tag;
  address?: Address;
}
