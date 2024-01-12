import { PrismaClient } from '@prisma/client';
import { EntityTag } from '@/core/entitys/entityTag.entity';
import { IEntityTagRepository } from '@/core/interfaces/entityTagRepository.interface';

export class EntityTagRepository implements IEntityTagRepository {
  constructor(private prisma: PrismaClient) {}

  async countAllEntityTagsByTagId(tagId: number): Promise<number> {
    const count = await this.prisma.entityTag.count({
      where: { tagId },
    });

    return count;
  }

  async createEntityTag(
    entityTag: Omit<EntityTag, 'id' | 'createdAt' | 'updatedAt' | 'tag'>
  ): Promise<number> {
    const { id } = await this.prisma.entityTag.create({
      data: entityTag,
    });

    return id;
  }

  async getEntityTagsByEntityId(entityId: number): Promise<EntityTag[]> {
    const entityTags = await this.prisma.entityTag.findMany({
      where: { entityId },
      include: { tag: true },
    });

    return entityTags;
  }

  async getEntityTagsByTagId(tagId: number): Promise<EntityTag[]> {
    const entityTags = await this.prisma.entityTag.findMany({
      where: { tagId },
    });

    return entityTags;
  }

  async deleteEntityTagByTagId(tagId: number): Promise<void> {
    await this.prisma.entityTag.deleteMany({
      where: { tagId },
    });
  }

  async deleteByEntityId(entityId: number): Promise<void> {
    await this.prisma.entityTag.deleteMany({
      where: { entityId },
    });
  }
}
