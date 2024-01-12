import { User } from '@/core/entitys/user.entity';
import { UserFilters, Sorting } from '@/api/v1/helpers/types';

export interface IUserRepository {
  createUser(
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  getUserById(id: number): Promise<User | null>;

  getUserByUserName(userName: string): Promise<User | null>;

  getUserByPhoneNumber(phoneNumber: string): Promise<User | null>;

  getAllUsers(
    limit: number,
    offset: number,
    filters: UserFilters,
    sort: Sorting
  ): Promise<{
    users: Omit<User, 'password'>[];
    totalUsers: number;
  }>;

  updateUser(
    id: number,
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number>;

  updatePassword(id: number, password: string): Promise<void>;

  deleteUser(id: number): Promise<number>;
}
