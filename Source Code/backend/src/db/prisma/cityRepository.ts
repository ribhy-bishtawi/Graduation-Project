import { PrismaClient } from '@prisma/client';
import { City } from '@/core/entitys/city.entity';
import { CityFilters, Sorting } from '@/api/v1/helpers/types';
import { ICityRepository } from '@/core/interfaces/cityRepository.interface';

export class CityRepository implements ICityRepository {
  constructor(private prisma: PrismaClient) {}

  async craeteCity(
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const newCity = await this.prisma.city.create({
      data: {
        arabicName: city.arabicName,
        englishName: city.englishName,
        status: city.status,
      },
    });
    return newCity.id;
  }

  async getCityById(id: number): Promise<City | null> {
    const city = await this.prisma.city.findUnique({
      where: {
        id,
      },
    });
    return city;
  }

  async getAllCities(
    limit: number,
    offset: number,
    filters: CityFilters,
    sort: Sorting
  ): Promise<{
    cities: City[];
    totalCities: number;
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
        // Filter by status
        status: filters.status ? { equals: filters.status } : undefined,
      },

      // Sorting (field(id , arabicName, status) and order(asc, desc))
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

    const cities = await this.prisma.city.findMany(prismaQuery);

    const totalCities = await this.prisma.city.count({
      where: prismaQuery.where,
    });

    return {
      cities,
      totalCities,
    };
  }

  async updateCityById(
    id: number,
    city: Omit<City, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedCity = await this.prisma.city.update({
      where: {
        id,
      },
      data: {
        arabicName: city.arabicName,
        englishName: city.englishName,
      },
    });

    return updatedCity.id;
  }

  async updateCityStatusById(id: number, status: string): Promise<void> {
    await this.prisma.city.update({
      where: {
        id,
      },
      data: {
        status,
      },
    });
  }

  async deleteCityById(id: number): Promise<number> {
    const deletedCity = await this.prisma.city.delete({
      where: {
        id,
      },
    });
    return deletedCity.id;
  }
}
