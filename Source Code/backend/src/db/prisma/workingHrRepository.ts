import { PrismaClient } from '@prisma/client';
import { WorkingHr } from '@/core/entitys/workingHr.entity';
import { IWorkingHrRepository } from '@/core/interfaces/workingHrRepository.interface';

export class WorkingHrRepository implements IWorkingHrRepository {
  constructor(private prisma: PrismaClient) {}

  async createWorkingHr(
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id } = await this.prisma.workingHr.create({
      data: workingHr,
    });

    return id;
  }

  async getWorkingHrById(id: number): Promise<WorkingHr | null> {
    const workingHr = await this.prisma.workingHr.findUnique({
      where: { id },
    });

    return workingHr;
  }

  async getWorkingHrByEntityId(entityId: number): Promise<WorkingHr[]> {
    const workingHr = await this.prisma.workingHr.findMany({
      where: { entityId },
    });

    return workingHr;
  }

  async updateWorkingHrById(
    id: number,
    workingHr: Omit<WorkingHr, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const { id: workingHrId } = await this.prisma.workingHr.update({
      where: { id },
      data: workingHr,
    });

    return workingHrId;
  }

  async deleteWorkingHrById(id: number): Promise<number> {
    const { id: workingHrId } = await this.prisma.workingHr.delete({
      where: { id },
    });

    return workingHrId;
  }

  async deleteWorkingHrByEntityId(entityId: number): Promise<void> {
    await this.prisma.workingHr.deleteMany({
      where: { entityId },
    });
  }
}
