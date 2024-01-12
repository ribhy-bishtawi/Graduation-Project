import { PrismaClient } from '@prisma/client';
import { AddressTag } from '@/core/entitys/addressTag.entity';
import { IAddressTagRepository } from '@/core/interfaces/addressTagRepository.interface';

export class AddressTagRepository implements IAddressTagRepository {
  constructor(private prisma: PrismaClient) {}

  async countAllAddressTagsByTagId(tagId: number): Promise<number> {
    const count = await this.prisma.addressTage.count({
      where: { tagId },
    });

    return count;
  }

  async createAddressTag(
    addressTag: Omit<
      AddressTag,
      'id' | 'createdAt' | 'updatedAt' | 'tag' | 'address'
    >
  ): Promise<number> {
    const { id } = await this.prisma.addressTage.create({
      data: addressTag,
    });

    return id;
  }

  async getAddressTagsByAddressId(addressId: number): Promise<AddressTag[]> {
    const addressTags = await this.prisma.addressTage.findMany({
      where: { addressId },
      include: { tag: true },
    });

    return addressTags;
  }

  async getAddressTagsByTagId(tagId: number): Promise<AddressTag[]> {
    const addressTags = await this.prisma.addressTage.findMany({
      where: { tagId },
      include: { address: true },
    });

    return addressTags;
  }

  async deleteAddressTagByTagId(tagId: number): Promise<void> {
    await this.prisma.addressTage.deleteMany({
      where: { tagId },
    });
  }

  async deleteByAddressId(addressId: number): Promise<void> {
    await this.prisma.addressTage.deleteMany({
      where: { addressId },
    });
  }
}
