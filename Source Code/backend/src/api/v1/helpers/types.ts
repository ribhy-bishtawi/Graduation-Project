import { Request } from 'express';

export interface RequestWithUser extends Request {
  user: {
    id: number;
    userName: string;
    type: string;
  };
}

export interface Sorting {
  field: string | undefined;
  order: string | undefined;
}

export interface UserFilters {
  id: number;
  userName: string | undefined;
}

export interface payloadData {
  id: number;
  userName: string;
  type: string;
}

export interface AddressFilters {
  id: number;
  arabicName: string | undefined;
  englishName: string | undefined;
  entityId: number;
}

export interface TagFilters {
  id: number;
  arabicName: string | undefined;
  englishName: string | undefined;
}



export interface CategoryFilters {
  id: number;
  arabicName: string | undefined;
  englishName: string | undefined;
}

export interface EntityFilters {
  id: number;
  arabicName: string | undefined;
  englishName: string | undefined;
  status: string | undefined;
  type: string | undefined;
  commercialId: string | undefined;
}

export interface CityFilters {
  id: number;
  arabicName: string | undefined;
  englishName: string | undefined;
  status: string | undefined;
}
