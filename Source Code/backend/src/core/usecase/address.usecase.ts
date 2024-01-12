import { AddressFilters, Sorting } from '@/api/v1/helpers/types';
import { Address } from '@/core/entitys/address.entity';
import { IAddressRepository } from '@/core/interfaces/addressRepository.interface';

export class AddressUsecase {
  constructor(private addressRepository: IAddressRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: AddressFilters,
    sort: Sorting
  ): Promise<string> {
    // Validate id is a number and greater than 0
    if (filters.id) {
      if (isNaN(filters.id) || filters.id < 0) {
        return 'Id must be a number and greater than 0!';
      }
    }

    // Validate entityId is a number and greater than 0
    if (filters.entityId) {
      if (isNaN(filters.entityId) || filters.entityId < 0) {
        return 'Entity Id must be a number and greater than 0!';
      }
    }

    // Validate pageNumber is a number and greater than 0
    if (pageNumber) {
      if (isNaN(pageNumber) || pageNumber < 0) {
        return 'Page number must be a number and greater than 0!';
      }
    }

    // Validate pageSize is a number and greater than 0
    if (pageSize) {
      if (isNaN(pageSize) || pageSize <= 0) {
        return 'Page size must be a number and greater than 0!';
      }
    }

    // Validate sorting
    if (sort.order) {
      if (!sort.field) {
        return 'Sort field must be provided!';
      }
    }

    // Sort field can be either 'id' or 'arabicName'
    if (sort.field) {
      if (
        sort.field !== 'id' &&
        sort.field !== 'arabicName' &&
        sort.field !== 'englishName' &&
        sort.field !== 'entityId'
      ) {
        return 'Sort field must be either "id" or "arabicName" or "englishName" or "entityId"!';
      }
    }

    // Sort order can be either 'asc' or 'desc'
    if (sort.order) {
      if (sort.order !== 'asc' && sort.order !== 'desc') {
        return 'Sort order must be either "asc" or "desc"!';
      }
    }

    return 'OK';
  }

  async createAddress(
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const id = await this.addressRepository.createAddress(address);

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
    const { addresses, totalAddresses } =
      await this.addressRepository.getAllAddresses(
        limit,
        offset,
        filters,
        sort
      );

    return { addresses, totalAddresses };
  }

  async getAddressById(id: number): Promise<Address | null> {
    const address = await this.addressRepository.getAddressById(id);

    return address;
  }

  async getAddressesByEntityId(entityId: number): Promise<Address[]> {
    const addresses = await this.addressRepository.getAddressesByEntityId(
      entityId
    );

    return addresses;
  }

  async updateAddressById(
    id: number,
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const AddressId = await this.addressRepository.updateAddressById(
      id,
      address
    );

    return AddressId;
  }

  async deleteAddressById(id: number): Promise<number> {
    const addressId = await this.addressRepository.deleteAddressById(id);

    return addressId;
  }

  async deleteAddressesByEntityId(entityId: number): Promise<void> {
    await this.addressRepository.deleteAddressesByEntityId(entityId);
  }
}
