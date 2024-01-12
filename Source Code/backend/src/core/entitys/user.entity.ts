export class User {
  id: number;
  userName: string;
  fullName?: string | null;
  profileImage?: string | null;
  googleId?: string | null;
  facebookId?: string | null;
  appleId?: string | null;
  type: string;
  phoneNumber?: string | null;
  email?: string | null;
  password?: string | null;
  otpCode?: string | null;
  otpExpiry?: Date | null;
  createdAt: Date;
  updatedAt: Date;
}
