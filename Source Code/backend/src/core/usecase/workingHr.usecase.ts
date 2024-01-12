import { WorkingHr } from '@/core/entitys/workingHr.entity';
import { IWorkingHrRepository } from '@/core/interfaces/workingHrRepository.interface';

export class WorkingHrUseCase {
  constructor(private workingHrRepository: IWorkingHrRepository) {}

  async createWorkingHr(
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const id = await this.workingHrRepository.createWorkingHr(workingHr);

    return id;
  }

  async getWorkingHrById(id: number): Promise<WorkingHr | null> {
    const workingHr = await this.workingHrRepository.getWorkingHrById(id);

    return workingHr;
  }

  async getWorkingHrByEntityId(entityId: number): Promise<WorkingHr[]> {
    const workingHr = await this.workingHrRepository.getWorkingHrByEntityId(
      entityId
    );

    return workingHr;
  }

  async updateWorkingHrById(
    id: number,
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const workingHrId = await this.workingHrRepository.updateWorkingHrById(
      id,
      workingHr
    );

    return workingHrId;
  }

  async deleteWorkingHrById(id: number): Promise<number> {
    const workingHrId = await this.workingHrRepository.deleteWorkingHrById(id);

    return workingHrId;
  }

  async deleteWorkingHrByEntityId(entityId: number): Promise<void> {
    await this.workingHrRepository.deleteWorkingHrByEntityId(entityId);
  }
}
