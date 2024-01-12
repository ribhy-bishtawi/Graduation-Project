import { AddressFilters, Sorting } from '@/api/v1/helpers/types';
import { Address } from '@/core/entitys/address.entity';

export interface IAddressRepository {
  createAddress(
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getAllAddresses(
    limit: number,
    offset: number,
    filters: AddressFilters,
    sort: Sorting
  ): Promise<{
    addresses: Address[];
    totalAddresses: number;
  }>;

  getAddressById(id: number): Promise<Address | null>;

  getAddressesByEntityId(entityId: number): Promise<Address[]>;

  updateAddressById(
    id: number,
    address: Omit<Address, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  deleteAddressById(id: number): Promise<number>;

  deleteAddressesByEntityId(entityId: number): Promise<void>;
}
