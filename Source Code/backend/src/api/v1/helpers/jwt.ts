import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;

export const signToken = (
  payload: object,
  expiresIn: string | number = '12h'
): string => {
  // check if jwt secret is set
  if (!JWT_SECRET) {
    return '';
  }

  return jwt.sign(payload, JWT_SECRET, { expiresIn });
};

export const verifyToken = (token: string): object | null => {
  // check if jwt secret is set
  if (!JWT_SECRET) {
    return null;
  }

  try {
    return jwt.verify(token, JWT_SECRET) as object;
  } catch (error) {
    return null;
  }
};
