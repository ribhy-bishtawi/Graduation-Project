/*
 Warnings:
 
 - You are about to drop the column `owener_id` on the `entity` table. All the data in the column will be lost.
 
 */
-- DropForeignKey
ALTER TABLE
  `entity` DROP FOREIGN KEY `entity_owener_id_fkey`;

-- AlterTable
ALTER TABLE
  `category`
MODIFY
  `visit_count` INTEGER NULL DEFAULT 0;

-- AlterTable
ALTER TABLE
  `entity` DROP COLUMN `owener_id`,
ADD
  COLUMN `owner_id` INTEGER NULL,
MODIFY
  `visit_count` INTEGER NULL DEFAULT 0;

-- AddForeignKey
ALTER TABLE
  `entity`
ADD
  CONSTRAINT `entity_owner_id_fkey` FOREIGN KEY (`owner_id`) REFERENCES `user`(`id`) ON DELETE
SET
  NULL ON UPDATE CASCADE;