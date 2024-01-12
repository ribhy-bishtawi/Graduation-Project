import { PrismaClient } from '@prisma/client';
import { Entity } from '@/core/entitys/entity.entity';
import { IEntityRepository } from '@/core/interfaces/entityRepository.interface';
import { EntityFilters, Sorting } from '@/api/v1/helpers/types';

export class EntityRepository implements IEntityRepository {
  constructor(private prisma: PrismaClient) {}

  async increaseVisitCount(id: number): Promise<void> {
    await this.prisma.entity.update({
      where: { id },
      data: {
        visitCount: {
          increment: 1,
        },
      },
    });
  }

  async createEntity(
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id } = await this.prisma.entity.create({ data: entity });

    return id;
  }

  async getAllEntitys(
    limit: number,
    offset: number,
    filters: EntityFilters,
    sort: Sorting
  ): Promise<{
    entitys: Entity[];
    totalEntitys: number;
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

        // Filter by type
        type: filters.type ? { equals: filters.type } : undefined,

        // Filter by commercialId
        commercialId: filters.commercialId
          ? { equals: filters.commercialId }
          : undefined,
      },

      // Sorting (field(id , arabicName) and order(asc, desc))
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
    const entitys = await this.prisma.entity.findMany(prismaQuery);

    // Get total entitys
    const totalEntitys = await this.prisma.entity.count({
      where: prismaQuery.where,
    });

    return { entitys, totalEntitys };
  }

  async getEntityById(id: number): Promise<Entity | null> {
    const entity = await this.prisma.entity.findUnique({
      where: { id },
    });

    return entity;
  }

  async getEnitiesByCityId(cityId: number): Promise<Entity[]> {
    const entitys = await this.prisma.entity.findMany({
      where: { cityId },
    });

    return entitys;
  }

  async updateEntity(
    id: number,
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedEntity = await this.prisma.entity.update({
      where: { id },
      data: entity,
    });

    return updatedEntity.id;
  }

  async updateEntityStatus(id: number, status: string): Promise<void> {
    await this.prisma.entity.update({
      where: { id },
      data: { status },
    });
  }

  async deleteEntityById(id: number): Promise<number> {
    const deletedEntity = await this.prisma.entity.delete({
      where: { id },
    });

    console.log('Deleted entity with id: ', deletedEntity.id);

    return deletedEntity.id;
  }
}
