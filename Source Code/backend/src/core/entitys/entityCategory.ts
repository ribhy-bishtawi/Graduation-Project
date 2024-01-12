import { Category } from '@/core/entitys/category.entity';

export class EntityCategory {
  id: number;
  entityId: number;
  categoryId: number;
  createdAt?: Date;
  updatedAt?: Date;
  category?: Category;
}
