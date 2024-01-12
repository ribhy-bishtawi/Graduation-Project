import { Entity } from '@/core/entitys/entity.entity';
import { IEntityRepository } from '@/core/interfaces/entityRepository.interface';
import { EntityFilters, Sorting } from '@/api/v1/helpers/types';

export class EntityUseCase {
  constructor(private entityRepository: IEntityRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: EntityFilters,
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

    // Validate that status is either 'hidden' or 'published'
    if (filters.status) {
      if (filters.status !== 'hidden' && filters.status !== 'published') {
        return 'Status must be either "hidden" or "published"!';
      }
    }

    // Validate that type is either 'store', 'publicPlace' or 'bankBranch'
    if (filters.type) {
      if (
        filters.type !== 'store' &&
        filters.type !== 'publicPlace' &&
        filters.type !== 'bankBranch'
      ) {
        return 'Type must be either "store", "publicPlace" or "bankBranch"!';
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
      if (sort.field !== 'id' && sort.field !== 'arabicName') {
        return 'Sort field must be either "id" or "arabicName"!';
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

  async increaseVisitCount(id: number): Promise<void> {
    await this.entityRepository.increaseVisitCount(id);
  }

  async createEntity(
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const entityId = await this.entityRepository.createEntity(entity);

    return entityId;
  }

  async getAllEntitys(
    limit: number,
    offset: number,
    filters: EntityFilters,
    sort: Sorting
  ): Promise<{ entitys: Entity[]; totalEntitys: number }> {
    const { entitys, totalEntitys } = await this.entityRepository.getAllEntitys(
      limit,
      offset,
      filters,
      sort
    );

    return { entitys, totalEntitys };
  }

  async getEntityById(id: number): Promise<Entity | null> {
    const entity = await this.entityRepository.getEntityById(id);

    return entity;
  }

  async getEnitiesByCityId(cityId: number): Promise<Entity[]> {
    const entitys = await this.entityRepository.getEnitiesByCityId(cityId);

    return entitys;
  }

  async UpdateEntityById(
    id: number,
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const entityId = await this.entityRepository.updateEntity(id, entity);

    return entityId;
  }

  async UpdateEntityStatus(id: number, status: string): Promise<void> {
    await this.entityRepository.updateEntityStatus(id, status);
  }

  async deleteEntityById(id: number): Promise<number> {
    const entityId = await this.entityRepository.deleteEntityById(id);

    return entityId;
  }
}
