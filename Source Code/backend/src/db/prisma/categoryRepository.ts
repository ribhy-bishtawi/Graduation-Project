import { PrismaClient } from '@prisma/client';
import { Category } from '@/core/entitys/category.entity';
import { ICategoryRepository } from '@/core/interfaces/categoryRepository.interface';
import { CategoryFilters, Sorting } from '@/api/v1/helpers/types';
export class CategoryRepository implements ICategoryRepository {
  constructor(private prisma: PrismaClient) {}

  async createCategory(
    category: Omit<Category, 'id' | 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const createdCategory = await this.prisma.category.create({
      data: {
        arabicName: category.arabicName,
        englishName: category.englishName,
      },
    });
    return createdCategory.id;
  }

  async getCategoryById(id: number): Promise<Category | null> {
    const category = await this.prisma.category.findUnique({
      where: { id },
    });
    return category;
  }

  async getAllCategories(
    limit: number,
    offset: number,
    filters: CategoryFilters,
    sort: Sorting
  ): Promise<{ categories: Category[]; totalCategories: number }> {
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
      },

      // Sorting (field(id , arabicName) and order(asc, desc))
      orderBy: {
        [sort.field || 'createdAt']: sort.order || 'desc',
      },

      // Pagination
      take: limit,
      skip: offset,
    };

    const categories = await this.prisma.category.findMany(prismaQuery);

    const totalCategories = await this.prisma.category.count({
      where: prismaQuery.where,
    });

    return { categories, totalCategories };
  }

  async updateCategoryById(
    category: Omit<Category, 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedCategory = await this.prisma.category.update({
      where: { id: category.id },
      data: {
        arabicName: category.arabicName,
        englishName: category.englishName,
      },
    });
    return updatedCategory.id;
  }

  async updateCategoryVisitCountById(id: number): Promise<number> {
    const updatedCategory = await this.prisma.category.update({
      where: { id },
      data: {
        visitCount: {
          increment: 1,
        },
      },
    });
    return updatedCategory.id;
  }

  async deleteCategory(id: number): Promise<number> {
    const deletedCategory = await this.prisma.category.delete({
      where: { id },
    });
    return deletedCategory.id;
  }
}
