import { PrismaClient } from '@prisma/client';
import { Tag } from '@/core/entitys/tag.entity';
import { ITageRepository } from '@/core/interfaces/tagRepository.interface';
import { TagFilters, Sorting } from '@/api/v1/helpers/types';

export class TagRepository implements ITageRepository {
  constructor(private prisma: PrismaClient) {}

  async createTag(
    tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id } = await this.prisma.tag.create({
      data: tag,
    });

    return id;
  }

  async getTagById(id: number): Promise<Tag | null> {
    const tag = await this.prisma.tag.findUnique({
      where: { id },
    });

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
        [sort.field || 'createdAt']: sort.order
          ? sort.order
          : sort.field
          ? 'asc'
          : 'desc',
      },

      // Pagination
      take: limit,
      skip: offset,
    };

    // Execute query
    const tags = await this.prisma.tag.findMany(prismaQuery);

    // Get total tags
    const totaltags = await this.prisma.tag.count({
      where: prismaQuery.where,
    });

    return { tags, totaltags };
  }

  async updateTagById(
    id: number,
    tag: Omit<Tag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id: tagId } = await this.prisma.tag.update({
      where: { id },
      data: tag,
    });

    return tagId;
  }

  async deleteTagById(id: number): Promise<number> {
    const { id: tagId } = await this.prisma.tag.delete({
      where: { id },
    });

    return tagId;
  }
}
