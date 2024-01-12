import { User } from '@/core/entitys/user.entity';
import { IUserRepository } from '@/core/interfaces/userRepository.interface';
import { UserFilters, Sorting } from '@/api/v1/helpers/types';

export class UserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async validateParameters(
    pageNumber: number,
    pageSize: number,
    filters: UserFilters,
    sort: Sorting
  ): Promise<string> {
    // Validate id is a number and greater than 0
    if (filters.id) {
      if (isNaN(filters.id) || filters.id < 0) {
        return 'Id must be a number and greater than 0!';
      }
    }
    // Validate pageNumber is a number and greater than 0
    if (pageNumber) {
      if (isNaN(pageNumber) || pageNumber < 0) {
        return 'Page number must be a number and greater than 0!';
      }
    }
    // Validate pageSize is a number and greater than 0
    if (pageSize) {
      if (isNaN(pageSize) || pageSize <= 0) {
        return 'Page size must be a number and greater than 0!';
      }
    }
    // Validate sorting
    if (sort.order) {
      if (!sort.field) {
        return 'Sort field must be provided!';
      }
    }
    // Sort field can be either 'id' or 'userName'
    if (sort.field) {
      if (sort.field !== 'id' && sort.field !== 'userName') {
        return 'Sort field must be either "id" or "userName"!';
      }
    }
    // Sort order can be either 'asc' or 'desc'
    if (sort.order) {
      if (sort.order !== 'asc' && sort.order !== 'desc') {
        return 'Sort order must be either "asc" or "desc"!';
      }
    }
    return 'OK';
  }

  async createUser(
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const newUser = await this.userRepository.createUser(user);
    return newUser;
  }

  async getUserById(id: number): Promise<User | null> {
    const user = await this.userRepository.getUserById(id);
    return user;
  }

  async getUserByUserName(userName: string): Promise<User | null> {
    const user = await this.userRepository.getUserByUserName(userName);
    return user;
  }

  async getUserByPhoneNumber(phoneNumber: string): Promise<User | null> {
    const user = await this.userRepository.getUserByPhoneNumber(phoneNumber);
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
    const { users, totalUsers } = await this.userRepository.getAllUsers(
      limit,
      offset,
      filters,
      sort
    );
    return { users, totalUsers };
  }

  async updateUser(
    id: number,
    user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>
  ): Promise<number> {
    const updatedUser = await this.userRepository.updateUser(id, user);
    return updatedUser;
  }

  async updatePassword(id: number, password: string): Promise<void> {
    await this.userRepository.updatePassword(id, password);
  }

  async deleteUser(id: number): Promise<number> {
    const deletedUser = await this.userRepository.deleteUser(id);
    return deletedUser;
  }
}
