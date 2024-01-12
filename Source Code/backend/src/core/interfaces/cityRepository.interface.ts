import { City } from '@/core/entitys/city.entity';
import { CityFilters, Sorting } from '@/api/v1/helpers/types';

export interface ICityRepository {
  craeteCity(
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getCityById(id: number): Promise<City | null>;

  getAllCities(
    limit: number,
    offset: number,
    filters: CityFilters,
    sort: Sorting
  ): Promise<{
    cities: City[];
    totalCities: number;
  }>;

  updateCityById(
    id: number,
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  updateCityStatusById(id: number, status: string): Promise<void>;

  deleteCityById(id: number): Promise<number>;
}
