import { Tag } from '@/core/entitys/tag.entity';
import { TagFilters, Sorting } from '@/api/v1/helpers/types';

export interface ITageRepository {
  createTag(tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>): Promise<number>;

  getTagById(id: number): Promise<Tag | null>;

  getAllTags(
    limit: number,
    offset: number,
    filters: TagFilters,
    sort: Sorting
  ): Promise<{
    tags: Tag[];
    totaltags: number;
  }>;

  updateTagById(
    id: number,
    tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  deleteTagById(id: number): Promise<number>;
}
