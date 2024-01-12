/*
  Warnings:

  - The `open_time` column on the `working_hr` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `close_time` column on the `working_hr` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE `working_hr` DROP COLUMN `open_time`,
    ADD COLUMN `open_time` DOUBLE NULL,
    DROP COLUMN `close_time`,
    ADD COLUMN `close_time` DOUBLE NULL;
