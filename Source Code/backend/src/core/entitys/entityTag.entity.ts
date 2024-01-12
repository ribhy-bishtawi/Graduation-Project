import { Tag } from '@/core/entitys/tag.entity';

export class EntityTag {
  id: number;
  entityId: number;
  tagId: number;
  createdAt?: Date;
  updatedAt?: Date;
  tag?: Tag;
}
