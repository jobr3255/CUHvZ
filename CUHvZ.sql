-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CUHvZ
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `CUHvZ` ;

-- -----------------------------------------------------
-- Schema CUHvZ
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CUHvZ` DEFAULT CHARACTER SET utf8 ;
USE `CUHvZ` ;

-- -----------------------------------------------------
-- Table `CUHvZ`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`users` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(30) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(12) NULL DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `clearance` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`user_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`user_details` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`user_details` (
  `id` INT NOT NULL,
  `join_date` DATETIME NULL,
  `activated` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_details`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`subscriptions` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`subscriptions` (
  `id` INT NOT NULL,
  `weeklong` TINYINT(1) NOT NULL DEFAULT 1,
  `lockin` TINYINT(1) NOT NULL DEFAULT 1,
  `general` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_subscriptions`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`tokens`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`tokens` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`tokens` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `expiration` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  INDEX `user_idx` (`user_id` ASC),
  CONSTRAINT `fk_token_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`lockins`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`lockins` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`lockins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `event_date` DATE NULL,
  `waiver` VARCHAR(255) NULL,
  `eventbrite` VARCHAR(255) NULL,
  `blaster_eventbrite` VARCHAR(255) NULL,
  `state` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`lockin_text`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`lockin_text` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`lockin_text` (
  `id` INT NOT NULL,
  `details` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_lockin_details`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`lockins` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklongs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklongs` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklongs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `start_date` DATETIME NULL,
  `end_date` DATETIME NULL,
  `state` INT NOT NULL DEFAULT 0,
  `waiver` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_details` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklong_details` (
  `id` INT NOT NULL,
  `stun_timer` INT NOT NULL DEFAULT 300,
  `details` TEXT NULL,
  `monday` TEXT NULL,
  `tuesday` TEXT NULL,
  `wednesday` TEXT NULL,
  `thursday` TEXT NULL,
  `friday` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_weeklong_details`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_missions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_missions` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklong_missions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weeklong_id` INT NOT NULL,
  `day` ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') NOT NULL,
  `campus` ENUM('on', 'off') NOT NULL,
  `mission` VARCHAR(255) NULL,
  `time` VARCHAR(20) NULL,
  `location` VARCHAR(255) NULL,
  `location_link` VARCHAR(500) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `weeklong_idx` (`weeklong_id` ASC),
  CONSTRAINT `fk_weeklong_mission`
    FOREIGN KEY (`weeklong_id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_players`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_players` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklong_players` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weeklong_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `player_code` VARCHAR(45) NOT NULL,
  `type` ENUM('normal', 'oz', 'suicide', 'starved', 'inactive') NOT NULL DEFAULT 'normal',
  `status` ENUM('human', 'zombie', 'deceased') NOT NULL DEFAULT 'human',
  `poisoned` INT NOT NULL DEFAULT 0,
  `points` INT NOT NULL DEFAULT 0,
  `kills` INT NOT NULL DEFAULT 0,
  `starve_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `weeklong_idx` (`weeklong_id` ASC),
  UNIQUE INDEX `weeklong_player_code` (`player_code` ASC, `weeklong_id` ASC),
  INDEX `player_idx` (`user_id` ASC),
  UNIQUE INDEX `weeklong_player` (`weeklong_id` ASC, `user_id` ASC),
  CONSTRAINT `fk_weeklong`
    FOREIGN KEY (`weeklong_id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player`
    FOREIGN KEY (`user_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`activity` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`activity` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weeklong_id` INT NOT NULL,
  `user1_id` INT NOT NULL,
  `user2_id` INT NULL,
  `action` VARCHAR(45) NOT NULL,
  `desciption` VARCHAR(255) NULL,
  `time_logged` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `weeklong_idx` (`weeklong_id` ASC),
  INDEX `user1_idx` (`user1_id` ASC),
  INDEX `user2_idx` (`user2_id` ASC),
  CONSTRAINT `fk_weeklong_activity`
    FOREIGN KEY (`weeklong_id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user1`
    FOREIGN KEY (`user1_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user2`
    FOREIGN KEY (`user2_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`codes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`codes` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`codes` (
  `id` INT NOT NULL,
  `weeklong_id` INT NOT NULL,
  `code` VARCHAR(45) NOT NULL,
  `point_val` INT NOT NULL DEFAULT 0,
  `feed_val` INT NOT NULL DEFAULT 0,
  `type` ENUM('generic', 'supply drop', 'mission') NOT NULL DEFAULT 'generic',
  `num_uses` INT NULL,
  `max_uses` INT NOT NULL,
  `activation` DATETIME NULL,
  `expiration` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_codes_1_idx` (`weeklong_id` ASC),
  CONSTRAINT `weeklong`
    FOREIGN KEY (`weeklong_id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`used_codes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`used_codes` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`used_codes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `time_used` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `code_idx` (`code_id` ASC),
  INDEX `user_idx` (`user_id` ASC),
  CONSTRAINT `fk_code`
    FOREIGN KEY (`code_id`)
    REFERENCES `CUHvZ`.`codes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_weeklong_player`
    FOREIGN KEY (`user_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`supply_drops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`supply_drops` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`supply_drops` (
  `id` INT NOT NULL,
  `location` VARCHAR(45) NULL,
  `poison` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_supply_drop`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`codes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`emails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`emails` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`emails` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `subject` VARCHAR(255) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `body` TEXT NOT NULL,
  `scheduled_send` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_emails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_emails` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklong_emails` (
  `id` INT NOT NULL,
  `weeklong_id` INT NOT NULL,
  `day` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `weeklong_idx` (`weeklong_id` ASC),
  CONSTRAINT `fk_email`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`emails` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_weeklong_email`
    FOREIGN KEY (`weeklong_id`)
    REFERENCES `CUHvZ`.`weeklongs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`time_offset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`time_offset` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`time_offset` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `offset` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`used_tokens`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`used_tokens` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`used_tokens` (
  `id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `time_used` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `CUHvZ`.`users`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (1, 'LegendaryCrypt', 'jobr3255@colorado.edu', 'Josh', 'Brown', '3038191330', '$2y$10$I8/LQM3KB7190xHKYWTaKemyj7UY/RVNK77PMVmX7L.kIY4H1.yMq', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (28, 'LilBisch', 'devonr363@gmail.com', 'Devon', 'Ricken', '7202997200', '$2y$10$GmkbWv6xdfEGjHM15vFXDON9qy4fpVK/azdx9DN/mdOLwXASyh4q2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (29, 'ghost', 'scarley.harris@gmail.com', 'Blair', 'Harris', '7192170839', '$2y$10$FuwGzxZzBOF4j7QxFzt7/eU6KP8I3jaJp4.6rNqLNVSSo2LuGmiGC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (31, 'NerdyDruid', 'colleenrfeuerborn@gmail.com', 'Colleen', 'Feuerborn', '7203276770', '$2y$10$1B1g2xTsVW.ljmXdBLexfeg23aT/KY8tSwJ4a8yIZpqt8LW2TiFc6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (32, 'lucasmcmahon', 'lucas.mcmahon@live.com', 'Lucas', 'McMahon', 'NULL', '$2y$10$ANrLIOPzla4x4pscPZQBn.tDLZCx2NNr9q6ag5d.7vUaTT7osC1XK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (33, 'BSnow', 'cialonebenjamin@gmail.com', 'Ben', 'Cialone', '7203121951', '$2y$10$Wqepp4I0D1epqJ3lNcNZu.pnLjXTkC.D7rvRaCI0RZfBezaCX.3PO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (34, 'Xray009', 'xray009@live.com', 'Christian ', 'Wills', '7203843510', '$2y$10$77rN/D2kHmHJpxFfF4YyLu4WL0KODr7UYKmdI4dCVa4phLJqcqX5y', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (35, 'MCRN-Combat-Epidemiologist', 'michael.martinson@colorado.edu', 'Michael', 'Martinson', '8058361018', '$2y$10$Oc6zkm8hzQ335JWinyHDUehCG/CzP4EQqpNmeG8EO/pehaMoiLAwy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (36, 'JoelCourtney', 'joel.e.courtney@gmail.com', 'Joel', 'Courtney', '7205396135', '$2y$10$0d9XR8U/UaTo/w0X.M88feFhjOQ8pbAhflxpd.ykqnqGpQ.OKqkHK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (37, 'elco3300', 'elco3300@colorado.edu', 'Elizabeth', 'Cohn', '7133677675', '$2y$10$0IUZUAhfLDz2NpZP3yT22eNxAefnKLlPnJFRmSsOHVchizW8hdSXu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (38, 'Arete13', 'zabr8997@colorado.edu', 'Zane', 'Brink', '7195881624', '$2y$10$yWHGciGRf2abY.skY1wCS.1WLDmwqNxDzwT1m99ocl.uGq8r31Z/C', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (39, 'natkosacki', 'kosacki12@gmail.com', 'nat', 'kosacki', '7196443621', '$2y$10$.YJ8e0mJDUpirCq5cuUL6uiTMZToxIHW0K/deL2sbHKKwFzPZEvbO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (40, 'lilbitch', 'yako4377@colorado.edu', 'yash', 'kothamdi', '9708897290', '$2y$10$O2o6VtKmirRJFgHaFcS9COLKowlSeF50HXOUJ5B5zjyaTH.dNzEQi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (41, 'bryce.renner', 'Bryce.Renner@Colorado.edu', 'Bryce', 'Renner', '7193376800', '$2y$10$EKul/aU0XXJcfgCtYv5xmOY/D0b7U5sOPaRMQRptSgN4Tz6eBwhwS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (42, 'Saotorii', 'albatross245@gmail.com', 'Matthew', 'MacKenna', '9704029483', '$2y$10$e68gVLeHupGYeHbM9fmJYe4GBLnU48OYaBlOfOiDU7b0Hf9OlgUYa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (43, 'AustinA24', 'auan4697@colorado.edu', 'Austin', 'Anderson', '7029941308', '$2y$10$blOUBt/bUhepZPvlHV5BYO/5uFhdLEvBL/qX3yE13bPBSWVfhSvUa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (44, 'rast1447', 'rast1447@colorado.edu', 'Callan', 'Stone', '7202095351', '$2y$10$uve9AbLyfsz0oUKZcGZdp.Eo7eBJ2j5jzs2QTwo333YPJ3LE2gc7.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (45, 'RikuDarkWielder', 'mklb492@gmail.com', 'MATTHEW', 'BRAND', '8165185131', '$2y$10$D88F4m/H2HxP2XtuIvZpLeYsCVEBUycDcmh1dGYsy8cfiJRvNfCc.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (46, 'A-dingus', 'Adam.bloom3@gmail.com', 'Adam', 'Bloom', '3038182106', '$2y$10$svEyMgd92YFXrEIUzQeW.eKh0mJTCU93OBcS/P5JY9mWv88jlAXLO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (47, 'arkatheia', 'jahy3427@colorado.edu', 'Jennifer', 'Alexia', '4107087636', '$2y$10$azvjV.hlSJAW.HK6dwA/g.Z3dxDqVhp19JAG4rqrdddKkgT7VPMBe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (48, 'Nobody', 'akashgaonkar@gmail.com', 'AKASH', 'GAONKAR', '7208771505', '$2y$10$w3r.Plnlm1hWIo7R7NWWueGmucV/cZDtrlLn4dskvKLk9rKmlqZju', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (49, 'BrandonSantori', 'brsa7220@colorado.edu', 'Brandon', 'Santori', '5124349234', '$2y$10$1sI5faQknH605GvVivT2U.m8NPizAW3xZPUusCpJqsllnznyoaVM.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (50, 'elar5353', 'elizabeth.arthur@colorado.edu', 'Liz', 'Arthur', '3176278633', '$2y$10$3nXuBB5R3nAbCGaCQUNXtOPHaCHqV.RYAjRgtYPjcg/ko1JSyPveW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (51, 'Zoolouie', 'allo1877@colorado.edu', 'Zander', 'Louie', '7203019572', '$2y$10$fz2QkFBHfFo21pn4gJM4/e0WXSI17/fvguhSP4qn5TJ/YyWn0viGq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (52, 'Fairouz', 'alfa1081@colorado.edu', 'Al', 'Fairouz', '7203008636', '$2y$10$DB4AqCLhW.a6ic2aGMdABe4hGBfj2KP8s22WB3ktum4hwq6UoCyv6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (53, 'Bluetayman85', 'Bluetayman85@gmail.com', 'Taylor', 'Atkinson', '9702016183', '$2y$10$yK6TPnlScPt3xHp4k84F2e5OjiMdJfJWPzeXPbJEywuS/mbaanq72', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (54, 'Birchjuice', 'm.paige.paulsen@gmail.com', 'Paige', 'Paulsen ', '7203764721', '$2y$10$u0HDwRcf221FqZ8l8RWvFeZwBu107CbTJ0KXMoQRfqlVjLt6A7MH2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (55, 'KurtRomberg', 'mongolhoarde@gmail.com', 'Kurt', 'Romberg', '7206757604', '$2y$10$4s5Z04su5L0whBtM8CdFn.d7UUsrM7jOj9nHAag3K4K4TjYsXASy.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (56, 'eightbitbuenos', 'eightbitbuenos@hotmail.com', 'Josh', 'Munoz', '3126109262', '$2y$10$RYSaN7aKbqeaJFPZZu6SOupOogJa4g.f8/U7Y61skhieHMV35l6oS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (57, 'joch13', 'chuj1377@gmail.com', 'Joyce', 'Chu', '7204747492', '$2y$10$/hjsKMViqA8rE4AqFZy6c.U3vf0aVNFB/5eK6zUFMC4JPyQ97Bcgu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (58, 'knottoo', 'ookn9353@colorado.edu', 'Oonagh', 'Knott', '6315594171', '$2y$10$/WbtK1k/Wpk6nul.Z6Zth.K6H9hGKOCo992CokRVp1idWgAWmhLq.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (59, 'aidanhartnett', 'aidan.hartnett@colorado.edu', 'Aidan', 'Hartnett', '7203943662', '$2y$10$b/aoz6DZ1tyXVN4o60rTJO5NpDYWhO81keLFucMRMoRj2pgs8ogBW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (60, 'Nadiv', 'nadivge@gmail.com', 'Nadiv', 'Edelstein', '7202357772', '$2y$10$S9Rje9jPPkDoR8MdZpQLuepO3dBxh9KQeM4NqBZaWVpZyIslmjKLS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (61, 'JuciaPucia', 'jubi8194@colorado.edu', 'Julia', 'Bierylo', '7209174562', '$2y$10$YVq69AczjRnJA4z9SeKqRee7zbgE3D3cpy3jrg3DvxS0aocZKH6zG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (62, 'darthvid1', 'david.wells@colorado.edu', 'David', 'Wells', '7203691334', '$2y$10$C1saCbypyoh38Spu8klTTudznBYSdGYoxONVa.7Zdk8sb4eGJuLca', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (63, 'Boo-theGhost', 'auma7178@colorado.edu', 'Aubrey', 'MacDougall', '3034751685', '$2y$10$1TBYoKMzFfT8ZSxr3se.xOvByjl8W1sZRMdbMi7A.vS.eGdoJs6dm', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (64, 'Drnotdoctor', 'sara9982@colorado.edu', 'Sam', 'Raizman', '7208918416', '$2y$10$5nuAVyFJKW43xxs0vd2AyOpIaNokIhcAm9z5HE6IF1I8QA.HsZLuy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (65, 'thayer', 'thco9672@colorado.edu', 'Thayer', 'Cornell', '6179470666', '$2y$10$oWZbeky20vFzsJRwxaGoG.dDelC0IONifeXYjSwcxax2zH5YsU456', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (66, 'Lawllipop', 'behe0929@colorado.edu', 'Ben', 'Hesser', '3039063720', '$2y$10$es/G2lSILx2/Imy36pIdDeuCRwP5TLPCAMLaVCTYrpZ1bHprkj34.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (67, 'claudiasellis', 'claudia.e.davis@colorado.edu', 'Claudia', 'Davis', '3342353222', '$2y$10$7qq0Jowl60HP9cKLzRtFCua8o909O/3fUFZ5rtryZOMWCdLWOlziu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (68, 'jesswoodhead', 'jesswoodie@gmail.com', 'Jessica', 'Woodhead', '3036676296', '$2y$10$vMQDirdzQkMKApt5gU/V/eReQ.4zzYHLk7ROZCrWH/oxs2lHgo2nC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (69, 'Savvycappy', 'saca1856@colorado.edu', 'Savannah', 'Capdevila', '9496379429', '$2y$10$ma3x84OhF12AwdviUPvZUeT5YCXCmYsl5RhA.ODA1bg5T/LOgUVQa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (70, 'Zakdebaggis', 'zakdebaggis@comcast.net', 'Zak', 'DeBaggis', '7203847705', '$2y$10$HItsfnZMOPvGvy60xND31u6bDM7oFR27u8ibj5eUhD7CQCKWdnP5i', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (71, 'Parone', 'mparone@gmail.com', 'Matthew', 'Parone', '3032649636', '$2y$10$AVSeXv6Un8jdydd/gPVrQeJlMDTJNNXALUyTCv9O.GWNiCFsInotK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (72, 'Xina5000', 'chth2581@colorado.edu', 'Christina', 'Thompson ', '8283353665', '$2y$10$KytVBwqfI0mLs/gYJXkMcu13obC4Xu2Y1XLZIqTAOcEpeslIBCdq.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (73, 'Krysten', 'krysten.gard@colorado.edu', 'Krysten', 'Gard', '7193301350', '$2y$10$xcOp5cwtW/e/SlZkf19TJevi9FPfLoWmKVECfoHu.Z8v/1ToUZQz.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (74, 'Rdubs', 'Rowan.Woodbury@colorado.edu', 'Rowan', 'Woodbury', '7209178961', '$2y$10$BLz5k1ZGjtJgEYHulY2v4egH9LKeZRnE/msoYiex7064qEh8uQVvy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (75, 'sydchan', 'sydneygchandler@yahoo.com', 'Sydney', 'Chandler', '7143902124', '$2y$10$AQ/sFqiJtQGruAZEosJOqOqy6XSnqLVd9tgR1o7t1lT5aoxTgkdXO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (76, 'maca8117', 'maca8117@colorado.edu', 'Matias', 'Capli', '7206212671', '$2y$10$ccK4L6J9lt2/4jq0RAOXi.Jo44Kj0I6svETYjIlbACi/m/KnT9vaW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (77, 'Mare2072', 'mare2072@colorado.edu', 'Mason', 'Reichert', '7207088571', '$2y$10$xY8iH/HNMKDW/UlkboiPcuG4z/i9A0m57O4kHdCsVJrn.80z5UU1u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (78, 'Andrewstiller', 'andrewstiller101@gmail.com', 'Andrew', 'Stiller ', '3035235830', '$2y$10$YXQUHjuxhMHEgNKVJsVjmOKyW6OnmUdBHUUIR3C6kvBhuzbG1J7LW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (79, 'chriskirschh', 'christophertkirsch@gmail.com', 'Christopher', 'Kirsch', '9043474825', '$2y$10$sKgVktyt13vHh3xgbBtUs.Ir5iHZFTqnDRG46kREGfJPo1tJTEO/u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (80, 'aliden', 'lidenamy@gmail.com', 'Amy', 'Liden', '9702611332', '$2y$10$mEj84B6PNWlU0N/nnjNJZOYVoc6L5fwmcsN40Lr/cior0N4MJzUCa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (81, 'char7887', 'char7887@colorado.edu', 'Fern', 'Aroonnithi', '7209195268', '$2y$10$6XVxmWOpqUdVGNfj8G5Gf./uBnjv1tfhWfFd8MUD7wUbK0CdXnILK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (82, 'rebeccaopiela', 'reop0775@colorado.edu', 'Rebecca', 'Opiela', '2817701965', '$2y$10$GkTeQD9ZjwO0vaOeoC5iGuf/APV9Rs.4DBF5jbWCbZgnIH5IO8GeC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (83, 'janderson', 'jenniferhorses@gmail.com', 'Jennifer', 'Anderson', '7209383122', '$2y$10$5WJ8Hde62PA7KUZ7aBwhfeRNPitChWiuCWRvdya8fvbGJzmjaO2pq', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (85, 'kriss', 'kebuniv@gmail.com', 'kristin', 'bogar', '3036566892', '$2y$10$llxxni85DIQZp.dGhAsOru2WLyKcGor7YJZB9A8WqGMsEDw0ybQ4.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (86, 'JoshThewild', 'jowi6757@colorado.edu', 'Josh', 'Wild', '4108687526', '$2y$10$5eb/tqclLbkvAJhTZGo/U.UrKfqZzsdRdthX7vTOq0Et82J1cYG5K', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (87, 'Tlex', 'abirren96@gmail.com', 'Lexie', 'Birren', '3037463995', '$2y$10$4eyWqfoBH.etuBuIqfwRnOPsJy3BN4CqPfXMhGK8sL67MdMqrsxz6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (88, 'Luci', 'sherriffla@yahoo.com', 'Luci', 'Sherriff', '9703661979', '$2y$10$3taXIGCEv3MxhGD0wMJBG.rWTqemAKw0QFEDiJAZkg8rYZNYoy8.a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (89, 'ocollette', 'olco0540@colorado.edu', 'Olivia', 'Cornejo', '3037048785', '$2y$10$.NWRiL4Gy4taClCHqJnD4.ifKltcvRXam/JKCCawdYhpjeA0ReBNG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (90, 'GrayGhost666', 'angelflorencio13@gmail.com', 'Angel', 'Florencio', '3038597434', '$2y$10$0zelkdonJw.SzoF573NC4.nAqLksarEHBiYGdhdO3WhpD96HyQ0zq', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (91, 'Liponiks', 'nilo1307@colorado.edu', 'Nick', 'Lopinski', '8479091345', '$2y$10$NjlGrrc4zYxd6odPksFU7uzievQUXAWRPGDGBJacSzs2P3H8R3mpa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (92, 'BattleCoder', 'trpa7630@colorado.edu', 'Tristan', 'Palmero', '7148737626', '$2y$10$V0JNrsY/Os3tzU7foqlGLOEwvWsYSMHPKeDYlAp8eHDVufApKePxG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (93, 'Pikesterz', 'anpi4252@colorado.edu', 'Andrew', 'Pike', '5105070945', '$2y$10$kQMNfojHGb6PAlMIw1fFPeOu4OSMZNrtNOs5qwmWnPldt3UbBec4O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (94, 'Jehe3586', 'jehe3586@colorado.edu', 'Jesse', 'Helser', '9704563171', '$2y$10$7J2MZZjIG73OoGectMDMy.6fIc8npTrN3piy2C2FJOeNL.vCvGXGO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (95, 'Vanessa', 'Vjc.cornejo@gmail.com', 'Vanessa', 'Cornejo', '3035887447', '$2y$10$qAbRX/1Z9vOeIEOyx0PubeDVBLvhHePoxfYgNDBCLaY0UNpQIMHlS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (96, 'Adam.Bender', 'adbe1633@colorado.edu', 'Adam', 'Bender', '3034510240', '$2y$10$BGImSSNBV6plSjzPuZcDleUTId8scVIce9kD8eOSazGFcX7vCBsX6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (97, 'bostongal161', 'elizabethemilycohn@gmail.com', 'Elizabeth', 'Cohn', '7133677675', '$2y$10$NgIMLr.YCWEqnMPM84G/O.QgeNimxkDlDseeH/CFDDrzMglLqtCIy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (98, 'cammiep', 'capi8817@colorado.edu', 'Cameron ', 'Pittman', '2105630670', '$2y$10$q3KbjDCIF1.0Ef96vCrwN.VqFjyjy9atpNNtqMlNutzhMVQ1g9eb6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (99, 'TheUnexpectedBidet', 'jawh3661@colorado.edu', 'Jackson', 'Whitley', '2529952443', '$2y$10$eB.d5jT8ulMt0YO0EFxgM.t4fji3JwyQAa6uCrKcSTSwzmZ7ALXny', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (100, 'alla4384', 'alla4384@colorado.edu', 'Alyssa', 'Landi', '9739670187', '$2y$10$NVBjZYHydxpGN7AHR69f/uvOlzfTE06fNnHBQ5H7Chc2SRTmbLaPa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (101, 'TheRogue', 'ansp1208@colorado.edu', 'AJ', 'Spencer', '2089997231', '$2y$10$9MrdlzBnNG6v4AOXNlRtaeGxn.Myym5QOMp8qwUJ2sBB.UtRPDDPG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (102, 'YourMom', 'juanlomeli12@icloud.com', 'Juan', 'Lomeli', '7193314965', '$2y$10$EctaO18IjjxM9HyW8nRBiO04DdZQEg65Jb.EGc260jSj08PxazkN2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (103, 'JamesHere', 'kach6345@colorado.edu', 'kakam', 'chen', '3038197450', '$2y$10$MqJLlO2x6spuKDde20j.3e55hKqgFZCGH/6bpb6a8MmGRzMp2w3w.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (104, 'Soren', 'soren.heinz@colorado.edu', 'Soren', 'Heinz', '2156881461', '$2y$10$WUAjmzlUZXf7/Mx4cYmsFeHpD433jwsUUeFnhEfQaXURZr3PEWM3y', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (105, 'hual0827', 'hual0827@colorado.edu', 'Hunter', 'Allen', '7203249299', '$2y$10$eACqWB7pAoYMISfUEtwVt.9kA5rCpzX.C2WAgaM8/.5Mb17qhKf9C', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (106, 'SocialJustusWarrior', 'justus_leben@me.com', 'Justus', 'Leben', '7202548275', '$2y$10$O3BBW03tgho5STJCdLULZ.L6xkD6VKGOfafBukR0dfGCROHs3wib2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (107, 'Kirsten', 'kiko8499@colorado.edu', 'Kirsten', 'Kollar', '9704566628', '$2y$10$cE33KrZ5ndTMnkAyRrNAZOS2.ugdkvJ0kiOAFMSRPMDK4mJZDZJsa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (108, 'legaer', 'luke.eber@yahoo.com', 'Luke', 'Eberwein', '4846021717', '$2y$10$ed.R2a.uWFfGdVyyZIAWqOo15p0Ht3KIlfO/GvuF5ndSlMGBcGU0O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (109, 'Bech9120', 'bech9120@colorado.edu', 'Benjamin', 'Chilton', '3038687985', '$2y$10$rLIrM16KfOLB0HDYaG6EB.zeOamD2265jJ49NujNDWD5QhZLNiNu2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (110, 'Benjaminc037', 'Benjaminc037@outlook.com', 'Ben', 'Chilton', '3038687985', '$2y$10$G2nlYynwh3vWJ61C865NeOpTQffaJkYLMrxhxIsblsp7qkqXWR6Ci', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (111, 'poimaster', 'isma0101@colorado.edu', 'Z', 'MacLean', '7205055605', '$2y$10$uwMtdq6UegEykotN3gTEC.vAQsMg8AYHczRIJ6dBCRBgyfdViWgEq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (112, 'Rhi', 'everydaymagic17@gmail.com', 'Rhiannon', 'McKee-Gresham', '3037759484', '$2y$10$mk5adAr8BLXu1S7xoIIOI.LG2Wf2QJhDSBNS.hXoP3B3px727wj0q', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (113, 'magickayla', 'kmhoang17@gmail.com', 'Kayla', 'Hoang', '7206489696', '$2y$10$0ddsRG45WKx9jgjzEjLDjuMQ0HtrD/EBGq0v0t/a3LBCZu.vbBi7e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (114, 'jasminelucky', 'jasmine_lopez_00@hotmail.com', 'jasmine', 'lopez', '2028098453', '$2y$10$T0cBQVBaUQtrH/g/bfq3iO5zsuHXcT0Bi7jF/e23ojDcp4WNiaEey', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (115, 'Salavein', 'geoffrey.keeton@colorado.edu', 'Geoff', 'Keeton', '2032168870', '$2y$10$onaieGyV5Oy/aypFqcrqn.yCmSfZD0IUxzh8g1NfYB2ATx6NpLVni', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (116, 'chdu1446', 'chdu1446@colorado.edu', 'Chris', 'Dusbabek', '9706921380', '$2y$10$Vqey2PRyp0TNJwHX4/gFoecZhc1zmvmMfGxmgnh8odn89SvwqQA1O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (117, 'chba9443', 'christhezombiehunter@gmail.com', 'christian', 'bauer', '3039172759', '$2y$10$8EtSAT0K27AlK472uN.xt.C.3eBibAJBszXkIW808ELeVcbM5Hbta', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (118, 'karasel', 'kame0575@colorado.edu', 'Kara', 'Metcalfe', '7203838201', '$2y$10$VyLkIPPSpmxANG20NQ3AyejR5LioBevSg9KXtXWAZIy/CqEF9StN.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (119, 'Zargen19', 'zael2453@colorado.edu', 'Zach', 'Elsass', '9704850531', '$2y$10$NpYZv13AL.1aGmdSy3zI9ORxe/dPB16jPtfhwXYGe/Dx60dZytvWm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (120, 'brockknechtel', 'brockknechtel@gmail.com', 'brock', 'knechtel', '7207450550', '$2y$10$o2su8sF5cLAkIXhiEXZ0wuA1r1ZEaoqJnev0jeN38B3eBmEY8vU7q', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (121, 'GrandMasterChino', 'torresleo548@gmail.com', 'Leo', 'Torres', '7196844521', '$2y$10$K0m9n5B/faqVE6UHXU162.TIwApN2tepivPzD3mgvtsCH4G.7h0Qa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (122, 'Idontlikesand47', 'deri9928@colorado.edu', 'Devon', 'Ricken', '7202997200', '$2y$10$B0mM9CU0mqTBa4Lt6.Ff7OB3eWyEd8xszNVz96FMh9DRwQYl8GhCS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (123, 'ancu2103', 'anthony.cuff@colorado.edu', 'Anthony', 'Cuff', '3033744084', '$2y$10$GqNzrLO25sATXWIocq9DhODx7GKQYZkFLFih5IYxSTcGjyhNf8mRu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (124, 'RedCurlyFury', 'project21124@gmail.com', 'Nicholas', 'Piotrowski', '5202629330', '$2y$10$jgCeO38herNs9unl3hQWueitUcwH4GClLSj22D3Sx5XvA6/B6CikS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (125, 'anniejo99', 'anha2504@colorado.edu', 'Anna', 'Haynes', '3038037051', '$2y$10$GWQ5XZv1EYyGueVPqTz/l.mwowaEC0BR7LIMb88wjnoPjgDig55ni', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (126, 'Oceanxmyths', 'brvi8053@colorado.edu', 'Brayan', 'Villegas ', '7207715810', '$2y$10$YJORWj5kV1Mme2oE//ZeV.acg3C0kiRrJndHgxo9PvzVOfuivgTtS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (127, 'Jastatic', 'jago5210@colorado.edu', 'Jasmin', 'Godinez', '7203548394', '$2y$10$SvWOSPmrE7V2rHq.MOZQh.ApnXoWPa7nWJ75cENT0H/LhxDAICaOS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (128, 'dsowders', 'deso7541@colorado.edu', 'Derick', 'Sowders', '6098744302', '$2y$10$L/FZaLjIj72BsDjzqqEaS.NX8uMc4I2Cs8neRTGS8QcX63FSNZawy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (129, 'Mwillis25', 'miwi0161@colorado.edu', 'Mikey', 'Willis', '9706181382', '$2y$10$cGTxWz8OY6QuzuQML2zAse1CYrSsmU2uA5ZH49lICj.cOZKc2iadq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (130, 'Emely17', 'emdo3345@colorado.edu', 'Emely', 'Dominguez', '9126959671', '$2y$10$dH/unD8X.jzvBGB5dNyKWeP4OBNJSuFEzEFVgFv/fXW6bx7rWCaFu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (131, 'Yara', 'Odbu8119@colorado.edu', 'Odbayar', 'Bumaa', '3039087572', '$2y$10$0iRU5iOgdRrdXeHYZV8/suOZIjCvaRhvFqjFsNX081XpklcKk33Ma', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (132, 'MainSequenceStar', 'cabu5273@colorado.edu', 'Caelan', 'Burke-Kaiser', '4147199224', '$2y$10$KB2zbZygbBdHCCjBilo8p.a8LNuDLq9TXW3hc8umwvPlW0cavbQee', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (133, 'Eggcelent', 'amandaaeag@gmail.com', 'Amanda', 'Gerritsen', '8473475787', '$2y$10$mBDgFIly3FvHKEv24GafnuvG3Tj928DImmGEMamiVvGPu03SCzaXW', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (134, 'Kirstenk', 'kollarkirsten@gmail.com', 'Kirsten ', 'Kollar', '9704566628', '$2y$10$Fp/kRMhl7il5Gfk5U/zgtu92Nqe5uG.YuKu0eTdf5UM1jv0vXsTyi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (135, 'Bellaallen1015', 'isal9976@colorado.edu', 'Bella', 'Allen', '7202292949', '$2y$10$YhUgZTAIBz.2JR1OGGJoTezIGFb3aIVAvcVGKNpfo2RN4leKRBM2S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (136, 'lial3088', 'lial3088@colorado.edu', 'Lily', 'Allen', '7202294539', '$2y$10$ByhPA6PxjD40zBZXzZqOgO9Poa01Miih30.lKOsYDvnDh8YR64Xcu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (137, 'abal6725', 'abal6725@colorado.edu', 'Abeer', 'Ali', '3033569214', '$2y$10$o3Per34SAqkzw.cQXj303OheuhndjOmrLbi5NI/p.Cwdn/1tlzWlm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (138, 'jackdapogo', 'jada6520@colorado.edu', 'Jack', 'Davis', '7202916776', '$2y$10$dn2ZM.BcWjzk.roGY2IWje8ZJ6No3Bkw.7HZ0oMKl2B29Npiw1EX6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (139, 'r12v56k', 'rybe5499@gmail.com', 'ryan', 'Berger', '3033787486', '$2y$10$AJKSNsj4wCXUmMFF0Qe2iOx7gjBh4Z6I6RLXS/tm6nD.b66DVmh36', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (140, 'r12v56kk', 'gaaem1234@gmail.com', 'ryan', 'berger', '3033787486', '$2y$10$2PyD8XiNtBGg7rpnDEeiduh4oZSodKzeDoibvRoOO.q.7W5K/toxm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (141, 'MalloryP', 'mape6980@colorado.edu', 'Mallory', 'Perschke', '8477676255', '$2y$10$btEPlLidNSZ4iFtxFJiiMObqXVaS9TiSs4HFApNpp07tva.HJRyWS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (142, 'SeanDunk', 'sean.dunkelman@colorado.edu', 'Sean', 'Dunkelman', '7757811401', '$2y$10$K6s96Fy9N2XYDMhqMbMQSOeiciUUMKBkaX384uD4goGcl836U2/ou', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (143, 'GPB', 'geba2669@colorado.edu', 'G. Paul', 'Bailey', '3035200200', '$2y$10$U1Bx3X.BJoU7kd8XnrJsjOlcJ4tFKtwpQtlHnUdj11W6yQ5jDZe2C', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (144, 'prescottjd', 'japr9997@colorado.edu', 'Jackson', 'Prescott', '7205195375', '$2y$10$PAbSt7qiHEtTPu38QWDN9Of6aeedqL/7abzBq7eRFaCjdafMj2vW2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (145, 'jessfree23', 'jefr6993@colorado.edu', 'Jessica', 'Freeman', '6144063645', '$2y$10$8EZusrzFw9qLeioqymqXoubiEcURhdqWRTZOh/lJMYm4hdbucltZy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (146, 'FakeSaffron', 'joca6705@gmail.com', 'Jack', 'Carter', '4086803591', '$2y$10$/TnP6rkXIZ2lDuOeGZcaiOHlRrieDALOo512TU9jNvj5RKWxDmh6G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (147, 'Fake-Saffron', 'joca6705@colorado.edu', 'Jack', 'Carter', '4086803591', '$2y$10$Jgdh2tWacQo7DuaLWZtn0.56A6a/ppIYsc6PYK61AlN6Uq8oATUGW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (148, 'dracoshooter187', 'josemartinezt.o.b@gmail.com', 'jose', 'martinez', '7204865745', '$2y$10$eg.RZbu/OVC8Nxfmn9smCeL1QgUUm2vS3Favha0fsjaZ.RWTG.yA6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (149, 'MsAssassinLexi', 'almo1622@colorado.edu', 'Alexis', 'Morehouse', '7202097721', '$2y$10$arl/IyXB0tRIIetdK.HfyuoAVfIsdbsoyO526GfC.iJ3kSe.JfjT6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (150, 'Mego4489', 'Mercedes.Gonzaleswagner@Colorado.EDU', 'Mercedes', 'Gonzales-wagner', '7206290355', '$2y$10$8IhUoXEKvp6M19KNl12Ac.6KWjKzGlX/pkskr3zt2iiYktg4Pi816', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (151, 'drewdpham', 'drewdpham@gmail.com', 'Andrew', 'Pham', '3039138918', '$2y$10$gkQL5zlCBfxnlvhZQlyyL.IdbOt3dNJbSDp3z18C/.9wShf.zDuXm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (152, 'NicoArhcer', 'archer.nicoemerson@gmail.com', 'Nico', 'Archer', '7209515529', '$2y$10$BicHpfY3ix/B8EVcFDZxWO6eKQ3i7DPbOGHvNP6.3Xcz7vgZfhSkK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (153, 'timmellen', 'skobuffs1018@gmail.com', 'Tim', 'Mellen', '3032424484', '$2y$10$cyjpr7/G9BM4Xqd24Qu3KO2nakYpTOtwVex4Ybt8ge083qOm7k3G6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (154, 'Jud', 'juwe7869@colorado.edu', 'Judson', 'Wells', '9494828122', '$2y$10$yoYLMtXpxyCioaiGobNUHuFm8myslZe8nPfPdq9dVJjWYJWwqR2wW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (155, 'Bberti', 'brbe5789@colorado.edu', 'Brennan', 'Berti', '7029011304', '$2y$10$f.Rqo.uOg3k6BHkCxLZFjuv3fCoqyrrUS7YbbyntD7L5TxsTHCMda', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (156, 'JaCl', 'j.clark@colorado.edu', 'Jacob', 'Clark', '3196319200', '$2y$10$lQEILVvBUyNMvuperuU0Ler1U5ceN4fa5QuxU6VfNvpibbjaK2Ft2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (157, 'Jake', 'japi8981@colorado.edu', 'Jake', 'Pirnack', '3039603805', '$2y$10$CCzHKk4sreen0adb35NTOOg9A1.uol5DBUDnHoBZvDR5Vy7s7s55W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (158, 'Elaukli', 'even.laukli@colorado.edu', 'Even', 'Laukli', '2078380396', '$2y$10$npwtln7aigJrQGQnABWvy.Xet21zKCEFwlNesTAFh4Q4RkUZwIPI6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (159, 'Anonymoosellama', 'elvin.chateauvert@colorado.edu', 'Elvin', 'Chateauvert', '8433240396', '$2y$10$BBUbClh9J8Oit.dCZy2eN.DTpktEKaYLPduNlfe79NnkQ9PiI1Y1e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (160, 'Ricardo420p', 'rite5632@colorado.edu', 'Richard', 'Terrile', '6264877006', '$2y$10$jJhGfBY.BdVqnYoifsrIvOzmpvdJj8vdhusGLn5gPxX2Yrzuh9fTy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (161, 'MilaBergmann', 'mibe0968@colorado.edu', 'Mila', 'Bergmann-Ruzicka', '8083432759', '$2y$10$sIhb8nRZCe8P5zsHD50rG.0d34GIQ4Qe1XYHtr/bRdDX6itJOxvD2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (162, 'MilaBergmannR', 'HypnoticTorch@gmail.com', 'Mila', 'Bergmann-Ruzicka', '8083432759', '$2y$10$2qCw4fjAH921aUlM/pe9a.TcbH5lZyxJ.PZlxZqBVzlhpKkhB9UyO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (163, 'berrybrown', 'mibr8352@colorado.edu', 'Mikey', 'Brown', '7202536660', '$2y$10$J5F6HWI8amaK4QocIOZPrOzyiFjQqSWlxNdYyFdYvroKgovMbB1Oe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (164, 'Eily5', 'eire0970@colorado.edu', 'Eileen', 'Reh', '8582046261', '$2y$10$l3u.gmYzpaHltml4dVZQ.e.wYqP3Idy9DCpuhJxEwxJpSpRwMWbjK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (165, 'Lunamintie', 'kathryn.kander@colorado.edu', 'Luna', 'Kander', '7194591493', '$2y$10$P/y8TqcJBaeZSwrLzlQ5FukjkCt4bVu0w7pfvJC5yPCqC1Fi5jNSS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (166, 'ikarki', 'iska6979@colorado.edu', 'Isha', 'Karki', '7202104510', '$2y$10$t7Elh30zIxn/3lSoF2dCJejV5rMdbNpS8trfpXN/KdPfzaBcH7Ze2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (167, 'Nataliescheele', 'nasc9623@colorado.edu', 'natalie', 'Scheele', '4155298842', '$2y$10$2jZU37B2.K43zn3EMP/.weluPlJE9cl3Yu.AYFPhUGeuknB4j9RIW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (168, 'alexnichols67', 'alni9764@colorado.edu', 'Alex', 'Nichols', '9732231442', '$2y$10$mv4ejs903vtoef3iEQ99VucxuO6wd53Y6oSgCHYdSeeSmIp2F.Igy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (169, 'WutangAndy', 'anmu8159@colorado.edu', 'Anderson', 'Mun', '3037201903', '$2y$10$iQvYR8H3VS2tknkPnZQKHeDIMKY7MkPYyCULuWq4HES52fBXdMLuW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (170, 'Else9805', 'else9805@colorado.edu', 'Elijah ', 'Sensibar ', '5206645870', '$2y$10$tiJKC4N9Tp8eaWrZ9W.34empBYZGuhuHMpQ67HbYTdoZ2GaxwSVze', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (171, 'MrGinger', 'isdi9319@colorado.edu', 'Isaac', 'Dickerson', '3037755134', '$2y$10$rM3kl1kyB2JihUZ.VifmGeUEAWBgacoxGXAKSQ9lOeKxB7V.CIA.u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (172, 'Swagatron', 'seanianderson03@gmail.com', 'Seani', 'Anderson', '7203913487', '$2y$10$FCJDv3fTqBgDkuE6hvJqG.Gb4lJjBPLt9fPymkDPsXImqvdG6OXnW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (173, 'Zikra', 'ziha1747@colorado.edu', 'Zikra', 'Hashmi', '7209398116', '$2y$10$vk3qbBlkDyYKTUkgXxYtg.kjT6H0Yh5QLI7jHOO8MgC4ILfA00Fbu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (174, 'Jeregami', 'Jebr7127@colorado.edu', 'Jeremy', 'Brown', '7205524358', '$2y$10$rDJKiqSqfPqTI9u2s8IvnOB9QbLRdghOvQ80aksHizDqcpFtA1I52', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (175, 'cocomcalpine', 'comc2569@colorado.edu', 'Coco', 'McAlpine', '4159394695', '$2y$10$upaIdxii1ErNRsLly3NYFOyLf.kPHen3EoainSj3HJQXJlPI9fTyi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (176, 'Bellelavery', 'isla3747@colorado.com', 'Belle', 'Lavery', '6507409244', '$2y$10$zpV05ngHiQBuxqGOlli1Hu1hh1LESuk9fSY5rziVNzzEuRW2ItTYq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (177, 'Tez', 'elisedancingqueen@yahoo.com', 'Elise', 'Bloom', 'NULL', '$2y$10$6HoUhJoPhMvoocrkYre5BuG46wL5RwHDIBLU9O3zCj9ei0VFFdGre', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (178, 'aziz626', 'azizalabdulrazzaq@gmail.com', 'Abdulaziz', 'Alabdulrazzaq', '7202073213', '$2y$10$rP/nTjlYnyQqt5bV5i6XHuYN5k017raaudpz27ItmILEBkPVuYr6G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (179, 'ErinKugler7', 'erku1213@colorado.edu', 'Erin', 'Kugler', '2157913138', '$2y$10$auC6HnuHru44tW.6mdWWOe9iEdhsVo66v/dvfRozWrMkfnra1K4Hm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (180, 'meganborchardt', 'mebo9701@colorado.edu', 'Megan', 'Borchardt', '3038294669', '$2y$10$0KLMYGYB80JRw82xTKqNLeittHiHaSjkiyz.y9lZ6/eZwIj/warOm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (181, 'sophben', 'sobe1438@colorado.edu', 'Sophie', 'Benecick', '2015190290', '$2y$10$tTVkIHKsAL5Qv4ebHdyzhO1QXav9x25zs3J2xR7L9Xm.b92eemndO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (182, 'thebirdman', 'logandwagner@gmail.com', 'Logan', 'Wagner', '7203461498', '$2y$10$uuexg4sbmAHKhARxG.FUtuMOWr9C0CtHdVBtxMnGkHU2ayX1SEjYy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (183, 'borkymcgee', 'juno.presken@gmail.com', 'Juno', 'Presken', '3035515356', '$2y$10$gorhasVA6.l2LqgQmx55lOTyzC4zdZHBBtjQWBNq787jeVg9TP/BO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (184, 'Gaga', 'gaga0997@gmail.com', 'Gaby', 'Garcia', '7209036661', '$2y$10$yNrJBgCyMM/wjOx/ZSacXuSreHNYUn3U4/EQHWIrfbOOKFQ5bhdy2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (185, 'Gaga0997', 'gaga0997@colorado.edu', 'Gaby', 'Garcia', '7209036661', '$2y$10$Pg0hULXkNyt6kLXB00htsuxqw1e0u.D7ztFoZ6gVS0/pIH45yd9ta', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (186, 'Faswlya', 'emle7585@colorado.edu', 'Emily', 'Lee', '7204124892', '$2y$10$QZPuNpah5AI5fHekF.7l0eGgGz7fnodOUTS8ta/drVkMOy4yjcuKq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (187, 'xxmichellemtzxx', 'eisa3025@colorado.edu', 'Michelle', 'Sanchez', '7193526021', '$2y$10$zDyblBiDSUaVAgfBqJFUt.cmAnMpgzyquF6nDUHd/gYIWX6ErGeiq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (188, 'Abelgeb123', 'abelgebretsadik1996@gmail.com', 'Abel', 'Gebretsadik', '7206022871', '$2y$10$/QnYFWXUaILERUPAVofx4ueT7xYw2jCcooImRj0OEzzZMcQ8AI6bG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (189, 'Gcominelli', 'gico2439@colorado.edu', 'Giulia', 'Cominelli', '7207238887', '$2y$10$hMK9m6sFXXhLMmdoYP3PBO7BdqB3p18H.ZTFqbuUi4wHMDfPkJyrm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (190, 'Mancy', 'mash7825@colorado.edu', 'Mancy', 'Shah', '7202172270', '$2y$10$BHaiM9vQH8yxYnZhHZXI0OLdCoVbg10hNI5CKSzQxXykHUEBYe2wO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (191, 'shellulose', 'hayu7527@colorado.edu', 'hai', 'li', '9705184718', '$2y$10$U3Lm/TT9.xaOVDkt70dtAej1R5UopgCDs4HQvSt1ae9aOUyTy3OoO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (192, 'Thompson', 'alth5662@colorado.edu', 'Alex', 'Thompson', '2247171145', '$2y$10$.tDFPpAh40BIf/tM3gOL0eYBok.4ipGCe1Q8jzY78TGR./O1H.TCC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (193, 'olar6807', 'drammagoose098@gmail.com', 'Olivia', 'Arjona', '3037201469', '$2y$10$HPlEKBjeLRWq8fPZdiQZwuWkFT0wkX9LNK7tvydplT5TC20Y26fna', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (194, 'phwu6529', 'PHWU6529@GMAIL.COM', 'Phillip', 'Wu', '9737673636', '$2y$10$AoRN3hcEcZc62pzRbyesc.4VWRuHcCH/dHyVX.fFOn0dFNmkEtbjW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (195, 'skrieger', 'skrieger.2015@gmail.com', 'Samantha', 'Krieger', '8157193455', '$2y$10$EkmbcvVdncW3owwUyvXK8OM8uDM1214LZGXj6y/7GbqLINPeol5Q6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (196, 'PapaGeorgio423', 'gehu3453@COLORADO.EDU', 'GEORGE', 'HUGHES', '9157066394', '$2y$10$yPM1f6vyfXcaDdDmbgBelO/NCcd5Fj3thEAU4FjURER5XF4tBEPEK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (197, 'sbarrette', 'saba2244@colorado.edu', 'Sam', 'Barrette', '9789895510', '$2y$10$czGhrcEt9rhBaQX8qvMhGeV6wmwlFYIxJVR5/KmvipSO1pUNa5y8G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (198, 'Kellenposacki', 'posackikellen@gmail.com', 'Kellen', 'Posacki', '3366094888', '$2y$10$nLJC.pF7Z9yTt/0P3d/KHe4FcA2H6VkTbQbOzi6AthSk2lAEiwnia', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (199, 'connorlacey', 'cola2087@colorado.edu', 'Connor', 'Lacey', '6143151773', '$2y$10$JXGD3T68RK8Yg0WDYDa0IOhw.0eUS1GLYvqBQ2/IKP408wh9lGNkC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (200, 'Brucevalentine', 'brucevalentine123@icloud.com', 'Bruce', 'Valentine', '3033304735', '$2y$10$q0CHZYUw6y.gUtsYRfwfwO/SNmdbGYoLdlPWC2Ub1x8RujEK.N3GC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (201, 'connorlacey1', 'laceyconnor@icloud.com', 'Connor', 'Lacey', '6143151773', '$2y$10$Sc.H9.lIemSrJXEt5OpbTu7HP7DI8yRYV9XX0zvZAlxlvBHeDjM1e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (202, 'Luwe8329', 'luwe8329@colorado.edu', 'lucy', 'weld', '9148604545', '$2y$10$EXkDPJc5oqqjG3lBAgs89.brJoZfz.ZLu/mE127mYWI4V4/3hLTpq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (203, 'iceShelves', 'pima0202@colorado.edu', 'Pim', 'Maydhisudhiwongs', '7203296239', '$2y$10$0VMUfYgFDHyqlMTgt86E8.wbwGt9jRXtZwdvER.229uaU7rfl4DQO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (204, 'shakz', 'jada4845@colorado.edu', 'James', 'Dao', '3235474785', '$2y$10$zZTEH1CC18fyaxlPa4/ZHOI5kQLIeXQFSvUKsAz/TniAbJk9IDFaK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (205, 'jimbo50', 'alexander.karas@colorado.edu', 'Alexander', 'Karas', '3033495341', '$2y$10$d//jOQKDSzzt0ScTx9db7u5RcOU/eWMAkIAwJGlZpHbpgViMk9zn2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (206, 'ajkaras', 'ajkaras@comcast.net', 'Alexander', 'Karas', '3033495341', '$2y$10$I8btJwYKPZnuS9mPW0bCjen.R6atF6HlYwqYdt8PEmj6bAtRokXIa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (207, 'Ckamiel10', 'caka0065@colorado.edu', 'Casey', 'Kamiel', '9739548804', '$2y$10$RRU/grTiYXm0QUTnF/FPLe7LPJKi13pRdSfA8GSGlbxFzqIOgQvTC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (208, 'Chrisposacki', 'christopher.posacki@colorado.edu', 'Chris', 'Posacki', '3366094887', '$2y$10$bUG/YBDvitIox1YW0AIMT.eYhRVIcCw5pb7umn/oYeBI9/WP0tNLC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (209, 'Realdealkamiel', 'cticket61099@aol.com', 'Casey', 'Kamiel', '9739548804', '$2y$10$p/9171tl6xpu/kQt3fWcVupAW9d3q3jF0v9pPpG8v784aNBi/4pvm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (210, 'coren83', 'corenlam8@gmail.com', 'Coren', 'Lam', '3035499967', '$2y$10$/ThX9iucn44TBFtxyoLMP.8tuaGW32GM0ewwhL6fbNsU3DkGnKLMK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (211, 'ZombieCadet25', 'anng7621@colorado.edu', 'Andrew', 'Nguyen', '7202809801', '$2y$10$WZRFCYqSCxd5M02m469Tj.9D9m87qwgoauYZr.bpBVVlThv0Ymq5G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (212, 'InvertedCrossfader', 'trri8648@colorado.edu', 'Tristan', 'Ricci', '7192211066', '$2y$10$C1XjfKg3qa6njh4VI58W7.fTgGwu/eB1bvo0P3Ea1elrNQ.SHyqou', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (213, 'baltschuler', 'beal3203@colorado.edu', 'Ben', 'Altschuler', '7204984605', '$2y$10$ur.SEkH46RCfx2GapXJtFOPgpgCJlXoFwd/KxurOY7d2ppWoZbhB2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (214, 'aazizh', 'a.alhumaid99@gmail.com', 'Abdullah', 'Alhumaid', '9703933555', '$2y$10$rcsYtlxcnUenueXlIyVBQuRCgkTHYLY9E.NPutwdeLVAuu7NF4iFC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (215, 'benaltschuler', 'baltschuler2000@gmail.com', 'Ben', 'Altschuler', '7204984605', '$2y$10$.guYQCzcYOP8LL/Y16dhjuoPRpfOhbu8hiDFgkwflzOL0GAaXOFmS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (216, 'alantheman', 'alva0349@colorado.edu', 'Alan ', 'Vaghedi', '5713938667', '$2y$10$1S3OwpBQJrY2LAN5/RQy/.j3KQplMp1hHPMzsJcHm9NzLCF40nxwq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (217, 'scottray19', 'scottyr19@hotmail.com', 'scott', 'ray', '4254638468', '$2y$10$G/uZQdkQvBPaqEY9kqIRY.nJ/d8QFl2ULM5eNSg9bRUI.XeU0yB6O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (218, 'CUCLAM3', 'clam382200@gmail.com', 'Corey', 'Lam', '3035502059', '$2y$10$cfZLPjVinxA/gL/gd8FPbeSJPHogMatnAi/LDlElvbLspKwGZRDUO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (219, 'yolodactyl', 'aalo7987@colorado.edu', 'Aaron', 'Lombardi', '7192256290', '$2y$10$4y57Oe5HItYbLdwKA3NQsOG1defKFEZqC3/halXKDPkC3SR/F9lIy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (220, 'CreativeFeeling', 'kead1599@colorado.edu', 'Kelsey', 'Adams', '7039397554', '$2y$10$TgwEq/s8y9xrk5sXI5bZeuZJTrPv33Rt1SBb02.g2KWdKkRn4hulu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (221, 'desc7849', 'desc7849@colorado.edu', 'Denny', 'Schaedig', '3035072815', '$2y$10$VsEZfA6Z6QH4v76puV2KDOuJxB3.eoxBJpJUzYCn3EohV9DnVIiuK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (222, 'Saint', 'bisa0401@colorado.edu', 'Will', 'Bishop', '7202262328', '$2y$10$15VMOXNFHrW93bY1JNoa/eVw2GU9LcI2b9MSD9YdoNJZAA66Rj.SS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (223, 'Adam98', 'adve3509@colorado.edu', 'Adam', 'Vega', '9704155287', '$2y$10$CQmjpuFtQ/PcDl4IS2EZauDMYxqai7JHb4GaPszMqpNNpdzBIvG3S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (224, 'joor228', 'joor2163@colorado.edu', 'Jorge', 'Ortiz', '7205570422', '$2y$10$T4jYZXUPMHzapewH655n1u01IPuNJLUniO1277ysjhxd5RlQu1naO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (225, 'Phoenixflash', 'kifu0187@colorado.edu', 'Kimberly', 'Fung', '3035624476', '$2y$10$cA4atf9T5fs0j6vDqv7uCO.JqLmqulHE.RY4RocHLQiKLI6nLtNqe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (226, 'Trinityp', 'trinity.padilla@colorado.edu', 'Trinity', 'Padilla', '9703192155', '$2y$10$YGlOxnMvdB0mYsUhQMUyrOUOlfhfn0IZ1ochjvCujmWSuIQupSGyy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (227, 'Mast7851', 'mast7851@colorado.edu', 'Madison', 'Stratton', '8019001018', '$2y$10$PLBMUzHTxzlvhqUMCcPzGORBWL.9qGMlN4U0BH1/S3FbZbBsu/IlS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (228, 'Thyme', 'thyme.zuschlag@colorad.edu', 'Thyme', 'Zuschlag', '9708462715', '$2y$10$Vke4B4swdFn7/9l1Ox1X1uiYmgmRgFr13GOwIPho29Y1oniG/1Vm.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (229, 'Hcallipari', 'blackbelthayden@me.com', 'Hayden', 'Callipari', '7205197400', '$2y$10$RTA4pxhGflxGDJER3BPFhuzgQNimcdpYLNcSm.qjtnjBqTDtGmHCy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (230, 'adda1846', 'adda1846@colorado.edu', 'Addie', 'Damron', '4146884281', '$2y$10$SQ4vCoX9B7bYHDSpx2lw..WWcMhlvVDqw.RagZvCY0rjiiLeXZMz6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (231, 'annaben777', 'annalisabenson01@gmail.com', 'Anna', 'Benson', '3038566139', '$2y$10$RsnmwSuS3RXjVOtpja/xV.nLO4SrOoOqDAVkkeVOC2SB0b5xxamIS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (232, 'Evan', 'evha0005@colorado.edu', 'Evan', 'Hanson', '7204800062', '$2y$10$.smRFJ7KqDv2f2IPbgdXS.oZzmGOznPigdfMzOdtU9hpKAQ4gW2ci', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (233, 'jackjohnh00', 'jack.johnharless00@gmail.com', 'Jack', 'Harless', '7205458091', '$2y$10$31xAN7OCvnGIjAqoZNJXuu7Ai1vGK/IK0T0zydTXhQu/S5jOLVUTK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (234, 'jstone', 'just1749@colorado.edu', 'Justin', 'Stone', '8086990795', '$2y$10$kCXaZ3bJf6xg4b60oILnLOkZt7jzveBFwjZca/npW6zogI6pCk/ue', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (235, 'Jomi3845', 'jomi3845@colorado.edu', 'Jonathan', 'Michou', '9072238302', '$2y$10$Ph.6DVvk4YOE3gP1dfRdZuV8/EasnzXXFRCR8f0p4QAb7xtdzgXXm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (236, 'Shehila.Carter', 'shehila.carter13@gmail.com', 'Shehila', 'Carter', '3038093999', '$2y$10$gOhw.IW54n8fQmry5Tlt9OUdznStP7Zjmyqjs4Iv3uipMH8bmDyh.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (237, 'MarisaC21', 'marisa.cruz@colorado.edu', 'Marisa', 'Cruz', '7192525332', '$2y$10$9IF5sK3lDwTH8yRhL6E1iuYDt8m0ehkHHVcZB9Juhov5O63QvFnKi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (238, 'Xectus', 's.gerwig24@gmail.com', 'Stephen', 'Gerwig', '7203006770', '$2y$10$v8isK9bM8/heVwN6t47xkO/s7uxSammvxOb3ho9Xog8g4KSyaRQ5q', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (239, 'UnrealisticX', 'ian.w.quinn2@gmail.com', 'Ian', 'Quinn', '3144359058', '$2y$10$VvHy0zncT7sDFZGCvkeYkuHzT8udYzsQ4qO4duJPkTG8eLTVu7mE.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (240, 'Iane23', 'iaeh1777@colorado.edu', 'Ian', 'Ehlers', '9785056148', '$2y$10$f9DEPdEC0yucc6Jre.ewKO1iG4z9WUdVs1pLIBvlGtHWYsVOwSvmS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (241, 'AceMcFlop', 'simpleshoe@gmail.com', 'Mike', 'Linz', '7196412279', '$2y$10$U8G4qs2ZV9pD2OvZdcrEUOus6MIAkTRomK1FKzcXYX3bRTphoH5/S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (242, 'Samrel556', 'thomas.sigler@colorado.edu', 'Thomas', 'Sigler', '7202338965', '$2y$10$YMx3Wb/Lp0i.d6dAJkTDd.tRbdkFRu9lapNaHA7VZaiMf9RqmStdC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (243, 'shaanp', 'shonoe18@gmail.com', 'Shaan', 'Patel', '8478002037', '$2y$10$Oqj3vdY8ofXHHj9H/uG/ie.OBHT/fQX8yMs2U23LhA8MAhdOYZDH.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (244, 'camikburke', 'cabu4385@colorado.edu', 'cameron', 'burke', '6039210661', '$2y$10$DteaKKQJYw245rGkFLuvl.YFvTtMO/h0H46RtR8qC9UMBWwN2kvna', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (245, 'isabelmlo', 'islo0450@colorado.edu', 'Isabel', 'Lopez', '7208545634', '$2y$10$Fk5XYGwxP5y8jqEa59WntuHdQX5YeLL/ckcU7iWoVm/wBkHyqktBm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (246, 'tiffanylee', 'tile5880@colorado.edu', 'Tiffany', 'Lee', '9704492217', '$2y$10$v0.RJHKHquFpOIymml9aCOibBIB1bQbRQGZSHxEJA8NxanLtUDD96', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (247, 'rili5381', 'rili5381@colorado.edu', 'Rita', 'Livits', '7202988878', '$2y$10$sTs1X.GVF5gWY.kpjPY2w.2iv2ccR.hZk7sUGElJbvGLsTV7E3oiu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (248, 'Dannaconda', 'dannyviboch@aol.com', 'Danny', 'Viboch', '8584725114', '$2y$10$VoRU0II9IiIb/looSlWS0u57dlH85syAjYyX6I65wsI369z4HV44K', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (249, 'ryyyyantaylor', 'ryan4125taylor@gmail.com', 'Ryan', 'Taylor', '5624772165', '$2y$10$FCzsTM6qUCeK/0kHNaU/ROcYRngbkJBar5NEi9Mo7mUyq.7wDw64y', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (250, 'Toryblysik', 'Toly1886@colorado.edu', 'Tory', 'Lysik', '9107427134', '$2y$10$AgqsDS.KlHpEDrov/pRC5.fPhQ7uWtHhebcg.Ip1hZdQ.4WeLc3l.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (251, 'Oden', 'crawleb.ci@gmail.com', 'Caleb', 'Imboden', '8708347794', '$2y$10$ZUzQxeTZeLIX/TKMoJrF6e6jrPEWF.wR4UEGY3tnWC99Rzt9PhhSC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (252, 'wima5559', 'wima5559@colorado.edu', 'William', 'Maloney', '7205601637', '$2y$10$LUUWLB7Ymn2pXpoTfj1YtO7EtbKyY6ZZLtH.vi87nEQuH8lb7QBQK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (253, 'paca7559', 'paca7559@colorado.edu', 'Patrick', 'Campbell', '3039904038', '$2y$10$wZP4mYEmOF/lKM2Gy33vquV1aVHgx42mK3tYy6NfcF/zKDn4G8qd.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (254, 'ShreaG', 'shgh8771@colorado.edu', 'Shrea', 'Ghosh', '7203381319', '$2y$10$aVKN7ONEsE0SkchavWRvO.QBJuB6QEC/hZhYJ9TgY1.J6avaScXAy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (255, 'ShreaGhosh', 'shreaghosh99@gmail.com', 'Shrea', 'Ghosh', '7203381319', '$2y$10$ByBakHUFVKvXQtnnjy/wQu.dtlE8PYDjHhGmLELsZTs6/xN.ZtKAW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (256, 'CasuallyCausal', 'jawa8653@colorado.edu', 'Jamie', 'Warren', '3032148188', '$2y$10$GuLDB08u92CciNxaU7G9oOiIKAzPK.LcHHtb.DzpklYaUnPWjqXCa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (257, 'Davydave00', 'dewi2605@colorado.edu', 'Delvecchio', 'Wilson', '5053863449', '$2y$10$bfXE82Ge7rJQtcKWFNmUCef.LNIq.nEHiRCm3/DYRak2l2ki7lCeO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (258, 'dewi2605', 'davy.davew@gmail.com', 'Delvecchio', 'Wilson', '5053863449', '$2y$10$vjQB0.Ag0u/Scmi.cFplNuszRjRpuDniMh1PiXDKYuarw54yvNxEu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (259, 'Bufftin', 'jure0127@colorado.edu', 'Justin', 'Reeves', '3038864362', '$2y$10$NJegg1TIPTeZzRl6vOZa2uKzBlu.lHeXLxyrScNv5MRGw1E1JzKLm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (260, 'LHayes', 'laha5544@colorado.edu', 'Larsen', 'Hayes', '6199932782', '$2y$10$U27usXKMJv57fWpiHcqNEeZ9A0JxEa0sjZLzqLEFkQPdNix3RFAS.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (261, 'RanaTheunicorn', 'rmarrghalani@me.com', 'Rana ', 'Marghalani ', '7204277058', '$2y$10$UuBzExMSUyS2r/6s/u22H.ztMrwYdRy5CiYHr8PY1Cz12yX98BAVS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (262, 'Ethan', 'ethan.herrold@colorado.edu', 'Ethan', 'Herrold', '3035656987', '$2y$10$TpCGrB3aEk3.D2MrURz1SuFtSb35yPZXHCYWxcd88.mJpLbA.M1R6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (263, 'Ktburds', 'ktburds@hotmail.com', 'Kyle', 'Burds', '3039031753', '$2y$10$fKRP5GmlzWRvB3Skx8mQBeyG7BSQuNElwlqCa7Fr/ll0PuRG/U/y2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (264, 'nohe', 'nohegeno@hotmail.com', 'nohe', 'revelo', '6124443252', '$2y$10$bR.XZLuunwK7revJ12NofOZu9tFOrw7/5WJB7HU85Us2iEiKNQMeu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (265, 'pjwarrior12', 'ryta4737@colorado.edu', 'Ryan', 'Taylor', '5624772165', '$2y$10$EN7pUvkLH/3oBzmrNlpvzuGwTeYL2GK4zIXOszb/xF.X8ALAL8tR.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (266, 'Clairewilcox', 'clairefwilcox@gmail.com', 'Claire', 'Wilcox', '6184209737', '$2y$10$XS.MzWrJIrEkhdrbvwnmt.IgC4zqgCVKgawKAJgmFBNDOMQi/hKzG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (270, 'Gary', 'champ.baines@gmail.com', 'Gary', 'Baines', '9014284074', '$2y$10$RXVfpoetlxDe2Fa7Y8sA/us3mpiPuUQFIpJ9YprN/z8.Qp8PqSDZa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (271, 'xXNerfan11Xx', 'tmr710@gmail.com', 'Trent', 'Richardson', '7195517040', '$2y$10$5tOn7kZWr1H0eNMvcyZFyOzvevWqcDfbo2gasF1wJOvahRmQIgdbC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (273, 'TestGuy', 'golfinjosh@yahoo.com', 'Test', 'Guy', 'NULL', '$2y$10$u10byIUGj0Yv/yUm0bNv0ebGkagni6EER04iamEd2nNUm/3xHcCDq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (274, 'eroeck006', 'erro2466@colorado.edu', 'Eric', 'Roeck', '4089210624', '$2y$10$pLX/ovqTvue/njrCvQ7oTesIYOaw8yje9gY2G9AaXCKT8GeI4dM1G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (275, 'Matr3942', 'matr3942@colorado.edu', 'Cameron', 'Trost', '5305743117', '$2y$10$V1qyGwq.4SGWYgcmPFXt5OPKKKFl.PHDAz6BGjY8g/iCe3n2CPmlO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (276, 'habr7336', 'habr7336@colorado.edu', 'Hannah', 'Briner', '9702617767', '$2y$10$RDZmbGC82nvtnV68UbpboOIOZY/x3OTt1lxu8X.fd.VpLvNQ1AXYO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (277, 'bhaldo', 'brha1688@colorado.edu', 'Brooke', 'Haldorson', '7202360579', '$2y$10$vghdqYQalqCmeg4VZot7pOz6sys44dbtSiyurO05FT5MYpmo2WTZu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (278, 'rebecca.su', 'resu6335@colorado.edu', 'Rebecca', 'Su', '7203838686', '$2y$10$jf3yfIoe/Y6WtRdkapbsceWXaZW1U914rBByGr5uViGQNqAl4Mt8a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (279, 'sierakiana', 'sica5093@colorado.edu', 'Siera Kiana', 'Camacho', '3037189021', '$2y$10$Pqo2YlVhJ9lutAEn5W0sEOstgj3sXO/L/t/QE3zS37jXhz1e8hHjy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (280, 'kaea3463', 'kaea3463@colorado.edu', 'Katie', 'Eaman', '3038072977', '$2y$10$VJmBaqiD53cTunmUYVTR4uJik10r1MTvBdtd9.wtpcNuouKZrXfSO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (281, 'aaron1edu23', 'aabu4992@colorado.edu', 'aaron', 'burgard', '2012890441', '$2y$10$qaOV/SUQLNT.ogkgbz2SqugD2uPcmvZ36H3F6DsoFD7FVipXsLXMO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (282, 'renniemaui', 'retu3846@colorado.edu', 'rennie', 'tucker-meuse', '9707869968', '$2y$10$iX1NdE5JfNhkjcgz.MtZdONqcxgG2VrBE66U19ZBCPLAVU0L2Yj4S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (283, 'MacAttack', 'mac30123456@gmail.com', 'Mac', 'Cohen', '9704565760', '$2y$10$IaFWRcJGOaVtBAMrWlp.VeNlOwg9iwRHh7VyrYUJLzcBa1ly38LmK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (284, 'MacAttack27', 'mico4709@colorado.edu', 'Mac', 'Cohen', '9704565760', '$2y$10$5fT3i3KObrvXvDZwt14VJ.t0AzoXipMDN/XVOtxfZbS6Ds6HRQsXO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (285, 'aminder17', 'andrew.minder@colorado.edu', 'Andrew', 'Minder', '2036451687', '$2y$10$LDSaUknjSnAvzVZA7kslU.hxJvMpkNL.YDwfAihmRxLmkViOzyS7K', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (286, 'JakeLiebow', 'jali1005@colorado.edu', 'Jake', 'Liebow', '2038070765', '$2y$10$EFU0QyofNfOgBo6673K7yuOyUDQmv9jmSmXQLFR17KaX51p9fTdWO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (287, 'brennensched', 'brennen.schedler@gmail.com', 'Brennen', 'Schedler', '3039183739', '$2y$10$G3kXW.bohYyMTawiT2BqoeT6cE.cOgDggK/EtUKnIIDbrobMJLrYa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (288, 'MattSoto', 'maso9985@colorado.edu', 'Matt', 'Soto', '9495272900', '$2y$10$2BzaW57kAnX5h6jgUplX4esF9s8OdzHOs1.mZXIhEjwA4NdUlBxj6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (289, 'SakoStylo', 'sako4595@colorado.edu', 'Samantha', 'Koenen', '6164850259', '$2y$10$04LCwYdXG1zL/Abq.tNRjOjlZ10E/E/SCzh3ZpXkZ45cwzXAObR8q', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (290, 'Lalyon', 'luly2738@colorado.edu', 'Luke', 'Lyon', '7167139153', '$2y$10$s82r9ZgzrnNrQ6p3FtxE/eFCQCjrJmvZtPn8C.LgDL7nD2NY29Buy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (291, 'oscard', 'osde4450@colorado.edu', 'Oscar', 'DeRoche', '2074185763', '$2y$10$/893t/yYIyndHSuylujRHuenFUzyXWgp30vyKjrM9LbKfzXZDSuQ2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (292, 'cjhemstreet11', 'cjhemstreet11@gmail.com', 'Cole', 'Hemstreet', '3037463370', '$2y$10$Dx5isVKy.JTwbOFQEnfgu.GOZPqGSNyRYuYxO2gpAY9SXXzwfxx0e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (293, 'somebodyxxx', 'hurricanejr@hotmail.com', 'Vaibhav', 'Chourasia', '7202911477', '$2y$10$wPuR.UWQaULv9ao0U4ieeuUKL/MZoAJBV51q/uXXrxxLpLLCy/f4O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (294, 'annanat', 'annanat23@gmail.com', 'Anna', 'Lee', '2079397712', '$2y$10$P3FuEGl9yQeLKDwh22sfCO7uqPtOB3ob6mRgFB010SnfJBt.qbeza', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (295, 'devinriggins', 'deri0734@colorado.edu', 'devin', 'riggins', '4437979855', '$2y$10$jtM7FEEzIojMcWnoCd/e..8Q7.ZYMvQw/v8Rj3Rj4qN2z7P9pURTG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (296, 'Rezz', 'riha6672@colorado.edu', 'Blake', 'Hampton', 'NULL', '$2y$10$McF5wGI4Tx2zGCoYV7JFBejvOrEq9zlRoy1UiST3Mvq9hI1kGIeRm', 1);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (297, 'Troy', 'troywright3282@gmail.com', 'Troy ', 'Wright', '9726004616', '$2y$10$4SN2Kmb0723NT/ZgCkpbv.OIZdIQ0VydUI3VY2ocU2Ht7lKdq.Nyy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (298, 'Kenjeongliver', 'jiki2508@colorado.edu', 'Michael ', 'Kim', '6503394038', '$2y$10$QRpogE4p1U9IxEl34BoW0O9YlCCn57A8VXt2Szml9PVVDZtzvpRw2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (299, 'GaigeZ', 'gasc4841@colorado.edu', 'Gaige', 'Schaal', '3032462596', '$2y$10$5nO5dDUqExkCAapwNk6/hOtDxaB/lHhy66uPSjPJgKVEPcU07xBD2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (300, 'TaylorMcDon', 'tamc3926@colorado.edu', 'Taylor', 'McDonald', '9702090414', '$2y$10$8viaP3q9nL8x925MGfHY2OcCCHxBB.UC8D2s4TBivuMNdDfttCLc2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (301, 'Gilster55', 'magi7124@colorado.edu', 'Matthew', 'Gilster', '6189609948', '$2y$10$PuSyphYZ1au01AW5iMt4VeeQMW1iLnTwUqTh4UI5n3qHSh/UnWnV6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (302, 'Micanat', 'michael.bac1999@gmail.com', 'Michael', 'Bac', '7139067155', '$2y$10$l.gJZjbuMHBmDFKi9iyiUux.4x2.aOtqvv19aQl9KUoR15o3q6zqy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (303, 'Owen', 'owbo2103@colorado.edu', 'Owen', 'Borusiewicz', '7203185647', '$2y$10$Nw2JKzs/6d.4alzYnZGzVe2fxLtt20rx0m5KYgKAAM3eGo4RY.Xcm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (304, 'Poop', 'mohammed.k.alhouti@gmail.com', 'Mohammad', 'Alhouti', '7202071391', '$2y$10$9JtmhihRsrLXYuAmKuR9BuFRm9DVYoQynjnNP3g4SPzljx.PW9gey', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (305, 'Hamad', 'haal3849@colorado.edu', 'Hamad', 'Alsaleem', '7209174361', '$2y$10$Z/g3s/D6eRm7DlWs0U6KwOUypZPq0G3TLvwBkMuorUwPVcjvA184u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (306, 'ambineid', 'contactambineid@gmail.com', 'Aziz', 'Bineid', '7204161620', '$2y$10$ddBsWNhQ0Er.LtoetleCqe.mJ9iS8IqsLjbJq8qrKjUfPTDY5sWIu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (307, 'Smor777', 'samo9751@colorado.edu', 'Sam', 'Morin', '7209511058', '$2y$10$VizCo.klwXjsHGznjpZmWu0FBpQQKLCAZQ2SHLj6AqFxftRd912aK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (308, 'Fletch12', 'rafl4970@colorado.edu', 'Rachel ', 'Fletcher', '7817333122', '$2y$10$Mz51f7fRxsapNMGru0xxN.N6NLDrX3ZH1nETl.10ipAy.aSoHFbki', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (309, 'StubbyBud', 'jon.hoeffel@gmail.com', 'Jonathan', 'Hoeffel', '7192091953', '$2y$10$olXVnT4MYShuvCmj0OAebOnVWqyw0qWp6ojCqjEkK7IJSbWIBCXBe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (310, 'Trevessse', 'tlshirakawa@gmail.com', 'Trevor', 'Shirakawa', '2158503544', '$2y$10$IQVL6SwZwQ6uLj..KaCXH.KYJFo921xN0wD0G0lcuhceH1dAUd5eC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (311, 'MacDaddy', 'lama5596@colorado.edu', 'Lauren', 'Macdonald', '7196511105', '$2y$10$zVVpcdhp6fAE.dQtfgLzVO74.RehFMVQlphlg7.VLo2x99Z.cVmo.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (312, 'cstiltner', 'cast0513@colorado.edu', 'Caitlin', 'Stiltner', '3037208975', '$2y$10$PpAZT6GhS/wLq.DdnwP/MOG7ZuTHfoTIBpU6pe83huF7KOakWa1qy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (313, 'lmills', 'lemi4353@colorado.edu', 'Leandre', 'Mills', '8108249998', '$2y$10$9c5F6Nw0Vyi/48HkppPO9ukojgIHS1caVPPt1Jck/ikI.shsdeutS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (314, 'anen3020', 'anen3020@colorado.edu', 'Kaylee', 'Engelhardt', '3072173663', '$2y$10$zfLAVCenPl49y.xUQu8IlOkKsor8SB8WFkJrRXeZWv40i/RNfitAq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (315, 'Jkirch123', 'jkirchner123@gmail.com', 'Justin', 'Kirchner', '7149047537', '$2y$10$T89HPKnxQgiPTJQKPU.db.OsItQir2c7e6TkE4z./E0mKXZ.i221S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (316, 'iakona31', 'iakona_agpalza31@yahoo.com', 'Iakona', 'Agpalza', '9103913383', '$2y$10$QDX2337a6mT24U9isZImbeWmQVSYyDPNQcsSFv5yZ6zPOHgnANuQW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (317, 'Dshumway', 'rubispiritwolf@gmail.com', 'Diane', 'Shumway', '7203930071', '$2y$10$cQ7yJbx/LM7e0u/RREpAQ.KmYWNIcg7RUdWXMAsAbtX0/rhDx21MW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (318, 'SydneyHighsmith', 'SyHi6486@colorado.edu', 'Sydney', 'Highsmith', '9702137818', '$2y$10$MS/bWiNgGv8sesi7.6WX8.RWBQvyu.05bj9K45sgTju/fu863GknG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (319, 'pittviper', 'sandra.ortmann@colorado.edu', 'Sandee', 'Ortmann', '6692254532', '$2y$10$8.pNL6tX2rCNHY7KfXkdAeYy8QwfA8mKGiOG38jEnp8xacL0wP1kW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (320, 'Bowserbot', 'bowserbot@gmail.com', 'Bobby', 'Ford', '3035657052', '$2y$10$0WbGg3PyFVkzBDAmPnhV5uU1N61FrBlAClWm4GnErX4CZEjkb/tBS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (321, 'meaghanthompson', 'meth0502@colorado.edu', 'Meaghan', 'Thompson', '9493954204', '$2y$10$gJaIVd0TIJsHWamo63tOCuv1RlF0y/mLljUN2sJfXHeWpGXcVVeQG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (322, 'bassamii', 'abal1781@colorado.edu', 'Abdullah', 'Albassam', '7202923778', '$2y$10$rbLk3ERJUCVN8bLXV9lkROOImYuMOPqlHE11ZMbl1dEdie6iBk7w.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (323, 'Frap5891', 'frap5891@colorado.edu', 'Frances', 'Applegarth', '4156860989', '$2y$10$PXlNKFcYCTPW.eeyhDvR0eo5eAgYLjuP9d1FiZOykeNifawgSNYtC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (324, 'Psmall', 'pasm9701@colorado.edu', 'Paige', 'Small', '7326938278', '$2y$10$FpsaNzyUew/00QOEF8xqaOQj5PjQPIh3CT6MSXHZzMRbYSFLxr/ny', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (325, 'AJGaccetta', 'aj.gaccetta@gmail.com', 'AJ', 'Gaccetta', '7206306291', '$2y$10$R71Ufs3rd7egKfxtSdHf/uHtTiJgxr/ZqY92rFkPZ5pIv7V4AYWui', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (326, 'ablobianco', 'allo3329@colorado.edu', 'A-B', 'LoBianco', '9496483228', '$2y$10$ZmxqSeVL2jrSgy5rmfYeXeYpblytalfnUrEqNioHJahpmF92bRjS6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (327, 'Bpage203', 'bepa0041@colorado.edu', 'Max', 'Page', '2482245310', '$2y$10$ksxjQrOBUy8ZdraE2SJFPOt66e62IDcKBMx3g2vRei5Ls0bTEhnFe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (328, 'Virivarela', 'viva8647@colorado.edu', 'Viri', 'Varela', '7202387419', '$2y$10$SStjETfdDexw5SaOs7UDXudTzxuYD.2eV4Lp/rDJR/YkMNWura8bG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (329, 'Bregagliardi', 'brga3962@colorado.edu', 'Bre', 'Gagliardi', '5616018344', '$2y$10$UyB.AoN7sBFngks2uMDCbeSVhPCTaJVLKuk6eMgcYXnm7pYTeAwTW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (330, 'Resc2214', 'resc2214@colorado.edu', 'Renee ', 'Schnettler ', '3038172036', '$2y$10$GLoHkxs.gPxZcRWNKlpGdOBoZAJtnEkG6a2am/7fwUYyyZUZeGFR2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (331, 'AndrewFerraro', 'anfe6566@colorado.edu', 'Andrew', 'Ferraro', '3039120348', '$2y$10$hHS7S0YzJnNVpadTE01KrOWf/ieK1yG1nni6/nwm4dHEyOQmqEPYW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (332, 'marinekaufmann', 'maka0950@colorado.edu', 'Marine', 'Kaufmann', '3059889643', '$2y$10$BHhHLs/i/rIHg4t7rs7YSOkIXq28pUTLbZkThzUWeuEB7hQJD9eQW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (333, 'nerfOrNothing', 'lada0032@colorado.edu', 'Lauren', 'Daniels', '3035238157', '$2y$10$C47DrGXDHqKOm3Z23RUL9u4zbGjg88vbYDuEce88izLNNdqgpw6sK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (334, 'Saol2097', 'saol2097@colorado.edu', 'Sarah', 'Olson', '3038872250', '$2y$10$BwSxz3akM9fHHrn.J8zAwuT6nvxJ/wDnrJYWdWI4/NOtYcUENfe9.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (335, 'brli3504', 'brli3504@colorado.edu', 'Brett', 'Li', '7192463376', '$2y$10$Ykky147E1Ts8967Tyu0bd.yV6vK1CJUo8KfjmaWlNvwgoLP1QkVRG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (336, 'Dads', 'fech5240@colorado.edu', 'Felix', 'Chan', '7202065487', '$2y$10$3vl0AgXpf9m25jU/QRya6.QZZIWxytomZ585e/k09pBmPbrxlYG9u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (337, 'killA667', 'josa0759@colorado.edu', 'jordan', 'eee', '6193026361', '$2y$10$2ijilJBAXLr9sk1YbgqloO5bVgrQ83nqRvgmM.7bS6XwBb7lbEI5a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (338, 'CthulhuofMars', 'salpsan64@gmail.com', 'Nathaniel', 'Carr', '6237557591', '$2y$10$GIZgADkxFJScxvwQMmQNDOIritDQB8mfTJO2pjb2ozYJ0hJX02n8S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (339, 'Isaaczakin', 'isza5334@colorado.edu', 'Isaac', 'Zakin', '2024076415', '$2y$10$9FA70IpUjNSXuBt0r4c4kubaPjK6OYUwM2NxVkBqJl3U/un4aExJy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (340, 'Desu', 'deka5129@colorado.edu', 'Deshant', 'Karki', '7202855811', '$2y$10$RjfHSIn1y0j29hjZJJj3JO4EjWF.MPpeV8802YnZ9hMG8FKtQDOx2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (341, 'Kisa4985', 'asako91299@gmail.com', 'Kiernan ', 'Sanders-Reed ', '5052214422', '$2y$10$TqoJkF3GruAFP72ceHkQiOyNAG0gEdtAy02DC7yXsUwH79mc/tKsq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (342, 'Sabu5269', 'sarah.r.burns@colorado.edu', 'Sarah', 'Burns', '7193379927', '$2y$10$AHL6qAs//XZdDZihv8MpAu9veG/XK84eTW/.NoXTk1Kz2fEoybSh6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (343, 'Morgannegau', 'moga2589@colorado.edu', 'Morganne', 'Gau', '3036686341', '$2y$10$rrrJ9k/3CskBG2WRoVb.SuJy3i5yxOPPrVJUPvtz6OuObYA1gCR6a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (344, 'Brli6383', 'brli6383@colorado.edu', 'Brian', 'List', '9705894864', '$2y$10$LXmd8AlYCFD9Q47G7eNE0eVLKPP1T5mq2XmGvRoqSHdjodhGi/k8i', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (345, 'thma4535', 'thma4535@colorado.edu', 'Thomas', 'Mahre', '9707731243', '$2y$10$93ugvHQm2.b0NBSgnjXdgu1z.0C9XE2LCJeQoV4HO2FPGdyVQhWx.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (346, 'freelancer99', 'masp3836@colorado.edu', 'matthew', 'spallas', '5105797516', '$2y$10$xAu7VmjtM8h7Uv3AfuogYONx2KoFEO8c4mqfvYoHflatrc3u3Yqqe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (347, 'Whatsnewpussycat', 'lucas.brack@colorado.edu', 'Lucas', 'Brack', '7202613695', '$2y$10$CcAIMgm6lcSzrlB4B/mP3.lqIewsdyzB52zV/5pS1ns.OvUjRrcCG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (348, 'Bobross', 'Elpe0091@colorado.edu', 'Elijah', 'Pettet', '9709488474', '$2y$10$LR.ibsue5TD4cJMF0sHt0euScs17BcCXcLxPYHpLlTrvTiS2G7bRK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (349, 'Numbuh23', 'gzimm4@gmail.com', 'Gavin', 'Zimmerman', '4356596998', '$2y$10$3bOI6kyqwImI5441R2P2CeEopD6rgI3PseLqvuzJHdIGHfwXqV4B6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (350, 'Ryjo', 'ryanjajoseph@gmail.com', 'Ryan', 'Joseph', '6177809990', '$2y$10$BZCq8VfLkGkWxky/pIisC.MPWqIinA.zk1arB08sUkn7z0od1c4.m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (351, 'Lightning_nerd', 'thma1325@colorado.edu', 'Thomas', 'Maeda', '9704081507', '$2y$10$ugRbTEQRXrx7WWVFso6iy.2oF.UGOBMCsYL3uxQooCrTX2G8pc69S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (352, '7DaysWolves', 'soul7588@colorado.edu', 'Sophia', 'Ulmer', '3036565621', '$2y$10$79yBEJ./vBwPWIvfLmo.vOKsUTDsXIK5xnMC8qa.H9PFhBlBwtsKq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (353, 'phinny43', 'phinny43@yahoo.com', 'Phinny', 'Negash', '3039998846', '$2y$10$5J7LNjLwls0uco1k2k5jK./dIQosjqrvNszvzg8b5ScLvhnEvxkx6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (354, 'Imoutohru', 'bozephanlo@gmail.com', 'Tohru', 'Dutro-Maeda', '7204135678', '$2y$10$2uMSX89vYujbW0EKGLR8y.3cy6UZt/UeeG6Ry0nUGs45gNHTc5UL.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (355, 'hutr4516', 'hutr4516@colorado.edu', 'Gia', 'Tran', '7204010728', '$2y$10$KhfZferm9uUkER6ZKkes1OVGJePXe1qO5tKDSqjPisMtD5xCdk.GS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (356, 'alex4968', 'mach7619@colorado.edu', 'alex', 'champion', '7194539800', '$2y$10$RHQOnkokjD1F7NY5vNGlf.CH8CgOISFDPw7Rr8bg8J/XGmf2WSzCS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (357, 'benjamin99', 'elca2630@colorado.edu', 'Benjamin', 'Carew', '9108034145', '$2y$10$rGMSue21vl2De929NzfgU.ton/Ol3cf7qG8QyR4./09bnj5bdYlJ6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (358, 'orionstars', 'orion.rozance@gmail.com', 'Orion', 'Rozance', '7206284409', '$2y$10$vicE1twnNHRaRRcx5ZYH8uF.eT8lfth5iY..BEfQ45HbqGKoAM7KS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (359, 'randomcory', 'corymundt24@outlook.com', 'Cory', 'Mundt', '3032492932', '$2y$10$4LY/m/fT6roTtU7uv73rk.uMhVeTAywwO5qGlewwqDZCOvniNmZde', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (360, 'fskhajah', 'fakh0593@colorado.edu', 'Fatemah', 'Khajah', '3038038908', '$2y$10$Qd.NlpT3qi0.NQDjvPGyNefN50CcDhSkkL6k.mMArKsdXZAzzLID6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (361, 'TalalKhalfan', 'talalk@outlook.com', 'Talal', 'Khalfan', '7205197898', '$2y$10$HXjgx8pLTt9Jpg/Yx7AvUO4oNCMwFGARcltAwrOn.p/XGNCUMt4vu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (362, 'faal9208', 'faisal.qattan55@gmail.com', 'Faisal', 'Al-Qattan', '7202999417', '$2y$10$XG1lfy1R/QtTs7vojEVwVuIhrQLl1u.RX3Quqfp1qZBOFvsuFr9G6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (363, 'Jefferson', 'jepi0026@colorado.edu', 'Jeff', 'Pincus', '7046121945', '$2y$10$Gwbq1geA.ycvZlmx24WUDuVQR6B4c1rDksUl34twEC9mnoXsRXNLe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (364, 'soyboy', 'cairnesliam@gmail.com', 'Liam', 'Cairnes', '9726556686', '$2y$10$LmbZzHMGuwWLG.mC5L5WlOvo2JzPRMn06ykwfr0FTTNaSt5nuaHR.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (365, 'Shelleileigh', 'midi3532@colorado.edu', 'Michelle', 'Diller', '3038416182', '$2y$10$/FCuLlCUdLJPf/lDFcT7Ke7logbEWvNSrCaUR0ojzKQRm.j/BUbJS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (366, 'Kaitlynhval', 'Kahv7616@colorado.edu', 'Kaitlyn', 'Hval', '7202447503', '$2y$10$Lne/54hiSAeuqsbhQSJlTuPAkScmFBGBnFnyB4P9CUmRSeqBeKaIK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (367, 'Mayagreenstein', 'magr7328@colorado.edu', 'Maya', 'Greenstein', '2016933807', '$2y$10$IhMOPysklPkcDAxgKrzSiOB9JkQHwEMokU9.csqy1byBoMvY1yHN6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (368, 'Talal', 'takh3745@colorado.edu', 'Talal', 'Khalfan', '7205197898', '$2y$10$r.YHxDHY03eRWULcMqldDOR2tFoyJjLox72fFALWBMiBzGE6o1cU6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (369, 'PartyFruit', 'phcu2335@colorado.edu', 'Phaedra', 'Curlin', '7204868399', '$2y$10$NSmPZUGnKp/Oktb6OMnWiewc9u8Mtpkuxsx7Xcu/YZcprI6AAJFvm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (370, 'nativekhmerican', 'adamlouisgrabowski@gmail.com', 'ADam', 'Grabowski', '7205392043', '$2y$10$.y3EG17WDKrZwCv2lq4OyOtl489mwTXTKZKK7mUFuS55wbC.GZDJW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (371, 'SashaK', 'alexkryuchkovlive50@gmail.com', 'Sasha', 'Kryuchkov', '7186500037', '$2y$10$KrDgRLYjTzgAlC/4n8R.1.hhc7uqtsgk1Z6v0Y3Y0geifFmzy5/N.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (372, 'Jusc8836', 'jusc8836@colorado.edu', 'Justin', 'Schroeder', '3035960971', '$2y$10$9i8Po9h5Sm/T/UUfQmYNzecA90Y7xYgIfP7kGCu1UEzVHI250/MIq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (373, 'BuzzKillington', 'kyleoneilz@gmail.com', 'Kyle', 'ONeil', '2233409073', '$2y$10$/fA1M0brNCihdE2xzJmryOnvWfNzxeXk.mNukPxNwwYGTyZFjYp8a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (374, 'jaho7942', 'jaho7942@colorado.edu', 'Jack', 'Holland', '7203608625', '$2y$10$PR7KkBpvggA6Hr9VhNJQPe5PLBw2GAy6GmTfksFWDr1p0OvuRCUku', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (375, 'kapl1914', 'kapl1914@colorado.edu', 'Katie', 'Plain', '4144773527', '$2y$10$q0JC0b6/i8GNan1dDZNbw.aNVKDk4NLGRVtntFkgm/f1lcUgTlRw6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (376, 'Brendan', 'br031000@gmail.com', 'Brendan', 'Rishavy', '7192137347', '$2y$10$/flXlAzw3X/ceh7oiB2xjOCdBkOk2RAxyHJEU7K6jT8krc2RKle2W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (377, 'ButtMcFuggins', 'jela5842@colorado.edu', 'Jeremy', 'Lamb', '8189669827', '$2y$10$tkJuETAY7wi.XZ4UtKwH5.KxFhU8VkzWXmBq3WrObDXO8ZR56NbH2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (378, 'Rosco', 'rosco.adgate@gmail.com', 'Thomas', 'Adgate', '9704567997', '$2y$10$gk8/ugJJ39H1iAMIeG3jruep9Zxzfot6SkNCPXahbuzVaFECeXiIm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (379, 'Davidkoon25', 'dako2807@colorado.edu', 'David', 'Koon', '3035472111', '$2y$10$VAYDAvbaRkBz8SKSqYxeDu2m7puGfa8HI2mAV0D.KcGzP5NJETj3S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (380, 'Calebhanson', 'caha9531@colorado.edu', 'Caleb', 'Hanson', '6508049249', '$2y$10$9UbSopXwqSrm4whr2HkkSekN2UhGeBEtyZJHLezRCTt3bj1l.PcyW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (381, 'gabriellalettow', 'gale8501@colorado.edu', 'Gabriella', 'Lettow', '3037753017', '$2y$10$eAXnjUbD2BzYg9nV9ZjnAOshdK42EMSDP1HtuP6bIUHBaDhjT2Coq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (382, 'Brendanmulcahy44', 'brmu1856@colorado.edu', 'Brendan', 'Mulcahy ', '9499030163', '$2y$10$eIDxHgs3wmU5bwilCZtlTuyUoiEPQJIz0ttttYZRVlPgvtQNrM9/G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (383, 'Kabe1130', 'kabe1130@colorado.edu', 'Kayla', 'Berry', '9702611586', '$2y$10$TTN1NshGoUwAyQbGXWvrp.ToPpWzvjwe89l2JyqYi6zCn88KDrK16', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (384, 'Nol7333', 'noelle.m.ireland@gmail.com', 'Noelle', 'Ireland', '7209756941', '$2y$10$grGCPkQNud7LMOmJrfJvmeXXreIZKhwdjM3s9M2d7Bb8v5IFRK0fK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (385, 'Patrickmaisto', 'Pama7339@colorado.edu', 'Patrick', 'Maisto', '9084337337', '$2y$10$RLHFWWRvX2SXDsqze6DG..uAFltYqxDrRYyJt/ip.CLP7TkIoSPzW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (386, 'frank', 'frbo5265@colorado.edu', 'Franky', 'Borges', '7737338017', '$2y$10$LnIk50URU.L84ytVklc5.ObfPX.RdV1Q2cwm9bOWokqsDYvS1ptI6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (387, 'barkode', 'george.demarigny@gmail.com', 'George', 'De Marigny', '2108626051', '$2y$10$lR/ynELmUkcTRIYXnJ/qF.GDXqRsqPFhlll74dlhEyfGbIvAzcMKG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (388, 'Westwood', 'wesu2739@colorado.edu', 'Westwood', 'Sutherland', '2032288861', '$2y$10$0VzOFIa.v1f0uofvMINwtev6CpDr0M18aC4VAQ/2JJF5RT0s1xTe.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (389, 'Jeff', 'rete9290@colorado.edu', 'Reid', 'Teren', '3102834010', '$2y$10$ET8pjZpy8mXczBUB7Jpziu9nd3AZY5SinvnnaJEr4BAvxVyrP/qMi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (390, 'PostApocalypticPythagoras', 'maxsherwin12@gmail.com', 'max', 'sherwin', '2165432388', '$2y$10$ME9I23z/z5VprYbmLJhXX.iPKx/2mAYXYjWiUWGmd/AFpxWWdKmnu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (391, 'Zachm22', 'zachlmarks@gmail.com', 'Zach', 'Marks', '3107406536', '$2y$10$4tyR8iFCpCkPEOGnLlRSeue8LH6vSeXDX1vTe3GcPbLIGUPo396eK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (392, 'JaredKonigsberg', 'jako3362@gmail.com', 'Jared', 'Konigsberg', '8474774032', '$2y$10$IBeRFG7gDLAOpfh0RQf.iOlPXhqcLPQPjegKgOKXPSAXexpaYQZ9.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (393, 'c88borus', 'cabo8693@colorado.edu', 'Cameron', 'Borusiewicz', '2156224024', '$2y$10$2.dLory6ztW9sAnCdsMFDu9NKyf/Dizfr7lgzXS7ft3s7akiLHY7O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (394, 'Brh0504', 'brh0504@yahoo.com', 'Brittany', 'Harris', '5052058199', '$2y$10$JgFbQ.2Ya05pZ/Ct5krTZucZiTY0CQVzsDyVpMhAqFXUuNZWo2WDm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (395, 'Oaxaca', 'mitr9556@colorado.edu', 'Mitch', 'Trahan', '7194596562', '$2y$10$7CAd77vSmRt/dsKmFcRra.Zi2DSbFCuhQ464irvJ931d1evsIgPWS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (396, 'BEANS', 'leanne.jgelrub@gmail.com', 'Leanne', 'Rubinstein', '7192092509', '$2y$10$/BxuasbDkMYjEPSvYWLjPO.55WhCHUbGPcy1Ns.m7K01nKaeYTFOi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (397, 'Kahshmick', 'kyne7959@colorado.edu', 'Kyle', 'Neubarth', '6506860616', '$2y$10$ZwLkS3M.KCCyt3deDBOwwekoMhPteGDeXV78E/hEiEBBLD084QZPS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (398, 'bbiancadd', 'bbiancadd@outlook.com', 'Bianca', 'Dibbern', '3214272063', '$2y$10$3LduwNlAq/3hzeYDl1fKeOp9iO/ldYUTdx8L32OBFrrkxrhw4bQL.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (399, 'nona8035', 'naik.noopur13@gmail.com', 'Noopur', 'Naik', '7194251494', '$2y$10$UvoCKZQuwfDl3/SukPHN3OiDNAG9/yaDCMj2Oe10ygKg7Q3Ty2lHG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (400, 'Garrett', 'garo6689@colorado.edu', 'Garrett', 'Roerick', '6184022220', '$2y$10$vJ2eMUWNwPDcbBcT0gva/.HOB6J3RqVeE0k3Ywfw8NkbVp482PvdW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (401, 'alexmeldrum', 'alme4959@colorado.edu', 'Alex', 'Meldrum', '8103916908', '$2y$10$2Edfykh9x17TyOlH2e.kP.yw97vAh8OYZXCA3kGG62IQD1iIr6wCS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (402, 'Mani2257', 'mani2257@colorado.edu', 'Maria', 'Nino', '7203090661', '$2y$10$h/O2vfjY3M/hQ2AU/bPAneBjdptAFcFHC4g4s8NTZs5zZwIdFvx1W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (403, 'moke', 'gkeshk@gmail.com', 'Galal ', 'keshk', '7033626611', '$2y$10$Ljz0.DbsayumznuiP07n5uxzgjhSRcLRdnPMjRPtFKd/5ilSjqzAe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (404, 'skywalka', 'luke.roberson@colorado.edu', 'Luke', 'Roberson', '9139059442', '$2y$10$/PKGvbCOG4vlgbfW72k1NOK4p8HO7AysQKJ4id9K5sipC5SJYLgHm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (405, 'chbe3912', 'chbe3912@colorado.edu', 'Christopher', 'Benben', '9148261202', '$2y$10$NZCF29aT/KE4L5w3bndBF.o1/IExip9iie.IbP837cnEG3Y2GDTrm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (406, 'RiFitz', 'riley.fitzpatrick@comcast.net', 'Riley', 'Fitzpatrick', '3037259009', '$2y$10$c3ZufQcUtwM7WBT50Ht3Me7Rb49BDxT767O8Usm3zMvD.TyK2oHZy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (407, 'FitzyP', 'rifi2703@colorado.edu', 'Riley', 'Fitzpatrick', '3037259009', '$2y$10$4VfdFvnsKvTSdH1h4Y2QYONW1RPSVt3AvCqbkGAc4u3ip5Bigkgdu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (408, 'TheMonster', 'hugenbergja@gmail.com', 'JAKE', 'HUGENBERG', '3038868877', '$2y$10$84fcNZMTKH6mmUZ635GObewVu.lIG5rnZfb/qBCndTjBtxGxIdZdq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (409, 'kevin', 'kmkuptz@gmail.com', 'Kevin', 'Kuptz', '9256833462', '$2y$10$27Wy9Afci3WSU.7AlA2GDOZzEecbd45qxMKi5rcMelJxIdtdqvwNm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (410, 'KrispyKreamPie', 'bego9298@colorado.edu', 'Ben', 'Goldsmith', '2395710101', '$2y$10$Lffi6cfmLM.2I9UTh9ZaouqqmZJs38hk1JEQjL9wZY6p0VqKhm6h6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (411, 'kjaiserlp', 'laka4851@colorado.edu', 'Laura', 'Kaiser', '7203630928', '$2y$10$YE5m8plkaOVZc/BAGIy4jOEGjCxavLgmPS/cOKRiMZhOW38AnEPhO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (412, 'jackspicer', 'jack.spicer@colorado.edu', 'Jack', 'Spicer', '7205325122', '$2y$10$owOoqePJO3trwn7rX8G.TOwtMzreP5.JP4CEXRepi3K7YYccwyn3u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (413, 'Lingling', 'dagu8740@colorado.edu', 'Danny', 'Guo', '3343328515', '$2y$10$htDYDHOllEyv5D1hnvDbGOc4quy8nD/n5XJ9o0SbaVOmPhfGG02Ou', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (414, 'chbr4046', '28thlegion@gmail.com', 'Christopher', 'Brown', '9704859381', '$2y$10$yV62NAPCWncdFRkXDdcrWehbeGyV7KjKB/PEp2kvG2tBkagfqK7hW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (415, 'Choate11', 'chch9991@colorado.edu', 'Christopher', 'Choate', '5099513118', '$2y$10$HMYQvH25af94OXjeEX6BhOP6YEd1XzyRr.Wl33DJ3ShLjlV.mEAry', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (416, 'Jwarren', 'jamiewaski@gmail.com', 'Jamie', 'Warren', '3032148188', '$2y$10$yBc1fi2.b5joLN5b.PUKneyIjm24VGILPtt6.Gfiy3itdWya9wj0m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (417, 'Aric', 'armc8346@colorado.edu', 'aric', 'mccarty', '5739995188', '$2y$10$Y7oj3vRpYaiJhY7rndh3FOLgY013dnifQU18mCM2isE.c0X2a6wOa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (418, 'isabellelavery', 'isla3747@colorado.edu', 'isabelle', 'lavery', '6507409244', '$2y$10$poGy0a65zZFSoT8UZIztkO8w/LITEJCxTrHnv1ba2npp2A3.pdl72', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (419, 'Meximo1233', 'zacharyyounger@gmail.com', 'Zachary', 'Younger', '7194249494', '$2y$10$8pceZtI820aTqaVFU0eDAe2f.FPX8EMJQjfwzDKHCSkaRPWbK5QLC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (420, 'ajberry445', 'ango8123@colorado.edu', 'Anuja', 'Gore', '9704492336', '$2y$10$88xvw/IGaWcR2NuvjZHZrOhNfqP/Ik4ujVoy2DkEJ2Dqkq7umbQX.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (421, 'Luna', 'islu0754@colorado.edu', 'Isabella', 'Luna', '7202753008', '$2y$10$uca7Ip1WD71YhJzbEiGVSeVj9q/J9p18/1x2dpUqKYJ/eMRCQNQuS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (422, 'dewildchild', 'jacobd2340@gmail.com', 'Jacob', 'DeWild', '7204403091', '$2y$10$wb/nPs21mDwWlTnW5U4PLeZenGbWgF57rQ8haYjkciO44Oyxw9iem', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (423, 'MarioBrah', 'gmahanson@gmail.com', 'Mario ', 'Hanson', '7193231273', '$2y$10$YoVG0SNkTHoaJRC7le3rJuvgr9xJrfJKjy91waFegkJ/zRWwnsFWG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (424, 'T-Bear', 'anfe1742@colorado.edu', 'Antonio', 'Feula', '7206849041', '$2y$10$97PL4B5DoPMcgSEmPbQQwuMjM85meQLWAH8nA/TkG6agBTVQm5ArK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (425, 'WillXue', 'wixu0246@colorado.edu', 'William', 'Xue', '7207257045', '$2y$10$hRAZ9z9f1JMQIb9LcBy/9ODl7.IYqDCHBvZ1JQ837OYZdtfyJPngq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (426, 'pickettmap', 'mipi6515@colorado.edu', 'Mikayla', 'Pickett', '3309218096', '$2y$10$DBDy8g.MSgqSxT2BMb7aCOo/RSs0dXhLMbe4M0xpNDXRtyueR5zwS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (427, 'TheLegend27', 'jacob.toray@gmail.com', 'Jacob', 'Toray', '7203183207', '$2y$10$D8ipSFeRBSxrlUDaNboNo.GTukFxq9ai9zz3nH1ungJ36op5gYKR.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (428, 'Cinnamon', 'ethan.comjaycohen@yahoo.com', 'Ethan', 'Cohen', '7203439756', '$2y$10$iomtOiBEIc2lM6drsp1TWOpGkX5CX/Lr/cyHD70fu6m9qN7ef.W7m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (429, 'Cinnamon292', 'zipo116@yahoo.com', 'Ethan', 'Cohen', '7203439756', '$2y$10$aQaBALf6FFxWiSOwqcQ0U.rHvNfs0awXd3xYcFMFZb7PvSDirlm5O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (430, 'geofish', 'george.fisher@colorado.edu', 'George', 'Fisher', '6505189246', '$2y$10$aTu5cSIM8WMVhoB8xV4elulSHURWsdlUClE9Peal6WkyrK0tiCxva', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (431, 'aleixlyon', 'ally3917@colorado.edu', 'Aleix', 'Lyon', '3034371788', '$2y$10$w9.66h3wuuz/fRvmKyuyAu6btxly3JlAT7LwpeeabC2I71c/gohoa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (432, 'Tjovanovich', 'taylor.jovanovich@colorado.edu', 'Taylor', 'Jovanovich', '3032531435', '$2y$10$TdO9fJnl47T0t/vv9uTdPeG4MmEwRKShNFzbHOaSDsvHZbmMCQRlq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (433, 'ConnerJ', 'sleepybirdcj@gmail.com', 'Conner', 'John', '3036385268', '$2y$10$1/egTJdj9BJ1gzB0P.3ySe8bEdffvBpcxqSJFUf5oBmYDncvOvoNG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (434, 'Carlybennett', 'cabe1223@colorado.edu', 'Carly', 'Bennett', '7203349597', '$2y$10$tBfgc91SQ6dZ1v5VhEKvzewO1gPVePyTMsQIhAPePWIjffWjhgVRy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (435, 'tesssssss', 'tess.richey@colorado.edu', 'Tess', 'Richey', '9708192214', '$2y$10$cm3/SrfVvMDozmhfL7Jk8uwHT5Fj./IRHveWFvXTxzHLVNR32oPdy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (436, 'AnaO2008', 'Anastasia.Oldham@colorado.edu', 'Ana', 'Oldham', '7203880432', '$2y$10$Q/yqfJVqnHYhNmRC9Fc74Oswidpy17v1xRmDXIeAE.KaI5js49mLK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (437, 'asandridge', 'alsa6908@colorado.edu', 'Alex', 'Sandridge', '3033301197', '$2y$10$iB.8RIa3i80DDUpTlYya6ewkM2THho2y424giTKuGJgckjlR.3EVm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (438, 'bluurrg', 'alch2627@colorado.edu', 'Alex', 'Chang', '4157125260', '$2y$10$IJ9kVZBxXl1BEBwGaJfTfekytChe1xqarrzB9T2GxaQjNNRWfYW4i', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (439, 'Briguy', 'briguy18f@gmail.com', 'Brian', 'Farrar', '7202205925', '$2y$10$fhAPt.8FOd2fZKix3dJMeu.KxbY1hJ7MqKtrCD6Ik7hTgaLPXN3YK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (440, 'D3v1ld0g', 'brandyntblea@gmail.com', 'Brandyn', 'Blea', '3035236657', '$2y$10$fo2I1y5bcdgJqeUKiGOzC.S7SvUCkzjEuxwV2LENWQjwtRvP7tjUK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (441, 'BigPapa', 'mafa7413@colorado.edu', 'Matthew', 'Faust', '7175253187', '$2y$10$TFGBD6EADKzHMYrrEzM2Ae6h5Se5YilZBRJRmWbThqNizo2hTS5em', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (442, 'row2019', 'muuw3692@colorado.edu', 'Rowena', 'Uwizeye', '7205325476', '$2y$10$OsGvvwLVmwoxH/n4mJGxg.A4s42ARt7cBg9Hi7FNxDnW6HCwYIzzO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (443, 'cthomson', 'cath4793@colorado.edu', 'Caroline', 'Thomson', '7202801552', '$2y$10$z2ojDph2tMJw252gcBpYfulkOPsPrGgUkNNw.sTRPAuovJ/ehP89u', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (444, 'Bairdude', 'matthewbairr@gmail.com', 'Matt', 'Bair', '8143863897', '$2y$10$iLlGZUPhCzDL0W38t4M6a.PrGUMjj7qcolYGGWOnvSpXZUsbMBZLK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (445, 'zesu0094', 'zesu0094@colorado.edu', 'Zengda', 'Sun', '7209035131', '$2y$10$OtEI7XccmyUfc/nAjAYr7e021CYKQnJPehlEtY/lGPdGB.DkdVemO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (446, 'PlanetaryMax', 'maxeatstacos@gmail.com', 'Maxwell', 'Panetta', '7072102894', '$2y$10$e9Ac71QnGBnTgRKUuqDRT.Z9Qkp/v4qOhbL4y1zyYIC08qDBESvuO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (447, 'kaka', 'jadnana50@yahoo.com', 'kak', 'laura', '0671445187', '$2y$10$SwibEUhNIXJ2mSHJ9uhmie8aW7K/TIHg7IGUJ5OtzM8iUKSte8UES', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (448, 'TheNerfAlchemist', 'connor626britt@gmail.com', 'Connor', 'Britt', '8175059949', '$2y$10$MH9adasctPSmfwKaUcFhrO375SFK6uQSR/BhFi17hPoqUin6pbC4C', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (449, 'oleasjuan', 'oleas.juan92@gmail.com', 'Juan', 'Oleas', '9546639390', '$2y$10$H8aIO05WeaUZQ82reXtxKe88pszlyNTW9.PQtaPGpuahBXVUZS/yi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (450, 'Jakpattamasaevi', 'jakrapongp@gmail.com', 'Jak', 'Pattamasaevi', '3033301117', '$2y$10$uZ/OyOXynW/KPttMcMW1veON1BjOT05XpmEOry9ahtoKckrvwjfhm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (451, 'Gh0ul', 'flowersyoyosj@gmail.com', 'Samuel', 'Flowers', '7196605497', '$2y$10$H/mpQEiDa8W859BbJqhXfeTrDN6m1AINtcYzIuG5Hi38e3VzNTWNa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (452, 'dagr2622', 'dagr2622@colorado.edu', 'Danny', 'Griffith', '8605101068', '$2y$10$lCoiIJhAv23R/2UdXR9ZIeszu0e.SyTTBkefVonC/hC4RuH5GOzfm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (453, 'BanhBao123', 'bang3478@colorado.edu', 'Bao', 'Nguyen', '7205795728', '$2y$10$MXVk3Kj9NH7lKUSmnXLhNOXsPU0jwGgZ5l4cOpCUpYYtJ9b5zjw0G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (454, 'Bao', 'bao2722@gmail.com', 'Bao Phuc', 'Nguyen ', '7205795728', '$2y$10$Sh5n4S0v6DxmaBKmsVymAeKc/la45/V3viKTEFhQqyqoVm8fooEpa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (455, 'joeatspizza', 'laco6897@colorado.edu', 'Lawrence', 'Cohen', '3036188318', '$2y$10$m.SxPbPUYNyEUr2iXT/Ye.4QHBZEkc8E.nFjJtvG8rUm/hrEmufOS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (456, 'scottscheraga', 'scottscheraga@gmail.com', 'Scott', 'Scheraga', '2014216673', '$2y$10$.GMrzv6loCwVzid7aKZSJ.i1.nOWhxWg.4jWjihAlR7QQmDRnh2rK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (457, 'anyavallentin', 'anva4669@colorado.edu', 'Anya', 'Vallentin', 'NULL', '$2y$10$vPGYLtDdgihH4WfLA0C1t.GMOwfG7AGgNVTMlpjBa72N5cWUEytBu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (458, 'LucyS15', 'lust2939@colorado.edu', 'Lucy', 'Steed', '7206962332', '$2y$10$G7TBPp1o9xvBvoduETb3NeSdBvXe3K4BxbSHuvyLTbmHOxoHVIpv6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (459, 'ConfusedCourier', 'tybo@q.com', 'Tyler', 'Morris', '7193310645', '$2y$10$Y9uFFScEtW/TBlNMToK1c..X7Ql6Uw.sjGSKzBme6Hpn/Dm5I0IuS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (460, 'Madelynalbright', 'madelyn.albright@colorado.edu', 'Madelyn', 'Albright ', '3363926996', '$2y$10$744zFQCC1JWQrfMs8CJ2AO0EHjDFUzWzD/.No6oegWXf.3Jzr1n/m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (461, 'clha4473', 'clha4473@colorado.edu', 'Clifford', 'Hardin', '3147754007', '$2y$10$ly7CnPCT3kTn3Vg2EaKt0.OZ.sT0EAJqMzDKbx4j6r0VICyVeIcW.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (462, 'TalaV', 'tavi7698@colorado.edu', 'Tala', 'Vicknair', '7193235823', '$2y$10$8Qeyid5pD.zDGl1kzNTTou6y4EeF.W43bZdsNQVdSTAr.AF.CYz7e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (463, 'DanielBoiko', 'gorinich555@gmail.com', 'Daniel', 'Boiko', '3033305542', '$2y$10$TplYqkH5bLj2n6d67WhXNeDNiDKphz7pdmG0O.P9svMJdoVysLFAW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (464, 'LisaLynn', 'liam7199@colorado.edu', 'Lisa', 'Amore', '3059032885', '$2y$10$iZ/2HbdIQSCw4AUc7.FSZe5OCNm4X3wGrc2ydOPPL/uXoYhd8ySsG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (465, 'DomDaBomb', 'dole2690@colorado.edu', 'Dominic', 'Lee', '7209854508', '$2y$10$BaJWdWxxomfPnQnbUas12OS105Z6VPbzj6AqwqrfQ2PBrjyPuduAy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (466, 'abraheem007', 'abab5755@colorado.edu', 'Abraheem', 'Abu-shanab', '7637030483', '$2y$10$/3lWOZaIo3zgMZ4i5CCpsuctN7ABq.BpkP1x/je0nGvZPOSwS.OsO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (467, 'dwysie', 'emdw7672@colorado.edu', 'Emily', 'Dwyer', '4155727739', '$2y$10$7CYaT5C4vCY6iMcGAK5sm.l09Nwg6737wRlo71P4cnecivgSSF0P.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (468, 'Sarah', 'sarah.koppenjan@gmail.com', 'Sarah', 'Koppenjan', '8058869977', '$2y$10$MrhBQs/iSepzz82kE20aqeld0WeiToPOhhIQdLtpv8Y.6WQeYxpKq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (469, 'camo7370', 'carolinecmorr@gmail.com', 'Caroline', 'Morrison', '2185769508', '$2y$10$5zlseg.135dLz3GXCRq52O8t0arf9v4c.di2HlJpfJ203x27zJb9W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (470, 'adra2698', 'ramirezadam513@gmail.com', 'Adam', 'Ramirez', '3035876582', '$2y$10$UxlzhRl6525zGKGViDVn1Op6M3GkGNbCf3bCSiinUj82FJrytK19m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (471, 'maes4595', 'maes4595@colorado.edu', 'Martha', 'Esparza', '9709873102', '$2y$10$0lLNZy2SttfJFJM.sK3EaeUrrohqbevb4KAI1SoBDQg4ieC8lN3iq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (472, 'Luc', 'lubo2884@colorado.edu', 'Luc', 'Bollen', '4434660647', '$2y$10$BquXgjvoC7ZWHGRWSNDeieR.RodIAmdVuJeJbTwaPBmRSXLoKIJ22', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (473, 'Martinibomb', 'maal5844@colorado.edu', 'Martin', 'Allsbrook', '3232046868', '$2y$10$t/2XX9WNpnVkOPPNeqGn0.gubJjszZ6wle.ABPfdd/yvOxXuj4AxS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (474, 'AHavi1', 'anha6516@colorado.edu', 'Anna', 'Haviland ', '7202451816', '$2y$10$469Sbi9a8gUnsAE0plXeheXUKre0DtcrWHYNjX3sYiaSBSYhsfNOu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (475, 'TheBeau', 'besh4317@colorado.edu', 'Beau', 'Shaw', '3035914888', '$2y$10$td6FTDzeak8d40cXUx0uOuZnUXt8ZdWWxGxOXh42P7H5N15vQ7xs2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (476, 'Major.Tom', 'thum3835@colorado.edu', 'Tom', 'U', '3037750524', '$2y$10$BYtJSnN7vXaxMFYrt3qESu5F5/GKqdUsRrvuTuCkhqlqraM/ZbW8G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (477, 'Gnatty-bug', 'natcostello@gmail.com', 'Nathalie', 'Costello', '2812454934', '$2y$10$HzSIC4XLyn.ON1B7UG12Be18BD3WHbZi48ld2nN5A//W3WUQ5rPKu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (478, 'Critter70', 'critterlc7@gmail.com', 'Lauryn', 'Crittenden ', '9704153580', '$2y$10$wB87BzsOJFtee0rv2ytGaecoMvk5wMyvOjW09rq2OWun8cPsy/RGi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (479, 'joch7841', 'joch7841@colorado.edu', 'Joreen', 'Chua', 'NULL', '$2y$10$2dRlxxI8/r4QlAGJh0F/vOo3D50cy.2roGcUnyjC86S2yEiXBSygC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (480, 'ekab', 'beco3052@colorado.edu', 'Ben', 'Courlang', '4153186483', '$2y$10$jyfrWPaAFMqnvTuso.bPzuAhdiHe.82KxTeZk7g0PYxhEY8lTw/Om', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (481, 'Greencat9', 'nicholasanthonylayton@gmail.com', 'Nicholas', 'Layton', '7196506192', '$2y$10$jT6S3McpBPBlHNS0KMx4fO.qP5iwJhsNeIRb2LIpcIvgDkvvjegVa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (482, 'HoodPope', 'darrylcronon@gmail.com', 'darryl', 'cronon', '7209792299', '$2y$10$GusUWxcQWRvkwakd/ZAQxOW2nL3RHbhsh9Nphdl44wTJcoqNyniqS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (483, 'br247', 'brianna.akh@gmail.com', 'Brianna', 'Sondakh', '7204129717', '$2y$10$UW2ojvh76yj0CVYr6tSwBO3poMT10PPkIatpR8KCMUXrTz1aV9uk6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (484, 'HYEHN', 'haho9581@colorado.edu', 'Hayley', 'Hong', '2137001824', '$2y$10$wUckGYc58Z9gnCDffq6dqezweQWHBEXzYl9Rgcijl7WFC4E1ZXxDy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (485, 'CaptMoistFart', 'hure3435@colorado.edu', 'Hunter', 'Reichers', '7202347028', '$2y$10$BJECvzrosAAmFbV0MmPuWOjsXJ3jo2oLK0dBufPGqnzySKBB0iQ76', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (486, 'daniel.loewito', 'daniel.loewito@colorado.edu', 'Daniel', 'Loewito', '2063711587', '$2y$10$RmZFm7Ef6ApIMYXHEIEC4O6Q4.BgwtePSh90f1TypNgF1p44v/Dbu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (487, 'anna.benerman', 'wheretofindabenerman@gmail.com', 'Anna', 'Benerman', '7208797047', '$2y$10$bEleRU.elERogOsnukhGB.yms.0UNy9zFMnd1WYnic1s6q8hmZZUu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (488, 'robbayy', 'rohe5584@colorado.edu', 'Robert', 'Hellums', '7138706139', '$2y$10$thQw9/1uhheISsLy.eM.XuW8gmBc6FxTE5SEYSjve1cd47bi.ySSO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (489, 'PraisedList0', 'alhe0529@colorado.edu', 'Alex', 'Hersch', '9085789901', '$2y$10$uIUpwgpZZ1qvLbiasXzi8umPp6.C549sEDp8F9tTdejTL0Ly2IAEW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (490, 'master864', 'kaki5229@colorado.edu', 'kangmin', 'kim', 'NULL', '$2y$10$9sOjNDUzJ5j.QeIIKbAeQu8rDaHc/jdv1Uklub0KYFJmPjxSqJFrW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (491, 'Joyyyyy', 'jojo8583@colorado.edu', 'Joy', 'Johnson', '7206605790', '$2y$10$m8ZYJ7qGuzn8hzydSZLPuud37erequu5SaXkWr15C7HAKUzhxjXMO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (492, 'littlemisspiggy', 'kame9790@colorado.edu', 'Katie ', 'Megerle', '7206260616', '$2y$10$s6PgmiptUVD5PNCzthToluF7QEo15rBt7zsWR8dQs3BCL/P0GG0AC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (493, 'littlemisspigggy', 'katiemegerle@gmail.com', 'Katie ', 'Megerle', '7206260616', '$2y$10$N99OFkLol1VOaVhCzsXQ2O2H6B5W261DkJP74LZ93aBVTI8c5XAde', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (494, 'littlemisspigggyyyy', 'katiemegerlee@gmail.com', 'Katie ', 'Megerle', '7206260616', '$2y$10$C4S5O31NgJUkUDkcedbWFO3WiZseIdXhHphS6gVuHxcf1yaG0hKei', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (495, 'graciekelly', 'gracemachen127@GMAIL.COM', 'GRACE', 'MACHEN', '9795993368', '$2y$10$2KzIk3LuCdqbFFtjoGxey.MgovCejHfS8nJGbpgt1QQ7UQoGAYTb2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (496, 'ajjacobi', 'adja8452@colorado.edu', 'Adrienne', 'Jacobi', '7204389914', '$2y$10$b3FVjjlkujqe3D2OAKLkv.N8qBz/PvR44Wruqvd2AenSd.NApyRJC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (497, 'skyc123', 'skco8647@colorado.edu', 'Skylar', 'Cohn', '4438332020', '$2y$10$48te1/MwK0CIIxe9SPiBqOPQjzlbfYEaURYzKptOKg5Edn9.MtKLW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (498, 'GavvySavvy', 'elda3053@colorado.edu', 'Gavyn', 'Draveen', '3035142023', '$2y$10$ypnFJ5xdwhrgpVHImerK9u3MStMfgbE9jz4ijEPD04gLRax2NA88e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (499, 'Tenno', 'michaelcwalley21@gmail.com', 'Michael', 'Walley', '9496143655', '$2y$10$kTiZHV4StgH0OV7/f8F4YeoS76BfiS/wdQLY6eqjWGCEd/4KYtbl.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (500, 'KeatonAdams', 'keatonadams37@gmail.com', 'Keaton', 'Foster-Adams', '8054709885', '$2y$10$apeSKOpxEqHsadDup5/sAul1bjh6isfLeHIx95zprXy2IMLuuDvhK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (501, 'Cecily', 'kaco1900@colorado.edu', 'Cecily', 'Coors', '3035216330', '$2y$10$0A.14EMEGdKs1z.2Q1EOfO4tn7G1Y/FadSbK3JXTBfM2s/SUz15SW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (502, 'Absolution', 'maxwell.banks@colorado.edu', 'Max', 'Banks', '9703051670', '$2y$10$m8Cub8LV7gXt51JGiKLOZOhUSHWSq1NTTs5POCNsQGw7Ja0IlcjFW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (503, 'NathanLevinson', 'nathanlevinson260@gmail.com', 'nathan', 'levinson', '5739532522', '$2y$10$xLVQBRXLVWwjt90ailH.D.HFIEhxlmYzgXPYOCVzoequxbn3EpdW6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (504, 'Klieg', 'jakliegerman@gmail.com', 'Jack', 'Kliegerman', '9703898133', '$2y$10$y8liX9FF0fG5PIDNLI9P7eNMLMwAE2rq0/BOGLlpPAQzebe6MaCGC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (505, 'kaycepurcell', 'kapu7569@colorado.edu', 'Kayce', 'Purcell', '7195571156', '$2y$10$oVrG8Egvds1rfXLhjVh6letCdSPTi.cjKAsbI9nJVo1A60INc/ECu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (506, 'kyto3825', 'kyle.towstik@colorado.edu', 'Kyle', 'Towstik', '7203468829', '$2y$10$0U.1xmHQrnIor4xq5YP/Dujqwdhd4XkDr3DXALkJZyJBZVDUY0egK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (507, 'mach6496', 'mach6496@colorado.edu', 'Max', 'Chambers', '7202738090', '$2y$10$jRjF7MMr1nT56Hw1sSNgUOXb9GL0i5DXQblJFr5De6AVJIxferyUm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (508, 'adamgarb', 'adamdavid142@gmail.com', 'Adam', 'Garb', '9032453056', '$2y$10$tGkM.IK/SxxliI5JtXXGBO1sDxUdoZ24oCcPt0.pakuekeMmKTZzG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (509, 'nateberm', 'nabe9398@colorado.edu', 'Nate', 'Berman', 'NULL', '$2y$10$DEWo6CPh0Er9CZFXF8vNGuEvbAtMwfNhkUPG/rGAp0Udmbf6LIMDm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (510, 'cbumpus', 'chbu3885@colorado.edu', 'Chris', 'Bumpus', 'NULL', '$2y$10$yWEAjhQJtNt51jWPFda62epXuoyu5C2fDB23NG33C1pHBQ44ananC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (511, 'Kiara', 'kiro3364@colorado.edu', 'Kiara', 'Rodriguez', '7192905226', '$2y$10$P1pakPA1s129crHM2RvMT.W1U8NeUePC3GslosmCd/mvzsWSYz2I.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (512, '19scohen', 'saco9094@colorado.edu', 'Samantha', 'Cohen', '2153852510', '$2y$10$KUEbVNlmDoL.jrAfBGecPONwZBPxXctq9La88MxyU45y9O66EGup.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (513, 'mahubbeling', 'mahu7554@colorado.edu', 'Maggie', 'Hubbeling', '9702189669', '$2y$10$QpB.sLzTl68dJgWkrGJOTON8OGrg/9F3atFJ.ieEStcJ0Hxhjt4o.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (514, 'isga', 'isga2105@colorado.edu', 'ishan', 'gandhi', 'NULL', '$2y$10$1yvqexje2KwMQaVOncXMweqAe.trNvBHGB9ZQmEdnXvVxcFOMFleK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (515, 'Switzy', 'cjentz01@gmail.com', 'Caitlin', 'Jentz', '6082794391', '$2y$10$57BJz9hELzk3clSVkQdnTun0fpxTKWL7nLi6i0hE7F78kGfhPj0D2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (516, 'ahyo', 'ahfa0599@colorado.edu', 'Ahyo', 'Falick', 'NULL', '$2y$10$96cT7A0hpYarvzphvZmFJuyN57PIH2b4cssFuNukslerhH8z9khpW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (517, 'rachelmiller206', 'rami5506@colorado.edu', 'Rachel', 'Miller', '2069027897', '$2y$10$wSmL7XGfGEFKVFtf/4/Bau7pZXi4xBV1xdqTcB0j7cvombYbAawQa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (518, 'maje7033', 'maje7033@colorado.edu', 'Maymuna', 'Jeylani', 'NULL', '$2y$10$GDaRgUfeHFIUVpY3KLDNXOccAfhmrLZpfLdRkJPQ6bsA/VxUoeuKm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (519, 'Esraa', 'esraa.alsayer@gmail.com', 'Esraa', 'Aldhufairi', '7207057277', '$2y$10$L19dJmHaaCYBUXPXeSD7ueXcpp1ny.m.ofR1zLeF7IqIjktP1887O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (520, 'Abdulrahman.boush', 'hamnii.36ali@gmail.com', 'Abdulrahman ', 'Boush', '7202437112', '$2y$10$K2CciTKrXxXxZ3I.9lhVreZn2b6x4WPtfQelS996bimsIlhah.THW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (521, 'anjo7843', 'anjo7843@colorado.edu', 'Andre', 'Johnson', '7194538200', '$2y$10$.F1t1arDvJtvzIXgU/xU9eOiIImHD/yhsYA7hhAkdi8TFO5Rp8jbe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (522, 'gauy1985', 'gauy0122@colorado.edu', 'Garrett', 'Uythoven', 'NULL', '$2y$10$pg3eBI9Ho5.nIMWUuSdmgepUazhuaf.FXHgF.KSv7.YUyiKICO6Sa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (523, 'Bagel87', 'evsp6686@colorado.edu', 'Eva', 'Spiegel', '8605434232', '$2y$10$QUJjtD4uqVYF.tWigUEETO4WDTPn0/XOBUzVygbQmgh7jnKR92ziG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (524, 'Sydthekid420', 'mcphailsydney@gmail.com', 'Sydney', 'Mcphail', '8432149652', '$2y$10$6yS/BWKd/3jqB.fbQHaZCeE.cuE7CMM51MClk4dcG0Hg3Q.cPvJ7m', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (525, 'Kebabs4806', 'sige1751@colorado.edu', 'Sierra', 'George', '3039092424', '$2y$10$Lqv3inTflcuLkVGoDNdGM.MN4hN2fqqk4bz6nEBeRmyfkoggxVo52', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (526, 'RatatatRattata', 'thebutyraceous@gmail.com', 'Sabela ', 'Vasquez ', 'NULL', '$2y$10$GHCVRXvZ/FmjTzbWklcMYuB3qzS1gxG3V5cH1aqgFUeo6HR2KIQTG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (527, 'lillymcnichols', 'lilmc806@gmail.com', 'Lilly', 'McNichols', '6302104008', '$2y$10$V/64aT4O3twC1LupSJsClOR3tsBzp/StQYWfZG2kFRsvpOMJX..86', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (528, 'capr4391', 'capr4391@colorado.edu', 'Cali', 'Pran', 'NULL', '$2y$10$dBtnHmwQ4eGpAKAK4ipry.wH2D3Q2gsKvs5K7cwrsLropptdHsmVW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (529, 'gabib', 'butvilofskygabi@gmail.com', 'Gabi', 'Butvilofsky', 'NULL', '$2y$10$PP12e19dbSNZhOFASra0HOkBwn2kbbWsr8Wzwss45N449UPT2AtQO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (530, 'than0553', 'than0553@colorado.edu', 'Tom', 'Anderson', '7206267638', '$2y$10$VbeMezKPIj7Eqv0aUbSZ1OFnWD0EjzHB0gm5Ti6c4X.hCqrTVaWfO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (531, 'Redtea', 'mika9215@colorado.edu', 'minerva', 'kasayapanand', '7203439564', '$2y$10$cTSYqsSsTCOXRgExn8KzFeOf8KNzhmqeDX73VoiwJruH0rjLz6eBi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (532, 'canthecat', 'canthecat10@gmail.com', 'Elijah', 'none', '5206645870', '$2y$10$tFUavndVkYxUlA3Aexub1Ort0F8fMIPBdQiQVz7GzVQuP3Tb.mwuS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (533, 'NoahHIcks', 'nghicks33@gmail.com', 'Noah', 'Hicks ', '7209345636', '$2y$10$Ngy4SwuZndX8ACknnZ5.BONX3MUCVUFRVrQvq8YmOatjMthovNXDS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (534, 'CafeteriaFruit', 'coleinco@gmail.com', 'Cole', 'Reddish', '7193672811', '$2y$10$KlxOUuuHaWMkb8RGLJuSdeuRLK.9.nu.OpQuqWQN0dMSbM8Ic3BxW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (535, 'FratBroJosh', 'caroline.farris35@gmail.com', 'Caroline ', 'Farris ', '9706188529', '$2y$10$LUfSwbU7E4AHJU1.3fKQg.YFU1YjyuzPe76iM4FNSsL1kOmB0F6uO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (536, 'scooterwoo', 'scooter725@icloud.com', 'scott', 'cohn', '5163536584', '$2y$10$/F3b24FYneMJlwcLpN0isuo/dMORJAwpfgzXeNsZlcVjCBd05kMkS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (537, 'shoveldick666', 'lahe7796@colorado.edu', 'lando', 'hennessy', '2155189161', '$2y$10$cV0euZ0avt3Qg/Sq/HC6h.pjp6QRy90qyywKtxq8uKuPVLbpVKVUi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (538, 'Kyle.Mitchiner', 'kylemitchiner@gmail.com', 'Kyle', 'Mitchiner', '7205572766', '$2y$10$ysKbM7bqZXVy4sD5uWhRxOSCbPBYv4fxbFd45WNnQ1jGVkLJuAN/S', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (539, 'ctezera', 'caleb.tezera@colorado.edu', 'Token', 'Brown', '3036693830', '$2y$10$mgl3rBXTn8m.ZQOFqSBpj.CLmNLcVUbRrhvOTW7RP3Mx27H0IiDHO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (540, 'Epost7437', 'empo6914@colorado.edu', 'E', 'Post', '3039179985', '$2y$10$E9j2v22dF4qKD5xt11L8Lu0LXK9MjtIbK2LB9x9VvwS/Rj66o8djC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (541, 'zasullivan', 'z.sully2000@gmail.com', 'Zoe', 'Sullivan', '6126194995', '$2y$10$HUmLFQ1GCIuBcR55/BF5wu0ovDfRWAof7b2twqrDoZucAWRC84z.O', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (542, 'trevtrev', 'trre1556@colorado.edu', 'Trevor', 'Reece', '3035628245', '$2y$10$./cxmRGpxIh90kp2NijbfujRonbREW5mj41wilEnW7oN6BcNiPUgG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (543, 'Nataliescheeoe', 'natalie.scheele.10@gmail.com', 'natalie', 'Scheele', '4155298842', '$2y$10$Wf7ZJgUDxsmimLxp.CqH.ufJHZLmf8sovkpFf1FQqy/Xzy3NLSrQK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (544, 'crasyluke', 'lbatista01@yahoo.com', 'Lucas', 'Batista', 'NULL', '$2y$10$0kM0Mk4HO23BnGLm5fsDz.i7krVgqaDh9MnE6T4/Wln1BE8G4Vbz.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (545, 'SeanThiltgen', 'sean.thiltgen@gmail.com', 'Sean', 'Thiltgen', '3103657080', '$2y$10$RvYd.W7shDGHqKqA3FaAY.6n79ggI9B/YC1zOjKlCVk93r9W8lgY6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (546, 'SeanT', 'sean.thiltgen@colorado.edu', 'Sean', 'Thiltgen', '3103657080', '$2y$10$fBUlOXGpbGk8TaWLCMbEEuzEl7JrrhBfDAtOE2JEHH8k4uQfngxeq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (547, 'Emaline', 'emke8810@colorado.edu', 'Emaline', 'Kerwin', '6309171556', '$2y$10$J/v2QozwYc9zQxncx7Bdt.gxRaco7ljg/bSHNUcCiDtGdEkhDav7a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (548, 'Aliammar', 'aliammarq80@outlook.com', 'Ali', 'Alameer', '7202438991', '$2y$10$lVfzBybowF61EWQh8Sny4Oqxvr9hyZrVRIZWE7FyeGW7.PwSw75B.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (549, 'Alaa', 'alaaoojuly2001@hotmail.com', 'Alaa', 'Alnajar', '9495168318', '$2y$10$bbgMMFwQMLfSMxHWSCJFdeiKDdR1LY1X5uNkEW5tZvk/o4r9JpADy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (550, 'Ajsalbannai', 'azkar365@gmail.com', 'Ahmad', 'Albannay', '3038026302', '$2y$10$iHVCedL5XPfFukjJly7vn.35I78c8S/rzFHYurzIO4R3m22TWlRZq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (551, 'mbusafar', 'mkusafat@outlook.com', 'MOHAMMAD', 'BUSAFAR', '7202511281', '$2y$10$.pSFLvWT5px2Ks7oeawuMurARczGlT4l8qGahUAzn2AGM8jzkuyPq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (552, 'Lillithwinchester', 'anlu3931@colorado.edu', 'Anissa', 'Lujan', '7192489241', '$2y$10$WpINeHfeu7fDldgqlkFLKuig9oJKV1mxB0/ZSlJSkkV6SZom7DOHS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (553, 'Niko', 'niko@vonunger.de', 'Niko', 'von Unger', 'NULL', '$2y$10$SxWv8t3Gu7Vbe/4c41c.qeRcR9BD98dfxBeao567PdMnNls.Thdyq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (554, 'AeroSophia', 'annasophiaonice@icloud.com', 'Anna Sophia', 'Rorrer Warren', '3854147575', '$2y$10$RRyfJALmYvNxMyuAVUOklOUiKN7PTWJ5Umsi3z9/Af5.zQXfriOB.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (555, 'Rickys1414', 'rickysreyes@gmail.com', 'Ricky', 'Reyes', 'NULL', '$2y$10$1bcsc7/MAIdziYGeCAB1QOcZwf63hP4qPFFFdMFeGQ1JsdNiw/Tn.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (556, 'SPiiKeSS', 'Poorn.Mehta@Colorado.EDU', 'Poorn', 'Mehta', '7209400389', '$2y$10$p8Jlz1Y2EV5mWoMQLG5uDe/zavGkFALLuSFSwu5omIAsYUYGtdjBC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (557, 'vyski1', 'vagl6989@colorado.edu', 'Vanessa', 'Gluchowski', 'NULL', '$2y$10$7Ac4FqJI1ZVIlG8EhubBb.OlBhU0uUemCaeSiR8U26CKdCYLXkr8W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (558, 'Dania', 'daal9113@colorado.edu', 'Dania', 'Alhamli', 'NULL', '$2y$10$R/jDOcHewtrOSbBHcOYfWO/kkI/NNrpcqnsXq/3ZA4cjVaYSuEKFi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (559, 'Ray', 'oliverdoig@gmail.com', 'Oliver', 'Doig', '4083169778', '$2y$10$Z.RBfnV8JlVM3QcsYrT5xuLpXrvHKZw02/N9ScDykpGAlTdaHkJwi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (560, 'yash1595', 'yash.gupte@colorado.edu', 'Yash', 'Gupte', '7204538422', '$2y$10$XOvTUb0WPVFodDJu4GckH.LhkQsGedwgIf8.baBbtbJfN73aQUGla', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (561, 'small-angry-and-ready-to-fight', 'keei3508@colorado.edu', 'Kelly', 'Eisen', 'NULL', '$2y$10$cqd3aVOOVL5WNkTePDyeEuW161daGlwS9mjEmY6A3WKgaUCPq7u1C', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (562, 'Janesy', 'jili3523@colorado.edu', 'Jingqi', 'Liu', 'NULL', '$2y$10$QEtxKpkobBkEaLhaMrWRYOC87CU9dWBzdX7ejkZANXZa61bSDChaK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (563, 'Abdullah', 'Abdullahghunaim55@gmail.com', 'Abdullah', 'Ghounaim ', '7207274219', '$2y$10$jf6wqKHOdgdVaTSF2RvMDOaCu1C2LZs7YTc91nJ091BdtuYVE/Dd2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (564, 'Alexalv', 'alexis9530@yahoo.com', 'Alexis', 'Alvarez', '7203729072', '$2y$10$m.Ed.TERGu5Li94CMYUwEOhEbSJOoV/BdN4yv96KxddsSBPzrkCyG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (565, 'Communistjk', 'colerockwood97@gmail.com', 'Cole', 'Rockwood', '8134207338', '$2y$10$XetY/EHxVyH8aXck4WHxq.yTeJj5FZQ9coe1y5xGDCfyMZXgN.gxm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (566, 'AlexPichler', 'ALPI9677@colorado.edu', 'Alex', 'Pichler', 'NULL', '$2y$10$/GWnGTaegx7x5P7GIYgteutK2hDXcxOykMLC/9yMfYmr/VQUHM4za', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (567, 'maro4763', 'madison.roche13@gmail.com', 'Madison', 'Roche', '5053920696', '$2y$10$KMAaICrqi.HCLzgzLdbXSeTF.saf7ELUBQrYnnkwoJ5i.PJTjxZ3K', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (568, 'lucymbdavis', 'luda4286@colorado.edu', 'Lucy', 'Davis', 'NULL', '$2y$10$ttCPQR6zoWGm8OrNfkESh.dyh5K4cYb6gUwKc.0mad7T47pHAKWBm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (569, 'Moosta', 'mostafa.1419@hotmail.com', 'Mostafa', 'AL Hrbi', '7209089100', '$2y$10$b/XLiYOfIbxD5DTkSex9GO6yQ4q5XZ2meIfd5llocHdgAJnKuEWuq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (570, 'jennals311', 'jesn4512@colorado.edu', 'Jenna', 'Snyder', 'NULL', '$2y$10$9Z8cJwLaJxTousdpuq5.M.PsdHXfA16Bb8lg.t7kkt6pT9oQRJCvi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (571, 'jenna.l.snyder', 'jenna.lee.snyder@gmail.com', 'Jenna', 'Snyder', '7205567324', '$2y$10$ehSsoHC0MIBcFizwyi9YIOJp/XE.FI.47uta8pO6Ikqy21zWdQFdK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (572, 'Mittyfresh', 'owen.ahlers@colorado.edu', 'Owen', 'Ahlers', 'NULL', '$2y$10$BacxMbM4l5UzQXGhgbCOSuNZOoBjFp/EmPve8aCnY4c/Sr85rFZq2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (573, 'Pizzafoot', 'spencer.stepanek@colorado.edu', 'Spencer', 'Stepanek', '7193511225', '$2y$10$1jdFzbvpzMnzdRYbsv6Nr.ZNZkDUArSlLizC/eMcvnzyTB8d4WJWS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (574, 'xire0381', 'xire0381@colorado.edu', 'Alex', 'Ren', '7205205579', '$2y$10$DGPMc9CSyfJ.z9RakBDbxuTnPcnpZpfY.Odlzffig9QTiGB4YiYJi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (575, 'yuti3188', 'yuti3188@colorado.edu', 'Lavender', 'Tian', '7206219950', '$2y$10$bsJQ5Y6IUgQhpQUSVA/I9.6rH7fpO2MNCLwrcjLX4q1F47ag0QfK.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (576, 'Belindapolynice24', 'belindap1999@gmail.com', 'Belinda', 'Polynice', '6613098578', '$2y$10$/108jRyLM.IqL7qS3EQPheMm13dB/DIWfJuuo5Ltm3J1XqesyBUcG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (577, 'tickles', 'jack.spicer@coloraod.edu', 'Jack', 'Spicer', 'NULL', '$2y$10$UBrLlZRB69yTMZR4jxLsNeyzs0VhZ5fn61SQcJTpGn6GEa5mI9n3G', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (578, 'Yojo', 'Ben.massik@gmail.com', 'Ben', 'Massik', '4156863392', '$2y$10$0MDyJu5Oeti6okM2RacYT..KIIG9GbG25gSnDbNAoGm46oQBFH7xe', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (579, 'qmorton', 'quentin.morton@colorado.edu', 'Quentin', 'Morton', '5183919591', '$2y$10$SMNLVN2UUWGqxOi0nios5ePJ8xxWTITebMZfhY1Wt8xX9PVbPS1ai', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (580, 'untraceable', 'nmickski@gmail.com', 'Nathan', 'Mick', 'NULL', '$2y$10$zE/32EsnhWGHylBJQChec.ji.8PoxadEBJEQe7HI9GaTTE.NvWRQi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (581, 'ribl6345', 'ribl6345@gmail.com', 'Riley', 'Blackwood', '7272711415', '$2y$10$vqejGKUaXLRa6VEFe2.06.0jzZ4aql.yNcG9SA80xq6yKQKOKpQlq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (582, 'riley32599', 'ribl6345@colorado.edu', 'Riley', 'Blackwood', '7272711415', '$2y$10$TYIN/m5xBorqppFLM7ov1emG3Ve18MtGpm.ortvVLyjWqxAbm626W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (583, 'Mimi5526', 'mimi5526@colorado.edu', 'Mikayla ', 'Michels ', 'NULL', '$2y$10$jN92ok6OkFDezddqKHDZiuaRObohxTKNfzMsyi6NrFA7.hlJFa9ci', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (584, 'emmarinz', 'emma@rinzler.net', 'Emma', 'Rinzler', 'NULL', '$2y$10$fkzRhupo3daqalCT3oMkPOYIVDnxuCO7I84TeIWRFvu5R9OJprCJ6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (585, 'Plea80s', 'klaudia.lenore@gmail.com', 'Klaudia', 'Brooks', '7194194661', '$2y$10$/AUJh4qazdFgpXGUFIfnqOnVzMuxemsC1YoPFOP2OIXi4EB6n9E36', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (586, 'anferguson', 'alfe6135@colorado.edu', 'Alexandra', 'Ferguson', '7203084590', '$2y$10$/vG6lP561b.oXCKtvivhwOXXoIhGnpZwKq/dEfomgX.5Tpnvn4JvK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (587, 'Jlarry04', 'w00dstok@hotmail.com', 'Jacob', 'Lawrence', 'NULL', '$2y$10$5hGg7VOCSw4an0dNtHGuhOmAyDeW/oM2Jn4drl/LqlaTkSvDumdcC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (588, '123456789', 'nathanielcurtis01@gmail.com', 'Nathan', 'Curtis', 'NULL', '$2y$10$dmA2g/swPuyWuoy1uDjY1eUtX8BcxVs..2wsmQAOle5BmpLoWpCk6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (589, 'SkoNavyBuffs', 'chde0402@colorado.edu', 'Christian', 'Dean', 'NULL', '$2y$10$ykvh7HrsGj4u.7CA3vQNvessPVbFtwK8oxP2sy3xsLuRsme4phhZG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (590, 'NickHasPants', 'nhsmyrnios@gmail.com', 'Nick', 'Smyrnios', '9258782392', '$2y$10$hqQfXHya78Tgx/pHJYajv.9bCBiMWrhQjtiOmPpFKjwtz5mwWvpS.', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (591, 'Slytiger', 'climbanderson@gmail.com', 'Henry', 'Anderson', '9706902979', '$2y$10$pe9.It7W/dlU4EqW1KOH2e.Qw/YoSrdRc5ta2OFhTRrD0ZqIeHEDq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (592, 'sank180', 'kisa4985@colorado.edu', 'Kiernan', 'Sanders-Reed', '5052214422', '$2y$10$vN85MTzhNl5tIFbWLuuYQOqQ85FWysagRzUBKs1DIedi9NP0dxcm2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (593, 'Duke', 'duba9823@colorado.edu', 'Dulguun', 'Baatarkhuyag', '7209386906', '$2y$10$AZHvSD9rEgrV7QKxESJJIuseK.9GtIz2yKIfV7chEXv8Fu3cSoxVC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (594, 'dash4703', 'darby.shepherd@colorado.edu', 'Darby', 'Shepherd', '3037106037', '$2y$10$pJzlIuOsUOXaVHN/dur/bu.N.uxutR9VSw3n3E0D7YbmsOSL82vC2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (595, 'OhDang', 'Jamc3850@colorado.edu', 'Jack', 'Mc Hale', '7206512227', '$2y$10$Lq1eHTZKQRdUPeYpen9o5eplffIK7.c8.t.JlyD29UBbFDmBzT9Lm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (596, 'huha49000', 'hunterh531@yahoo.com', 'Hunter', 'Hajdu', 'NULL', '$2y$10$BIY5PNg714JlQr1/Rc03Xejn6DjXdbK2plde/OwsX7Ns0YX6Yvuyy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (597, 'Moon', 'jmoon0125@gmail.com', 'Junhyeon', 'Moon', 'NULL', '$2y$10$SuuXQVTVHtuI/FQmm.QTnea6XvQNiZob4cYmInGaS00BKLv50FZca', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (598, 'SquabJ', 'ali.jrox77@gmail.com', 'AJ', 'Dawkins', '7203635418', '$2y$10$RN3xZ8rsQLp3MfR4aLCm6OEkoHpqth0KTaPDc1Aked.O3y34dEXku', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (599, 'LcSwift', 'lach2535@colorado.edu', 'Landin', 'Chesne', '3038345156', '$2y$10$P5NCuNZIlLXb2MhUILGhtOOD8DRxI5KhP3MH9k4x6vOAjSCtVFKQK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (600, 'a.malikfd', 'abal5428@colorad.edu', 'Abdulmalik', 'Aldosary', '7206623027', '$2y$10$P/yJ3D8ROmre09cfMxiRNuiwMeArSLIBoqksZWbkK/HuRyzyWM8NW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (601, 'Lampard8-2000', 'moal7758@colorado.edu', 'Mohammed', 'AlDarwish', '7209983836', '$2y$10$pIpLgJhLmtfrLK4VF/rQiea.ypi2qMqLTyDAeO1VoHv9QNZzsE/mW', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (602, 'MisterTwisterII', 'tore2722@colorado.edu', 'Toby', 'Renfro', '3038813032', '$2y$10$mr7Foh0oJkYPWYfg..bX.OYtoS/rcGajsnm79M.PptA1BrgvSjdsS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (603, 'Juanj.v', 'juve8936@colorado.edu', 'Juan', 'Jimenez', 'NULL', '$2y$10$MPzQi5OAWnut/mPnOvvBcO8hAw8UNDMOjeKolWJ7Tbs6PY7BG398W', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (604, 'GravMaster', 'wiri1105@colorado.edu', 'Will', 'Riley', '7204001048', '$2y$10$juXTd0hAZb6gPB9vOYW7ZuA.D9WQkuydSeyTJt8HvNZGuVv4LRXcy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (605, 'arumidden', 'leto0509@colorado.edu', 'Leah', 'Topilow', 'NULL', '$2y$10$y2VXkTcStH2cPYwCEhsPu.xsn78eY.otroQx3k4ESZYWsW1NCp/di', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (606, 'Dlimusa', 'dali5246@colorado.edu', 'Darryl ', 'Lim', '7208787332', '$2y$10$UbarJrskb4SyJkg7xNB8aOlbfLad8y38DQBrCKbkggKSEfCWPQmoC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (607, 'galeprinster', 'abpr9862@colorado.edu', 'Gale', 'Prinster', '3037463300', '$2y$10$xOdSC2xckzxrR5S93djU9ehWWQ8.wQOV3ZLqSCsllY2ku0M9zp/p6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (608, 'Caufwee', 'alexcormican@gmail.com', 'Alexandros', 'Cormican', '9085009069', '$2y$10$Soh2gyw8.A92AjvDbM6yxObRQAtTTl24zGOY2CDfEInONtXirrZra', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (609, 'Greybear', 'Dgreybear69@gmail.com', 'Dakota', 'Greybear', 'NULL', '$2y$10$UsTFi7nRPVish/OF.UkL/u0DMTexldTbkjaD8djsgHoOL3/rfcQem', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (610, 'anmi0664', 'anmi0664@colorado.edu', 'Andrew', 'Minder', '2036451687', '$2y$10$J.CUBFIHDiToqSnM9mgS2O.baATb796iaeVlbfMrGH1gpF4EItuzu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (611, 'Zlatin', 'diglooclark@gmail.com', 'Dillon', 'Clark', 'NULL', '$2y$10$08eVPfjqpFe9YOrfvoFKG.zmaO3IUa4FhCy0DcltnKJcupIZ4QIwy', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (612, 'Jackomitus', 'jackomitus@yahoo.com', 'Jack', 'Clark', '5125478778', '$2y$10$XkYQt1.27rSmqaGVNRIwI.HaVd2jk7ln7hLbL8X8S5R0bkUGSgeHa', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (613, 'noahxn', 'noahxn@gmail.com', 'Noah', 'Nguyen', '3034761133', '$2y$10$U4UwZdIhWN4erhgTEJPbY.nM1pTw9lS7y1TaRqtGUc.DL9RwI6rgu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (614, 'jamo0590', 'jamo0590@colorado.edu', 'Jacob', 'Morris', '7206708331', '$2y$10$IYI9FlhKoWQj3Z6zdG6l9OQ5sXUzp0SBS50FaoafIrvJZelivM79a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (615, 'rkshearon', 'shearon@colorado.edu', 'ROB', 'SHEARON', '9703432297', '$2y$10$eLRRGJOYlLbtTwoDs3dMwuMSk3YqQCE.2.1ZLs5y4dtpRaMkLUq42', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (616, 'maddio33', 'maddison.orosz@colorado.edu', 'maddison', 'orosz', '8582451057', '$2y$10$oBLCJjOjWQiff..M5QVdGe.rTstbo.1NyvtDxIDPfTk5BFtLHwqhG', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (617, 'yibo', 'yifa8872@colorado.edu', 'yibo', 'fan', 'NULL', '$2y$10$DztDlUot/UnRf9QdyHJvz.mfo7DD/dFdjGdX0eWKvwx17r3I.4Y4a', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (618, 'ashleysh17', 'asho7012@colorado.edu', 'Ashley', 'Howard', '7206352821', '$2y$10$mJQo7nntViH8ZXmWjbOFKeJsaKiHLHHhCbCKcm5xzg41MRNsniO9e', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (619, 'courteneybm', 'comc4919@colorado.edu', 'Courteney', 'McGowan', '8026815704', '$2y$10$yZbLWJN2XcyuHnDehBQJBuofbP0i4zmyjcI8J0ihJNK2XFrEjq0AO', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (620, 'froschty', 'jafr5256@colorado.edu', 'Jacob', 'Frosch', '3034890547', '$2y$10$9Gamgg5OEhCGqlsZN2kH9.eccktncrWoEQxl6S2TcNQ4WsevHf8y2', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (621, 'xxlunaxx', 'doctork910@gmail.com', 'Josh', 'Florencio', '3034888239', '$2y$10$YBtLoXBn0cy4IfwGPpH1q.gRnVckG4xU2/PslBbpmqnJGfrdl9BWK', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (622, 'Kushagra', 'Kushagra.Pandey@colorado.edu', 'Kushagra', 'Pandey', '7209804416', '$2y$10$06bybyXNmTg9LpS0D5JNwetAfSqolR2.P2dwusa0SBko/BIEAssOS', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (623, 'Vaidehi', 'vaidehi.salway@colorado.edu', 'Vaidehi', 'Salway', 'NULL', '$2y$10$gP8u9/IBtreuDRhgXLyvWOid2QI61WSEyof1CM6UJmFJsjICNzydm', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (624, 'apfefer', 'anpf9194@colorado.edu', 'Andrew', 'Pfefer', '3035198777', '$2y$10$IfXgavGhEOFv6Vm8ws7IG.wXBMCwlrDrqmHsW28uea6vEGCfVHYzC', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (625, 'Kavanwaves', 'kavanganapathi23@gmail.com', 'Kavan', 'Ganapathy', '7206437690', '$2y$10$wKQc6gRSWArK4HL510jnVOGuWX7IDHfMj8Zo2cAHSmu9k8aJk3zRi', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (626, 'Edge3.0', 'dominicedginton@yahoo.com', 'Eoghan', 'Edginton', '2108675369', '$2y$10$aMskcLShqXBUMQDvzMoUo.k8BAGIOIKQgq4KBi6x9NJkw.p.HmGjq', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (627, 'Edge06UK', 'doed2896@colorado.edu', 'Dominic', 'Edginton', '2108675369', '$2y$10$jSoDvbhj7womW3cdjbh/bONAEgKwy6XtuJpcQtXp5eizYV/NbMo96', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (628, 'halobuffs', 'christianjdean117@gmail.com', 'Christian', 'Dean', 'NULL', '$2y$10$n2C8SJGRXPl69Bfiq5tcguWJun3/YHxZhlFqqXK5e8YTarHG.Jvai', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (629, 'chadsworthboolington', 'cosh1912@gmail.com', 'Corey', 'Sherman', '8159732934', '$2y$10$ysQUVsdK8IXuL98tMkgxQunnNa8nKxQQ/82MYXKrAnNSu/9Aebqcu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (630, 'chadsworthboolington2', 'cosh1912@colorado.edu', 'Corey', 'Sherman', '8159732934', '$2y$10$7iDd.Pp9.Ln/Hg6H3Nt8.O8P5VfovxBIjswk0NzskXZvXJiRsKhF6', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (631, 'MrDoubleWW', 'samc9731@colorado.edu', 'Samuel', 'McCullough', '8156775696', '$2y$10$ynbMF9PNzWzXolGHSVPqtuESrkqIsyu57zzVWfrYOMWfw98TmfBeu', 0);
INSERT INTO `CUHvZ`.`users` (`id`, `username`, `email`, `first_name`, `last_name`, `phone`, `password`, `clearance`) VALUES (632, 'Hannah', 'haph8993@colorado.edu', 'Hannah', 'Phelps', '2068490554', '$2y$10$ngOxjWWr1aAzv7t8wz2jqOJmMV9me00fN6jlJXZMve/MdgUgo1x8a', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`user_details`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (1, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (28, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (29, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (31, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (32, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (33, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (34, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (35, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (36, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (37, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (38, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (39, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (40, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (41, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (42, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (43, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (44, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (45, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (46, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (47, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (48, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (49, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (50, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (51, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (52, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (53, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (54, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (55, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (56, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (57, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (58, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (59, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (60, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (61, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (62, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (63, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (64, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (65, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (66, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (67, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (68, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (69, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (70, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (71, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (72, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (73, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (74, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (75, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (76, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (77, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (78, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (79, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (80, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (81, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (82, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (83, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (85, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (86, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (87, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (88, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (89, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (90, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (91, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (92, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (93, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (94, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (95, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (96, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (97, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (98, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (99, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (100, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (101, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (102, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (103, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (104, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (105, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (106, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (107, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (108, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (109, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (110, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (111, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (112, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (113, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (114, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (115, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (116, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (117, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (118, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (119, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (120, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (121, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (122, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (123, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (124, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (125, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (126, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (127, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (128, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (129, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (130, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (131, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (132, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (133, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (134, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (135, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (136, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (137, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (138, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (139, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (140, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (141, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (142, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (143, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (144, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (145, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (146, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (147, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (148, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (149, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (150, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (151, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (152, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (153, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (154, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (155, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (156, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (157, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (158, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (159, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (160, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (161, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (162, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (163, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (164, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (165, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (166, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (167, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (168, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (169, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (170, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (171, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (172, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (173, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (174, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (175, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (176, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (177, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (178, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (179, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (180, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (181, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (182, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (183, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (184, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (185, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (186, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (187, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (188, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (189, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (190, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (191, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (192, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (193, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (194, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (195, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (196, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (197, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (198, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (199, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (200, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (201, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (202, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (203, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (204, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (205, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (206, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (207, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (208, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (209, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (210, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (211, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (212, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (213, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (214, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (215, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (216, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (217, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (218, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (219, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (220, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (221, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (222, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (223, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (224, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (225, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (226, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (227, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (228, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (229, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (230, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (231, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (232, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (233, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (234, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (235, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (236, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (237, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (238, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (239, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (240, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (241, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (242, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (243, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (244, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (245, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (246, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (247, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (248, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (249, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (250, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (251, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (252, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (253, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (254, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (255, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (256, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (257, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (258, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (259, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (260, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (261, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (262, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (263, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (264, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (265, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (266, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (270, '2019-03-31 01:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (271, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (273, '2019-03-31 01:50:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (274, '2019-03-31 23:31:37', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (275, '2019-04-01 19:09:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (276, '2019-04-02 17:06:38', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (277, '2019-04-02 18:05:06', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (278, '2019-04-02 18:07:12', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (279, '2019-04-04 16:06:41', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (280, '2019-04-04 16:29:03', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (281, '2019-04-04 17:10:16', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (282, '2019-04-04 17:12:09', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (283, '2019-04-04 17:25:45', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (284, '2019-04-04 17:26:19', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (285, '2019-04-04 17:59:19', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (286, '2019-04-04 18:03:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (287, '2019-04-04 18:20:03', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (288, '2019-04-04 18:22:36', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (289, '2019-04-04 18:25:39', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (290, '2019-04-04 18:28:34', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (291, '2019-04-04 18:30:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (292, '2019-04-04 18:31:52', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (293, '2019-04-04 19:08:29', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (294, '2019-04-04 20:00:34', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (295, '2019-04-04 21:45:45', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (296, '2019-04-05 21:40:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (297, '2019-04-05 22:49:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (298, '2019-04-08 16:03:30', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (299, '2019-04-08 17:29:48', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (300, '2019-04-09 00:28:29', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (301, '2019-04-09 00:32:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (302, '2019-04-09 01:29:18', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (303, '2019-04-09 03:45:48', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (304, '2019-04-09 04:19:44', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (305, '2019-04-09 04:20:42', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (306, '2019-04-09 04:21:30', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (307, '2019-04-09 07:47:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (308, '2019-04-09 12:59:20', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (309, '2019-04-09 13:18:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (310, '2019-04-09 14:13:28', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (311, '2019-04-09 16:24:58', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (312, '2019-04-09 16:27:45', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (313, '2019-04-09 16:33:50', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (314, '2019-04-09 16:39:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (315, '2019-04-09 16:58:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (316, '2019-04-09 17:36:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (317, '2019-04-09 18:28:51', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (318, '2019-04-09 18:30:25', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (319, '2019-04-09 18:41:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (320, '2019-04-09 18:53:06', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (321, '2019-04-09 19:04:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (322, '2019-04-09 19:28:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (323, '2019-04-09 19:57:52', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (324, '2019-04-09 19:57:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (325, '2019-04-09 20:16:41', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (326, '2019-04-09 20:41:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (327, '2019-04-09 20:42:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (328, '2019-04-09 22:07:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (329, '2019-04-10 01:13:29', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (330, '2019-04-10 01:13:52', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (331, '2019-04-10 01:13:58', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (332, '2019-04-10 02:10:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (333, '2019-04-10 03:31:48', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (334, '2019-04-10 04:36:59', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (335, '2019-04-10 06:40:13', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (336, '2019-04-10 06:50:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (337, '2019-04-10 15:34:40', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (338, '2019-04-10 15:53:05', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (339, '2019-04-10 17:11:29', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (340, '2019-04-10 18:23:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (341, '2019-04-10 19:41:19', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (342, '2019-04-10 20:28:21', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (343, '2019-04-10 20:32:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (344, '2019-04-10 22:35:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (345, '2019-04-11 00:11:59', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (346, '2019-04-11 02:10:02', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (347, '2019-04-11 02:53:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (348, '2019-04-11 03:02:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (349, '2019-04-11 03:05:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (350, '2019-04-11 13:33:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (351, '2019-04-11 15:55:03', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (352, '2019-04-11 18:22:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (353, '2019-04-11 19:31:25', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (354, '2019-04-11 20:44:50', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (355, '2019-04-11 20:55:00', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (356, '2019-04-11 21:20:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (357, '2019-04-11 21:22:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (358, '2019-04-11 21:28:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (359, '2019-04-11 21:39:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (360, '2019-04-12 01:30:35', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (361, '2019-04-12 01:32:13', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (362, '2019-04-12 01:32:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (363, '2019-04-12 01:47:30', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (364, '2019-04-12 01:51:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (365, '2019-04-12 01:53:41', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (366, '2019-04-12 01:53:44', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (367, '2019-04-12 03:00:48', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (368, '2019-04-12 07:51:25', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (369, '2019-04-12 13:51:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (370, '2019-04-12 16:48:47', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (371, '2019-04-12 17:24:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (372, '2019-04-12 18:08:36', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (373, '2019-04-12 19:10:36', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (374, '2019-04-12 20:00:43', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (375, '2019-04-12 20:01:43', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (376, '2019-04-12 21:17:43', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (377, '2019-04-12 21:20:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (378, '2019-04-12 22:15:39', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (379, '2019-04-12 23:15:59', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (380, '2019-04-12 23:16:42', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (381, '2019-04-13 00:41:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (382, '2019-04-13 02:47:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (383, '2019-04-13 04:10:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (384, '2019-04-13 04:23:32', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (385, '2019-04-13 04:57:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (386, '2019-04-13 05:33:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (387, '2019-04-13 05:47:16', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (388, '2019-04-13 05:50:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (389, '2019-04-13 05:52:33', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (390, '2019-04-13 06:26:07', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (391, '2019-04-13 06:44:28', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (392, '2019-04-14 02:28:00', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (393, '2019-04-14 06:17:25', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (394, '2019-04-14 08:37:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (395, '2019-04-14 18:20:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (396, '2019-04-14 18:38:47', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (397, '2019-04-14 18:45:57', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (398, '2019-04-14 19:41:15', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (399, '2019-04-14 19:41:58', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (400, '2019-04-14 20:16:17', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (401, '2019-04-14 20:56:08', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (402, '2019-04-14 21:44:14', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (403, '2019-04-14 22:57:52', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (404, '2019-04-15 03:13:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (405, '2019-04-15 09:19:25', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (406, '2019-04-15 13:49:06', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (407, '2019-04-15 13:50:31', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (408, '2019-04-15 14:11:09', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (409, '2019-04-15 15:00:08', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (410, '2019-04-15 16:06:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (411, '2019-04-15 17:05:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (412, '2019-04-15 17:07:30', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (413, '2019-04-15 17:28:55', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (414, '2019-04-15 17:58:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (415, '2019-04-15 18:06:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (416, '2019-04-15 18:20:06', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (417, '2019-04-15 19:00:20', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (418, '2019-04-15 19:42:00', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (419, '2019-04-15 19:44:00', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (420, '2019-04-15 19:58:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (421, '2019-04-15 20:04:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (422, '2019-04-15 20:08:34', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (423, '2019-04-15 20:12:32', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (424, '2019-04-15 21:07:13', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (425, '2019-04-15 21:09:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (426, '2019-04-15 22:14:12', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (427, '2019-04-15 22:33:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (428, '2019-04-15 22:58:50', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (429, '2019-04-15 22:59:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (430, '2019-04-15 23:03:09', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (431, '2019-04-16 00:52:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (432, '2019-04-16 00:56:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (433, '2019-04-16 01:00:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (434, '2019-04-17 04:32:24', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (435, '2019-04-17 04:40:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (436, '2019-04-17 09:44:21', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (437, '2019-04-17 16:48:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (438, '2019-04-17 20:52:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (439, '2019-04-18 16:17:04', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (440, '2019-04-18 17:29:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (441, '2019-04-18 19:01:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (442, '2019-04-18 19:07:34', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (443, '2019-04-19 14:49:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (444, '2019-04-19 19:01:55', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (445, '2019-04-19 22:09:17', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (446, '2019-04-24 19:42:12', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (447, '2019-05-16 23:32:23', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (448, '2019-07-04 21:13:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (449, '2019-07-08 09:18:44', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (450, '2019-07-16 22:42:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (451, '2019-07-27 06:01:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (452, '2019-08-25 03:20:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (453, '2019-08-29 01:10:54', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (454, '2019-08-29 01:24:06', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (455, '2019-08-29 19:18:52', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (456, '2019-08-29 19:34:14', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (457, '2019-08-29 19:45:16', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (458, '2019-08-29 20:01:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (459, '2019-08-29 20:13:02', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (460, '2019-08-29 21:00:19', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (461, '2019-08-29 21:05:59', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (462, '2019-08-29 21:20:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (463, '2019-08-29 21:36:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (464, '2019-08-30 01:18:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (465, '2019-08-30 06:18:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (466, '2019-08-31 07:29:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (467, '2019-08-31 23:19:47', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (468, '2019-09-03 04:09:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (469, '2019-09-03 22:36:30', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (470, '2019-09-04 14:48:37', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (471, '2019-09-04 17:52:58', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (472, '2019-09-05 04:57:39', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (473, '2019-09-13 22:11:58', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (474, '2019-09-14 13:49:18', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (475, '2019-09-18 22:23:05', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (476, '2019-09-20 02:56:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (477, '2019-10-01 03:24:18', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (478, '2019-10-20 14:48:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (479, '2019-11-04 16:28:19', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (480, '2019-11-04 17:55:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (481, '2019-11-04 18:38:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (482, '2019-11-04 19:22:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (483, '2019-11-04 20:56:50', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (484, '2019-11-04 21:00:14', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (485, '2019-11-04 22:19:04', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (486, '2019-11-04 22:21:04', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (487, '2019-11-04 22:23:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (488, '2019-11-04 22:24:24', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (489, '2019-11-04 22:34:34', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (490, '2019-11-05 03:25:55', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (491, '2019-11-05 18:36:06', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (492, '2019-11-05 21:20:27', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (493, '2019-11-05 21:21:08', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (494, '2019-11-05 21:22:19', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (495, '2019-11-05 21:26:56', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (496, '2019-11-05 21:54:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (497, '2019-11-06 03:56:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (498, '2019-11-06 16:29:28', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (499, '2019-11-06 17:02:08', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (500, '2019-11-06 17:54:46', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (501, '2019-11-06 18:08:26', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (502, '2019-11-06 18:09:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (503, '2019-11-06 18:42:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (504, '2019-11-06 18:45:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (505, '2019-11-06 18:53:06', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (506, '2019-11-06 18:58:20', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (507, '2019-11-06 18:59:10', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (508, '2019-11-06 19:00:04', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (509, '2019-11-06 19:06:14', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (510, '2019-11-06 19:09:11', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (511, '2019-11-06 19:11:55', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (512, '2019-11-06 19:17:08', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (513, '2019-11-06 19:45:32', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (514, '2019-11-06 19:48:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (515, '2019-11-06 20:08:36', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (516, '2019-11-06 20:43:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (517, '2019-11-06 21:13:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (518, '2019-11-06 22:04:46', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (519, '2019-11-06 22:38:13', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (520, '2019-11-06 22:38:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (521, '2019-11-06 22:38:48', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (522, '2019-11-06 22:52:20', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (523, '2019-11-07 02:30:29', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (524, '2019-11-07 02:32:33', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (525, '2019-11-07 02:32:57', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (526, '2019-11-07 03:34:30', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (527, '2019-11-07 06:45:43', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (528, '2019-11-07 19:20:31', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (529, '2019-11-07 19:21:58', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (530, '2019-11-07 20:23:17', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (531, '2019-11-07 20:34:30', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (532, '2019-11-08 00:36:00', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (533, '2019-11-08 01:14:19', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (534, '2019-11-08 01:17:53', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (535, '2019-11-08 17:46:38', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (536, '2019-11-08 17:48:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (537, '2019-11-08 18:10:26', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (538, '2019-11-08 18:34:10', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (539, '2019-11-08 18:37:37', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (540, '2019-11-08 18:58:42', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (541, '2019-11-08 22:06:14', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (542, '2019-11-08 22:07:49', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (543, '2019-11-08 23:09:02', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (544, '2019-11-09 00:02:09', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (545, '2019-11-09 05:59:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (546, '2019-11-09 06:03:41', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (547, '2019-11-10 21:45:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (548, '2019-11-10 22:24:32', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (549, '2019-11-10 22:30:10', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (550, '2019-11-10 23:53:22', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (551, '2019-11-11 04:17:37', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (552, '2019-11-11 07:24:54', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (553, '2019-11-11 17:16:16', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (554, '2019-11-11 17:59:27', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (555, '2019-11-11 19:02:44', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (556, '2019-11-11 19:42:17', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (557, '2019-11-11 19:49:17', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (558, '2019-11-11 20:34:12', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (559, '2019-11-11 20:39:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (560, '2019-11-11 20:39:59', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (561, '2019-11-11 21:19:34', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (562, '2019-11-11 22:57:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (563, '2019-11-12 18:35:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (564, '2019-11-12 20:14:39', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (565, '2019-11-12 21:52:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (566, '2019-11-14 06:22:55', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (567, '2019-11-16 00:55:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (568, '2019-11-16 05:22:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (569, '2019-11-16 19:50:07', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (570, '2019-11-18 19:04:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (571, '2019-11-18 19:25:39', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (572, '2019-11-18 20:23:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (573, '2019-11-19 01:00:06', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (574, '2019-11-19 21:53:39', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (575, '2019-11-19 21:54:25', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (576, '2019-11-20 03:50:51', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (577, '2019-11-20 20:10:52', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (578, '2019-11-21 03:23:26', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (579, '2019-11-21 04:25:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (580, '2019-11-22 16:44:07', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (581, '2019-11-22 21:18:57', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (582, '2019-11-22 21:23:09', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (583, '2019-11-23 03:36:50', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (584, '2019-11-23 20:50:56', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (585, '2020-02-05 23:31:30', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (586, '2020-02-24 17:43:24', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (587, '2020-02-24 18:12:59', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (588, '2020-02-24 19:58:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (589, '2020-02-24 20:33:18', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (590, '2020-02-24 23:30:13', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (591, '2020-02-25 19:39:15', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (592, '2020-02-25 23:09:49', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (593, '2020-02-26 17:10:42', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (594, '2020-02-26 18:38:07', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (595, '2020-02-26 19:08:10', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (596, '2020-03-02 18:53:30', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (597, '2020-03-02 19:18:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (598, '2020-03-02 19:49:40', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (599, '2020-03-02 21:00:51', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (600, '2020-03-03 17:03:00', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (601, '2020-03-03 17:49:39', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (602, '2020-03-03 21:05:04', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (603, '2020-03-03 22:42:34', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (604, '2020-03-04 17:49:29', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (605, '2020-03-04 18:16:29', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (606, '2020-03-04 18:41:32', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (607, '2020-03-04 18:54:26', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (608, '2020-03-05 18:10:22', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (609, '2020-03-05 18:49:34', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (610, '2020-03-05 19:36:56', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (611, '2020-03-05 20:25:49', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (612, '2020-03-05 20:55:11', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (613, '2020-03-05 21:25:00', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (614, '2020-03-06 17:11:46', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (615, '2020-03-06 19:05:49', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (616, '2020-03-06 19:18:08', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (617, '2020-03-06 19:24:10', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (618, '2020-03-06 19:46:16', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (619, '2020-03-06 20:27:35', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (620, '2020-03-06 21:40:34', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (621, '2020-03-07 00:37:15', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (622, '2020-03-07 20:17:28', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (623, '2020-03-07 20:22:23', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (624, '2020-03-08 16:45:35', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (625, '2020-03-09 04:17:50', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (626, '2020-03-09 15:45:11', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (627, '2020-03-09 15:47:10', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (628, '2020-03-09 19:58:12', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (629, '2020-03-12 06:34:29', 0);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (630, '2020-03-12 06:45:33', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (631, '2020-03-12 23:35:45', 1);
INSERT INTO `CUHvZ`.`user_details` (`id`, `join_date`, `activated`) VALUES (632, '2020-03-13 00:39:03', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`subscriptions`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (1, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (28, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (29, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (31, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (32, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (33, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (34, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (35, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (36, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (37, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (38, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (39, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (40, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (41, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (42, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (43, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (44, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (45, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (46, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (47, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (48, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (49, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (50, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (51, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (52, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (53, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (54, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (55, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (56, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (57, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (58, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (59, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (60, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (61, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (62, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (63, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (64, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (65, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (66, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (67, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (68, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (69, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (70, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (71, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (72, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (73, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (74, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (75, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (76, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (77, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (78, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (79, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (80, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (81, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (82, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (83, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (85, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (86, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (87, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (88, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (89, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (90, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (91, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (92, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (93, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (94, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (95, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (96, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (97, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (98, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (99, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (100, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (101, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (102, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (103, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (104, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (105, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (106, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (107, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (108, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (109, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (110, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (111, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (112, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (113, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (114, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (115, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (116, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (117, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (118, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (119, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (120, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (121, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (122, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (123, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (124, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (125, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (126, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (127, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (128, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (129, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (130, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (131, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (132, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (133, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (134, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (135, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (136, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (137, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (138, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (139, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (140, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (141, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (142, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (143, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (144, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (145, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (146, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (147, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (148, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (149, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (150, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (151, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (152, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (153, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (154, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (155, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (156, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (157, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (158, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (159, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (160, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (161, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (162, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (163, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (164, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (165, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (166, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (167, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (168, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (169, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (170, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (171, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (172, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (173, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (174, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (175, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (176, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (177, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (178, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (179, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (180, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (181, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (182, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (183, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (184, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (185, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (186, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (187, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (188, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (189, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (190, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (191, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (192, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (193, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (194, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (195, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (196, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (197, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (198, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (199, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (200, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (201, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (202, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (203, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (204, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (205, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (206, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (207, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (208, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (209, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (210, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (211, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (212, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (213, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (214, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (215, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (216, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (217, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (218, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (219, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (220, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (221, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (222, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (223, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (224, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (225, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (226, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (227, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (228, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (229, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (230, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (231, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (232, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (233, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (234, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (235, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (236, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (237, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (238, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (239, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (240, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (241, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (242, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (243, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (244, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (245, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (246, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (247, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (248, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (249, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (250, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (251, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (252, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (253, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (254, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (255, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (256, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (257, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (258, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (259, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (260, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (261, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (262, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (263, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (264, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (265, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (266, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (270, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (271, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (273, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (274, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (275, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (276, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (277, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (278, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (279, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (280, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (281, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (282, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (283, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (284, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (285, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (286, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (287, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (288, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (289, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (290, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (291, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (292, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (293, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (294, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (295, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (296, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (297, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (298, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (299, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (300, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (301, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (302, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (303, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (304, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (305, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (306, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (307, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (308, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (309, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (310, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (311, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (312, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (313, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (314, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (315, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (316, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (317, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (318, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (319, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (320, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (321, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (322, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (323, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (324, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (325, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (326, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (327, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (328, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (329, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (330, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (331, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (332, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (333, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (334, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (335, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (336, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (337, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (338, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (339, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (340, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (341, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (342, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (343, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (344, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (345, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (346, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (347, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (348, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (349, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (350, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (351, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (352, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (353, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (354, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (355, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (356, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (357, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (358, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (359, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (360, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (361, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (362, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (363, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (364, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (365, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (366, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (367, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (368, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (369, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (370, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (371, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (372, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (373, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (374, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (375, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (376, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (377, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (378, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (379, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (380, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (381, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (382, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (383, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (384, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (385, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (386, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (387, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (388, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (389, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (390, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (391, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (392, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (393, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (394, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (395, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (396, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (397, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (398, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (399, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (400, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (401, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (402, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (403, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (404, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (405, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (406, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (407, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (408, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (409, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (410, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (411, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (412, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (413, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (414, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (415, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (416, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (417, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (418, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (419, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (420, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (421, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (422, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (423, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (424, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (425, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (426, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (427, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (428, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (429, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (430, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (431, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (432, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (433, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (434, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (435, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (436, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (437, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (438, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (439, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (440, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (441, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (442, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (443, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (444, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (445, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (446, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (447, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (448, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (449, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (450, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (451, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (452, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (453, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (454, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (455, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (456, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (457, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (458, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (459, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (460, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (461, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (462, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (463, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (464, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (465, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (466, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (467, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (468, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (469, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (470, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (471, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (472, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (473, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (474, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (475, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (476, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (477, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (478, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (479, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (480, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (481, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (482, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (483, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (484, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (485, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (486, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (487, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (488, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (489, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (490, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (491, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (492, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (493, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (494, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (495, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (496, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (497, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (498, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (499, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (500, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (501, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (502, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (503, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (504, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (505, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (506, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (507, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (508, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (509, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (510, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (511, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (512, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (513, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (514, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (515, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (516, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (517, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (518, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (519, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (520, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (521, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (522, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (523, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (524, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (525, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (526, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (527, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (528, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (529, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (530, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (531, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (532, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (533, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (534, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (535, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (536, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (537, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (538, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (539, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (540, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (541, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (542, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (543, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (544, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (545, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (546, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (547, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (548, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (549, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (550, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (551, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (552, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (553, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (554, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (555, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (556, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (557, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (558, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (559, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (560, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (561, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (562, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (563, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (564, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (565, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (566, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (567, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (568, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (569, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (570, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (571, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (572, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (573, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (574, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (575, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (576, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (577, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (578, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (579, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (580, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (581, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (582, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (583, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (584, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (585, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (586, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (587, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (588, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (589, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (590, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (591, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (592, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (593, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (594, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (595, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (596, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (597, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (598, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (599, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (600, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (601, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (602, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (603, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (604, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (605, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (606, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (607, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (608, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (609, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (610, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (611, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (612, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (613, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (614, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (615, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (616, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (617, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (618, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (619, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (620, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (621, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (622, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (623, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (624, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (625, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (626, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (627, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (628, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (629, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (630, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (631, 1, 1, 1);
INSERT INTO `CUHvZ`.`subscriptions` (`id`, `weeklong`, `lockin`, `general`) VALUES (632, 1, 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`lockins`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`lockins` (`id`, `title`, `event_date`, `waiver`, `eventbrite`, `blaster_eventbrite`, `state`) VALUES (1, 'Entombed', '2018-03-23', '/lockin/waiver/lockin_waiver_fall18.pdf', 'NULL', 'NULL', 1);
INSERT INTO `CUHvZ`.`lockins` (`id`, `title`, `event_date`, `waiver`, `eventbrite`, `blaster_eventbrite`, `state`) VALUES (2, 'Close Encounters of the Undead Kind', '2018-11-16', '/lockin/waiver/lockin_waiver_spring18.pdf', 'NULL', 'NULL', 1);
INSERT INTO `CUHvZ`.`lockins` (`id`, `title`, `event_date`, `waiver`, `eventbrite`, `blaster_eventbrite`, `state`) VALUES (3, 'Ragnarok', '2019-04-19', '/lockin/waiver/lockin_waiver_spring19.pdf', 'NULL', 'NULL', 1);
INSERT INTO `CUHvZ`.`lockins` (`id`, `title`, `event_date`, `waiver`, `eventbrite`, `blaster_eventbrite`, `state`) VALUES (4, 'Ivy\'s Infection', '2019-11-22', '/lockin/waiver/Fall2019LockinWaiver.pdf', 'NULL', 'NULL', 1);
INSERT INTO `CUHvZ`.`lockins` (`id`, `title`, `event_date`, `waiver`, `eventbrite`, `blaster_eventbrite`, `state`) VALUES (5, 'Blood Nation', '2020-03-20', '/lockin/waiver/BloodNationLockinWaiver.pdf', 'NULL', 'NULL', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`lockin_text`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`lockin_text` (`id`, `details`) VALUES (1, 'BOLD[Important note to all player under the age of 18:]\nDue to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.\nIf your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.\n[LINE]\nIn the 6th dynasty of the golden age of Ancient Egypt, there lived the son of Montu, a Pharaoh of divine blood with Sekhmet’s fury raging in his soul. A Pharaoh whose soul was tainted, who became a harbinger of destruction; his name so cursed that few dare to speak it. His reign was paved with blood and fire, and so too was his death.\n\nAs soon as he became of age to be pharaoh, he killed his father. He brutally stabbed him into the sand, blade driven directly into the old man’s heart. He allowed his father no burial, no guide, and no means of obtaining eternal life with the gods.\n\nHe was Pharaoh, his will was the will of the gods.\n\nAfter his rise, he waged a war on the Nile.\n\nSoon it became evident that this man of war cared not for the gods: he craved bloodshed, craved conquering, and would go to Duat and back for his bloodlust.\n\nGuided by the light of Ra, a peasant boy brought together a revolution, claiming he had seen the god in a dream, had been ordered by the fallen king of the gods, Osiris, to end the reign of a madman.\n\nSoldiers and simple folk alike joined, overthrowing the slave prisons, freeing those who were taken from families, killing those loyal to the pharaoh.\n\nThen the pharaoh’s guards, who, it was said, carried a piece of the pharaoh’s soul, came with pails of liquid fire. They set the cities ablaze, burning men, women and children alike.\n\nFrom her window, the queen watched the Nile burn. She watched the people run screaming into the water, watched children lose family and friends. She watched the Nile burn and turn red with the blood of those seeking refuge from the flames. A single solitary tear slipped down her cheek, the mark of a mother mourning her young.\n\nShe sought the oracle of Pakhet, pleading for knowledge of what to do, how to stop this madness.\n\nThe oracle’s words were simple, “the madness of Pharaoh will never cease, nor will his bloodshed. If you wish for his end and the end of the wars he has wrought, you must drive a poisoned blade through his throat and trap his soul in the pieces of his sceptre. Should you fail to trap his soul, his fury will remain, his soul, once whole, will be too powerful to limit.”\n\nEmboldened by these words, while seeking forgiveness for the sin she would commit, the queen and her handmaidens laced five daggers with the venom of the cobra. Each woman would kill one man that night, after Pharaoh had tired himself of his victory.\n\nEach handmaiden entered the room of one of the guards, and the Queen entered the room of her husband.\n\nShe slit his throat where he slept, broke his sceptre and trapped pieces of his soul in the shards. She fled to her bed chambers, only to be awoken by screams when her work had been discovered.\n\nPharaoh’s reign had ended, and his burial was swift. His tomb was a maze, laden with the warriors who had served him most faithfully, with his royal guards around the entrance to Pharaoh’s final resting place.\n\nWith time, his cursed name faded, and his deeds were forgotten.\n\nBut mankind cannot leave demons to rest.\n\nAn Archaeologist by the name of Pierce Wolf stumbled upon the cursed tomb of the king, found the sceptre of the fallen Pharaoh. Unknowingly, he stole from that tomb the Pharaoh’s gold.\n\nIn anger at their disturbed place of rest, his soldiers and his guards rose to reclaim what was theirs, and to reawaken the Pharaoh’s fury once more.');
INSERT INTO `CUHvZ`.`lockin_text` (`id`, `details`) VALUES (2, 'BOLD[Important note to all player under the age of 18:]\nDue to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.\nIf your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.');
INSERT INTO `CUHvZ`.`lockin_text` (`id`, `details`) VALUES (3, 'BOLD[Important note to all player under the age of 18:]\nDue to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.\nIf your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.');
INSERT INTO `CUHvZ`.`lockin_text` (`id`, `details`) VALUES (4, 'BOLD[Important note to all player under the age of 18:]\nDue to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.\nIf your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.');
INSERT INTO `CUHvZ`.`lockin_text` (`id`, `details`) VALUES (5, 'Years after the return of the Avatar and the war had ended a new nation emerged, a nation of blood. Powered by dark spirits and fueled by rage and revenge for their people, a group of blood benders formed Blood Nation.\n\nThe blood benders made a deal with the dark spirits, allowing the spirits to inhabit their bodies in exchange for enhancing their blood bending capabilities beyond imagination. The dark spirits bestowed the ability to control anyone from anywhere as long as they have been infected with dark spirit energy.\n\nThey have declared war on the Fire Nation and have begun to advance their brainwashed armies. Coming into contact with anyone infected with the dark spirit energy results in the infection immediately spreading and taking control of their mind, joining the Blood Nation.\n\nBOLD[Important note to all player under the age of 18:]\nDue to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.\nIf your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.\n\nBOLD[Tentative schedule:]\nBOLD[Please not that there is roughly 2.5 - 3 hours between doors opening and when gameplay starts.]\n9:00 pm: Doors open and check-in begins\n9:15 pm: Rules presentation\n9:30 pm: Rules presentation\n9:45 pm: Rules presentation\n10:00 pm: Doors close\n10:15 pm: Final rules presentation\n10:30 - 11:00 pm: First round begins\n(Note: This when we aim to start the first round and is subject to change)\n~12:00 pm First round ends\nNext 15-30 minutes is dedicated to clean up and next round setup\n~12:30 pm Second round begins\n~ 1:30: Second round ends\nThe rest of the time is dedicated to cleaning up\n\n\nParking:\nIMAGE[/images/where-to-park.png]');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`weeklongs`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (1, 'Close Encounters of the Undead Kind', '2018-09-24 09:00:00', '2018-09-28 17:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (2, 'Lovecraft', '2017-11-12 09:00:00', '2017-11-20 17:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (3, 'Souljourn Preamble', '2017-04-20 09:00:00', '2017-03-24 17:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (4, 'Ragnarok', '2019-04-15 13:00:00', '2019-04-19 21:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (5, 'Ivy\'s Infection', '2019-11-11 14:00:00', '2019-11-15 22:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (6, 'Blood Nation', '2020-03-09 13:00:00', '2020-03-13 21:00:00', 4, 'NULL');
INSERT INTO `CUHvZ`.`weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`, `waiver`) VALUES (7, 'Test Weeklong', '2020-04-20 09:00:00', '2020-04-24 17:00:00', 2, 'NULL');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`weeklong_details`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (1, 300, 'Fight through hordes of zombies... but also aliens.\n\nLINK[Join the Discord!][https://discord.gg/wV6SqQ] Choose your role from role-reqest by clicking on the indicated emoji for a human or a zomnbie. Please be honest and play fair.\n', 'Mission email:\n[SUBJECT] EYES ONLY not hands or teeth\n\nAll forces near checkpoint Omega should converge to Beach park. Hostile agents are attracted to unidentified noodle shaped objects which have been detected near a playground and should be handled with extreme care. Civilians have been told that we will be performing fumigation in the area. Get your stories straight. Any unauthorized personnel should be diverted. Secure the objects from any and all hostiles and wait for item extraction.\n\n\n[SUBJECT] Monday Mission Update\n\nThe objects have been secured thanks to shakz, the lone survivor of the mission. Thanks to shakz the alien objects have been secured for observation and the outbreak has been contained so far.\n\nTomorrow Dr. Wolf will need assistance gathering research on campus. He will be making to runs during the day, one at 10am and the other at 2pm. Escort him according to the following route UMC Fountains -> Theatre -> Koi pond/Hale -> Old Main -> Norlin Fountains -> REC -> Ralphie.\n\nPossible mission points:\nAll humans that are present for the start of the mission are awarded 10 points\nAll humans that are alive by the end of the mission are awarded 10 points.\n\nFailure to complete the either escort mission will have consequences.', '', '', '', '');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (2, 300, 'In a nutshell, the missions are designed as follows: successful completion of an on-campus mission lets the humans who completed it either choose to lengthen the zombie stun timer for the following day, or get a clue to help with that day\'s code.\nSolving the code will give the location of the off-campus game, which starts at 5:00pm each day. Off-campus missions involve finding and defending one or more deely-boppers, which the zombies are trying to capture. When a zombie captures a deely-bopper, that zombie becomes a special infected.\n', '', '', '', '', '');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (3, 300, 'In a nutshell, the missions are designed as follows: successful completion of an on-campus mission lets the humans who completed it either choose to lengthen the zombie stun timer for the following day, or get a clue to help with that day\'s code.\nSolving the code will give the location of the off-campus game, which starts at 5:00pm each day. Off-campus missions involve finding and defending one or more deely-boppers, which the zombies are trying to capture. When a zombie captures a deely-bopper, that zombie becomes a special infected.\n', '', '', '', '', '');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (4, 60, 'Don\'t forget to sign and bring your wavier when you pick up your bandanna!\nLINK_NEW_TAB[Ragnarok Weeklong waiver][/weeklong/waiver/Spring19WeeklongWaiver.pdf]\n\nLINK[Join the Discord!][https://discord.gg/nzqG7Wk] Choose your role from role-reqest by clicking on the indicated emoji for a human or a zomnbie. Please be honest and play fair.\n\nThis weeklong will be different than past weeklongs. This time we have Nerf blasters for the top 3 players! The players with the most points at the end of the weeklong will get to choose their prize blaster as well as securing a ticket to the lockin event that Friday night. Players can earn points by participating in off-campus missions, collecting supply drops and getting kills.\n\n1st place: Hyperfire or Hades\n2nd place: Surgefire or Hera\n3rd place: Strongarm or Kronos\nIMAGE[/images/weeklongS19_prizes.png]\n\nZombie stun timer will start at 5 minutes but can be reduced if humans fail their daily missions.\n\nWe\'ve also changed up how are humans have to play. Now humans have a starve timer and inactive humans will die if they don\'t go out and collect supply drops.\nHere are all the sign locations for potential supply drops. Humans must enter the 5 character code, located on the bottom of the signs, in order to receive the supply drop. Keep in mind that there will be a limited number of supply drops at each location so make sure you get there before other humans! You can also receive supply drops by going to off-campus missions.\nIMAGE[/images/sign_locations_map.png]\n\n\nThe skies weep\no\'er fire and ice\nthe gods\nnow risen\nthe earth\nnow fallen\n\nGreat Odin\nthe gates of\nValhalla\nhe shall open\nand come forth\nwarriors of light\n\nOn this day,\nbrave warriors,\nwhile thine\nmight now stand\nwho among you\nwill fall?\n\nRagnarok\nis upon you\nand with it comes\nthe final stone is turned\nas humanity falls\nto chaos,\n\nCome now warriors\nwill you die\nlike trampled flowers\nor will you stand\nand make the darkness\nfear your cry?\n\n\nChaos is here, friends, as it has been foretold. The army of the dead have risen to their God\'s command, and we must stand to face them. The gods are at out back, out weapons blessed by their hands, we must fight so that they might survive so that we might live to see the light of the sun once more. Surtr is coming, we are the last hope. If he triumphs, all will burn in his rage.\nWill you answer the call?', 'Greetings Warriors,\n\nThe first signs of Ragnarok are shown, the seer Völva has warned me of treachery on the part of my adoptive son Loki and my grandson. On this first day we require more strength to repel the forces of chaos, should they be upon us. On campus today will be late registration and bandanna pick up at the UMC.\n\nOff campus at Scott Carpenter Park is where we will be hunting down my grandson in hopes of halting his plans. The mission will be capture the flag and will start 6 PM when the sun is low.\n\nFarewell my children,\nThe All Father\n\n\nOff-campus Rewards:\nAll players that participate in the off-campus mission will earn 15 points\n\nMission Success:\nHumans present earn 10 points\n\nMission Failure:\nZombie stun timer reduced by 1 minute for all zombies', 'Greetings Warriors,\n\nYesterday\'s mission at Scott Carpenter park proved to be a failure, resulting in the zombie stun timer to be reduced to 4 minutes.\n\nMy son Loki is hiding himself in the form a fish. We must obtain pieces of a net that have been scattered throughout campus. To obtain these pieces you must locate these statues and take \"selfies\" and submit them on discord using the instructions provided below. These \"selfies\" will capture the pieces of the net in the picture. All four locations must be captured for the piece of the net to be obtained. Warriors must work together to collect a total of 10 pieces in order to build the net.\n\nPlease locate these statues and take a \"selfie\":\nIMAGE[/images/selfie_locations_S19.png]\n\nOnce the net pieces have been collected we can construct the net at Central Park and capture Loki at 6 PM. We must hold the area until the net can be constructed and then we may catch my son.\n\nMy children, I understand that you are needing sustenance to continue forth, I have sent you food for you and your families. The supplies have been sent to the following locations with the given amount of supplies at each location:\n\nSign #2: 25 supplies\nSign #6: 25 supplies\nSign #11: 25 supplies\nSign #18: 25 supplies\nBy aware the humans may only take one supply drop from any given location but they are allowed to collect from as many locations as they wish. Supply drops will increase the human stun timer by 24 hours with a cap for 48 hours. Collecting a supply drop also rewards that player with 10 points. Zombies cannot collect supply drops but are allowed to stalk those locations.\nThese supply drops will expire at 5pm today and new ones will be deployed tomorrow.\nLINK_NEW_TAB[Here\'s a link for the sign locations][/images/sign_locations_map.png]\n\nDiscord picture submission instructions:\nToday there will be a chat on our discord players tab called \"Tuesday-photo-submissions\". Use this chat to submit your photos by 5pm today. The earlier the better. Your messages and photos will not be seen by others and after submitting your photos will disappear from your view, but don\'t worry, they have been submitted. Please submit all photos at the same time as well as your username and/or player code. Have fun. And be creative.\n\nFarewell my children,\n\nThe All Father\n\nOn-campus Rewards:\nHumans earn 5 points per correct selfie submitted\nHumans earn bonus 10 points for all correct selfie locations\n\nMission Failure:\nZombie stun timer reduced by 1 minute for all zombies\n\nOff-campus Rewards:\nAll players that participate in the off-campus mission will earn 15 points\n\nMission Success:\nHumans that survive receive a supply drop\nHumans that win receive 10 bonus points\n\nMission Failure:\nZombie stun timer reduced by 1 minute for all zombies', 'Greetings Warriors,\n\nTuesday missions report\nThe on-campus mission resulted in the humans being successful! With a total of 11 full sets of \"selfies\" submitted we were able to retrieve pieces of the net. Unfortunately the off-campus mission proved to be a failure, the humans could not put together the in time and hence forth the zombie stun timer has been reduced to 3 minutes.\n\nOn this day I fear the prophesied winters are come, Today we are called to defend the remnants of civilization. There remains two mid-guardian cities who have not fallen to the forces of chaos, and on this day, brave warriors, we are called to defend. On campus at Wolf Law Soccer Field will be soccer defense at 1:30 PM. As well, warriors, today more sustenance will be delivered, humans must gather supplies while they can to avoid starvation.\n\nMy children, survival is necessary, we are the last pillars of the realms. We must gather and prepare our forces for the days ahead, at Beach Park at 6 PM. There will be much needed supplies and we must race to retrieve them before the forces of death.\n\nI have sent out more supplies to those in need. Unfortunately these supply drops are not protected by magic and now the zombies can steal the supplies. Luckily these supplies are not made from human flesh and are less effective in feeding the zombies. I also seem to have misplaced one of the supply drops, all I can remember is that it was at an odd sign location. Further rewards will be given to those who find it, please find it before the dead do.\nSign #4: 25 supplies, worth 10 points\nSign #10: 25 supplies, worth 10 points\nSign #16: 25 supplies, worth 10 points\nMissing supply drop: 10 supplies, worth 40 points\n\nFarewell my children,\nThe All Father\n\n\nOn-campus Rewards:\nAll players that participate in the on-campus mission will earn 15 points\n\nMission Failure:\nZombie stun timer reduced by 45 seconds for all zombies\n\n\nOff-campus Rewards:\nAll players that participate in off-campus mission will earn 15 points\n\nMission Success:\nSurviving humans earn 20 points + 1 supply drop\n\nMission Failure:\nZombie stun timer reduced by 45 seconds for all zombies', 'Greetings Warriors,\n\nYesterday proved to be disastrous as humans lost both the on and off campus missions resulting in the zombie stun timer being 1 minute and 30 seconds.\n\nLoki has broken free from his chains and the Earth has started to rumble. Buildings are crumbling and are being overrun by Hel\'s undead army. You must hold your outposts or there will be dire consequences.On campus is tower defense, poles with bandannas tied to them are defenses, humans must hold the towers by putting the bandanna above the line. Zombies must hold the tower by putting the bandanna below the line. Points will be recorded every half hour and posted on Discord. Refer to this map for locations of the control towers.\nIMAGE[/images/control_tower_map.png]\n\nThe last of the supplies have been sent out but Loki has taken it upon himself to hide one of the supply drops and all I can see is that it\'s located somewhere within the marked area. Here are the supply drops to collect.\nSign #12: 10 uses, +24 hours, +20 points\nSign #3: 10 uses, +24 hours, +20 points\nStolen supply drop: 10 uses, +24 hours, + 40 points\nIMAGE[/images/stolen_supply_drop.png]\n\nTonight we must preserve what we can and protect our ancient bloodlines. Warriors must rendezvous at Martin Park to help escort friends and families to safety. The undead will be upon us so come prepared. Off-campus is escort at Martin Park at 6 PM.\n\nThe day is growing dark my children.\nFarewell,\nThe All Father\n\nOn-campus Rewards:\nMission Failure:\nZombie stun timer reduced by 15 seconds for all zombies\n\n\nOff-campus Rewards:\nAll players that participate in off-campus mission will earn 15 points\n\nMission Success:\nSurviving humans receive a supply drop\n\nMission Failure:\nZombie stun timer reduced by 15 seconds for all zombie\nZombies are fed +12 hours', 'Greetings Warriors,\n\nYesterday humans took heavy losses and were unable to hold their stations and failed at saving their family members. The zombie stun timer has reached its lowest at 1 minute. I wish you good luck to those who are left standing, you are our last hope.\n\nToday my message to you is one of grief. Ragnarok is upon us. The giants are overtaking the realms and now the gods must step in to protect the last survivors. Today my children, you must write your name on a scroll to ensure the protection of the gods. We will preserve you, warriors, to ensure the greatest success in the battle for peace but you must still be human at the end of the day to receive that protection. On campus mission is to write your name an a book in the area with the LINK_NEW_TAB[Rock with a square cut out of it.][https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656]\n\nCome now brave warriors, the time for battle is near. The Lock-in is Tonight, doors open at 9pm and close at 10pm.\nLINK_NEW_TAB[Reserve your spot and accepting this invitation.][https://www.eventbrite.com/e/cu-hvz-ragnarok-tickets-60309888500]\nLINK_NEW_TAB[If you require weaponry we have some that you may rent, free of course.][https://www.eventbrite.com/e/cu-hvz-ragnarok-blaster-rental-tickets-60286249796]\n\nFarewell my children,\nThe All Father\n\nOn-campus Rewards:\nHumans earn 50 points if their USERNAME is written in the notebook and they are still human at 5pm today.');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (5, 60, 'Boulder is in chaos. Poison Ivy has created a super-virus that’s turning people into her zombie slaves. But she’s not alone. She’s teamed up with villains from all over the multiverse so that they’re powerful enough to take over the city. We need your help to stop them.\n\nDetails/Rules:\n- Off-campus is not perma death for humans, just for fun and points. Humans that ger tagged during off-campus missions will remain human after the mission and zombies will still get their points.\n- Yellow bandana must be worn around your leg to identify you as a player of the game.\n- The green bandana is worn on your head for zombies and around arm for humans.\n- Poisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.\nIMAGE[/images/human.jpg][45]IMAGE[/images/zombie.jpg][45]\n\nSuppy Drop Locations:\nIMAGE[/images/signs-fall19.png]', '[SUBJECT]: Villainy is Afoot\nAttention League of Heroes,\n\nThis is Commissioner Gordon from the Gotham City Police Department.\n\nWe recently had an alarming report reach the Gotham Police. Poison Ivy and a band of villains have been planning something dastardly; there’s been increased activity targeting chemical transports and chemical storage centers. We think they may be planning to create some sort of poison. Those affected by the poison have turned into zombie-like slaves.\n\nI will be dispatched to Boulder, Colorado to attempt to track down these villains before they can complete their plan.\n\nWe need you to come and agree to help us track down these fiends. Today at the BOLD[UMC is the final day to receive bandanas and turn in your waiver]. We will have a table set up for you to do so. There will be BOLD[no off campus mission] today on account of weather.\n\nStay Vigilant,\nCommissioner Gordon', '[SUBJECT]: The Riddler\nAttention Heroes,\n\nThis is Commissioner Gordon.\n\nI have danINCLUDE[riddler.txt]\n\nHello, hello, hello, mindless people of Boulder.\n\nI have a dangerous game to play, for those of you who are able. My games and riddles will bring you down to the cable.\n\nI have many gifts set, now it\'s time for you to fret. Three by three you must find for me, carefully placed will be the key. Central Park you must go, or let the zombie horde grow.\n\nFollow my riddles, disable my tricks, and you may live to see another day.\n\nSo what do you say,\nWant to play?\n\n- The Riddler\n\nI have one more riddle for you friends,\nWe are what is necessary for your life\nBut if you eat us you may be dead\nPick a number, a supply for you\nBeware whether it’s aid is false or true.\nPoison can be deadly.\n\n——————————————CONNECTION REESTABLISHED————————————--\n\nHeroes, this is commissioner Gordon. I do not know what the Riddler is planning but we know he will be active at Central park at 5pm. Please aid me in capturing him and foiling his plans. Careful when collecting these supply drops as it seems The Riddler may have poisoned one of them.\n\nStay Vigilant,\nCommissioner Gordon', '[SUBJECT] Winter is Coming and Frost is Leading It\nAttention Heroes,\n\nThis is Commissioner Gordon. I must first inform you that yesterday\'s mission failed. The Riddler was able to denote his packages releasing more of Poison Ivy\'s gas, this has resulted in these \'zombies\' becoming more powerful.\n\n---- Zombie stun timer has been reduced to 4 minutes ----\n\nWe’ve recently had reports of Killer Frost being active in the Boulder area. She is dangerous, and anyone who has tried to stop her has been frozen and reanimated as one of Ivy’s Zombies. She has been attempting to speed up the process of winter to make people more susceptible to the toxin Poison Ivy is making.\nWe have a plan on how to stop her: Frost is extremely self-conscious about her appearance and jealousy can be a way to drive her into the open. We need you to take \'selfies\' at specific locations showing off yourself and your friends. This should demoralize Frost and make her easier to capture. See image below for locations where the selfies must be taken, we\'re not sure where these are but we do know that these locations are the ones that will bring Killer Frost out in the open. At least 30 total correct selfies must be achieved to draw her out.\nIMAGE[/images/selfie-pics.jpg]\n\nI\'ve also sent out more supplies to those who need it but this batch seems to attract the zombies and they are eating it. Get to those supply drops fast before the zombies steal them all\nWe have also received information about a robbery that is going to occur at Martin park at 5 pm. Meet there to intercept the thieves.\n\nBest of luck Heroes,\nGordon', '[SUBJECT] Infectious Laughter\n\nAttention Heroes,\n\nYesterday was a dark day. Both missions failed and as a result the zombies have grown more powerful.\n****** Zombie stun timer reduced to 2 minutes ******\n\nINCLUDE[joker.txt]\n\nHAHAHAHAHHAHAHAHAHAHAHAHHA\n<div class=\'center\'>\n<img src=\'/images/smile.png\' style=\'width: 150px\'>\n</div>\nHELLOO COMMISSIONER\n\nheheHAHAHAHAhahehaha I have a game thAtS sUrE to make you DIE from LAuGHTeR. I’ve put some of mY TOYS around your city, they’re tick-TOCKING down as we SPEAK. Try to deactivate them if you wiSH but a big THANKS to Ivy for her little poison. Her little pets can FIX what you try to do, commissioner.\n\nLet\'s HAVE SOME FUN BOYS\n\nMR. J\n\n———————— CONNECTION REESTABLISHED ————————\n\nHello? Hello, this is Commissioner Gordon.\nThe Joker is up to his schemes and we need to stop him. His towers have been set up at 3 locations on CU Boulder\'s campus. These towers go off every 30 minutes and must be deactivated to prevent them from releasing more of Poison Ivy\'s gas into the atmosphere. Shutting down these towers won\'t be enough to stop them alone, the zombies can reactivate the towers so you must make sure to keep deactivating them. LINK_NEW_TAB[Here are the locations of the towers.][/images/control_tower_map.png]\n\nThe joker has also hinted at causing more mayhem at Scott Carpenter at 5pm. Please come and help stop his evil plans.\n\nWe need your help heroes.\nCommissioner Gordon', 'Attention Heroes,\n\nYesterdays missions proved to be failures and the zombies are reaching staggeringly dangerous levels.\n\n****** Zombie stun timer is now 1 minute ******\n\nThe city is in grave parrel. Lex Luthor plans to launch an attack on the city. We must evacuate all remaining heroes and citizens that have not yet been infected. I have set up a log that you can write your name in so we know who to evacuate and we will send a chopper to get you at Beach park at 5pm today. LINK_NEW_TAB[Here is the location of the log][https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656].\n\nI have also sent out the last of our supplies for those in need.\n\nGood luck heroes,\nCommissioner Gordan');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (6, 120, 'Years after the return of the Avatar and the war had ended a new nation emerged, a nation of blood. Powered by dark spirits and fueled by rage and revenge for their people, a group of blood benders formed Blood Nation.\n\nThe blood benders made a deal with the dark spirits, allowing the spirits to inhabit their bodies in exchange for enhancing their blood bending capabilities beyond imagination. The dark spirits bestowed the ability to control anyone from anywhere as long as they have been infected with dark spirit energy.\n\nThey have declared war on the Fire Nation and have begun to advance their brainwashed armies. Coming into contact with anyone infected with the dark spirit energy results in the infection immediately spreading and taking control of their mind, joining the Blood Nation.\n\nBOLD[When to turn in your waiver and get your bandanas:]\nWe will be tabling in the UMC during these times\nTuesday 3/3, 9 am - 5pm\nWednesday 3/4, 9 am - 5pm:\nThursday 3/5, 9 am - 5pm\nFriday 3/6, 9 am - 5pm\nMonday 3/9, 9 am - 5pm\n\nBOLD[Details/Rules:]\n- Off-campus is not perma death for humans, just for fun and points. Humans that get tagged during off-campus missions will remain human after the mission and zombies will still get their points.\n- Yellow bandana must be worn around your leg to identify you as a player of the game.\n- The green bandana is worn on your head for zombies and around your arm for humans.\n- Poisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.\nIMAGE[/images/human.jpg][45]IMAGE[/images/zombie.jpg][45]\n\n\nSuppy Drop Locations:\nIMAGE[/images/signs-fall19.png]', '[SUBJECT]: Investigate the Rig\n\nDefenders of the Fire Nation,\n\nWe’ve received reports of Blood Nation forces inhabiting the abandoned Fire Nation prison rig. We need volunteers to go investigate if the rumors are true. Be careful, as the rig is old, unstable and has begun to collapse. Remove any Blood Nation forces that reside there and return home safely.\n\nRemember, don’t come into contact with any of the Blood Nation forces. We must stop the dark spirits from spreading.\n\n- General Zuko', '[SUBJECT]: Defend the Moon Spirit\n\nDefenders of the Fire Nation,\n\nIn the aftermath of yesterday’s events, it has come to our attention that the citizens of the Northern Water tribe have been disappearing. We believe that the Blood Nation is behind these disappearances and that they plan to steal the Moon spirit to further increase their blood bending abilities. Go and protect the Moon spirit at all costs.\n\nI have sent out supplies to any of those who may need it but beware that Blood Nation soldiers may try to steal them.\n\n- General Zuko\n\n[LINE]\n\n[SUPPLY_DROPS]\nOne of these has been poisoned\nSign #9: 15 supplies\nSign #15: 15 supplies\nSign #17: 15 supplies\nSign #22: 15 supplies\nPoisoned supply drops will reduce the effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.\nLINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', '[SUBJECT]: Rock Slides in the Kolau Mountains\n\nDefenders of the Fire Nation,\n\nWe have received reports of an unusual number of large rock slides in the Kolau Mountains in the Earth Kingdom. This could be related to Blood Nation activity. We’re sending you in to investigate and determine if there is any threat.\n\nWhile you’re in the Earth Kingdom we’d like you to recruit Toph Beifong to aid in our efforts against the Blood Nation. She may be stubborn about it, so you will have to prove you’re worthy of her help… I wish you good luck.\n\n- General Zuko\n\n[LINE]\n\n[SUPPLY_DROPS]\nOne of these has been poisoned\nSign #4: 10 supplies\nSign #7: 10 supplies\nSign #11: 10 supplies\nSign #19: 10 supplies\nPoisoned supply drops will reduce the effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.\nLINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', '[SUBJECT]: Blue Spirit\n\nDefenders of the Fire Nation,\n\nA Blue Spirit imposter is wreaking havoc in the Fire Nation capital, setting fire to buildings and setting off explosives. Put out the fires and save anyone you can. Stopping this Blue Spirit imposter is of utmost importance.\n\n- General Zuko\n\n[LINE]\n\n[SUPPLY_DROPS]\nOne of these has been poisoned. Zombies can still steal but can not be poisoned.\nSign #6: 10 supplies\nSign #12: 10 supplies\nLINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', '[SUBJECT]: Invasion\n\nDefenders of the Fire Nation,\n\nWe have failed: the invasion has begun. All citizens that are not infected by the Dark Spirits must be evacuated immediately. We will send in an airship at 5 pm to pick up all survivors that have registered themselves in the logbook.\n\nOur last hope is the Avatar. Avatar Aang will travel to the Spirit world to talk to Koh in hopes of learning of a way to stop the Dark Spirits. Aang must be protected while in the Avatar state. If he falls under the control of the Blood Nation… all hope will be lost.\n\n- General Zuko');
INSERT INTO `CUHvZ`.`weeklong_details` (`id`, `stun_timer`, `details`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`) VALUES (7, 300, '', '', '', '', '', '');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`weeklong_missions`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (1, 1, 'monday', 'on', 'Late sign up, check in, bandanna retrieval', '9am - 5pm', 'UMC indoors', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (2, 1, 'monday', 'off', 'Defense', '6pm - 7pm', 'Beach park', 'https://www.google.com/maps/place/Beach+Park/@40.0048439,-105.2777321,16.71z/data=!4m8!1m2!2m1!1sbeach+park!3m4!1s0x0:0x68c652cd71473e8f!8m2!3d40.0048652!4d-105.2767923', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (3, 1, 'tuesday', 'on', 'Escort', '10am and 2pm', 'UMC Fountains -> Theatre -> Koi pond/Hale -> Old Main -> Norlin Fountains -> REC -> Ralphie', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (4, 1, 'tuesday', 'off', 'Capture the flag', '6pm - 7pm', 'Scott Carpenter park', 'https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (5, 1, 'wednesday', 'on', 'Station controll', '11am - 5pm', 'Norlin quad, Farrand field', '', 'To control a station: \nHumans: Move bandanna above marked line\nZombies: Move bandanna below marked line\nFlags will be checked hourly and the score will be tracked.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (6, 1, 'wednesday', 'off', 'Scavenger hunt', '6pm - 7pm', 'Martin Park', 'https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520229,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (7, 1, 'thursday', 'on', 'Soccer defense', '2pm - 3pm', 'Soccer field by Wolf Law', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (8, 1, 'thursday', 'off', 'Transport', '6pm - 7pm', 'Harlow Platts Park', 'https://www.google.com/maps/place/Harlow+Platts+Community+Park/@39.9732298,-105.2512539,16.22z/data=!4m5!3m4!1s0x876bed11894519ef:0xece9795e891ae36e!8m2!3d39.9746374!4d-105.2486266', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (9, 1, 'friday', 'on', 'Data entry', '9am - 5pm', 'Rock with square hole', 'https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656', 'Enter your username into the data log for identification during extraction.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (10, 1, 'friday', 'off', 'Retrieval and evacuation', '6pm - 7pm', 'Chautauqua', 'https://www.google.com/maps/place/Chautauqua+Park/@39.9992037,-105.2836883,17z/data=!3m1!4b1!4m5!3m4!1s0x876bec4712c4dfc1:0x761597124a9e2eab!8m2!3d39.9991996!4d-105.2814996', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (11, 2, 'monday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Late registration, last minute waiver hand in, trick or treat and sign sheet');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (12, 2, 'monday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'Scavenger hunt for deely boppers* (Location - Will Vill fields)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (13, 2, 'tuesday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Take pictures in front of designated buildings on campus in their halloween costumes with bandanas clearly visible email pictures to us');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (14, 2, 'tuesday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'Have a mod be a “pumpkin person” and zombies have to collect pumpkins from around the park and bring them to the “pumpkin person” (Location - Beach Park)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (15, 2, 'wednesday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Escort “newsperson” mission  from: C4C to: UMC fountains middle stops: circle patch of grass outside the engineering center, Ralphie Buffalo statue, Norlin fountains, Rock statue with the loop, UMC fountains. (Head north and loop around CHEM to the UMC.)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (16, 2, 'wednesday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'half-priced halloween candy defend the supply drop escort mission (Location - Boulder Creek Path; start under Folsom St bridge)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (17, 2, 'thursday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'riddle mission, use words on lawn signs around campus (different phrases on each sign with one word capitalized). Potential reward: vaccine? Email the final phrase to a proxy email. We will then email out vaccine codes to first 5 or 10.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (18, 2, 'thursday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', '(Deely bopper reward) Humans have to rotate around 3 spots, carrying (heavy) object (or two) to reset timers that last 5mins? And object has to remain in human hands for humans to win. If the object passes to and remains with zombies at any point during the mission, humans lose. Also if 2 or more timers get fucked also if even one timer gets to 12 minutes zombies win (Location - Martin Park)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (19, 2, 'friday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Zombies must join hands in a giant circle around the patch of grass in the biking roundabout in front of the EC. If they surround the entire circle with unstunned zombies, they win, and get deely boppers for Chautauqua. If they cannot succeed at this within 45 minutes, humans win a shortened time for Chautauqua. Zombies may not enter the circle itself, but humans may.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (20, 2, 'friday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'Per tradition, the off-campus mission takes place at Chautauqua park. Before starting the game, any remaining Deely Boppers are distributed to the surviving humans. During the mission, if a zombie kills a human who is carrying deely-boppers, then the zombie gets those boppers and becomes a Special Infected. In order to win, humans must defend the gazebo from the zombies for the full 45 minutes. Zombies win by having SPECIAL INFECTED touching both main pillars of the gazebo simultaneously for a eight-count, or by killing all the humans. In this way, the humans must defend the gazebo from the Special Infected for the entire duration of the game. Note that if the zombies win the on-campus mission that day, then the Special Infected will have a stun timer of only 1 minute.\n\nSo, the humans and zombies arrive at the park. At 5:00, the zombies begin attacking the gazebo. If, at any point, at least two Special Infected enter the gazebo and are simultaneously touching the pillars for a full eight-count, then the humans lose and the weeklong ends.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (21, 3, 'monday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Between 10:00 and 4:00, humans must LINK[go here][https://goo.gl/maps/T3qu61iSeds], to the stone monument in the center of the little park,\nand sign their name to the list. By the time 4:00 rolls around, if 2/3 of the human population has not signed their name to the list, the zombies win. If there are enough signatures, then the humans win and receive the location of the first off-campus mission.\nIf the humans win - they will receive a hint to the code which gives them the location of the off-campus mission\nIf the zombies win - they will get that hint\n(This mission has essentially two purposes: It is easy, and can be accomplished by individuals without too much effort and in accordance with their schedule, while also giving them opportunities to see and interact with each other. It also reinforces the idea that humans are united in their goals.  At the same time, it also gives the OZs a much higher chance of finding humans to kill on that first day, since there will be high traffic through that one area. The humans will likely win the mission, but many of them will be tagged nonetheless.)');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (22, 3, 'monday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'The first off-campus mission will be at Martin Park. This is where we will introduce the deely-bopper game element, and humans will likely win this mission. There will be a single bopper, located at the far end of the park away from the street/bus stop. Humans will have to defend this single, stationary area from 5:00 to 5:45. If a zombie is able to grab the deely bopper (not just touch it, but physically grab it) then that zombie becomes a Special Infected and the humans lose the mission.\n\nIf the zombies win - Stun Timers for the next day will decrease by 1 minute.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (23, 3, 'tuesday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'For day two, humans must escort an NPC around campus, taking photos at major locations to demonstrate that there\'s no real zombie threat. The NPC will spawn in front of the C4C, and humans must take a photo of him at each of the three locations:\n- Standing in the fountain of the UMC\n- With the buffalo statue of the stadium in the background\n- In front of Old Main\n\nThe photos must contain at least three posed human players and NO ZOMBIES. Any photo with a zombie in it will be invalidated. Meanwhile, the zombies are trying to zombify the NPC. To zombify the NPC, at least one zombie must touch and maintain touch with the NPC for an out-loud count of five-mississippi. (the NPC, when initially touched, will freeze in horror.)\n\nIf the humans win - they will receive a clue to the day\'s code, OR, the zombie stun timer will be increased by one minute for the next day.\nIf the zombies win - they will receive a clue for the day\'s code, OR, the zombie stun timer will be decreased by one minute.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (24, 3, 'tuesday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'The second off-campus mission will be at LINK[Beach park][https://goo.gl/maps/9L62BGE9eFB2], and will feature two deely boppers, placed on opposite ends (northeast and southwest) of the small square park. As before, the humans are attempting to protect both deely boppers for the entire hour between 5:00 and 5:45. If one of the deely-boppers is taken during the mission, the zombie who took it has his spawn time lowered to 30 seconds.\n\nIf the humans are able to defend both points - The zombie stun timer is raised by one minute, and 10 vaccines will be distributed among the surviving human (maximum one per player.)\nFor each bopper the zombies are able to recover, the zombie stun timer is lowered by one minute for the next day.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (25, 3, 'wednesday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'Humans must collect twelve doodads (pictured below) which are planted across Norlin Quad.\nHumans will start at the stairs leading up to the front of Norlin.\nZombies will start at the opposite end of Norlin, near the Hale science building. Humans have an hour to gather all twelve doodads, but if any of them leave the rectangle of Norlin quad, they may not re-join the mission.\n\nIf humans win - they get a clue for that day\'s code, OR, they may raise the zombie stun timer by one minute.\nIf Zombies win - they get a clue for that day\'s code, OR, they may lower the zombie stun timer by one minute.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (26, 3, 'wednesday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'The third off-campus mission will be at LINK[Scott Carpenter park][https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038]. There will be three stationary deely-boppers to defend, one at the top of the hill to the Northwest (near the playground) one at the top of the hill to the Southwest, and one at the bottom of the hill to the East.\nAs before, humans will attempt to defend these three points until 5:45. Each time a deely-bopper is successfully taken by a zombie, that zombie\'s stun timer decreases by 45 seconds.\n\nIf the humans successfully defend all 3 deely boppers - the zombie stun timer is raised by one minute, and 10 vaccines are distributed among the surviving players (limit 1 each)\nFor each deely-bopper the zombies steal, the zombie stun-timer is lowered by one minute for the following day.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (27, 3, 'thursday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'For day four, humans will have to defend a certain number of zones of the soccer pitch near Smith dormitory. Humans will arrange themselves in the zones. If a zombie is able to pick up the cone in each of the zones, no humans may enter that zone, but they may leave it. In this way, as zombies overrun each zone, the humans flee and cannot return. A human who leaves the soccer pitch entirely is out of the game, but is not zombified.\n\nIn order to win, humans must defend at least 1/3 of the zones of the soccer pitch for 20 minutes (or more/less depending upon player turnout). Zombie stun timer during this event is also based on player turnout.\n\nIf the humans win - they can either get a clue for the day\'s code, OR they can increase the zombie stun timer by one minute for the next day.\nIf the zombies win - they can either get a clue for that day\'s code, OR they can lower the zombie stun timer for one minute for the following day.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (28, 3, 'thursday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'For day four, the humans must defend three deely boppers at Harlow Platts park. There will be two stationary deely boppers, and one which is being worn by an NPC. The NPC will circle the lake repeatedly for the 45 minutes. The other two deely boppers will be located at the Southwest and Northwest areas of the park (see map). If a zombie tags the NPC, that zombie gets the deely boppers and becomes a special infected.\n\nIf the humans successfully defend all 3 deely boppers - the zombie stun timer is raised by one minute, and 20 vaccines are distributed among the surviving players (limit 1 each)\nFor each deely-bopper the zombies steal, the zombie stun-timer is lowered by one minute for the following day.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (29, 3, 'friday', 'on', 'NULL', 'NULL', 'NULL', 'NULL', 'For the final on-campus mission, human players must make a human pyramid on Farrand field. Mods will mark out an area using the flag football cones near the center. The pyramid must be built within that area, must contain at least 10 players, and from the moment the 10th player is in the top spot, it must stand for a full 10 count (ten “mississippis”). Having achieved that, the humans win the mission, and are granted safe passage off of Farrand Field. If the pyramid is toppled, or is not built within the necessary time period, the zombies win.\n\nIf the humans win - they increase the zombie stun timer by one minute for the final mission.\nIf the zombies win - the final mission will have a stun timer of 3 minutes, not 5.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (30, 3, 'friday', 'off', 'NULL', 'NULL', 'NULL', 'NULL', 'Per tradition, the off-campus mission takes place at Chautauqua park. Before starting the game, any remaining Deely Boppers are distributed to the surviving humans. During the mission, if a zombie kills a human who is carrying deely-boppers, then the zombie gets those boppers and becomes a Special Infected. In order to win, humans must defend the gazebo from the zombies for the full 45 minutes. Zombies win by having SPECIAL INFECTED touching both main pillars of the gazebo simultaneously for a eight-count, or by killing all the humans. In this way, the humans must defend the gazebo from the Special Infected for the entire duration of the game. Note that if the zombies win the on-campus mission that day, then the Special Infected will have a stun timer of only 1 minute.\n\nSo, the humans and zombies arrive at the park. At 5:00, the zombies begin attacking the gazebo. If, at any point, at least two Special Infected enter the gazebo and are simultaneously touching the pillars for a full eight-count, then the humans lose and the weeklong ends.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (31, 4, 'monday', 'on', 'Late sign up, check in, bandanna retrieval', '9am - 5pm', 'UMC indoors', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (32, 4, 'monday', 'off', 'Capture the flag', '6pm - 7pm', 'Scott Carpenter park', 'https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (33, 4, 'tuesday', 'on', 'Selfie scavenger hunt', '9am - 5pm', 'Selfie locations', '/images/selfie_locations_S19.png', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (34, 4, 'tuesday', 'off', 'Scavenger hunt and king of the hill', '6pm - 7pm', 'Central park', 'https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (35, 4, 'wednesday', 'on', 'Soccer defense', '1:30pm', 'Wolf Law soccer fields', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (36, 4, 'wednesday', 'off', '3 legged humans survival', '6pm - 7pm', 'Beach park', 'https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (37, 4, 'thursday', 'on', 'Tower Control', '9am - 5pm', 'Station locations', '/images/control_tower_map.png', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (38, 4, 'thursday', 'off', 'Eggscort / Checkpoint', '6pm - 7pm', 'Martin Park', 'https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520229,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (39, 4, 'friday', 'on', 'Data entry', '9am - 5pm', 'Rock with square hole', 'https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656', 'Enter your username into the data log for identification during extraction.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (40, 4, 'friday', 'off', '', '', '', '', 'LINK_NEW_TAB[The story continues at the Ragnarok Lock-in.][https://www.eventbrite.com/e/cu-hvz-ragnarok-tickets-60309888500]');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (41, 5, 'monday', 'on', 'Late sign up', '9am - 5pm', 'UMC indoors', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (42, 5, 'monday', 'off', '', '', '', '', 'Canceled due to weather');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (43, 5, 'tuesday', 'on', 'Supply Drops', '9am - 5pm', '', '', 'One of these has been poisoned\nSign #10: 25 supplies\nSign #12: 25 supplies\nSign #15: 25 supplies\nSign #23: 25 supplies\nPoisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.\nLINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (44, 5, 'tuesday', 'off', 'Scavenger Hunt', '5pm', 'Central Park', 'https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274', 'Success: All humans alive at the end of the mission receive extra points\nFail: Zombie stun timer reduced by 1 minute');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (45, 5, 'wednesday', 'on', 'Selfies', '9am - 5pm', 'Selfie Picture Locations', '/images/selfie-pics.jpg', 'Total of 30 selfies must be submitted in order to complete the mission\nMission failure: Zombie stun timer reduced by 1 minute\nMission Rewards:\n1/4 correct selfies = 5 points\n2/4 correct selfies = 10 points\n3/4 correct selfies = 20 points\n4/4 correct selfies = 40 points\nBest voted selfie (with permission from player) will receive 10 bonus points.\nHow to submit selfies:- All selfies must be submitted at the same time along with your username and player code.\n- Selfies must be submitted to the photo-submissions chat on discord by 5pm.\n- Player must be clearly visible and recognizable in picture. Group pictures are fine as long as we can identify the player submitting the photos, so circle yourself in one of the selfies so we know it\'s you.\n- Submissions that are missing the username and player code will not be counted');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (46, 5, 'wednesday', 'off', 'Checkpoints', '5pm', 'Martin park', 'https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520282,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342', 'Attending players will receive 20 bonus points for attending and will have their hunger fed.\nMission failure: Zombie stun timer reduced by 1 minute');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (47, 5, 'thursday', 'on', 'Tower control', '9am - 5pm', 'Tower locations', '/images/control_tower_map.png', '- Towers are made of PVC and are leaned against trees\n- Towers will be checked every half an hour and updates will be posted on Discord\n- Stations will be checked every half hour and points recorded\n- Humans must move the bandana above the line- Zombies must move the bandana below the line\n- Humans must have more points than zombies to winMission failure: Zombie stun timer reduced by 1 minute');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (48, 5, 'thursday', 'off', 'Capture the Flag', '5pm', 'Scott Carpenter Park', 'https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0117331,-105.2570978,17z/data=!3m1!4b1!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038', 'Attending players will receive 20 bonus points for attending and will have their hunger fed.\nMission failure: Zombie stun timer reduced by 1 minute');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (49, 5, 'friday', 'on', 'Notebook', '9am - 5pm', 'Rock with square hole', 'https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656', '- Humans must write their username in the notebook\n- Players in the notebook will receive 50 points at the end of the day if they are still human\n- Username MUST be legible');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (50, 5, 'friday', 'off', 'Timed Defense', '5pm', 'Beach Park', 'https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923', 'Attending players will receive 30 bonus points for attending');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (51, 6, 'monday', 'on', 'Late sign up', '9am - 5pm', 'UMC indoors', '', '');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (52, 6, 'monday', 'off', 'Shrinking Zone Control', '5:30 pm', 'Beach Park', 'https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923', 'All players present receive 10 points and +6 hours on their starve timer');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (53, 6, 'tuesday', 'on', 'Soccer Defense', '1 pm', 'Kittredge Soccer Fields', '', 'All players present receive 10 points and +6 hours on their starve timer');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (54, 6, 'tuesday', 'off', 'Capture the flag', '5 pm', 'Scott Carpenter Park', 'https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0117331,-105.2570978,17z/data=!3m1!4b1!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038', 'All players present receive 10 points and +6 hours on their starve timer');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (55, 6, 'wednesday', 'on', 'Selfies', '9am - 5pm', 'Find them', '', 'Total of 16 selfies must be submitted in order to complete the mission\nMission failure: Zombie stun timer reduced by 1 minute\nMission Rewards:\n1/4 correct selfies = 5 points\n2/4 correct selfies = 10 points\n3/4 correct selfies = 20 points\n4/4 correct selfies = 40 points\nBest voted selfie (with permission from the player) will receive 10 bonus points.\nHow to submit selfies:\n- All selfies must be submitted at the same time along with your username and player code through Discord photo-submissions channel.\n- Selfies must be submitted to the photo-submissions chat on discord by 5 pm.\n- Player must be clearly visible and recognizable in the picture. Group pictures are fine as long as we can identify the player submitting the photos, so circle yourself in one of the selfies so we know it\'s you.\n- Submissions that are missing the username and player code will not be counted\nIMAGE[/images/selfies-spring2020.jpg]');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (56, 6, 'wednesday', 'off', 'King of the Hill', '5 pm', 'Central Park', 'https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274', 'All players present receive 10 points and +6 hours on their starve timer');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (57, 6, 'thursday', 'on', 'Tower defense', '9am - 5pm', 'Tower locations', '/images/control_tower_map.png', '- Towers are made of PVC and are leaned against trees\n- Towers will be checked every half an hour and updates will be posted on Discord\n- Stations will be checked every half hour and points recorded\n- Humans must move the bandana above the line- Zombies must move the bandana below the line\n- Humans must have more points than zombies to winMission failure: Zombie stun timer reduced by 1 minute');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (58, 6, 'thursday', 'off', 'Egg-scort', '5:30 pm', 'Martin park', 'https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520282,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342', 'All players present receive 10 points and +6 hours on their starve timer');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (59, 6, 'friday', 'on', '', '', '', '', 'Canceled\nDue to the rising risks of Covid-19 we have decided to cancel Friday\'s on and off-campus missions. Stay safe out there.');
INSERT INTO `CUHvZ`.`weeklong_missions` (`id`, `weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES (60, 6, 'friday', 'off', '', '', '', '', 'Canceled\nDue to the rising risks of Covid-19 we have decided to cancel Friday\'s on and off-campus missions. Stay safe out there.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`weeklong_players`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (1, 1, 69, '5674b', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (2, 1, 67, '967a5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (3, 1, 113, 'ffb6b', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (4, 1, 70, 'f8ed0', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (5, 1, 71, '25e69', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (6, 1, 72, '7ae7a', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (7, 1, 75, 'efee6', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (8, 1, 73, 'f75b1', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (9, 1, 74, 'cf90d', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (10, 1, 80, '1bfd1', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (11, 1, 81, 'fd71f', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (12, 1, 83, '4e887', 'normal', 'zombie', 0, 10, 1, '2018-09-29 22:55:00');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (13, 1, 85, '84400', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (14, 1, 87, '8067e', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (15, 1, 91, 'a6462', 'normal', 'zombie', 0, 35, 3, '2018-09-30 16:40:19');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (16, 1, 92, '5fb5d', 'normal', 'zombie', 0, 40, 0, '2018-09-29 01:10:41');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (17, 1, 93, 'd65d0', 'normal', 'zombie', 0, 20, 0, '2018-09-29 01:09:42');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (18, 1, 95, '1a0d8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (19, 1, 101, '003f8', 'normal', 'zombie', 0, 20, 4, '2018-09-30 14:56:50');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (20, 1, 104, '176c4', 'normal', 'zombie', 0, 20, 0, '2018-09-29 21:17:22');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (21, 1, 105, '81ede', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (22, 1, 99, 'c2760', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (23, 1, 1, 'a88b4', 'oz', 'zombie', 0, 10, 2, '2018-09-29 22:55:00');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (24, 1, 110, 'b235a', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (25, 1, 111, '0dc90', 'normal', 'zombie', 0, 45, 1, '2018-09-29 21:43:41');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (26, 1, 114, 'd1b6b', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (27, 1, 115, '7b7d4', 'normal', 'zombie', 0, 0, 0, '2018-09-30 14:56:50');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (28, 1, 116, '3eae9', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (29, 1, 118, '44de8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (30, 1, 119, 'f7031', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (31, 1, 28, 'db77a', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (32, 1, 120, '1a7a8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (33, 1, 123, '825e5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (34, 1, 124, 'cce86', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (35, 1, 125, '6a1c8', 'normal', 'zombie', 0, 0, 0, '2018-09-29 21:01:37');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (36, 1, 126, '164ea', 'normal', 'zombie', 0, 10, 2, '2018-09-30 20:34:00');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (37, 1, 127, '5bc04', 'normal', 'zombie', 0, 0, 0, '2018-09-30 20:34:00');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (38, 1, 121, 'a5d72', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (39, 1, 128, 'e3dcf', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (40, 1, 129, '611b3', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (41, 1, 131, 'd72c2', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (42, 1, 132, '9ec78', 'normal', 'zombie', 0, 10, 0, '2018-09-30 18:15:31');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (43, 1, 133, '80dd9', 'normal', 'zombie', 0, 20, 2, '2018-09-30 18:15:31');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (44, 1, 134, '72794', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (45, 1, 96, '4bed2', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (46, 1, 135, '4845a', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (47, 1, 136, '8feff', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (48, 1, 137, '574f5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (49, 1, 130, '9f839', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (50, 1, 140, 'a0aa4', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (51, 1, 94, 'a5575', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (52, 1, 106, '10fb1', 'normal', 'deceased', 0, 5, 1, '2018-09-26 17:14:16');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (53, 1, 142, '9b87e', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (54, 1, 147, '649ff', 'normal', 'zombie', 0, 45, 3, '2018-09-29 17:53:12');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (55, 1, 148, '965c3', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (56, 1, 149, '9e3f4', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (57, 1, 108, '03644', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (58, 1, 151, 'cdd7b', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (59, 1, 90, 'f379b', 'oz', 'zombie', 0, 30, 6, '2018-09-29 17:53:12');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (60, 1, 152, '68e11', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (61, 1, 153, '0a7b8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (62, 1, 155, 'ec280', 'normal', 'zombie', 0, 5, 1, '2018-09-30 19:35:27');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (63, 1, 158, '1085d', 'normal', 'zombie', 0, 5, 1, '2018-09-30 16:40:19');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (64, 1, 162, '85552', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (65, 1, 164, 'e524f', 'normal', 'zombie', 0, 0, 0, '2018-09-29 16:25:01');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (66, 1, 165, '01dc6', 'normal', 'zombie', 0, 0, 0, '2018-09-29 21:52:32');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (67, 1, 171, '37f6d', 'normal', 'zombie', 0, 20, 0, '2018-09-30 16:17:58');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (68, 1, 172, 'db707', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (69, 1, 174, '602ad', 'normal', 'zombie', 0, 0, 0, '2018-09-29 17:58:44');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (70, 1, 176, '62dd0', 'normal', 'zombie', 0, 10, 2, '2018-09-29 01:12:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (71, 1, 177, '885c8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (72, 1, 63, '26e3d', 'normal', 'zombie', 0, 30, 2, '2018-09-29 17:53:12');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (73, 1, 88, '98778', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (74, 1, 178, '8e04d', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (75, 1, 144, '3d601', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (76, 1, 179, 'b219c', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (77, 1, 157, '3579b', 'normal', 'zombie', 0, 0, 0, '2018-09-30 16:40:19');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (78, 1, 156, 'a9fa2', 'normal', 'zombie', 0, 15, 1, '2018-09-29 21:56:53');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (79, 1, 180, '3ecfe', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (80, 1, 181, '8c128', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (81, 1, 98, '4379f', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (82, 1, 182, 'e9b21', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (83, 1, 183, 'b3034', 'normal', 'zombie', 0, 0, 0, '2018-09-29 01:12:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (84, 1, 186, '141ff', 'normal', 'zombie', 0, 15, 1, '2018-09-30 18:15:31');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (85, 1, 188, '25ef0', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (86, 1, 190, 'a8c2f', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (87, 1, 189, 'c31da', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (88, 1, 191, '7ce62', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (89, 1, 192, '51cb5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (90, 1, 163, 'b743d', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (91, 1, 193, '885a3', 'normal', 'zombie', 0, 0, 0, '2018-09-29 21:52:32');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (92, 1, 194, 'c88b0', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (93, 1, 195, 'db0a9', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (94, 1, 202, 'f472a', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (95, 1, 200, '489b3', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (96, 1, 203, '1e969', 'normal', 'zombie', 0, 0, 0, '2018-09-30 18:15:31');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (97, 1, 204, 'd528e', 'normal', 'zombie', 0, 56, 0, '2018-09-29 21:01:37');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (98, 1, 112, '08408', 'normal', 'zombie', 0, 0, 0, '2018-09-29 21:52:32');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (99, 1, 206, '90fcc', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (100, 1, 198, 'd6307', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (101, 1, 76, '4df84', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (102, 1, 208, 'd9553', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (103, 1, 211, 'fa72f', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (104, 1, 210, 'dc454', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (105, 1, 212, '9b8b5', 'normal', 'zombie', 0, 0, 0, '2018-09-30 19:35:27');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (106, 1, 209, '2e71f', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (107, 1, 214, '760f8', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (108, 1, 215, 'e28c4', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (109, 1, 201, '87d45', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (110, 1, 159, '2adda', 'normal', 'zombie', 0, 0, 0, '2018-09-30 16:17:58');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (111, 1, 216, '1e6db', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (112, 1, 217, '5e4be', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (113, 1, 218, '9e835', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (114, 1, 219, '80a5b', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (115, 1, 220, '442a7', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (116, 1, 221, '5f748', 'normal', 'zombie', 0, 0, 0, '2018-09-29 17:53:12');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (117, 1, 222, 'd596e', 'oz', 'zombie', 0, 0, 0, '2018-09-29 21:01:37');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (118, 1, 223, 'cefbd', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (119, 1, 224, '2bdc5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (120, 1, 227, 'ce3c5', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (121, 1, 232, '5c597', 'normal', 'human', 0, 0, 0, NULL);
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (122, 4, 174, 'acc50', 'oz', 'zombie', 0, 160, 1, '2019-04-20 10:35:30');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (123, 4, 1, 'df563', 'oz', 'zombie', 0, 230, 3, '2019-04-20 14:16:42');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (124, 4, 234, '4ecaa', 'normal', 'zombie', 0, 195, 1, '2019-04-20 10:47:38');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (125, 4, 133, 'f6552', 'normal', 'zombie', 0, 230, 3, '2019-04-20 13:42:35');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (126, 4, 275, '2fbff', 'normal', 'zombie', 0, 70, 1, '2019-04-20 09:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (127, 4, 83, 'da808', 'normal', 'zombie', 0, 70, 0, '2019-04-20 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (128, 4, 239, '4cddd', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (129, 4, 276, 'ba674', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (130, 4, 101, '0528d', 'inactive', 'deceased', 0, 0, 0, '2019-04-18 03:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (131, 4, 58, 'd93de', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (132, 4, 132, 'd88e9', 'normal', 'zombie', 0, 270, 6, '2019-04-20 15:00:34');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (133, 4, 64, 'fd1ee', 'normal', 'zombie', 0, 230, 0, '2019-04-20 15:18:42');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (134, 4, 249, 'b1d46', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (135, 4, 90, 'f403a', 'oz', 'zombie', 0, 295, 5, '2019-04-20 15:19:50');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (136, 4, 171, '3acb0', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (137, 4, 63, '463bb', 'normal', 'zombie', 0, 185, 1, '2019-04-20 16:23:06');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (138, 4, 279, 'df377', 'normal', 'human', 0, 185, 0, '2019-04-20 14:42:25');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (139, 4, 280, '52a3a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (140, 4, 281, '4c5dd', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (141, 4, 282, '01ccc', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (142, 4, 285, '1d23a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (143, 4, 286, '1939d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (144, 4, 287, 'ecd38', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (145, 4, 288, '8f06e', 'inactive', 'deceased', 0, 0, 0, '2019-04-18 03:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (146, 4, 289, '697f4', 'oz', 'deceased', 0, 50, 0, '2019-04-19 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (147, 4, 290, '704e5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (148, 4, 291, '34282', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (149, 4, 292, '0869b', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (150, 4, 293, 'e53e4', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (151, 4, 294, 'ae1bd', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (152, 4, 295, '6c1b5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (153, 4, 177, '7ab0c', 'inactive', 'deceased', 0, 0, 0, '2019-04-18 03:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (154, 4, 296, 'ef0af', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (155, 4, 127, '348cf', 'normal', 'zombie', 0, 70, 1, '2019-04-20 18:07:42');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (156, 4, 298, '8b4c1', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (157, 4, 299, 'bf054', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (158, 4, 88, 'c67e5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (159, 4, 300, '2e107', 'normal', 'human', 0, 75, 0, '2019-04-20 13:23:30');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (160, 4, 278, 'f758d', 'normal', 'deceased', 0, 50, 0, '2019-04-18 09:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (161, 4, 305, 'f086e', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (162, 4, 306, '132cd', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (163, 4, 304, '946a7', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (164, 4, 307, '5cd85', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (165, 4, 309, '0303e', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (166, 4, 315, 'c60da', 'starved', 'deceased', 0, 10, 0, '2019-04-19 15:00:18');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (167, 4, 316, 'ea29e', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (168, 4, 317, '6fedb', 'normal', 'deceased', 0, 25, 1, '2019-04-18 10:35:57');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (169, 4, 318, 'bd982', 'inactive', 'deceased', 0, 0, 0, '2019-04-18 05:31:05');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (170, 4, 349, 'd2f2a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (171, 4, 319, 'c77c0', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (172, 4, 405, '6cae9', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (173, 4, 321, '4160a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (174, 4, 186, '3f29e', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (175, 4, 322, '03d3d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (176, 4, 144, 'c439c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (177, 4, 324, '17e4d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (178, 4, 326, 'ee291', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (179, 4, 329, 'a9db5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (180, 4, 331, '07aea', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (181, 4, 330, 'fe22b', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (182, 4, 332, 'a88e6', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (183, 4, 333, '54aef', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (184, 4, 334, '30582', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (185, 4, 335, '37e22', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (186, 4, 336, 'b0be5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (187, 4, 337, '82fca', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (188, 4, 338, 'b3d7d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (189, 4, 339, '1ebe4', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (190, 4, 340, 'e5497', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (191, 4, 341, '4c396', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (192, 4, 61, 'eecc3', 'normal', 'zombie', 0, 90, 1, '2019-04-21 03:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (193, 4, 342, '797d5', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (194, 4, 344, 'aaf69', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (195, 4, 345, '122f2', 'normal', 'deceased', 0, 10, 1, '2019-04-18 07:57:45');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (196, 4, 346, 'fa391', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (197, 4, 347, '1bba3', 'starved', 'deceased', 0, 10, 0, '2019-04-19 15:00:18');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (198, 4, 350, '39676', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (199, 4, 351, 'eac91', 'normal', 'zombie', 0, 225, 0, '2019-04-20 13:35:54');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (200, 4, 352, 'af535', 'normal', 'zombie', 0, 175, 0, '2019-04-20 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (201, 4, 241, '93ee1', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (202, 4, 111, '92b72', 'oz', 'deceased', 0, 50, 0, '2019-04-18 06:09:31');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (203, 4, 354, '1533d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (204, 4, 356, '5db85', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (205, 4, 357, '0728b', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (206, 4, 358, 'c4474', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (207, 4, 360, '6286b', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (208, 4, 235, '0d5e9', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (209, 4, 372, 'de21c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (210, 4, 373, '38477', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (211, 4, 375, '24ac1', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (212, 4, 116, '903b3', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (213, 4, 374, '06996', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (214, 4, 376, '40386', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (215, 4, 377, '14a9a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (216, 4, 378, '026b6', 'normal', 'deceased', 0, 15, 0, '2019-04-18 10:41:34');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (217, 4, 380, 'cbebe', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (218, 4, 379, '4a2a4', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (219, 4, 383, '8c12b', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (220, 4, 384, '80a1a', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (221, 4, 387, 'b561f', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (222, 4, 389, 'ad435', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (223, 4, 390, '7f6fd', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (224, 4, 391, 'e08e7', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (225, 4, 348, '60d95', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (226, 4, 392, 'f449d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (227, 4, 393, 'dbd1c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (228, 4, 397, '40429', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (229, 4, 399, 'bd339', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (230, 4, 400, 'd6577', 'normal', 'deceased', 0, 20, 0, '2019-04-19 14:32:58');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (231, 4, 402, 'dd222', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (232, 4, 404, 'b569d', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (233, 4, 314, '2a8a3', 'normal', 'human', 0, 120, 0, '2019-04-20 13:21:40');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (234, 4, 407, '74db0', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (235, 4, 301, '75c7c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (236, 4, 408, '9ad0e', 'normal', 'zombie', 0, 120, 0, '2019-04-20 15:05:41');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (237, 4, 156, '63448', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (238, 4, 409, 'd8029', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (239, 4, 410, 'd3965', 'normal', 'deceased', 0, 10, 0, '2019-04-18 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (240, 4, 411, 'f63f0', 'normal', 'zombie', 0, 20, 2, '2019-04-20 04:54:32');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (241, 4, 412, '348fa', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (242, 4, 106, '678c6', 'suicide', 'deceased', 0, 5, 0, '2019-04-18 11:21:58');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (243, 4, 413, 'cc9ab', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (244, 4, 415, '51a0c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (245, 4, 416, '90c70', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (246, 4, 117, 'f948c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (247, 4, 417, '430b6', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 15:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (248, 4, 418, '3fd3f', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 17:42:20');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (249, 4, 308, 'b8850', 'normal', 'human', 0, 255, 0, '2019-04-20 14:46:20');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (250, 4, 420, '9f8bf', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 17:59:27');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (251, 4, 91, '238ac', 'normal', 'deceased', 0, 55, 1, '2019-04-19 04:38:45');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (252, 4, 421, '1a8a1', 'normal', 'deceased', 0, 15, 0, '2019-04-18 06:05:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (253, 4, 422, 'ff5c4', 'inactive', 'deceased', 0, 0, 0, '2019-04-18 06:08:47');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (254, 4, 424, 'c6663', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 19:07:33');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (255, 4, 425, '3430f', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 19:09:50');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (256, 4, 365, '8de7e', 'normal', 'deceased', 0, 15, 0, '2019-04-18 10:41:29');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (257, 4, 426, 'ec098', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 20:14:36');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (258, 4, 364, 'c7c58', 'normal', 'deceased', 0, 15, 0, '2019-04-18 08:29:43');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (259, 4, 427, 'dc443', 'normal', 'zombie', 0, 100, 1, '2019-04-21 13:51:39');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (260, 4, 367, 'f2fbc', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 20:39:40');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (261, 4, 430, '3210f', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 21:03:35');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (262, 4, 363, '5804c', 'inactive', 'deceased', 0, 0, 0, '2019-04-17 23:30:55');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (263, 4, 438, '33ea1', 'normal', 'zombie', 0, 0, 0, '2019-04-20 06:52:19');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (264, 5, 1, 'be3e0', 'oz', 'zombie', 0, 142, 2, '2019-11-17 16:10:09');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (265, 5, 174, '48c21', 'normal', 'zombie', 0, 42, 0, '2019-11-16 16:10:25');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (266, 5, 83, '42d3d', 'normal', 'human', 0, 190, 0, '2019-11-17 15:40:33');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (267, 5, 439, '5ff5c', 'normal', 'zombie', 0, 95, 0, '2019-11-16 17:15:44');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (268, 5, 101, '9c23b', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (269, 5, 116, '25af0', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (270, 5, 111, 'f7d96', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (271, 5, 479, '9b1b5', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (272, 5, 460, 'dd30d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (273, 5, 45, '56db2', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (274, 5, 133, '93295', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (275, 5, 327, '8ce01', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (276, 5, 122, '9cf06', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (277, 5, 480, '26841', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (278, 5, 90, '95573', 'oz', 'deceased', 0, 68, 1, '2019-11-15 16:48:24');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (279, 5, 481, '6a81d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (280, 5, 482, '8f180', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (281, 5, 427, 'a55c8', 'normal', 'zombie', 0, 32, 0, '2019-11-16 00:14:51');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (282, 5, 276, '642c4', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (283, 5, 483, '3706b', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (284, 5, 484, '74e04', 'normal', 'human', 0, 30, 0, '2019-11-16 17:50:27');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (285, 5, 88, '9a018', 'oz', 'deceased', 0, 50, 0, '2019-11-15 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (286, 5, 485, '7e85d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (287, 5, 486, '92404', 'oz', 'deceased', 0, 50, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (288, 5, 487, '5d07c', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (289, 5, 488, '0503c', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (290, 5, 489, 'dfd50', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (291, 5, 257, '16228', 'normal', 'human', 0, 130, 0, '2019-11-16 18:48:28');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (292, 5, 490, '33c84', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (293, 5, 132, 'a1987', 'oz', 'zombie', 0, 78, 2, '2019-11-16 04:48:24');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (294, 5, 279, '727d1', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (295, 5, 491, '2df6d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (296, 5, 494, '49e6a', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (297, 5, 495, '4af8b', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (298, 5, 497, '23624', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (299, 5, 498, 'c9987', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (300, 5, 499, 'da879', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (301, 5, 500, '3c805', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (302, 5, 501, '40d11', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (303, 5, 502, '8b3a9', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (304, 5, 503, '5a369', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (305, 5, 504, '65662', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (306, 5, 505, '643b5', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (307, 5, 506, 'd2782', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (308, 5, 507, '311fc', 'oz', 'deceased', 0, 50, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (309, 5, 508, '5feba', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (310, 5, 509, '543db', 'starved', 'deceased', 0, 30, 0, '2019-11-15 18:37:57');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (311, 5, 510, 'dcb37', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (312, 5, 511, '16aac', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (313, 5, 512, '048e5', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (314, 5, 514, '8faa8', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (315, 5, 515, '12d83', 'normal', 'deceased', 0, 18, 0, '2019-11-15 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (316, 5, 64, '8402f', 'normal', 'human', 0, 20, 0, '2019-11-16 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (317, 5, 516, '52e74', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (318, 5, 517, '28a8c', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (319, 5, 518, '0cbae', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (320, 5, 519, '8c761', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (321, 5, 520, '4ad4d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (322, 5, 521, '41dd9', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (323, 5, 522, 'fa259', 'normal', 'zombie', 0, 164, 7, '2019-11-17 17:00:13');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (324, 5, 524, '79306', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (325, 5, 523, '04992', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (326, 5, 525, '7691d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (327, 5, 526, '04a71', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (328, 5, 278, '6386b', 'starved', 'deceased', 0, 10, 0, '2019-11-15 14:05:11');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (329, 5, 527, '9859b', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (330, 5, 528, 'a4d71', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (331, 5, 529, 'b5a78', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (332, 5, 411, 'b78ff', 'normal', 'zombie', 0, 80, 0, '2019-11-16 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (333, 5, 530, 'e5d11', 'normal', 'zombie', 0, 54, 0, '2019-11-16 08:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (334, 5, 531, '7908e', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (335, 5, 532, '36fce', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (336, 5, 533, '83857', 'oz', 'deceased', 0, 50, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (337, 5, 534, '03453', 'oz', 'deceased', 0, 50, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (338, 5, 100, '21719', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (339, 5, 535, '0077a', 'oz', 'zombie', 0, 66, 0, '2019-11-16 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (340, 5, 536, '308c4', 'oz', 'deceased', 0, 60, 1, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (341, 5, 537, '616b9', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (342, 5, 538, 'fabb8', 'oz', 'deceased', 0, 50, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (343, 5, 539, '8277c', 'oz', 'deceased', 0, 50, 0, '2019-11-14 02:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (344, 5, 540, '62344', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (345, 5, 541, '2971d', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (346, 5, 542, '82359', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (347, 5, 544, 'dd055', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (348, 5, 63, '00226', 'normal', 'human', 0, 155, 0, '2019-11-16 17:12:25');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (349, 5, 234, 'c9242', 'normal', 'zombie', 0, 70, 0, '2019-11-16 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (350, 5, 545, '4d799', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (351, 5, 546, '48a60', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (352, 5, 548, 'e6120', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (353, 5, 549, '95420', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (354, 5, 171, 'fb0de', 'starved', 'zombie', 0, 25, 0, '2019-11-16 17:50:03');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (355, 5, 408, 'f44fe', 'normal', 'human', 0, 295, 0, '2019-11-17 21:30:38');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (356, 5, 551, '9739e', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (357, 5, 552, '2eb2e', 'inactive', 'deceased', 0, 0, 0, '2019-11-14 14:00:08');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (358, 5, 553, '4bf68', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 15:16:32');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (359, 5, 554, 'df701', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 15:59:33');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (360, 5, 555, 'a563e', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 17:02:51');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (361, 5, 324, '744a3', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 17:04:45');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (362, 5, 556, '98b9b', 'normal', 'zombie', 0, 103, 0, '2019-11-16 21:38:05');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (363, 5, 557, '83f45', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 17:49:25');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (364, 5, 558, '04f45', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 18:34:17');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (365, 5, 296, '0355d', 'normal', 'zombie', 0, 80, 0, '2019-11-16 03:58:25');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (366, 5, 561, '5c70d', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 19:19:38');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (367, 5, 562, 'bb556', 'inactive', 'deceased', 0, 0, 0, '2019-11-13 20:57:27');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (368, 6, 1, '6ab20', 'oz', 'zombie', 0, 110, 1, '2020-03-14 16:43:42');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (369, 6, 586, '16e8d', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (370, 6, 587, '00ff1', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (371, 6, 133, 'b72ad', 'normal', 'deceased', 0, 8, 0, '2020-03-12 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (372, 6, 588, '27fbf', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (373, 6, 589, '82ec2', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (374, 6, 590, '1007a', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (375, 6, 239, 'a52be', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (376, 6, 591, '0645c', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (377, 6, 556, '7c752', 'starved', 'zombie', 0, 42, 0, '2020-03-14 10:20:28');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (378, 6, 592, '0757a', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (379, 6, 375, 'd7bb8', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (380, 6, 593, 'f5d0b', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (381, 6, 490, 'fb51c', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (382, 6, 174, '3640c', 'normal', 'deceased', 0, 20, 0, '2020-03-12 21:30:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (383, 6, 234, '121ea', 'oz', 'zombie', 0, 108, 0, '2020-03-13 21:17:10');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (384, 6, 90, '956ad', 'normal', 'human', 0, 150, 0, '2020-03-14 20:02:17');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (385, 6, 596, 'f675d', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (386, 6, 597, 'd33c1', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (387, 6, 598, 'cac41', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (388, 6, 296, '3fffc', 'normal', 'human', 0, 80, 0, '2020-03-13 16:55:05');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (389, 6, 599, 'e37a3', 'starved', 'deceased', 0, 20, 0, '2020-03-13 13:46:59');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (390, 6, 354, 'b0108', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (391, 6, 601, 'e6ae5', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (392, 6, 439, 'fb5da', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (393, 6, 602, 'e451a', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (394, 6, 279, 'c686e', 'starved', 'zombie', 0, 15, 0, '2020-03-13 19:52:14');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (395, 6, 603, 'fb086', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (396, 6, 604, '757f1', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (397, 6, 605, '70c82', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (398, 6, 606, '6735e', 'starved', 'deceased', 0, 10, 0, '2020-03-13 13:04:38');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (399, 6, 607, '7ee53', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (400, 6, 608, '60432', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (401, 6, 132, 'f8d29', 'oz', 'zombie', 0, 74, 1, '2020-03-13 23:59:29');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (402, 6, 609, 'b4272', 'suicide', 'deceased', 0, 18, 1, '2020-03-13 08:14:41');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (403, 6, 610, 'c2397', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (404, 6, 611, '02dd0', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (405, 6, 612, '88ed5', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (406, 6, 613, '7ac98', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (407, 6, 171, '2cff5', 'normal', 'human', 0, 50, 0, '2020-03-14 19:53:23');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (408, 6, 614, '414f4', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (409, 6, 615, 'b48e4', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (410, 6, 616, '3aba8', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (411, 6, 617, 'f0303', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (412, 6, 618, 'fcc56', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (413, 6, 619, '887e1', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (414, 6, 620, 'fb82f', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (415, 6, 101, 'd92f3', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (416, 6, 621, '97687', 'normal', 'human', 0, 120, 0, '2020-03-14 16:43:52');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (417, 6, 83, 'f2fdc', 'suicide', 'zombie', 0, 22, 0, '2020-03-13 21:17:09');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (418, 6, 622, '6621c', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (419, 6, 623, '1a981', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (420, 6, 624, 'f96c7', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (421, 6, 625, '601ad', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 13:01:26');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (422, 6, 408, '39d32', 'normal', 'human', 0, 70, 0, '2020-03-14 15:31:30');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (423, 6, 257, '843ef', 'starved', 'zombie', 0, 40, 0, '2020-03-14 14:17:16');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (424, 6, 530, 'ee230', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 18:12:01');
INSERT INTO `CUHvZ`.`weeklong_players` (`id`, `weeklong_id`, `user_id`, `player_code`, `type`, `status`, `poisoned`, `points`, `kills`, `starve_date`) VALUES (425, 6, 628, 'e6b2a', 'inactive', 'deceased', 0, 0, 0, '2020-03-11 19:49:39');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`activity`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`activity` (`id`, `weeklong_id`, `user1_id`, `user2_id`, `action`, `desciption`, `time_logged`) VALUES (1, 1, 106, NULL, 'starved', 'died of starvation', '2018-09-26 11:14:00');
INSERT INTO `CUHvZ`.`activity` (`id`, `weeklong_id`, `user1_id`, `user2_id`, `action`, `desciption`, `time_logged`) VALUES (2, 1, 90, 132, 'zombified', 'ate', '2018-09-24 10:16:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CUHvZ`.`time_offset`
-- -----------------------------------------------------
START TRANSACTION;
USE `CUHvZ`;
INSERT INTO `CUHvZ`.`time_offset` (`id`, `offset`) VALUES (1, 0);

COMMIT;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE `CUHvZ`;

DELIMITER $$

USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`users_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
INSERT INTO CUHvZ.user_details (id, join_date) VALUES (NEW.id, DATE_ADD(NOW(), INTERVAL (select offset from CUHvZ.time_offset where id=1) HOUR));
INSERT INTO CUHvZ.subscriptions (id) VALUES (NEW.id);
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`users_BEFORE_DELETE` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`users_BEFORE_DELETE` BEFORE DELETE ON `users` FOR EACH ROW
BEGIN
delete from subscriptions where id=OLD.id;
delete from user_details where id=OLD.id;
delete from tokens where user_id=OLD.id;
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`tokens_AFTER_DELETE` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`tokens_AFTER_DELETE` AFTER DELETE ON `tokens` FOR EACH ROW
BEGIN
INSERT INTO CUHvZ.used_tokens (id, user_id, token, type, time_used) VALUES (OLD.id, OLD.user_id, OLD.token, OLD.type, DATE_ADD(NOW(), INTERVAL (select offset from CUHvZ.time_offset where id=1) HOUR));
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`lockins_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`lockins_AFTER_INSERT` AFTER INSERT ON `lockins` FOR EACH ROW
BEGIN
INSERT INTO lockin_text (id) VALUES (LAST_INSERT_ID());
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`weeklongs_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`weeklongs_AFTER_INSERT` AFTER INSERT ON `weeklongs` FOR EACH ROW
BEGIN
INSERT INTO weeklong_details (id) VALUES (LAST_INSERT_ID());
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`weeklongs_BEFORE_DELETE` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`weeklongs_BEFORE_DELETE` BEFORE DELETE ON `weeklongs` FOR EACH ROW
BEGIN
delete from weeklong_details where id=OLD.id;
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`activity_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`activity_AFTER_INSERT` AFTER INSERT ON `activity` FOR EACH ROW
BEGIN
IF (NEW.time_logged IS NULL OR NEW.time_logged = '') THEN
	UPDATE activity set time_logged=(DATE_ADD(NOW(), INTERVAL (select offset from time_offset where id=1) HOUR)) where id=NEW.id;
END IF;
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`codes_BEFORE_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`codes_BEFORE_INSERT` BEFORE INSERT ON `codes` FOR EACH ROW
BEGIN
SET NEW.num_uses = NEW.max_uses;
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`used_codes_BEFORE_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`used_codes_BEFORE_INSERT` BEFORE INSERT ON `used_codes` FOR EACH ROW
BEGIN
SET NEW.time_used = DATE_ADD(NOW(), INTERVAL (select offset from date_offset where id=1) HOUR);
END$$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`used_codes_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`used_codes_AFTER_INSERT` AFTER INSERT ON `used_codes` FOR EACH ROW
BEGIN
UPDATE codes
SET num_uses = num_uses - 1
WHERE id = NEW.id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
