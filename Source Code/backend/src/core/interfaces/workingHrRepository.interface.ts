import { WorkingHr } from '@/core/entitys/workingHr.entity';

export interface IWorkingHrRepository {
  createWorkingHr(
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getWorkingHrById(id: number): Promise<WorkingHr | null>;

  getWorkingHrByEntityId(entityId: number): Promise<WorkingHr[]>;

  updateWorkingHrById(
    id: number,
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  deleteWorkingHrById(id: number): Promise<number>;

  deleteWorkingHrByEntityId(entityId: number): Promise<void>;
}
