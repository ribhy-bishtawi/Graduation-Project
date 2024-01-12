import { Category } from '@/core/entitys/category.entity';
import { ICategoryRepository } from '@/core/interfaces/categoryRepository.interface';
import { CategoryFilters, Sorting } from '@/api/v1/helpers/types';

export class CategoryUseCase {
  constructor(private categoryRepository: ICategoryRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: CategoryFilters,
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

  async createCategory(
    category: Omit<Category, 'id' | 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const categoryId = await this.categoryRepository.createCategory(category);
    return categoryId;
  }

  async getAllCategories(
    limit: number,
    offset: number,
    filters: CategoryFilters,
    sort: Sorting
  ): Promise<{
    categories: Category[];
    totalCategories: number;
  }> {
    const { categories, totalCategories } =
      await this.categoryRepository.getAllCategories(
        limit,
        offset,
        filters,
        sort
      );

    return { categories, totalCategories };
  }

  async updateCategoryById(
    category: Omit<Category, 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const categoryId = await this.categoryRepository.updateCategoryById(
      category
    );
    return categoryId;
  }

  async updateCategoryVisitCountById(id: number): Promise<number> {
    const categoryId =
      await this.categoryRepository.updateCategoryVisitCountById(id);
    return categoryId;
  }

  async getCategoryById(id: number): Promise<Category | null> {
    const category = await this.categoryRepository.getCategoryById(id);
    return category;
  }

  async deleteCategory(id: number): Promise<number> {
    const categoryId = await this.categoryRepository.deleteCategory(id);
    return categoryId;
  }
}
