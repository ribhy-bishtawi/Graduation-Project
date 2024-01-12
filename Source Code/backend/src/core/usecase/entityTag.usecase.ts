import { EntityTag } from '@/core/entitys/entityTag.entity';
import { IEntityTagRepository } from '@/core/interfaces/entityTagRepository.interface';

export class EntityTagUseCase {
  constructor(private entityTagRepository: IEntityTagRepository) {}

  async countAllEntityTagsByTagId(TagId: number): Promise<number> {
    const count = await this.entityTagRepository.countAllEntityTagsByTagId(
      TagId
    );

    return count;
  }

  async createEntityTag(
    entityTag: Omit<EntityTag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const id = await this.entityTagRepository.createEntityTag(entityTag);

    return id;
  }

  async getEntityTagsByEntityId(entityId: number): Promise<EntityTag[]> {
    const entityTags = await this.entityTagRepository.getEntityTagsByEntityId(
      entityId
    );

    return entityTags;
  }

  async getEntityTagsByTagId(tagId: number): Promise<EntityTag[]> {
    const entityTags = await this.entityTagRepository.getEntityTagsByTagId(
      tagId
    );

    return entityTags;
  }

  async deleteEntityTagByTagId(tagId: number): Promise<void> {
    await this.entityTagRepository.deleteEntityTagByTagId(tagId);
  }

  async deleteByEntityId(entityId: number): Promise<void> {
    await this.entityTagRepository.deleteByEntityId(entityId);
  }
}
