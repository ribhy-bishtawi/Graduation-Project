import { Category } from '@/core/entitys/category.entity';
import { CategoryFilters, Sorting } from '@/api/v1/helpers/types';
export interface ICategoryRepository {
  createCategory(
    category: Omit<Category, 'id' | 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getCategoryById(id: number): Promise<Category | null>;

  getAllCategories(
    limit: number,
    offset: number,
    filters: CategoryFilters,
    sort: Sorting
  ): Promise<{ categories: Category[]; totalCategories: number }>;

  updateCategoryById(
    category: Omit<Category, 'visitCount' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  updateCategoryVisitCountById(id: number): Promise<number>;

  deleteCategory(id: number): Promise<number>;
}
