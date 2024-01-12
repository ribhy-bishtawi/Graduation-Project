import { PrismaClient } from '@prisma/client';
import { EntityCategory } from '@/core/entitys/entityCategory';
import { IEntityCategoryRepository } from '@/core/interfaces/entityCategoryRepository.interface';

export class EntityCategoryRepository implements IEntityCategoryRepository {
  constructor(private prisma: PrismaClient) {}

  async countByCategoryId(categoryId: number): Promise<number> {
    const count = await this.prisma.entityCategory.count({
      where: { categoryId },
    });

    return count;
  }

  async createEntityCategory(
    entityCategory: Omit<
      EntityCategory,
      'id' | 'createdAt' | 'updatedAt' | 'category'
    >
  ): Promise<number> {
    const { id } = await this.prisma.entityCategory.create({
      data: entityCategory,
    });

    return id;
  }

  async getEntityCategoryByEntityId(
    entityId: number
  ): Promise<EntityCategory[]> {
    const entityCategory = await this.prisma.entityCategory.findMany({
      where: {
        entityId,
      },
      include: {
        category: true,
      },
    });

    return entityCategory;
  }

  async getEntityCategoryByCategoryId(
    categoryId: number
  ): Promise<EntityCategory[]> {
    const entityCategory = await this.prisma.entityCategory.findMany({
      where: {
        categoryId,
      },
    });

    return entityCategory;
  }

  async deleteByEntityId(entityId: number): Promise<void> {
    await this.prisma.entityCategory.deleteMany({
      where: { entityId },
    });
  }

  async deleteByCategoryId(categoryId: number): Promise<void> {
    await this.prisma.entityCategory.deleteMany({
      where: { categoryId },
    });
  }
}
