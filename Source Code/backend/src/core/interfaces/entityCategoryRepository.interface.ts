import { EntityCategory } from '@/core/entitys/entityCategory';

export interface IEntityCategoryRepository {
  countByCategoryId(categoryId: number): Promise<number>;

  createEntityCategory(
    entityCategory: Omit<EntityCategory, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getEntityCategoryByEntityId(entityId: number): Promise<EntityCategory[]>;

  getEntityCategoryByCategoryId(categoryId: number): Promise<EntityCategory[]>;

  deleteByEntityId(entityId: number): Promise<void>;

  deleteByCategoryId(categoryId: number): Promise<void>;
}
