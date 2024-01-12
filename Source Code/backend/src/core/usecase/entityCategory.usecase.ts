import { EntityCategory } from '@/core/entitys/entityCategory';
import { IEntityCategoryRepository } from '@/core/interfaces/entityCategoryRepository.interface';

export class EntityCategoryUseCase {
  constructor(private entityCategoryRepository: IEntityCategoryRepository) {}

  async countByCategoryId(categoryId: number): Promise<number> {
    const count = await this.entityCategoryRepository.countByCategoryId(
      categoryId
    );

    return count;
  }

  async createEntityCategory(
    entityCategory: Omit<EntityCategory, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const id = await this.entityCategoryRepository.createEntityCategory(
      entityCategory
    );

    return id;
  }

  async getEntityCategoryByEntityId(
    entityId: number
  ): Promise<EntityCategory[]> {
    const entityCategory =
      await this.entityCategoryRepository.getEntityCategoryByEntityId(entityId);

    return entityCategory;
  }

  async getEntityCategoryByCategoryId(
    categoryId: number
  ): Promise<EntityCategory[]> {
    const entityCategory =
      await this.entityCategoryRepository.getEntityCategoryByCategoryId(
        categoryId
      );

    return entityCategory;
  }

  async deleteByEntityId(entityId: number): Promise<void> {
    await this.entityCategoryRepository.deleteByEntityId(entityId);
  }

  async deleteByCategoryId(categoryId: number): Promise<void> {
    await this.entityCategoryRepository.deleteByCategoryId(categoryId);
  }
}
