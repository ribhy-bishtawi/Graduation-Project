import { AddressTag } from '@/core/entitys/addressTag.entity';

export interface IAddressTagRepository {
  countAllAddressTagsByTagId(tagId: number): Promise<number>;

  createAddressTag(
    addressTag: Omit<AddressTag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getAddressTagsByAddressId(addressId: number): Promise<AddressTag[]>;

  getAddressTagsByTagId(tagId: number): Promise<AddressTag[]>;

  deleteAddressTagByTagId(tagId: number): Promise<void>;

  deleteByAddressId(addressId: number): Promise<void>;
}
