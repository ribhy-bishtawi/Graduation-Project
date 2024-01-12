import { EntityTag } from '@/core/entitys/entityTag.entity';

export interface IEntityTagRepository {
  countAllEntityTagsByTagId(tagId: number): Promise<number>;

  createEntityTag(
    entityTag: Omit<EntityTag, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getEntityTagsByEntityId(entityId: number): Promise<EntityTag[]>;

  getEntityTagsByTagId(tagId: number): Promise<EntityTag[]>;

  deleteEntityTagByTagId(tagId: number): Promise<void>;

  deleteByEntityId(entityId: number): Promise<void>;
}
