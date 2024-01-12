import { City } from '@/core/entitys/city.entity';
import { CityFilters, Sorting } from '@/api/v1/helpers/types';
import { ICityRepository } from '@/core/interfaces/cityRepository.interface';

export class CityUseCase {
  constructor(private cityRepository: ICityRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: CityFilters,
    sort: Sorting
  ): Promise<string> {
    // Validate id is a number and greater than 0
    if (filters.id) {
      if (isNaN(filters.id) || filters.id < 0) {
        return 'Id must be a number and greater than 0!';
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
    // Sort field can be either 'id' or 'arabicName' or 'englishName' or 'status'
    if (sort.field) {
      if (
        sort.field !== 'id' &&
        sort.field !== 'arabicName' &&
        sort.field !== 'englishName' &&
        sort.field !== 'status'
      ) {
        return 'Sort field must be either "id" or "arabicName or englishName or status "!';
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

  async createCity(
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const newCityId = await this.cityRepository.craeteCity(city);
    return newCityId;
  }

  async getCityById(id: number): Promise<City | null> {
    const city = await this.cityRepository.getCityById(id);
    return city;
  }

  async getAllCities(
    pageNumber: number,
    pageSize: number,
    filters: CityFilters,
    sort: Sorting
  ): Promise<{
    cities: City[];
    totalCities: number;
  }> {
    const { cities, totalCities } = await this.cityRepository.getAllCities(
      pageNumber,
      pageSize,
      filters,
      sort
    );
    return { cities, totalCities };
  }

  async updateCityById(
    id: number,
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedCityId = await this.cityRepository.updateCityById(id, city);
    return updatedCityId;
  }

  async updateCityStatus(id: number, status: string): Promise<void> {
    await this.cityRepository.updateCityStatusById(id, status);
  }

  async deleteCityById(id: number): Promise<number> {
    const deletedCityId = await this.cityRepository.deleteCityById(id);
    return deletedCityId;
  }
}
