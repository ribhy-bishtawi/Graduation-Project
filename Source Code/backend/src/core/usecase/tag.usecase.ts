import { Tag } from '@/core/entitys/tag.entity';
import { ITageRepository } from '@/core/interfaces/tagRepository.interface';
import { TagFilters, Sorting } from '@/api/v1/helpers/types';

export class TagUseCase {
  constructor(private tagRepository: ITageRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: TagFilters,
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

  async createTag(
    tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const tagId = await this.tagRepository.createTag(tag);

    return tagId;
  }

  async getTagById(id: number): Promise<Tag | null> {
    const tag = await this.tagRepository.getTagById(id);

    return tag;
  }

  async getAllTags(
    limit: number,
    offset: number,
    filters: TagFilters,
    sort: Sorting
  ): Promise<{
    tags: Tag[];
    totaltags: number;
  }> {
    const { tags, totaltags } = await this.tagRepository.getAllTags(
      limit,
      offset,
      filters,
      sort
    );

    return { tags, totaltags };
  }

  async updateTagById(
    id: number,
    tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const tagId = await this.tagRepository.updateTagById(id, tag);

    return tagId;
  }

  async deleteTagById(id: number): Promise<number> {
    const tagId = await this.tagRepository.deleteTagById(id);

    return tagId;
  }
}
