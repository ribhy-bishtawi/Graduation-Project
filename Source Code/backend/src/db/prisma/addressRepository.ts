import { PrismaClient } from '@prisma/client';
import { Address } from '@/core/entitys/address.entity';
import { IAddressRepository } from '@/core/interfaces/addressRepository.interface';
import { AddressFilters, Sorting } from '@/api/v1/helpers/types';

export class AddressRepository implements IAddressRepository {
  constructor(private prisma: PrismaClient) {}

  async createAddress(
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id } = await this.prisma.address.create({
      data: address,
    });

    return id;
  }

  async getAllAddresses(
    limit: number,
    offset: number,
    filters: AddressFilters,
    sort: Sorting
  ): Promise<{
    addresses: Address[];
    totalAddresses: number;
  }> {
    const prismaQuery = {
      where: {
        // Filter by id
        id: filters.id ? { equals: filters.id } : undefined,

        // Filter by arabicName
        arabicName: filters.arabicName
          ? { contains: filters.arabicName }
          : undefined,

        // Filter by englishName
        englishName: filters.englishName
          ? { contains: filters.englishName }
          : undefined,

        // Filter by entityId
        entityId: filters.entityId ? { equals: filters.entityId } : undefined,
      },

      // Sorting (field(id , arabicName , englishName , entityId) and order(asc, desc))
      orderBy: {
        [sort.field || 'createdAt']: sort.order
          ? sort.order
          : sort.field
          ? 'asc'
          : 'desc',
      },

      // Pagination
      take: limit,
      skip: offset,
    };

    // Execute query
    const addresses = await this.prisma.address.findMany(prismaQuery);

    // Get total addresses
    const totalAddresses = await this.prisma.address.count({
      where: prismaQuery.where,
    });

    return { addresses, totalAddresses };
  }

  async getAddressById(id: number): Promise<Address | null> {
    const address = await this.prisma.address.findUnique({
      where: {
        id,
      },
    });

    return address;
  }

  async getAddressesByEntityId(entityId: number): Promise<Address[]> {
    const addresses = await this.prisma.address.findMany({
      where: {
        entityId,
      },
    });

    return addresses;
  }

  async updateAddressById(
    id: number,
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id: addressId } = await this.prisma.address.update({
      where: {
        id,
      },
      data: address,
    });

    return addressId;
  }

  async deleteAddressById(id: number): Promise<number> {
    const { id: addressId } = await this.prisma.address.delete({
      where: {
        id,
      },
    });

    return addressId;
  }

  async deleteAddressesByEntityId(entityId: number): Promise<void> {
    await this.prisma.address.deleteMany({
      where: {
        entityId,
      },
    });
  }
}
