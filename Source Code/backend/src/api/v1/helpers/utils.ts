export const validateDate = (date: string, name = 'date'): string => {
  if (isNaN(Date.parse(date))) return `Invalid ${name}, format YYYY-MM-DD!`;

  if (
    date.split('-')[0].length !== 4 ||
    date.split('-')[1].length !== 2 ||
    date.split('-')[2].length !== 2
  ) {
    return `${name} must follow the format YYYY-MM-DD!`;
  }

  return 'ok';
};
