export class Entity {
  id: number;
  arabicName: string;
  englishName: string;
  facebookLink: string | null;
  instagramLink: string | null;
  tiktokLink: string | null;
  cityId: number;
  profileImage: string | null;
  contactNumber: string | null;
  contactName: string | null;
  status?: string;
  type: string;
  visitCount?: number | null;
  arabicDescription: string | null;
  englishDescription: string | null;
  commercialId: string | null;
  ownerId: number | null;
  createdAt?: Date;
  updatedAt?: Date;
}
