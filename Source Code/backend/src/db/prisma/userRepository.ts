import { PrismaClient } from '@prisma/client';
import { User } from '@/core/entitys/user.entity';
import { IUserRepository } from '@/core/interfaces/userRepository.interface';
import { UserFilters, Sorting } from '@/api/v1/helpers/types';

export class UserRepository implements IUserRepository {
  constructor(private prisma: PrismaClient) {}

  async createUser(
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const newUser = await this.prisma.user.create({
      data: user,
    });
    return newUser.id;
  }

  async getUserById(id: number): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { id },
    });
    return user;
  }

  async getUserByUserName(userName: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { userName },
    });
    return user;
  }

  async getUserByPhoneNumber(phoneNumber: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { phoneNumber },
    });
    return user;
  }

  async getAllUsers(
    limit: number,
    offset: number,
    filters: UserFilters,
    sort: Sorting
  ): Promise<{
    users: Omit<User, 'password'>[];
    totalUsers: number;
  }> {
    const prismaQuery = {
      // Select fields
      select: {
        id: true,
        userName: true,
        fullName: true,
        profileImage: true,
        googleId: true,
        facebookId: true,
        appleId: true,
        type: true,
        phoneNumber: true,
        email: true,
        createdAt: true,
        updatedAt: true,
      },
      where: {
        // Filter by id
        id: filters.id ? { equals: filters.id } : undefined,
        // Filter by userName
        userName: filters.userName ? { contains: filters.userName } : undefined,
      },

      // Sorting (field(id, userName) and order(asc, desc))
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

    const users = await this.prisma.user.findMany(prismaQuery);

    const totalUsers = await this.prisma.user.count({
      where: prismaQuery.where,
    });

    return { users, totalUsers };
  }

  async updateUser(
    id: number,
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: user,
    });
    return updatedUser.id;
  }

  async updatePassword(id: number, password: string): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { password },
    });
  }

  async deleteUser(id: number): Promise<number> {
    const deletedUser = await this.prisma.user.delete({
      where: { id },
    });
    return deletedUser.id;
  }
}
