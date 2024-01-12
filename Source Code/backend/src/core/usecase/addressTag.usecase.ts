import { AddressTag } from '@/core/entitys/addressTag.entity';
import { IAddressTagRepository } from '@/core/interfaces/addressTagRepository.interface';

export class AddressTagUseCase {
  constructor(private addressTagRepository: IAddressTagRepository) {}

  async countAllAddressTagsByTagId(TagId: number): Promise<number> {
    const count = await this.addressTagRepository.countAllAddressTagsByTagId(
      TagId
    );

    return count;
  }

  async createAddressTag(
    addressTag: Omit<AddressTag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const id = await this.addressTagRepository.createAddressTag(addressTag);

    return id;
  }

  async getAddressTagsByAddressId(addressId: number): Promise<AddressTag[]> {
    const addressTags =
      await this.addressTagRepository.getAddressTagsByAddressId(addressId);

    return addressTags;
  }

  async getAddressTagsByTagId(tagId: number): Promise<AddressTag[]> {
    const addressTags = await this.addressTagRepository.getAddressTagsByTagId(
      tagId
    );

    return addressTags;
  }

  async deleteAddressTagByTagId(tagId: number): Promise<void> {
    await this.addressTagRepository.deleteAddressTagByTagId(tagId);
  }

  async deleteByAddressId(addressId: number): Promise<void> {
    await this.addressTagRepository.deleteByAddressId(addressId);
  }
}
