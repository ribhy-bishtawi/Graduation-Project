import { Entity } from '@/core/entitys/entity.entity';
import { EntityFilters, Sorting } from '@/api/v1/helpers/types';

export interface IEntityRepository {
  increaseVisitCount(id: number): Promise<void>;

  createEntity(
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getAllEntitys(
    limit: number,
    offset: number,
    filters: EntityFilters,
    sort: Sorting
  ): Promise<{ entitys: Entity[]; totalEntitys: number }>;

  getEntityById(id: number): Promise<Entity | null>;

  getEnitiesByCityId(cityId: number): Promise<Entity[]>;

  updateEntity(
    id: number,
    entity: Omit<Entity, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  updateEntityStatus(id: number, status: string): Promise<void>;

  deleteEntityById(id: number): Promise<number>;
}
