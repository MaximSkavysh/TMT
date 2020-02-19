
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema task_agile
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema task_agile
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `task_agile` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `task_agile` ;

-- -----------------------------------------------------
-- Table `task_agile`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`user` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email_address` VARCHAR(128) NOT NULL,
  `username` VARCHAR(64) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_address_uidx` (`email_address` ASC),
  UNIQUE INDEX `username_uidx` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`team` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`team` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_team_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`board`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`board` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`board` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(256) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `team_id` INT(11) NULL,
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_team_id_idx` (`team_id` ASC),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_board_team_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `task_agile`.`team` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_board_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`board_member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`board_member` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`board_member` (
  `board_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  INDEX `fk_board_id_idx` (`board_id` ASC),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  PRIMARY KEY (`user_id`, `board_id`),
  CONSTRAINT `fk_board_member_board_board_id`
    FOREIGN KEY (`board_id`)
    REFERENCES `task_agile`.`board` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_board_member_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`card_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`card_list` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`card_list` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `board_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `position` INT(11) NOT NULL,
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_board_id_idx` (`board_id` ASC),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_card_list_board_board_id`
    FOREIGN KEY (`board_id`)
    REFERENCES `task_agile`.`board` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_card_list_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`card` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`card` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `card_list_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `position` INT(11) NOT NULL,
  `archived` TINYINT(1) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_card_list_id_idx` (`card_list_id` ASC),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_card_card_list_card_list_id`
    FOREIGN KEY (`card_list_id`)
    REFERENCES `task_agile`.`card_list` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_card_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`assignment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`assignment` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`assignment` (
  `card_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  PRIMARY KEY (`card_id`, `user_id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_assignment_card_card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `task_agile`.`card` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assignment_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`attachment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`attachment` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`attachment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `card_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(255) NOT NULL,
  `file_type` INT(11) NOT NULL,
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_card_id_idx` (`card_id` ASC),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_attachment_card_card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `task_agile`.`card` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attachment_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `task_agile`.`activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_agile`.`activity` ;

CREATE TABLE IF NOT EXISTS `task_agile`.`activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `card_id` INT(11) NULL,
  `board_id` INT(11) NOT NULL,
  `type` TINYINT(1) NOT NULL DEFAULT 0,
  `detail` JSON NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  INDEX `fk_board_id_idx` (`board_id` ASC),
  INDEX `fk_card_id_idx` (`card_id` ASC),
  CONSTRAINT `fk_activity_user_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `task_agile`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_activity_board_board_id`
    FOREIGN KEY (`board_id`)
    REFERENCES `task_agile`.`board` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_activity_card_card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `task_agile`.`card` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
