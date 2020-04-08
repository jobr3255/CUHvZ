-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS `CUHvZ`;

GRANT ALL PRIVILEGES ON CUHvZ.* TO 'hvz'@'localhost' IDENTIFIED BY 'password';
-- -----------------------------------------------------
-- Schema CUHvZ
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CUHvZ` DEFAULT CHARACTER SET utf8 ;
USE `CUHvZ` ;

-- These tables need to be dropped before the users table can be dropped
DROP TABLE IF EXISTS `CUHvZ`.`tokens` ;
DROP TABLE IF EXISTS `CUHvZ`.`activity` ;
DROP TABLE IF EXISTS `CUHvZ`.`supply_drops` ;
DROP TABLE IF EXISTS `CUHvZ`.`used_codes` ;
DROP TABLE IF EXISTS `CUHvZ`.`codes` ;
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_players` ;
DROP TABLE IF EXISTS `CUHvZ`.`subscriptions` ;
DROP TABLE IF EXISTS `CUHvZ`.`user_details` ;
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
  `phone` varchar(12) DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `clearance` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`user_details`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `CUHvZ`.`user_details` (
  `id` INT NOT NULL,
  `join_date` DATE NULL,
  `activated` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_details`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `CUHvZ`.`subsriptions`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `CUHvZ`.`subscriptions` (
  `id` INT NOT NULL,
  `weeklong` TINYINT(1) NOT NULL DEFAULT 1,
  `lockin` TINYINT(1) NOT NULL DEFAULT 1,
  `general` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_subscriptions`
    FOREIGN KEY (`id`)
    REFERENCES `CUHvZ`.`users` (`id`)
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

INSERT INTO `time_offset` (`id`, `offset`) VALUES (1, 0);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `CUHvZ`;

DELIMITER $$

USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`users_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
INSERT INTO subscriptions (id) VALUES (NEW.id);
END$$


DELIMITER ;


INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `phone`, `clearance`) VALUES
(1, 'LegendaryCrypt', 'Josh', 'Brown', 'jobr3255@colorado.edu', '$2y$10$I8/LQM3KB7190xHKYWTaKemyj7UY/RVNK77PMVmX7L.kIY4H1.yMq', '3038191330', 1),
(28, 'LilBisch', 'Devon', 'Ricken', 'devonr363@gmail.com', '$2y$10$GmkbWv6xdfEGjHM15vFXDON9qy4fpVK/azdx9DN/mdOLwXASyh4q2', '7202997200', 0),
(29, 'ghost', 'Blair', 'Harris', 'scarley.harris@gmail.com', '$2y$10$FuwGzxZzBOF4j7QxFzt7/eU6KP8I3jaJp4.6rNqLNVSSo2LuGmiGC', '7192170839', 0),
(31, 'NerdyDruid', 'Colleen', 'Feuerborn', 'colleenrfeuerborn@gmail.com', '$2y$10$1B1g2xTsVW.ljmXdBLexfeg23aT/KY8tSwJ4a8yIZpqt8LW2TiFc6', '7203276770', 0),
(32, 'lucasmcmahon', 'Lucas', 'McMahon', 'lucas.mcmahon@live.com', '$2y$10$ANrLIOPzla4x4pscPZQBn.tDLZCx2NNr9q6ag5d.7vUaTT7osC1XK', NULL, 0),
(33, 'BSnow', 'Ben', 'Cialone', 'cialonebenjamin@gmail.com', '$2y$10$Wqepp4I0D1epqJ3lNcNZu.pnLjXTkC.D7rvRaCI0RZfBezaCX.3PO', '7203121951', 0),
(34, 'Xray009', 'Christian ', 'Wills', 'xray009@live.com', '$2y$10$77rN/D2kHmHJpxFfF4YyLu4WL0KODr7UYKmdI4dCVa4phLJqcqX5y', '7203843510', 0),
(35, 'MCRN-Combat-Epidemiologist', 'Michael', 'Martinson', 'michael.martinson@colorado.edu', '$2y$10$Oc6zkm8hzQ335JWinyHDUehCG/CzP4EQqpNmeG8EO/pehaMoiLAwy', '8058361018', 0),
(36, 'JoelCourtney', 'Joel', 'Courtney', 'joel.e.courtney@gmail.com', '$2y$10$0d9XR8U/UaTo/w0X.M88feFhjOQ8pbAhflxpd.ykqnqGpQ.OKqkHK', '7205396135', 0),
(37, 'elco3300', 'Elizabeth', 'Cohn', 'elco3300@colorado.edu', '$2y$10$0IUZUAhfLDz2NpZP3yT22eNxAefnKLlPnJFRmSsOHVchizW8hdSXu', '7133677675', 0),
(38, 'Arete13', 'Zane', 'Brink', 'zabr8997@colorado.edu', '$2y$10$yWHGciGRf2abY.skY1wCS.1WLDmwqNxDzwT1m99ocl.uGq8r31Z/C', '7195881624', 0),
(39, 'natkosacki', 'nat', 'kosacki', 'kosacki12@gmail.com', '$2y$10$.YJ8e0mJDUpirCq5cuUL6uiTMZToxIHW0K/deL2sbHKKwFzPZEvbO', '7196443621', 0),
(40, 'lilbitch', 'yash', 'kothamdi', 'yako4377@colorado.edu', '$2y$10$O2o6VtKmirRJFgHaFcS9COLKowlSeF50HXOUJ5B5zjyaTH.dNzEQi', '9708897290', 0),
(41, 'bryce.renner', 'Bryce', 'Renner', 'Bryce.Renner@Colorado.edu', '$2y$10$EKul/aU0XXJcfgCtYv5xmOY/D0b7U5sOPaRMQRptSgN4Tz6eBwhwS', '7193376800', 0),
(42, 'Saotorii', 'Matthew', 'MacKenna', 'albatross245@gmail.com', '$2y$10$e68gVLeHupGYeHbM9fmJYe4GBLnU48OYaBlOfOiDU7b0Hf9OlgUYa', '9704029483', 0),
(43, 'AustinA24', 'Austin', 'Anderson', 'auan4697@colorado.edu', '$2y$10$blOUBt/bUhepZPvlHV5BYO/5uFhdLEvBL/qX3yE13bPBSWVfhSvUa', '7029941308', 0),
(44, 'rast1447', 'Callan', 'Stone', 'rast1447@colorado.edu', '$2y$10$uve9AbLyfsz0oUKZcGZdp.Eo7eBJ2j5jzs2QTwo333YPJ3LE2gc7.', '7202095351', 0),
(45, 'RikuDarkWielder', 'MATTHEW', 'BRAND', 'mklb492@gmail.com', '$2y$10$D88F4m/H2HxP2XtuIvZpLeYsCVEBUycDcmh1dGYsy8cfiJRvNfCc.', '8165185131', 0),
(46, 'A-dingus', 'Adam', 'Bloom', 'Adam.bloom3@gmail.com', '$2y$10$svEyMgd92YFXrEIUzQeW.eKh0mJTCU93OBcS/P5JY9mWv88jlAXLO', '3038182106', 0),
(47, 'arkatheia', 'Jennifer', 'Alexia', 'jahy3427@colorado.edu', '$2y$10$azvjV.hlSJAW.HK6dwA/g.Z3dxDqVhp19JAG4rqrdddKkgT7VPMBe', '4107087636', 0),
(48, 'Nobody', 'AKASH', 'GAONKAR', 'akashgaonkar@gmail.com', '$2y$10$w3r.Plnlm1hWIo7R7NWWueGmucV/cZDtrlLn4dskvKLk9rKmlqZju', '7208771505', 0),
(49, 'BrandonSantori', 'Brandon', 'Santori', 'brsa7220@colorado.edu', '$2y$10$1sI5faQknH605GvVivT2U.m8NPizAW3xZPUusCpJqsllnznyoaVM.', '5124349234', 0),
(50, 'elar5353', 'Liz', 'Arthur', 'elizabeth.arthur@colorado.edu', '$2y$10$3nXuBB5R3nAbCGaCQUNXtOPHaCHqV.RYAjRgtYPjcg/ko1JSyPveW', '3176278633', 0),
(51, 'Zoolouie', 'Zander', 'Louie', 'allo1877@colorado.edu', '$2y$10$fz2QkFBHfFo21pn4gJM4/e0WXSI17/fvguhSP4qn5TJ/YyWn0viGq', '7203019572', 0),
(52, 'Fairouz', 'Al', 'Fairouz', 'alfa1081@colorado.edu', '$2y$10$DB4AqCLhW.a6ic2aGMdABe4hGBfj2KP8s22WB3ktum4hwq6UoCyv6', '7203008636', 0),
(53, 'Bluetayman85', 'Taylor', 'Atkinson', 'Bluetayman85@gmail.com', '$2y$10$yK6TPnlScPt3xHp4k84F2e5OjiMdJfJWPzeXPbJEywuS/mbaanq72', '9702016183', 0),
(54, 'Birchjuice', 'Paige', 'Paulsen ', 'm.paige.paulsen@gmail.com', '$2y$10$u0HDwRcf221FqZ8l8RWvFeZwBu107CbTJ0KXMoQRfqlVjLt6A7MH2', '7203764721', 0),
(55, 'KurtRomberg', 'Kurt', 'Romberg', 'mongolhoarde@gmail.com', '$2y$10$4s5Z04su5L0whBtM8CdFn.d7UUsrM7jOj9nHAag3K4K4TjYsXASy.', '7206757604', 0),
(56, 'eightbitbuenos', 'Josh', 'Munoz', 'eightbitbuenos@hotmail.com', '$2y$10$RYSaN7aKbqeaJFPZZu6SOupOogJa4g.f8/U7Y61skhieHMV35l6oS', '3126109262', 0),
(57, 'joch13', 'Joyce', 'Chu', 'chuj1377@gmail.com', '$2y$10$/hjsKMViqA8rE4AqFZy6c.U3vf0aVNFB/5eK6zUFMC4JPyQ97Bcgu', '7204747492', 0),
(58, 'knottoo', 'Oonagh', 'Knott', 'ookn9353@colorado.edu', '$2y$10$/WbtK1k/Wpk6nul.Z6Zth.K6H9hGKOCo992CokRVp1idWgAWmhLq.', '6315594171', 0),
(59, 'aidanhartnett', 'Aidan', 'Hartnett', 'aidan.hartnett@colorado.edu', '$2y$10$b/aoz6DZ1tyXVN4o60rTJO5NpDYWhO81keLFucMRMoRj2pgs8ogBW', '7203943662', 0),
(60, 'Nadiv', 'Nadiv', 'Edelstein', 'nadivge@gmail.com', '$2y$10$S9Rje9jPPkDoR8MdZpQLuepO3dBxh9KQeM4NqBZaWVpZyIslmjKLS', '7202357772', 0),
(61, 'JuciaPucia', 'Julia', 'Bierylo', 'jubi8194@colorado.edu', '$2y$10$YVq69AczjRnJA4z9SeKqRee7zbgE3D3cpy3jrg3DvxS0aocZKH6zG', '7209174562', 0),
(62, 'darthvid1', 'David', 'Wells', 'david.wells@colorado.edu', '$2y$10$C1saCbypyoh38Spu8klTTudznBYSdGYoxONVa.7Zdk8sb4eGJuLca', '7203691334', 0),
(63, 'Boo-theGhost', 'Aubrey', 'MacDougall', 'auma7178@colorado.edu', '$2y$10$1TBYoKMzFfT8ZSxr3se.xOvByjl8W1sZRMdbMi7A.vS.eGdoJs6dm', '3034751685', 1),
(64, 'Drnotdoctor', 'Sam', 'Raizman', 'sara9982@colorado.edu', '$2y$10$5nuAVyFJKW43xxs0vd2AyOpIaNokIhcAm9z5HE6IF1I8QA.HsZLuy', '7208918416', 0),
(65, 'thayer', 'Thayer', 'Cornell', 'thco9672@colorado.edu', '$2y$10$oWZbeky20vFzsJRwxaGoG.dDelC0IONifeXYjSwcxax2zH5YsU456', '6179470666', 0),
(66, 'Lawllipop', 'Ben', 'Hesser', 'behe0929@colorado.edu', '$2y$10$es/G2lSILx2/Imy36pIdDeuCRwP5TLPCAMLaVCTYrpZ1bHprkj34.', '3039063720', 0),
(67, 'claudiasellis', 'Claudia', 'Davis', 'claudia.e.davis@colorado.edu', '$2y$10$7qq0Jowl60HP9cKLzRtFCua8o909O/3fUFZ5rtryZOMWCdLWOlziu', '3342353222', 0),
(68, 'jesswoodhead', 'Jessica', 'Woodhead', 'jesswoodie@gmail.com', '$2y$10$vMQDirdzQkMKApt5gU/V/eReQ.4zzYHLk7ROZCrWH/oxs2lHgo2nC', '3036676296', 0),
(69, 'Savvycappy', 'Savannah', 'Capdevila', 'saca1856@colorado.edu', '$2y$10$ma3x84OhF12AwdviUPvZUeT5YCXCmYsl5RhA.ODA1bg5T/LOgUVQa', '9496379429', 0),
(70, 'Zakdebaggis', 'Zak', 'DeBaggis', 'zakdebaggis@comcast.net', '$2y$10$HItsfnZMOPvGvy60xND31u6bDM7oFR27u8ibj5eUhD7CQCKWdnP5i', '7203847705', 0),
(71, 'Parone', 'Matthew', 'Parone', 'mparone@gmail.com', '$2y$10$AVSeXv6Un8jdydd/gPVrQeJlMDTJNNXALUyTCv9O.GWNiCFsInotK', '3032649636', 0),
(72, 'Xina5000', 'Christina', 'Thompson ', 'chth2581@colorado.edu', '$2y$10$KytVBwqfI0mLs/gYJXkMcu13obC4Xu2Y1XLZIqTAOcEpeslIBCdq.', '8283353665', 0),
(73, 'Krysten', 'Krysten', 'Gard', 'krysten.gard@colorado.edu', '$2y$10$xcOp5cwtW/e/SlZkf19TJevi9FPfLoWmKVECfoHu.Z8v/1ToUZQz.', '7193301350', 0),
(74, 'Rdubs', 'Rowan', 'Woodbury', 'Rowan.Woodbury@colorado.edu', '$2y$10$BLz5k1ZGjtJgEYHulY2v4egH9LKeZRnE/msoYiex7064qEh8uQVvy', '7209178961', 0),
(75, 'sydchan', 'Sydney', 'Chandler', 'sydneygchandler@yahoo.com', '$2y$10$AQ/sFqiJtQGruAZEosJOqOqy6XSnqLVd9tgR1o7t1lT5aoxTgkdXO', '7143902124', 0),
(76, 'maca8117', 'Matias', 'Capli', 'maca8117@colorado.edu', '$2y$10$ccK4L6J9lt2/4jq0RAOXi.Jo44Kj0I6svETYjIlbACi/m/KnT9vaW', '7206212671', 0),
(77, 'Mare2072', 'Mason', 'Reichert', 'mare2072@colorado.edu', '$2y$10$xY8iH/HNMKDW/UlkboiPcuG4z/i9A0m57O4kHdCsVJrn.80z5UU1u', '7207088571', 0),
(78, 'Andrewstiller', 'Andrew', 'Stiller ', 'andrewstiller101@gmail.com', '$2y$10$YXQUHjuxhMHEgNKVJsVjmOKyW6OnmUdBHUUIR3C6kvBhuzbG1J7LW', '3035235830', 0),
(79, 'chriskirschh', 'Christopher', 'Kirsch', 'christophertkirsch@gmail.com', '$2y$10$sKgVktyt13vHh3xgbBtUs.Ir5iHZFTqnDRG46kREGfJPo1tJTEO/u', '9043474825', 0),
(80, 'aliden', 'Amy', 'Liden', 'lidenamy@gmail.com', '$2y$10$mEj84B6PNWlU0N/nnjNJZOYVoc6L5fwmcsN40Lr/cior0N4MJzUCa', '9702611332', 0),
(81, 'char7887', 'Fern', 'Aroonnithi', 'char7887@colorado.edu', '$2y$10$6XVxmWOpqUdVGNfj8G5Gf./uBnjv1tfhWfFd8MUD7wUbK0CdXnILK', '7209195268', 0),
(82, 'rebeccaopiela', 'Rebecca', 'Opiela', 'reop0775@colorado.edu', '$2y$10$GkTeQD9ZjwO0vaOeoC5iGuf/APV9Rs.4DBF5jbWCbZgnIH5IO8GeC', '2817701965', 0),
(83, 'janderson', 'Jennifer', 'Anderson', 'jenniferhorses@gmail.com', '$2y$10$5WJ8Hde62PA7KUZ7aBwhfeRNPitChWiuCWRvdya8fvbGJzmjaO2pq', '7209383122', 1),
(85, 'kriss', 'kristin', 'bogar', 'kebuniv@gmail.com', '$2y$10$llxxni85DIQZp.dGhAsOru2WLyKcGor7YJZB9A8WqGMsEDw0ybQ4.', '3036566892', 0),
(86, 'JoshThewild', 'Josh', 'Wild', 'jowi6757@colorado.edu', '$2y$10$5eb/tqclLbkvAJhTZGo/U.UrKfqZzsdRdthX7vTOq0Et82J1cYG5K', '4108687526', 0),
(87, 'Tlex', 'Lexie', 'Birren', 'abirren96@gmail.com', '$2y$10$4eyWqfoBH.etuBuIqfwRnOPsJy3BN4CqPfXMhGK8sL67MdMqrsxz6', '3037463995', 0),
(88, 'Luci', 'Luci', 'Sherriff', 'sherriffla@yahoo.com', '$2y$10$3taXIGCEv3MxhGD0wMJBG.rWTqemAKw0QFEDiJAZkg8rYZNYoy8.a', '9703661979', 0),
(89, 'ocollette', 'Olivia', 'Cornejo', 'olco0540@colorado.edu', '$2y$10$.NWRiL4Gy4taClCHqJnD4.ifKltcvRXam/JKCCawdYhpjeA0ReBNG', '3037048785', 0),
(90, 'GrayGhost666', 'Angel', 'Florencio', 'angelflorencio13@gmail.com', '$2y$10$0zelkdonJw.SzoF573NC4.nAqLksarEHBiYGdhdO3WhpD96HyQ0zq', '3038597434', 1),
(91, 'Liponiks', 'Nick', 'Lopinski', 'nilo1307@colorado.edu', '$2y$10$NjlGrrc4zYxd6odPksFU7uzievQUXAWRPGDGBJacSzs2P3H8R3mpa', '8479091345', 0),
(92, 'BattleCoder', 'Tristan', 'Palmero', 'trpa7630@colorado.edu', '$2y$10$V0JNrsY/Os3tzU7foqlGLOEwvWsYSMHPKeDYlAp8eHDVufApKePxG', '7148737626', 0),
(93, 'Pikesterz', 'Andrew', 'Pike', 'anpi4252@colorado.edu', '$2y$10$kQMNfojHGb6PAlMIw1fFPeOu4OSMZNrtNOs5qwmWnPldt3UbBec4O', '5105070945', 0),
(94, 'Jehe3586', 'Jesse', 'Helser', 'jehe3586@colorado.edu', '$2y$10$7J2MZZjIG73OoGectMDMy.6fIc8npTrN3piy2C2FJOeNL.vCvGXGO', '9704563171', 0),
(95, 'Vanessa', 'Vanessa', 'Cornejo', 'Vjc.cornejo@gmail.com', '$2y$10$qAbRX/1Z9vOeIEOyx0PubeDVBLvhHePoxfYgNDBCLaY0UNpQIMHlS', '3035887447', 0),
(96, 'Adam.Bender', 'Adam', 'Bender', 'adbe1633@colorado.edu', '$2y$10$BGImSSNBV6plSjzPuZcDleUTId8scVIce9kD8eOSazGFcX7vCBsX6', '3034510240', 0),
(97, 'bostongal161', 'Elizabeth', 'Cohn', 'elizabethemilycohn@gmail.com', '$2y$10$NgIMLr.YCWEqnMPM84G/O.QgeNimxkDlDseeH/CFDDrzMglLqtCIy', '7133677675', 0),
(98, 'cammiep', 'Cameron ', 'Pittman', 'capi8817@colorado.edu', '$2y$10$q3KbjDCIF1.0Ef96vCrwN.VqFjyjy9atpNNtqMlNutzhMVQ1g9eb6', '2105630670', 0),
(99, 'TheUnexpectedBidet', 'Jackson', 'Whitley', 'jawh3661@colorado.edu', '$2y$10$eB.d5jT8ulMt0YO0EFxgM.t4fji3JwyQAa6uCrKcSTSwzmZ7ALXny', '2529952443', 0),
(100, 'alla4384', 'Alyssa', 'Landi', 'alla4384@colorado.edu', '$2y$10$NVBjZYHydxpGN7AHR69f/uvOlzfTE06fNnHBQ5H7Chc2SRTmbLaPa', '9739670187', 0),
(101, 'TheRogue', 'AJ', 'Spencer', 'ansp1208@colorado.edu', '$2y$10$9MrdlzBnNG6v4AOXNlRtaeGxn.Myym5QOMp8qwUJ2sBB.UtRPDDPG', '2089997231', 0),
(102, 'YourMom', 'Juan', 'Lomeli', 'juanlomeli12@icloud.com', '$2y$10$EctaO18IjjxM9HyW8nRBiO04DdZQEg65Jb.EGc260jSj08PxazkN2', '7193314965', 0),
(103, 'JamesHere', 'kakam', 'chen', 'kach6345@colorado.edu', '$2y$10$MqJLlO2x6spuKDde20j.3e55hKqgFZCGH/6bpb6a8MmGRzMp2w3w.', '3038197450', 0),
(104, 'Soren', 'Soren', 'Heinz', 'soren.heinz@colorado.edu', '$2y$10$WUAjmzlUZXf7/Mx4cYmsFeHpD433jwsUUeFnhEfQaXURZr3PEWM3y', '2156881461', 0),
(105, 'hual0827', 'Hunter', 'Allen', 'hual0827@colorado.edu', '$2y$10$eACqWB7pAoYMISfUEtwVt.9kA5rCpzX.C2WAgaM8/.5Mb17qhKf9C', '7203249299', 0),
(106, 'SocialJustusWarrior', 'Justus', 'Leben', 'justus_leben@me.com', '$2y$10$O3BBW03tgho5STJCdLULZ.L6xkD6VKGOfafBukR0dfGCROHs3wib2', '7202548275', 0),
(107, 'Kirsten', 'Kirsten', 'Kollar', 'kiko8499@colorado.edu', '$2y$10$cE33KrZ5ndTMnkAyRrNAZOS2.ugdkvJ0kiOAFMSRPMDK4mJZDZJsa', '9704566628', 0),
(108, 'legaer', 'Luke', 'Eberwein', 'luke.eber@yahoo.com', '$2y$10$ed.R2a.uWFfGdVyyZIAWqOo15p0Ht3KIlfO/GvuF5ndSlMGBcGU0O', '4846021717', 0),
(109, 'Bech9120', 'Benjamin', 'Chilton', 'bech9120@colorado.edu', '$2y$10$rLIrM16KfOLB0HDYaG6EB.zeOamD2265jJ49NujNDWD5QhZLNiNu2', '3038687985', 0),
(110, 'Benjaminc037', 'Ben', 'Chilton', 'Benjaminc037@outlook.com', '$2y$10$G2nlYynwh3vWJ61C865NeOpTQffaJkYLMrxhxIsblsp7qkqXWR6Ci', '3038687985', 0),
(111, 'poimaster', 'Z', 'MacLean', 'isma0101@colorado.edu', '$2y$10$uwMtdq6UegEykotN3gTEC.vAQsMg8AYHczRIJ6dBCRBgyfdViWgEq', '7205055605', 0),
(112, 'Rhi', 'Rhiannon', 'McKee-Gresham', 'everydaymagic17@gmail.com', '$2y$10$mk5adAr8BLXu1S7xoIIOI.LG2Wf2QJhDSBNS.hXoP3B3px727wj0q', '3037759484', 0),
(113, 'magickayla', 'Kayla', 'Hoang', 'kmhoang17@gmail.com', '$2y$10$0ddsRG45WKx9jgjzEjLDjuMQ0HtrD/EBGq0v0t/a3LBCZu.vbBi7e', '7206489696', 0),
(114, 'jasminelucky', 'jasmine', 'lopez', 'jasmine_lopez_00@hotmail.com', '$2y$10$T0cBQVBaUQtrH/g/bfq3iO5zsuHXcT0Bi7jF/e23ojDcp4WNiaEey', '2028098453', 0),
(115, 'Salavein', 'Geoff', 'Keeton', 'geoffrey.keeton@colorado.edu', '$2y$10$onaieGyV5Oy/aypFqcrqn.yCmSfZD0IUxzh8g1NfYB2ATx6NpLVni', '2032168870', 0),
(116, 'chdu1446', 'Chris', 'Dusbabek', 'chdu1446@colorado.edu', '$2y$10$Vqey2PRyp0TNJwHX4/gFoecZhc1zmvmMfGxmgnh8odn89SvwqQA1O', '9706921380', 0),
(117, 'chba9443', 'christian', 'bauer', 'christhezombiehunter@gmail.com', '$2y$10$8EtSAT0K27AlK472uN.xt.C.3eBibAJBszXkIW808ELeVcbM5Hbta', '3039172759', 0),
(118, 'karasel', 'Kara', 'Metcalfe', 'kame0575@colorado.edu', '$2y$10$VyLkIPPSpmxANG20NQ3AyejR5LioBevSg9KXtXWAZIy/CqEF9StN.', '7203838201', 0),
(119, 'Zargen19', 'Zach', 'Elsass', 'zael2453@colorado.edu', '$2y$10$NpYZv13AL.1aGmdSy3zI9ORxe/dPB16jPtfhwXYGe/Dx60dZytvWm', '9704850531', 0),
(120, 'brockknechtel', 'brock', 'knechtel', 'brockknechtel@gmail.com', '$2y$10$o2su8sF5cLAkIXhiEXZ0wuA1r1ZEaoqJnev0jeN38B3eBmEY8vU7q', '7207450550', 0),
(121, 'GrandMasterChino', 'Leo', 'Torres', 'torresleo548@gmail.com', '$2y$10$K0m9n5B/faqVE6UHXU162.TIwApN2tepivPzD3mgvtsCH4G.7h0Qa', '7196844521', 0),
(122, 'Idontlikesand47', 'Devon', 'Ricken', 'deri9928@colorado.edu', '$2y$10$B0mM9CU0mqTBa4Lt6.Ff7OB3eWyEd8xszNVz96FMh9DRwQYl8GhCS', '7202997200', 0),
(123, 'ancu2103', 'Anthony', 'Cuff', 'anthony.cuff@colorado.edu', '$2y$10$GqNzrLO25sATXWIocq9DhODx7GKQYZkFLFih5IYxSTcGjyhNf8mRu', '3033744084', 0),
(124, 'RedCurlyFury', 'Nicholas', 'Piotrowski', 'project21124@gmail.com', '$2y$10$jgCeO38herNs9unl3hQWueitUcwH4GClLSj22D3Sx5XvA6/B6CikS', '5202629330', 0),
(125, 'anniejo99', 'Anna', 'Haynes', 'anha2504@colorado.edu', '$2y$10$GWQ5XZv1EYyGueVPqTz/l.mwowaEC0BR7LIMb88wjnoPjgDig55ni', '3038037051', 0),
(126, 'Oceanxmyths', 'Brayan', 'Villegas ', 'brvi8053@colorado.edu', '$2y$10$YJORWj5kV1Mme2oE//ZeV.acg3C0kiRrJndHgxo9PvzVOfuivgTtS', '7207715810', 0),
(127, 'Jastatic', 'Jasmin', 'Godinez', 'jago5210@colorado.edu', '$2y$10$SvWOSPmrE7V2rHq.MOZQh.ApnXoWPa7nWJ75cENT0H/LhxDAICaOS', '7203548394', 0),
(128, 'dsowders', 'Derick', 'Sowders', 'deso7541@colorado.edu', '$2y$10$L/FZaLjIj72BsDjzqqEaS.NX8uMc4I2Cs8neRTGS8QcX63FSNZawy', '6098744302', 0),
(129, 'Mwillis25', 'Mikey', 'Willis', 'miwi0161@colorado.edu', '$2y$10$cGTxWz8OY6QuzuQML2zAse1CYrSsmU2uA5ZH49lICj.cOZKc2iadq', '9706181382', 0),
(130, 'Emely17', 'Emely', 'Dominguez', 'emdo3345@colorado.edu', '$2y$10$dH/unD8X.jzvBGB5dNyKWeP4OBNJSuFEzEFVgFv/fXW6bx7rWCaFu', '9126959671', 0),
(131, 'Yara', 'Odbayar', 'Bumaa', 'Odbu8119@colorado.edu', '$2y$10$0iRU5iOgdRrdXeHYZV8/suOZIjCvaRhvFqjFsNX081XpklcKk33Ma', '3039087572', 0),
(132, 'MainSequenceStar', 'Caelan', 'Burke-Kaiser', 'cabu5273@colorado.edu', '$2y$10$KB2zbZygbBdHCCjBilo8p.a8LNuDLq9TXW3hc8umwvPlW0cavbQee', '4147199224', 0),
(133, 'Eggcelent', 'Amanda', 'Gerritsen', 'amandaaeag@gmail.com', '$2y$10$mBDgFIly3FvHKEv24GafnuvG3Tj928DImmGEMamiVvGPu03SCzaXW', '8473475787', 1),
(134, 'Kirstenk', 'Kirsten ', 'Kollar', 'kollarkirsten@gmail.com', '$2y$10$Fp/kRMhl7il5Gfk5U/zgtu92Nqe5uG.YuKu0eTdf5UM1jv0vXsTyi', '9704566628', 0),
(135, 'Bellaallen1015', 'Bella', 'Allen', 'isal9976@colorado.edu', '$2y$10$YhUgZTAIBz.2JR1OGGJoTezIGFb3aIVAvcVGKNpfo2RN4leKRBM2S', '7202292949', 0),
(136, 'lial3088', 'Lily', 'Allen', 'lial3088@colorado.edu', '$2y$10$ByhPA6PxjD40zBZXzZqOgO9Poa01Miih30.lKOsYDvnDh8YR64Xcu', '7202294539', 0),
(137, 'abal6725', 'Abeer', 'Ali', 'abal6725@colorado.edu', '$2y$10$o3Per34SAqkzw.cQXj303OheuhndjOmrLbi5NI/p.Cwdn/1tlzWlm', '3033569214', 0),
(138, 'jackdapogo', 'Jack', 'Davis', 'jada6520@colorado.edu', '$2y$10$dn2ZM.BcWjzk.roGY2IWje8ZJ6No3Bkw.7HZ0oMKl2B29Npiw1EX6', '7202916776', 0),
(139, 'r12v56k', 'ryan', 'Berger', 'rybe5499@gmail.com', '$2y$10$AJKSNsj4wCXUmMFF0Qe2iOx7gjBh4Z6I6RLXS/tm6nD.b66DVmh36', '3033787486', 0),
(140, 'r12v56kk', 'ryan', 'berger', 'gaaem1234@gmail.com', '$2y$10$2PyD8XiNtBGg7rpnDEeiduh4oZSodKzeDoibvRoOO.q.7W5K/toxm', '3033787486', 0),
(141, 'MalloryP', 'Mallory', 'Perschke', 'mape6980@colorado.edu', '$2y$10$btEPlLidNSZ4iFtxFJiiMObqXVaS9TiSs4HFApNpp07tva.HJRyWS', '8477676255', 0),
(142, 'SeanDunk', 'Sean', 'Dunkelman', 'sean.dunkelman@colorado.edu', '$2y$10$K6s96Fy9N2XYDMhqMbMQSOeiciUUMKBkaX384uD4goGcl836U2/ou', '7757811401', 0),
(143, 'GPB', 'G. Paul', 'Bailey', 'geba2669@colorado.edu', '$2y$10$U1Bx3X.BJoU7kd8XnrJsjOlcJ4tFKtwpQtlHnUdj11W6yQ5jDZe2C', '3035200200', 0),
(144, 'prescottjd', 'Jackson', 'Prescott', 'japr9997@colorado.edu', '$2y$10$PAbSt7qiHEtTPu38QWDN9Of6aeedqL/7abzBq7eRFaCjdafMj2vW2', '7205195375', 0),
(145, 'jessfree23', 'Jessica', 'Freeman', 'jefr6993@colorado.edu', '$2y$10$8EZusrzFw9qLeioqymqXoubiEcURhdqWRTZOh/lJMYm4hdbucltZy', '6144063645', 0),
(146, 'FakeSaffron', 'Jack', 'Carter', 'joca6705@gmail.com', '$2y$10$/TnP6rkXIZ2lDuOeGZcaiOHlRrieDALOo512TU9jNvj5RKWxDmh6G', '4086803591', 0),
(147, 'Fake-Saffron', 'Jack', 'Carter', 'joca6705@colorado.edu', '$2y$10$Jgdh2tWacQo7DuaLWZtn0.56A6a/ppIYsc6PYK61AlN6Uq8oATUGW', '4086803591', 0),
(148, 'dracoshooter187', 'jose', 'martinez', 'josemartinezt.o.b@gmail.com', '$2y$10$eg.RZbu/OVC8Nxfmn9smCeL1QgUUm2vS3Favha0fsjaZ.RWTG.yA6', '7204865745', 0),
(149, 'MsAssassinLexi', 'Alexis', 'Morehouse', 'almo1622@colorado.edu', '$2y$10$arl/IyXB0tRIIetdK.HfyuoAVfIsdbsoyO526GfC.iJ3kSe.JfjT6', '7202097721', 0),
(150, 'Mego4489', 'Mercedes', 'Gonzales-wagner', 'Mercedes.Gonzaleswagner@Colorado.EDU', '$2y$10$8IhUoXEKvp6M19KNl12Ac.6KWjKzGlX/pkskr3zt2iiYktg4Pi816', '7206290355', 0),
(151, 'drewdpham', 'Andrew', 'Pham', 'drewdpham@gmail.com', '$2y$10$gkQL5zlCBfxnlvhZQlyyL.IdbOt3dNJbSDp3z18C/.9wShf.zDuXm', '3039138918', 0),
(152, 'NicoArhcer', 'Nico', 'Archer', 'archer.nicoemerson@gmail.com', '$2y$10$BicHpfY3ix/B8EVcFDZxWO6eKQ3i7DPbOGHvNP6.3Xcz7vgZfhSkK', '7209515529', 0),
(153, 'timmellen', 'Tim', 'Mellen', 'skobuffs1018@gmail.com', '$2y$10$cyjpr7/G9BM4Xqd24Qu3KO2nakYpTOtwVex4Ybt8ge083qOm7k3G6', '3032424484', 0),
(154, 'Jud', 'Judson', 'Wells', 'juwe7869@colorado.edu', '$2y$10$yoYLMtXpxyCioaiGobNUHuFm8myslZe8nPfPdq9dVJjWYJWwqR2wW', '9494828122', 0),
(155, 'Bberti', 'Brennan', 'Berti', 'brbe5789@colorado.edu', '$2y$10$f.Rqo.uOg3k6BHkCxLZFjuv3fCoqyrrUS7YbbyntD7L5TxsTHCMda', '7029011304', 0),
(156, 'JaCl', 'Jacob', 'Clark', 'j.clark@colorado.edu', '$2y$10$lQEILVvBUyNMvuperuU0Ler1U5ceN4fa5QuxU6VfNvpibbjaK2Ft2', '3196319200', 0),
(157, 'Jake', 'Jake', 'Pirnack', 'japi8981@colorado.edu', '$2y$10$CCzHKk4sreen0adb35NTOOg9A1.uol5DBUDnHoBZvDR5Vy7s7s55W', '3039603805', 0),
(158, 'Elaukli', 'Even', 'Laukli', 'even.laukli@colorado.edu', '$2y$10$npwtln7aigJrQGQnABWvy.Xet21zKCEFwlNesTAFh4Q4RkUZwIPI6', '2078380396', 0),
(159, 'Anonymoosellama', 'Elvin', 'Chateauvert', 'elvin.chateauvert@colorado.edu', '$2y$10$BBUbClh9J8Oit.dCZy2eN.DTpktEKaYLPduNlfe79NnkQ9PiI1Y1e', '8433240396', 0),
(160, 'Ricardo420p', 'Richard', 'Terrile', 'rite5632@colorado.edu', '$2y$10$jJhGfBY.BdVqnYoifsrIvOzmpvdJj8vdhusGLn5gPxX2Yrzuh9fTy', '6264877006', 0),
(161, 'MilaBergmann', 'Mila', 'Bergmann-Ruzicka', 'mibe0968@colorado.edu', '$2y$10$sIhb8nRZCe8P5zsHD50rG.0d34GIQ4Qe1XYHtr/bRdDX6itJOxvD2', '8083432759', 0),
(162, 'MilaBergmannR', 'Mila', 'Bergmann-Ruzicka', 'HypnoticTorch@gmail.com', '$2y$10$2qCw4fjAH921aUlM/pe9a.TcbH5lZyxJ.PZlxZqBVzlhpKkhB9UyO', '8083432759', 0),
(163, 'berrybrown', 'Mikey', 'Brown', 'mibr8352@colorado.edu', '$2y$10$J5F6HWI8amaK4QocIOZPrOzyiFjQqSWlxNdYyFdYvroKgovMbB1Oe', '7202536660', 0),
(164, 'Eily5', 'Eileen', 'Reh', 'eire0970@colorado.edu', '$2y$10$l3u.gmYzpaHltml4dVZQ.e.wYqP3Idy9DCpuhJxEwxJpSpRwMWbjK', '8582046261', 0),
(165, 'Lunamintie', 'Luna', 'Kander', 'kathryn.kander@colorado.edu', '$2y$10$P/y8TqcJBaeZSwrLzlQ5FukjkCt4bVu0w7pfvJC5yPCqC1Fi5jNSS', '7194591493', 0),
(166, 'ikarki', 'Isha', 'Karki', 'iska6979@colorado.edu', '$2y$10$t7Elh30zIxn/3lSoF2dCJejV5rMdbNpS8trfpXN/KdPfzaBcH7Ze2', '7202104510', 0),
(167, 'Nataliescheele', 'natalie', 'Scheele', 'nasc9623@colorado.edu', '$2y$10$2jZU37B2.K43zn3EMP/.weluPlJE9cl3Yu.AYFPhUGeuknB4j9RIW', '4155298842', 0),
(168, 'alexnichols67', 'Alex', 'Nichols', 'alni9764@colorado.edu', '$2y$10$mv4ejs903vtoef3iEQ99VucxuO6wd53Y6oSgCHYdSeeSmIp2F.Igy', '9732231442', 0),
(169, 'WutangAndy', 'Anderson', 'Mun', 'anmu8159@colorado.edu', '$2y$10$iQvYR8H3VS2tknkPnZQKHeDIMKY7MkPYyCULuWq4HES52fBXdMLuW', '3037201903', 0),
(170, 'Else9805', 'Elijah ', 'Sensibar ', 'else9805@colorado.edu', '$2y$10$tiJKC4N9Tp8eaWrZ9W.34empBYZGuhuHMpQ67HbYTdoZ2GaxwSVze', '5206645870', 0),
(171, 'MrGinger', 'Isaac', 'Dickerson', 'isdi9319@colorado.edu', '$2y$10$rM3kl1kyB2JihUZ.VifmGeUEAWBgacoxGXAKSQ9lOeKxB7V.CIA.u', '3037755134', 0),
(172, 'Swagatron', 'Seani', 'Anderson', 'seanianderson03@gmail.com', '$2y$10$FCJDv3fTqBgDkuE6hvJqG.Gb4lJjBPLt9fPymkDPsXImqvdG6OXnW', '7203913487', 0),
(173, 'Zikra', 'Zikra', 'Hashmi', 'ziha1747@colorado.edu', '$2y$10$vk3qbBlkDyYKTUkgXxYtg.kjT6H0Yh5QLI7jHOO8MgC4ILfA00Fbu', '7209398116', 0),
(174, 'Jeregami', 'Jeremy', 'Brown', 'Jebr7127@colorado.edu', '$2y$10$rDJKiqSqfPqTI9u2s8IvnOB9QbLRdghOvQ80aksHizDqcpFtA1I52', '7205524358', 1),
(175, 'cocomcalpine', 'Coco', 'McAlpine', 'comc2569@colorado.edu', '$2y$10$upaIdxii1ErNRsLly3NYFOyLf.kPHen3EoainSj3HJQXJlPI9fTyi', '4159394695', 0),
(176, 'Bellelavery', 'Belle', 'Lavery', 'isla3747@colorado.com', '$2y$10$zpV05ngHiQBuxqGOlli1Hu1hh1LESuk9fSY5rziVNzzEuRW2ItTYq', '6507409244', 0),
(177, 'Tez', 'Elise', 'Bloom', 'elisedancingqueen@yahoo.com', '$2y$10$6HoUhJoPhMvoocrkYre5BuG46wL5RwHDIBLU9O3zCj9ei0VFFdGre', NULL, 0),
(178, 'aziz626', 'Abdulaziz', 'Alabdulrazzaq', 'azizalabdulrazzaq@gmail.com', '$2y$10$rP/nTjlYnyQqt5bV5i6XHuYN5k017raaudpz27ItmILEBkPVuYr6G', '7202073213', 0),
(179, 'ErinKugler7', 'Erin', 'Kugler', 'erku1213@colorado.edu', '$2y$10$auC6HnuHru44tW.6mdWWOe9iEdhsVo66v/dvfRozWrMkfnra1K4Hm', '2157913138', 0),
(180, 'meganborchardt', 'Megan', 'Borchardt', 'mebo9701@colorado.edu', '$2y$10$0KLMYGYB80JRw82xTKqNLeittHiHaSjkiyz.y9lZ6/eZwIj/warOm', '3038294669', 0),
(181, 'sophben', 'Sophie', 'Benecick', 'sobe1438@colorado.edu', '$2y$10$tTVkIHKsAL5Qv4ebHdyzhO1QXav9x25zs3J2xR7L9Xm.b92eemndO', '2015190290', 0),
(182, 'thebirdman', 'Logan', 'Wagner', 'logandwagner@gmail.com', '$2y$10$uuexg4sbmAHKhARxG.FUtuMOWr9C0CtHdVBtxMnGkHU2ayX1SEjYy', '7203461498', 0),
(183, 'borkymcgee', 'Juno', 'Presken', 'juno.presken@gmail.com', '$2y$10$gorhasVA6.l2LqgQmx55lOTyzC4zdZHBBtjQWBNq787jeVg9TP/BO', '3035515356', 0),
(184, 'Gaga', 'Gaby', 'Garcia', 'gaga0997@gmail.com', '$2y$10$yNrJBgCyMM/wjOx/ZSacXuSreHNYUn3U4/EQHWIrfbOOKFQ5bhdy2', '7209036661', 0),
(185, 'Gaga0997', 'Gaby', 'Garcia', 'gaga0997@colorado.edu', '$2y$10$Pg0hULXkNyt6kLXB00htsuxqw1e0u.D7ztFoZ6gVS0/pIH45yd9ta', '7209036661', 0),
(186, 'Faswlya', 'Emily', 'Lee', 'emle7585@colorado.edu', '$2y$10$QZPuNpah5AI5fHekF.7l0eGgGz7fnodOUTS8ta/drVkMOy4yjcuKq', '7204124892', 0),
(187, 'xxmichellemtzxx', 'Michelle', 'Sanchez', 'eisa3025@colorado.edu', '$2y$10$zDyblBiDSUaVAgfBqJFUt.cmAnMpgzyquF6nDUHd/gYIWX6ErGeiq', '7193526021', 0),
(188, 'Abelgeb123', 'Abel', 'Gebretsadik', 'abelgebretsadik1996@gmail.com', '$2y$10$/QnYFWXUaILERUPAVofx4ueT7xYw2jCcooImRj0OEzzZMcQ8AI6bG', '7206022871', 0),
(189, 'Gcominelli', 'Giulia', 'Cominelli', 'gico2439@colorado.edu', '$2y$10$hMK9m6sFXXhLMmdoYP3PBO7BdqB3p18H.ZTFqbuUi4wHMDfPkJyrm', '7207238887', 0),
(190, 'Mancy', 'Mancy', 'Shah', 'mash7825@colorado.edu', '$2y$10$BHaiM9vQH8yxYnZhHZXI0OLdCoVbg10hNI5CKSzQxXykHUEBYe2wO', '7202172270', 0),
(191, 'shellulose', 'hai', 'li', 'hayu7527@colorado.edu', '$2y$10$U3Lm/TT9.xaOVDkt70dtAej1R5UopgCDs4HQvSt1ae9aOUyTy3OoO', '9705184718', 0),
(192, 'Thompson', 'Alex', 'Thompson', 'alth5662@colorado.edu', '$2y$10$.tDFPpAh40BIf/tM3gOL0eYBok.4ipGCe1Q8jzY78TGR./O1H.TCC', '2247171145', 0),
(193, 'olar6807', 'Olivia', 'Arjona', 'drammagoose098@gmail.com', '$2y$10$HPlEKBjeLRWq8fPZdiQZwuWkFT0wkX9LNK7tvydplT5TC20Y26fna', '3037201469', 0),
(194, 'phwu6529', 'Phillip', 'Wu', 'PHWU6529@GMAIL.COM', '$2y$10$AoRN3hcEcZc62pzRbyesc.4VWRuHcCH/dHyVX.fFOn0dFNmkEtbjW', '9737673636', 0),
(195, 'skrieger', 'Samantha', 'Krieger', 'skrieger.2015@gmail.com', '$2y$10$EkmbcvVdncW3owwUyvXK8OM8uDM1214LZGXj6y/7GbqLINPeol5Q6', '8157193455', 0),
(196, 'PapaGeorgio423', 'GEORGE', 'HUGHES', 'gehu3453@COLORADO.EDU', '$2y$10$yPM1f6vyfXcaDdDmbgBelO/NCcd5Fj3thEAU4FjURER5XF4tBEPEK', '9157066394', 0),
(197, 'sbarrette', 'Sam', 'Barrette', 'saba2244@colorado.edu', '$2y$10$czGhrcEt9rhBaQX8qvMhGeV6wmwlFYIxJVR5/KmvipSO1pUNa5y8G', '9789895510', 0),
(198, 'Kellenposacki', 'Kellen', 'Posacki', 'posackikellen@gmail.com', '$2y$10$nLJC.pF7Z9yTt/0P3d/KHe4FcA2H6VkTbQbOzi6AthSk2lAEiwnia', '3366094888', 0),
(199, 'connorlacey', 'Connor', 'Lacey', 'cola2087@colorado.edu', '$2y$10$JXGD3T68RK8Yg0WDYDa0IOhw.0eUS1GLYvqBQ2/IKP408wh9lGNkC', '6143151773', 0),
(200, 'Brucevalentine', 'Bruce', 'Valentine', 'brucevalentine123@icloud.com', '$2y$10$q0CHZYUw6y.gUtsYRfwfwO/SNmdbGYoLdlPWC2Ub1x8RujEK.N3GC', '3033304735', 0),
(201, 'connorlacey1', 'Connor', 'Lacey', 'laceyconnor@icloud.com', '$2y$10$Sc.H9.lIemSrJXEt5OpbTu7HP7DI8yRYV9XX0zvZAlxlvBHeDjM1e', '6143151773', 0),
(202, 'Luwe8329', 'lucy', 'weld', 'luwe8329@colorado.edu', '$2y$10$EXkDPJc5oqqjG3lBAgs89.brJoZfz.ZLu/mE127mYWI4V4/3hLTpq', '9148604545', 0),
(203, 'iceShelves', 'Pim', 'Maydhisudhiwongs', 'pima0202@colorado.edu', '$2y$10$0VMUfYgFDHyqlMTgt86E8.wbwGt9jRXtZwdvER.229uaU7rfl4DQO', '7203296239', 0),
(204, 'shakz', 'James', 'Dao', 'jada4845@colorado.edu', '$2y$10$zZTEH1CC18fyaxlPa4/ZHOI5kQLIeXQFSvUKsAz/TniAbJk9IDFaK', '3235474785', 0),
(205, 'jimbo50', 'Alexander', 'Karas', 'alexander.karas@colorado.edu', '$2y$10$d//jOQKDSzzt0ScTx9db7u5RcOU/eWMAkIAwJGlZpHbpgViMk9zn2', '3033495341', 0),
(206, 'ajkaras', 'Alexander', 'Karas', 'ajkaras@comcast.net', '$2y$10$I8btJwYKPZnuS9mPW0bCjen.R6atF6HlYwqYdt8PEmj6bAtRokXIa', '3033495341', 0),
(207, 'Ckamiel10', 'Casey', 'Kamiel', 'caka0065@colorado.edu', '$2y$10$RRU/grTiYXm0QUTnF/FPLe7LPJKi13pRdSfA8GSGlbxFzqIOgQvTC', '9739548804', 0),
(208, 'Chrisposacki', 'Chris', 'Posacki', 'christopher.posacki@colorado.edu', '$2y$10$bUG/YBDvitIox1YW0AIMT.eYhRVIcCw5pb7umn/oYeBI9/WP0tNLC', '3366094887', 0),
(209, 'Realdealkamiel', 'Casey', 'Kamiel', 'cticket61099@aol.com', '$2y$10$p/9171tl6xpu/kQt3fWcVupAW9d3q3jF0v9pPpG8v784aNBi/4pvm', '9739548804', 0),
(210, 'coren83', 'Coren', 'Lam', 'corenlam8@gmail.com', '$2y$10$/ThX9iucn44TBFtxyoLMP.8tuaGW32GM0ewwhL6fbNsU3DkGnKLMK', '3035499967', 0),
(211, 'ZombieCadet25', 'Andrew', 'Nguyen', 'anng7621@colorado.edu', '$2y$10$WZRFCYqSCxd5M02m469Tj.9D9m87qwgoauYZr.bpBVVlThv0Ymq5G', '7202809801', 0),
(212, 'InvertedCrossfader', 'Tristan', 'Ricci', 'trri8648@colorado.edu', '$2y$10$C1XjfKg3qa6njh4VI58W7.fTgGwu/eB1bvo0P3Ea1elrNQ.SHyqou', '7192211066', 0),
(213, 'baltschuler', 'Ben', 'Altschuler', 'beal3203@colorado.edu', '$2y$10$ur.SEkH46RCfx2GapXJtFOPgpgCJlXoFwd/KxurOY7d2ppWoZbhB2', '7204984605', 0),
(214, 'aazizh', 'Abdullah', 'Alhumaid', 'a.alhumaid99@gmail.com', '$2y$10$rcsYtlxcnUenueXlIyVBQuRCgkTHYLY9E.NPutwdeLVAuu7NF4iFC', '9703933555', 0),
(215, 'benaltschuler', 'Ben', 'Altschuler', 'baltschuler2000@gmail.com', '$2y$10$.guYQCzcYOP8LL/Y16dhjuoPRpfOhbu8hiDFgkwflzOL0GAaXOFmS', '7204984605', 0),
(216, 'alantheman', 'Alan ', 'Vaghedi', 'alva0349@colorado.edu', '$2y$10$1S3OwpBQJrY2LAN5/RQy/.j3KQplMp1hHPMzsJcHm9NzLCF40nxwq', '5713938667', 0),
(217, 'scottray19', 'scott', 'ray', 'scottyr19@hotmail.com', '$2y$10$G/uZQdkQvBPaqEY9kqIRY.nJ/d8QFl2ULM5eNSg9bRUI.XeU0yB6O', '4254638468', 0),
(218, 'CUCLAM3', 'Corey', 'Lam', 'clam382200@gmail.com', '$2y$10$cfZLPjVinxA/gL/gd8FPbeSJPHogMatnAi/LDlElvbLspKwGZRDUO', '3035502059', 0),
(219, 'yolodactyl', 'Aaron', 'Lombardi', 'aalo7987@colorado.edu', '$2y$10$4y57Oe5HItYbLdwKA3NQsOG1defKFEZqC3/halXKDPkC3SR/F9lIy', '7192256290', 0),
(220, 'CreativeFeeling', 'Kelsey', 'Adams', 'kead1599@colorado.edu', '$2y$10$TgwEq/s8y9xrk5sXI5bZeuZJTrPv33Rt1SBb02.g2KWdKkRn4hulu', '7039397554', 0),
(221, 'desc7849', 'Denny', 'Schaedig', 'desc7849@colorado.edu', '$2y$10$VsEZfA6Z6QH4v76puV2KDOuJxB3.eoxBJpJUzYCn3EohV9DnVIiuK', '3035072815', 0),
(222, 'Saint', 'Will', 'Bishop', 'bisa0401@colorado.edu', '$2y$10$15VMOXNFHrW93bY1JNoa/eVw2GU9LcI2b9MSD9YdoNJZAA66Rj.SS', '7202262328', 0),
(223, 'Adam98', 'Adam', 'Vega', 'adve3509@colorado.edu', '$2y$10$CQmjpuFtQ/PcDl4IS2EZauDMYxqai7JHb4GaPszMqpNNpdzBIvG3S', '9704155287', 0),
(224, 'joor228', 'Jorge', 'Ortiz', 'joor2163@colorado.edu', '$2y$10$T4jYZXUPMHzapewH655n1u01IPuNJLUniO1277ysjhxd5RlQu1naO', '7205570422', 0),
(225, 'Phoenixflash', 'Kimberly', 'Fung', 'kifu0187@colorado.edu', '$2y$10$cA4atf9T5fs0j6vDqv7uCO.JqLmqulHE.RY4RocHLQiKLI6nLtNqe', '3035624476', 0),
(226, 'Trinityp', 'Trinity', 'Padilla', 'trinity.padilla@colorado.edu', '$2y$10$YGlOxnMvdB0mYsUhQMUyrOUOlfhfn0IZ1ochjvCujmWSuIQupSGyy', '9703192155', 0),
(227, 'Mast7851', 'Madison', 'Stratton', 'mast7851@colorado.edu', '$2y$10$PLBMUzHTxzlvhqUMCcPzGORBWL.9qGMlN4U0BH1/S3FbZbBsu/IlS', '8019001018', 0),
(228, 'Thyme', 'Thyme', 'Zuschlag', 'thyme.zuschlag@colorad.edu', '$2y$10$Vke4B4swdFn7/9l1Ox1X1uiYmgmRgFr13GOwIPho29Y1oniG/1Vm.', '9708462715', 0),
(229, 'Hcallipari', 'Hayden', 'Callipari', 'blackbelthayden@me.com', '$2y$10$RTA4pxhGflxGDJER3BPFhuzgQNimcdpYLNcSm.qjtnjBqTDtGmHCy', '7205197400', 0),
(230, 'adda1846', 'Addie', 'Damron', 'adda1846@colorado.edu', '$2y$10$SQ4vCoX9B7bYHDSpx2lw..WWcMhlvVDqw.RagZvCY0rjiiLeXZMz6', '4146884281', 0),
(231, 'annaben777', 'Anna', 'Benson', 'annalisabenson01@gmail.com', '$2y$10$RsnmwSuS3RXjVOtpja/xV.nLO4SrOoOqDAVkkeVOC2SB0b5xxamIS', '3038566139', 0),
(232, 'Evan', 'Evan', 'Hanson', 'evha0005@colorado.edu', '$2y$10$.smRFJ7KqDv2f2IPbgdXS.oZzmGOznPigdfMzOdtU9hpKAQ4gW2ci', '7204800062', 0),
(233, 'jackjohnh00', 'Jack', 'Harless', 'jack.johnharless00@gmail.com', '$2y$10$31xAN7OCvnGIjAqoZNJXuu7Ai1vGK/IK0T0zydTXhQu/S5jOLVUTK', '7205458091', 0),
(234, 'jstone', 'Justin', 'Stone', 'just1749@colorado.edu', '$2y$10$kCXaZ3bJf6xg4b60oILnLOkZt7jzveBFwjZca/npW6zogI6pCk/ue', '8086990795', 1),
(235, 'Jomi3845', 'Jonathan', 'Michou', 'jomi3845@colorado.edu', '$2y$10$Ph.6DVvk4YOE3gP1dfRdZuV8/EasnzXXFRCR8f0p4QAb7xtdzgXXm', '9072238302', 0),
(236, 'Shehila.Carter', 'Shehila', 'Carter', 'shehila.carter13@gmail.com', '$2y$10$gOhw.IW54n8fQmry5Tlt9OUdznStP7Zjmyqjs4Iv3uipMH8bmDyh.', '3038093999', 0),
(237, 'MarisaC21', 'Marisa', 'Cruz', 'marisa.cruz@colorado.edu', '$2y$10$9IF5sK3lDwTH8yRhL6E1iuYDt8m0ehkHHVcZB9Juhov5O63QvFnKi', '7192525332', 0),
(238, 'Xectus', 'Stephen', 'Gerwig', 's.gerwig24@gmail.com', '$2y$10$v8isK9bM8/heVwN6t47xkO/s7uxSammvxOb3ho9Xog8g4KSyaRQ5q', '7203006770', 0),
(239, 'UnrealisticX', 'Ian', 'Quinn', 'ian.w.quinn2@gmail.com', '$2y$10$VvHy0zncT7sDFZGCvkeYkuHzT8udYzsQ4qO4duJPkTG8eLTVu7mE.', '3144359058', 0),
(240, 'Iane23', 'Ian', 'Ehlers', 'iaeh1777@colorado.edu', '$2y$10$f9DEPdEC0yucc6Jre.ewKO1iG4z9WUdVs1pLIBvlGtHWYsVOwSvmS', '9785056148', 0),
(241, 'AceMcFlop', 'Mike', 'Linz', 'simpleshoe@gmail.com', '$2y$10$U8G4qs2ZV9pD2OvZdcrEUOus6MIAkTRomK1FKzcXYX3bRTphoH5/S', '7196412279', 0),
(242, 'Samrel556', 'Thomas', 'Sigler', 'thomas.sigler@colorado.edu', '$2y$10$YMx3Wb/Lp0i.d6dAJkTDd.tRbdkFRu9lapNaHA7VZaiMf9RqmStdC', '7202338965', 0),
(243, 'shaanp', 'Shaan', 'Patel', 'shonoe18@gmail.com', '$2y$10$Oqj3vdY8ofXHHj9H/uG/ie.OBHT/fQX8yMs2U23LhA8MAhdOYZDH.', '8478002037', 0),
(244, 'camikburke', 'cameron', 'burke', 'cabu4385@colorado.edu', '$2y$10$DteaKKQJYw245rGkFLuvl.YFvTtMO/h0H46RtR8qC9UMBWwN2kvna', '6039210661', 0),
(245, 'isabelmlo', 'Isabel', 'Lopez', 'islo0450@colorado.edu', '$2y$10$Fk5XYGwxP5y8jqEa59WntuHdQX5YeLL/ckcU7iWoVm/wBkHyqktBm', '7208545634', 0),
(246, 'tiffanylee', 'Tiffany', 'Lee', 'tile5880@colorado.edu', '$2y$10$v0.RJHKHquFpOIymml9aCOibBIB1bQbRQGZSHxEJA8NxanLtUDD96', '9704492217', 0),
(247, 'rili5381', 'Rita', 'Livits', 'rili5381@colorado.edu', '$2y$10$sTs1X.GVF5gWY.kpjPY2w.2iv2ccR.hZk7sUGElJbvGLsTV7E3oiu', '7202988878', 0),
(248, 'Dannaconda', 'Danny', 'Viboch', 'dannyviboch@aol.com', '$2y$10$VoRU0II9IiIb/looSlWS0u57dlH85syAjYyX6I65wsI369z4HV44K', '8584725114', 0),
(249, 'ryyyyantaylor', 'Ryan', 'Taylor', 'ryan4125taylor@gmail.com', '$2y$10$FCzsTM6qUCeK/0kHNaU/ROcYRngbkJBar5NEi9Mo7mUyq.7wDw64y', '5624772165', 0),
(250, 'Toryblysik', 'Tory', 'Lysik', 'Toly1886@colorado.edu', '$2y$10$AgqsDS.KlHpEDrov/pRC5.fPhQ7uWtHhebcg.Ip1hZdQ.4WeLc3l.', '9107427134', 0),
(251, 'Oden', 'Caleb', 'Imboden', 'crawleb.ci@gmail.com', '$2y$10$ZUzQxeTZeLIX/TKMoJrF6e6jrPEWF.wR4UEGY3tnWC99Rzt9PhhSC', '8708347794', 0),
(252, 'wima5559', 'William', 'Maloney', 'wima5559@colorado.edu', '$2y$10$LUUWLB7Ymn2pXpoTfj1YtO7EtbKyY6ZZLtH.vi87nEQuH8lb7QBQK', '7205601637', 0),
(253, 'paca7559', 'Patrick', 'Campbell', 'paca7559@colorado.edu', '$2y$10$wZP4mYEmOF/lKM2Gy33vquV1aVHgx42mK3tYy6NfcF/zKDn4G8qd.', '3039904038', 0),
(254, 'ShreaG', 'Shrea', 'Ghosh', 'shgh8771@colorado.edu', '$2y$10$aVKN7ONEsE0SkchavWRvO.QBJuB6QEC/hZhYJ9TgY1.J6avaScXAy', '7203381319', 0),
(255, 'ShreaGhosh', 'Shrea', 'Ghosh', 'shreaghosh99@gmail.com', '$2y$10$ByBakHUFVKvXQtnnjy/wQu.dtlE8PYDjHhGmLELsZTs6/xN.ZtKAW', '7203381319', 0),
(256, 'CasuallyCausal', 'Jamie', 'Warren', 'jawa8653@colorado.edu', '$2y$10$GuLDB08u92CciNxaU7G9oOiIKAzPK.LcHHtb.DzpklYaUnPWjqXCa', '3032148188', 0),
(257, 'Davydave00', 'Delvecchio', 'Wilson', 'dewi2605@colorado.edu', '$2y$10$bfXE82Ge7rJQtcKWFNmUCef.LNIq.nEHiRCm3/DYRak2l2ki7lCeO', '5053863449', 0),
(258, 'dewi2605', 'Delvecchio', 'Wilson', 'davy.davew@gmail.com', '$2y$10$vjQB0.Ag0u/Scmi.cFplNuszRjRpuDniMh1PiXDKYuarw54yvNxEu', '5053863449', 0),
(259, 'Bufftin', 'Justin', 'Reeves', 'jure0127@colorado.edu', '$2y$10$NJegg1TIPTeZzRl6vOZa2uKzBlu.lHeXLxyrScNv5MRGw1E1JzKLm', '3038864362', 0),
(260, 'LHayes', 'Larsen', 'Hayes', 'laha5544@colorado.edu', '$2y$10$U27usXKMJv57fWpiHcqNEeZ9A0JxEa0sjZLzqLEFkQPdNix3RFAS.', '6199932782', 0),
(261, 'RanaTheunicorn', 'Rana ', 'Marghalani ', 'rmarrghalani@me.com', '$2y$10$UuBzExMSUyS2r/6s/u22H.ztMrwYdRy5CiYHr8PY1Cz12yX98BAVS', '7204277058', 0),
(262, 'Ethan', 'Ethan', 'Herrold', 'ethan.herrold@colorado.edu', '$2y$10$TpCGrB3aEk3.D2MrURz1SuFtSb35yPZXHCYWxcd88.mJpLbA.M1R6', '3035656987', 0),
(263, 'Ktburds', 'Kyle', 'Burds', 'ktburds@hotmail.com', '$2y$10$fKRP5GmlzWRvB3Skx8mQBeyG7BSQuNElwlqCa7Fr/ll0PuRG/U/y2', '3039031753', 0),
(264, 'nohe', 'nohe', 'revelo', 'nohegeno@hotmail.com', '$2y$10$bR.XZLuunwK7revJ12NofOZu9tFOrw7/5WJB7HU85Us2iEiKNQMeu', '6124443252', 0),
(265, 'pjwarrior12', 'Ryan', 'Taylor', 'ryta4737@colorado.edu', '$2y$10$EN7pUvkLH/3oBzmrNlpvzuGwTeYL2GK4zIXOszb/xF.X8ALAL8tR.', '5624772165', 0),
(266, 'Clairewilcox', 'Claire', 'Wilcox', 'clairefwilcox@gmail.com', '$2y$10$XS.MzWrJIrEkhdrbvwnmt.IgC4zqgCVKgawKAJgmFBNDOMQi/hKzG', '6184209737', 0),
(269, 'Tester', 'Test', 'User', 'josh.brown.3255@gmail.com', '$2y$10$ZOS372jb2TIAldvJo/JRZunYuiRrSI17FoLQtCOJBEuKlCrJUO90q', NULL, 0),
(270, 'Gary', 'Gary', 'Baines', 'champ.baines@gmail.com', '$2y$10$RXVfpoetlxDe2Fa7Y8sA/us3mpiPuUQFIpJ9YprN/z8.Qp8PqSDZa', '9014284074', 0),
(271, 'xXNerfan11Xx', 'Trent', 'Richardson', 'tmr710@gmail.com', '$2y$10$5tOn7kZWr1H0eNMvcyZFyOzvevWqcDfbo2gasF1wJOvahRmQIgdbC', '7195517040', 0),
(273, 'TestGuy', 'Test', 'Guy', 'golfinjosh@yahoo.com', '$2y$10$u10byIUGj0Yv/yUm0bNv0ebGkagni6EER04iamEd2nNUm/3xHcCDq', NULL, 0),
(274, 'eroeck006', 'Eric', 'Roeck', 'erro2466@colorado.edu', '$2y$10$pLX/ovqTvue/njrCvQ7oTesIYOaw8yje9gY2G9AaXCKT8GeI4dM1G', '4089210624', 0),
(275, 'Matr3942', 'Cameron', 'Trost', 'matr3942@colorado.edu', '$2y$10$V1qyGwq.4SGWYgcmPFXt5OPKKKFl.PHDAz6BGjY8g/iCe3n2CPmlO', '5305743117', 0),
(276, 'habr7336', 'Hannah', 'Briner', 'habr7336@colorado.edu', '$2y$10$RDZmbGC82nvtnV68UbpboOIOZY/x3OTt1lxu8X.fd.VpLvNQ1AXYO', '9702617767', 0),
(277, 'bhaldo', 'Brooke', 'Haldorson', 'brha1688@colorado.edu', '$2y$10$vghdqYQalqCmeg4VZot7pOz6sys44dbtSiyurO05FT5MYpmo2WTZu', '7202360579', 0),
(278, 'rebecca.su', 'Rebecca', 'Su', 'resu6335@colorado.edu', '$2y$10$jf3yfIoe/Y6WtRdkapbsceWXaZW1U914rBByGr5uViGQNqAl4Mt8a', '7203838686', 0),
(279, 'sierakiana', 'Siera Kiana', 'Camacho', 'sica5093@colorado.edu', '$2y$10$Pqo2YlVhJ9lutAEn5W0sEOstgj3sXO/L/t/QE3zS37jXhz1e8hHjy', '3037189021', 0),
(280, 'kaea3463', 'Katie', 'Eaman', 'kaea3463@colorado.edu', '$2y$10$VJmBaqiD53cTunmUYVTR4uJik10r1MTvBdtd9.wtpcNuouKZrXfSO', '3038072977', 0),
(281, 'aaron1edu23', 'aaron', 'burgard', 'aabu4992@colorado.edu', '$2y$10$qaOV/SUQLNT.ogkgbz2SqugD2uPcmvZ36H3F6DsoFD7FVipXsLXMO', '2012890441', 0),
(282, 'renniemaui', 'rennie', 'tucker-meuse', 'retu3846@colorado.edu', '$2y$10$iX1NdE5JfNhkjcgz.MtZdONqcxgG2VrBE66U19ZBCPLAVU0L2Yj4S', '9707869968', 0),
(283, 'MacAttack', 'Mac', 'Cohen', 'mac30123456@gmail.com', '$2y$10$IaFWRcJGOaVtBAMrWlp.VeNlOwg9iwRHh7VyrYUJLzcBa1ly38LmK', '9704565760', 0),
(284, 'MacAttack27', 'Mac', 'Cohen', 'mico4709@colorado.edu', '$2y$10$5fT3i3KObrvXvDZwt14VJ.t0AzoXipMDN/XVOtxfZbS6Ds6HRQsXO', '9704565760', 0),
(285, 'aminder17', 'Andrew', 'Minder', 'andrew.minder@colorado.edu', '$2y$10$LDSaUknjSnAvzVZA7kslU.hxJvMpkNL.YDwfAihmRxLmkViOzyS7K', '2036451687', 0),
(286, 'JakeLiebow', 'Jake', 'Liebow', 'jali1005@colorado.edu', '$2y$10$EFU0QyofNfOgBo6673K7yuOyUDQmv9jmSmXQLFR17KaX51p9fTdWO', '2038070765', 0),
(287, 'brennensched', 'Brennen', 'Schedler', 'brennen.schedler@gmail.com', '$2y$10$G3kXW.bohYyMTawiT2BqoeT6cE.cOgDggK/EtUKnIIDbrobMJLrYa', '3039183739', 0),
(288, 'MattSoto', 'Matt', 'Soto', 'maso9985@colorado.edu', '$2y$10$2BzaW57kAnX5h6jgUplX4esF9s8OdzHOs1.mZXIhEjwA4NdUlBxj6', '9495272900', 0),
(289, 'SakoStylo', 'Samantha', 'Koenen', 'sako4595@colorado.edu', '$2y$10$04LCwYdXG1zL/Abq.tNRjOjlZ10E/E/SCzh3ZpXkZ45cwzXAObR8q', '6164850259', 0),
(290, 'Lalyon', 'Luke', 'Lyon', 'luly2738@colorado.edu', '$2y$10$s82r9ZgzrnNrQ6p3FtxE/eFCQCjrJmvZtPn8C.LgDL7nD2NY29Buy', '7167139153', 0),
(291, 'oscard', 'Oscar', 'DeRoche', 'osde4450@colorado.edu', '$2y$10$/893t/yYIyndHSuylujRHuenFUzyXWgp30vyKjrM9LbKfzXZDSuQ2', '2074185763', 0),
(292, 'cjhemstreet11', 'Cole', 'Hemstreet', 'cjhemstreet11@gmail.com', '$2y$10$Dx5isVKy.JTwbOFQEnfgu.GOZPqGSNyRYuYxO2gpAY9SXXzwfxx0e', '3037463370', 0),
(293, 'somebodyxxx', 'Vaibhav', 'Chourasia', 'hurricanejr@hotmail.com', '$2y$10$wPuR.UWQaULv9ao0U4ieeuUKL/MZoAJBV51q/uXXrxxLpLLCy/f4O', '7202911477', 0),
(294, 'annanat', 'Anna', 'Lee', 'annanat23@gmail.com', '$2y$10$P3FuEGl9yQeLKDwh22sfCO7uqPtOB3ob6mRgFB010SnfJBt.qbeza', '2079397712', 0),
(295, 'devinriggins', 'devin', 'riggins', 'deri0734@colorado.edu', '$2y$10$jtM7FEEzIojMcWnoCd/e..8Q7.ZYMvQw/v8Rj3Rj4qN2z7P9pURTG', '4437979855', 0),
(296, 'Rezz', 'Blake', 'Hampton', 'riha6672@colorado.edu', '$2y$10$McF5wGI4Tx2zGCoYV7JFBejvOrEq9zlRoy1UiST3Mvq9hI1kGIeRm', NULL, 1),
(297, 'Troy', 'Troy ', 'Wright', 'troywright3282@gmail.com', '$2y$10$4SN2Kmb0723NT/ZgCkpbv.OIZdIQ0VydUI3VY2ocU2Ht7lKdq.Nyy', '9726004616', 0),
(298, 'Kenjeongliver', 'Michael ', 'Kim', 'jiki2508@colorado.edu', '$2y$10$QRpogE4p1U9IxEl34BoW0O9YlCCn57A8VXt2Szml9PVVDZtzvpRw2', '6503394038', 0),
(299, 'GaigeZ', 'Gaige', 'Schaal', 'gasc4841@colorado.edu', '$2y$10$5nO5dDUqExkCAapwNk6/hOtDxaB/lHhy66uPSjPJgKVEPcU07xBD2', '3032462596', 0),
(300, 'TaylorMcDon', 'Taylor', 'McDonald', 'tamc3926@colorado.edu', '$2y$10$8viaP3q9nL8x925MGfHY2OcCCHxBB.UC8D2s4TBivuMNdDfttCLc2', '9702090414', 0),
(301, 'Gilster55', 'Matthew', 'Gilster', 'magi7124@colorado.edu', '$2y$10$PuSyphYZ1au01AW5iMt4VeeQMW1iLnTwUqTh4UI5n3qHSh/UnWnV6', '6189609948', 0),
(302, 'Micanat', 'Michael', 'Bac', 'michael.bac1999@gmail.com', '$2y$10$l.gJZjbuMHBmDFKi9iyiUux.4x2.aOtqvv19aQl9KUoR15o3q6zqy', '7139067155', 0),
(303, 'Owen', 'Owen', 'Borusiewicz', 'owbo2103@colorado.edu', '$2y$10$Nw2JKzs/6d.4alzYnZGzVe2fxLtt20rx0m5KYgKAAM3eGo4RY.Xcm', '7203185647', 0),
(304, 'Poop', 'Mohammad', 'Alhouti', 'mohammed.k.alhouti@gmail.com', '$2y$10$9JtmhihRsrLXYuAmKuR9BuFRm9DVYoQynjnNP3g4SPzljx.PW9gey', '7202071391', 0),
(305, 'Hamad', 'Hamad', 'Alsaleem', 'haal3849@colorado.edu', '$2y$10$Z/g3s/D6eRm7DlWs0U6KwOUypZPq0G3TLvwBkMuorUwPVcjvA184u', '7209174361', 0),
(306, 'ambineid', 'Aziz', 'Bineid', 'contactambineid@gmail.com', '$2y$10$ddBsWNhQ0Er.LtoetleCqe.mJ9iS8IqsLjbJq8qrKjUfPTDY5sWIu', '7204161620', 0),
(307, 'Smor777', 'Sam', 'Morin', 'samo9751@colorado.edu', '$2y$10$VizCo.klwXjsHGznjpZmWu0FBpQQKLCAZQ2SHLj6AqFxftRd912aK', '7209511058', 0),
(308, 'Fletch12', 'Rachel ', 'Fletcher', 'rafl4970@colorado.edu', '$2y$10$Mz51f7fRxsapNMGru0xxN.N6NLDrX3ZH1nETl.10ipAy.aSoHFbki', '7817333122', 0),
(309, 'StubbyBud', 'Jonathan', 'Hoeffel', 'jon.hoeffel@gmail.com', '$2y$10$olXVnT4MYShuvCmj0OAebOnVWqyw0qWp6ojCqjEkK7IJSbWIBCXBe', '7192091953', 0),
(310, 'Trevessse', 'Trevor', 'Shirakawa', 'tlshirakawa@gmail.com', '$2y$10$IQVL6SwZwQ6uLj..KaCXH.KYJFo921xN0wD0G0lcuhceH1dAUd5eC', '2158503544', 0),
(311, 'MacDaddy', 'Lauren', 'Macdonald', 'lama5596@colorado.edu', '$2y$10$zVVpcdhp6fAE.dQtfgLzVO74.RehFMVQlphlg7.VLo2x99Z.cVmo.', '7196511105', 0),
(312, 'cstiltner', 'Caitlin', 'Stiltner', 'cast0513@colorado.edu', '$2y$10$PpAZT6GhS/wLq.DdnwP/MOG7ZuTHfoTIBpU6pe83huF7KOakWa1qy', '3037208975', 0),
(313, 'lmills', 'Leandre', 'Mills', 'lemi4353@colorado.edu', '$2y$10$9c5F6Nw0Vyi/48HkppPO9ukojgIHS1caVPPt1Jck/ikI.shsdeutS', '8108249998', 0),
(314, 'anen3020', 'Kaylee', 'Engelhardt', 'anen3020@colorado.edu', '$2y$10$zfLAVCenPl49y.xUQu8IlOkKsor8SB8WFkJrRXeZWv40i/RNfitAq', '3072173663', 0),
(315, 'Jkirch123', 'Justin', 'Kirchner', 'jkirchner123@gmail.com', '$2y$10$T89HPKnxQgiPTJQKPU.db.OsItQir2c7e6TkE4z./E0mKXZ.i221S', '7149047537', 0),
(316, 'iakona31', 'Iakona', 'Agpalza', 'iakona_agpalza31@yahoo.com', '$2y$10$QDX2337a6mT24U9isZImbeWmQVSYyDPNQcsSFv5yZ6zPOHgnANuQW', '9103913383', 0),
(317, 'Dshumway', 'Diane', 'Shumway', 'rubispiritwolf@gmail.com', '$2y$10$cQ7yJbx/LM7e0u/RREpAQ.KmYWNIcg7RUdWXMAsAbtX0/rhDx21MW', '7203930071', 0),
(318, 'SydneyHighsmith', 'Sydney', 'Highsmith', 'SyHi6486@colorado.edu', '$2y$10$MS/bWiNgGv8sesi7.6WX8.RWBQvyu.05bj9K45sgTju/fu863GknG', '9702137818', 0),
(319, 'pittviper', 'Sandee', 'Ortmann', 'sandra.ortmann@colorado.edu', '$2y$10$8.pNL6tX2rCNHY7KfXkdAeYy8QwfA8mKGiOG38jEnp8xacL0wP1kW', '6692254532', 0),
(320, 'Bowserbot', 'Bobby', 'Ford', 'bowserbot@gmail.com', '$2y$10$0WbGg3PyFVkzBDAmPnhV5uU1N61FrBlAClWm4GnErX4CZEjkb/tBS', '3035657052', 0),
(321, 'meaghanthompson', 'Meaghan', 'Thompson', 'meth0502@colorado.edu', '$2y$10$gJaIVd0TIJsHWamo63tOCuv1RlF0y/mLljUN2sJfXHeWpGXcVVeQG', '9493954204', 0),
(322, 'bassamii', 'Abdullah', 'Albassam', 'abal1781@colorado.edu', '$2y$10$rbLk3ERJUCVN8bLXV9lkROOImYuMOPqlHE11ZMbl1dEdie6iBk7w.', '7202923778', 0),
(323, 'Frap5891', 'Frances', 'Applegarth', 'frap5891@colorado.edu', '$2y$10$PXlNKFcYCTPW.eeyhDvR0eo5eAgYLjuP9d1FiZOykeNifawgSNYtC', '4156860989', 0),
(324, 'Psmall', 'Paige', 'Small', 'pasm9701@colorado.edu', '$2y$10$FpsaNzyUew/00QOEF8xqaOQj5PjQPIh3CT6MSXHZzMRbYSFLxr/ny', '7326938278', 0),
(325, 'AJGaccetta', 'AJ', 'Gaccetta', 'aj.gaccetta@gmail.com', '$2y$10$R71Ufs3rd7egKfxtSdHf/uHtTiJgxr/ZqY92rFkPZ5pIv7V4AYWui', '7206306291', 0),
(326, 'ablobianco', 'A-B', 'LoBianco', 'allo3329@colorado.edu', '$2y$10$ZmxqSeVL2jrSgy5rmfYeXeYpblytalfnUrEqNioHJahpmF92bRjS6', '9496483228', 0),
(327, 'Bpage203', 'Max', 'Page', 'bepa0041@colorado.edu', '$2y$10$ksxjQrOBUy8ZdraE2SJFPOt66e62IDcKBMx3g2vRei5Ls0bTEhnFe', '2482245310', 0),
(328, 'Virivarela', 'Viri', 'Varela', 'viva8647@colorado.edu', '$2y$10$SStjETfdDexw5SaOs7UDXudTzxuYD.2eV4Lp/rDJR/YkMNWura8bG', '7202387419', 0),
(329, 'Bregagliardi', 'Bre', 'Gagliardi', 'brga3962@colorado.edu', '$2y$10$UyB.AoN7sBFngks2uMDCbeSVhPCTaJVLKuk6eMgcYXnm7pYTeAwTW', '5616018344', 0),
(330, 'Resc2214', 'Renee ', 'Schnettler ', 'resc2214@colorado.edu', '$2y$10$GLoHkxs.gPxZcRWNKlpGdOBoZAJtnEkG6a2am/7fwUYyyZUZeGFR2', '3038172036', 0),
(331, 'AndrewFerraro', 'Andrew', 'Ferraro', 'anfe6566@colorado.edu', '$2y$10$hHS7S0YzJnNVpadTE01KrOWf/ieK1yG1nni6/nwm4dHEyOQmqEPYW', '3039120348', 0),
(332, 'marinekaufmann', 'Marine', 'Kaufmann', 'maka0950@colorado.edu', '$2y$10$BHhHLs/i/rIHg4t7rs7YSOkIXq28pUTLbZkThzUWeuEB7hQJD9eQW', '3059889643', 0),
(333, 'nerfOrNothing', 'Lauren', 'Daniels', 'lada0032@colorado.edu', '$2y$10$C47DrGXDHqKOm3Z23RUL9u4zbGjg88vbYDuEce88izLNNdqgpw6sK', '3035238157', 0),
(334, 'Saol2097', 'Sarah', 'Olson', 'saol2097@colorado.edu', '$2y$10$BwSxz3akM9fHHrn.J8zAwuT6nvxJ/wDnrJYWdWI4/NOtYcUENfe9.', '3038872250', 0),
(335, 'brli3504', 'Brett', 'Li', 'brli3504@colorado.edu', '$2y$10$Ykky147E1Ts8967Tyu0bd.yV6vK1CJUo8KfjmaWlNvwgoLP1QkVRG', '7192463376', 0),
(336, 'Dads', 'Felix', 'Chan', 'fech5240@colorado.edu', '$2y$10$3vl0AgXpf9m25jU/QRya6.QZZIWxytomZ585e/k09pBmPbrxlYG9u', '7202065487', 0),
(337, 'killA667', 'jordan', 'eee', 'josa0759@colorado.edu', '$2y$10$2ijilJBAXLr9sk1YbgqloO5bVgrQ83nqRvgmM.7bS6XwBb7lbEI5a', '6193026361', 0),
(338, 'CthulhuofMars', 'Nathaniel', 'Carr', 'salpsan64@gmail.com', '$2y$10$GIZgADkxFJScxvwQMmQNDOIritDQB8mfTJO2pjb2ozYJ0hJX02n8S', '6237557591', 0),
(339, 'Isaaczakin', 'Isaac', 'Zakin', 'isza5334@colorado.edu', '$2y$10$9FA70IpUjNSXuBt0r4c4kubaPjK6OYUwM2NxVkBqJl3U/un4aExJy', '2024076415', 0),
(340, 'Desu', 'Deshant', 'Karki', 'deka5129@colorado.edu', '$2y$10$RjfHSIn1y0j29hjZJJj3JO4EjWF.MPpeV8802YnZ9hMG8FKtQDOx2', '7202855811', 0),
(341, 'Kisa4985', 'Kiernan ', 'Sanders-Reed ', 'asako91299@gmail.com', '$2y$10$TqoJkF3GruAFP72ceHkQiOyNAG0gEdtAy02DC7yXsUwH79mc/tKsq', '5052214422', 0),
(342, 'Sabu5269', 'Sarah', 'Burns', 'sarah.r.burns@colorado.edu', '$2y$10$AHL6qAs//XZdDZihv8MpAu9veG/XK84eTW/.NoXTk1Kz2fEoybSh6', '7193379927', 0),
(343, 'Morgannegau', 'Morganne', 'Gau', 'moga2589@colorado.edu', '$2y$10$rrrJ9k/3CskBG2WRoVb.SuJy3i5yxOPPrVJUPvtz6OuObYA1gCR6a', '3036686341', 0),
(344, 'Brli6383', 'Brian', 'List', 'brli6383@colorado.edu', '$2y$10$LXmd8AlYCFD9Q47G7eNE0eVLKPP1T5mq2XmGvRoqSHdjodhGi/k8i', '9705894864', 0),
(345, 'thma4535', 'Thomas', 'Mahre', 'thma4535@colorado.edu', '$2y$10$93ugvHQm2.b0NBSgnjXdgu1z.0C9XE2LCJeQoV4HO2FPGdyVQhWx.', '9707731243', 0),
(346, 'freelancer99', 'matthew', 'spallas', 'masp3836@colorado.edu', '$2y$10$xAu7VmjtM8h7Uv3AfuogYONx2KoFEO8c4mqfvYoHflatrc3u3Yqqe', '5105797516', 0),
(347, 'Whatsnewpussycat', 'Lucas', 'Brack', 'lucas.brack@colorado.edu', '$2y$10$CcAIMgm6lcSzrlB4B/mP3.lqIewsdyzB52zV/5pS1ns.OvUjRrcCG', '7202613695', 0),
(348, 'Bobross', 'Elijah', 'Pettet', 'Elpe0091@colorado.edu', '$2y$10$LR.ibsue5TD4cJMF0sHt0euScs17BcCXcLxPYHpLlTrvTiS2G7bRK', '9709488474', 0),
(349, 'Numbuh23', 'Gavin', 'Zimmerman', 'gzimm4@gmail.com', '$2y$10$3bOI6kyqwImI5441R2P2CeEopD6rgI3PseLqvuzJHdIGHfwXqV4B6', '4356596998', 0),
(350, 'Ryjo', 'Ryan', 'Joseph', 'ryanjajoseph@gmail.com', '$2y$10$BZCq8VfLkGkWxky/pIisC.MPWqIinA.zk1arB08sUkn7z0od1c4.m', '6177809990', 0),
(351, 'Lightning_nerd', 'Thomas', 'Maeda', 'thma1325@colorado.edu', '$2y$10$ugRbTEQRXrx7WWVFso6iy.2oF.UGOBMCsYL3uxQooCrTX2G8pc69S', '9704081507', 0),
(352, '7DaysWolves', 'Sophia', 'Ulmer', 'soul7588@colorado.edu', '$2y$10$79yBEJ./vBwPWIvfLmo.vOKsUTDsXIK5xnMC8qa.H9PFhBlBwtsKq', '3036565621', 0),
(353, 'phinny43', 'Phinny', 'Negash', 'phinny43@yahoo.com', '$2y$10$5J7LNjLwls0uco1k2k5jK./dIQosjqrvNszvzg8b5ScLvhnEvxkx6', '3039998846', 0),
(354, 'Imoutohru', 'Tohru', 'Dutro-Maeda', 'bozephanlo@gmail.com', '$2y$10$2uMSX89vYujbW0EKGLR8y.3cy6UZt/UeeG6Ry0nUGs45gNHTc5UL.', '7204135678', 0),
(355, 'hutr4516', 'Gia', 'Tran', 'hutr4516@colorado.edu', '$2y$10$KhfZferm9uUkER6ZKkes1OVGJePXe1qO5tKDSqjPisMtD5xCdk.GS', '7204010728', 0),
(356, 'alex4968', 'alex', 'champion', 'mach7619@colorado.edu', '$2y$10$RHQOnkokjD1F7NY5vNGlf.CH8CgOISFDPw7Rr8bg8J/XGmf2WSzCS', '7194539800', 0),
(357, 'benjamin99', 'Benjamin', 'Carew', 'elca2630@colorado.edu', '$2y$10$rGMSue21vl2De929NzfgU.ton/Ol3cf7qG8QyR4./09bnj5bdYlJ6', '9108034145', 0),
(358, 'orionstars', 'Orion', 'Rozance', 'orion.rozance@gmail.com', '$2y$10$vicE1twnNHRaRRcx5ZYH8uF.eT8lfth5iY..BEfQ45HbqGKoAM7KS', '7206284409', 0),
(359, 'randomcory', 'Cory', 'Mundt', 'corymundt24@outlook.com', '$2y$10$4LY/m/fT6roTtU7uv73rk.uMhVeTAywwO5qGlewwqDZCOvniNmZde', '3032492932', 0),
(360, 'fskhajah', 'Fatemah', 'Khajah', 'fakh0593@colorado.edu', '$2y$10$Qd.NlpT3qi0.NQDjvPGyNefN50CcDhSkkL6k.mMArKsdXZAzzLID6', '3038038908', 0),
(361, 'TalalKhalfan', 'Talal', 'Khalfan', 'talalk@outlook.com', '$2y$10$HXjgx8pLTt9Jpg/Yx7AvUO4oNCMwFGARcltAwrOn.p/XGNCUMt4vu', '7205197898', 0),
(362, 'faal9208', 'Faisal', 'Al-Qattan', 'faisal.qattan55@gmail.com', '$2y$10$XG1lfy1R/QtTs7vojEVwVuIhrQLl1u.RX3Quqfp1qZBOFvsuFr9G6', '7202999417', 0),
(363, 'Jefferson', 'Jeff', 'Pincus', 'jepi0026@colorado.edu', '$2y$10$Gwbq1geA.ycvZlmx24WUDuVQR6B4c1rDksUl34twEC9mnoXsRXNLe', '7046121945', 0),
(364, 'soyboy', 'Liam', 'Cairnes', 'cairnesliam@gmail.com', '$2y$10$LmbZzHMGuwWLG.mC5L5WlOvo2JzPRMn06ykwfr0FTTNaSt5nuaHR.', '9726556686', 0),
(365, 'Shelleileigh', 'Michelle', 'Diller', 'midi3532@colorado.edu', '$2y$10$/FCuLlCUdLJPf/lDFcT7Ke7logbEWvNSrCaUR0ojzKQRm.j/BUbJS', '3038416182', 0),
(366, 'Kaitlynhval', 'Kaitlyn', 'Hval', 'Kahv7616@colorado.edu', '$2y$10$Lne/54hiSAeuqsbhQSJlTuPAkScmFBGBnFnyB4P9CUmRSeqBeKaIK', '7202447503', 0),
(367, 'Mayagreenstein', 'Maya', 'Greenstein', 'magr7328@colorado.edu', '$2y$10$IhMOPysklPkcDAxgKrzSiOB9JkQHwEMokU9.csqy1byBoMvY1yHN6', '2016933807', 0),
(368, 'Talal', 'Talal', 'Khalfan', 'takh3745@colorado.edu', '$2y$10$r.YHxDHY03eRWULcMqldDOR2tFoyJjLox72fFALWBMiBzGE6o1cU6', '7205197898', 0),
(369, 'PartyFruit', 'Phaedra', 'Curlin', 'phcu2335@colorado.edu', '$2y$10$NSmPZUGnKp/Oktb6OMnWiewc9u8Mtpkuxsx7Xcu/YZcprI6AAJFvm', '7204868399', 0),
(370, 'nativekhmerican', 'ADam', 'Grabowski', 'adamlouisgrabowski@gmail.com', '$2y$10$.y3EG17WDKrZwCv2lq4OyOtl489mwTXTKZKK7mUFuS55wbC.GZDJW', '7205392043', 0),
(371, 'SashaK', 'Sasha', 'Kryuchkov', 'alexkryuchkovlive50@gmail.com', '$2y$10$KrDgRLYjTzgAlC/4n8R.1.hhc7uqtsgk1Z6v0Y3Y0geifFmzy5/N.', '7186500037', 0),
(372, 'Jusc8836', 'Justin', 'Schroeder', 'jusc8836@colorado.edu', '$2y$10$9i8Po9h5Sm/T/UUfQmYNzecA90Y7xYgIfP7kGCu1UEzVHI250/MIq', '3035960971', 0),
(373, 'BuzzKillington', 'Kyle', 'ONeil', 'kyleoneilz@gmail.com', '$2y$10$/fA1M0brNCihdE2xzJmryOnvWfNzxeXk.mNukPxNwwYGTyZFjYp8a', '2233409073', 0),
(374, 'jaho7942', 'Jack', 'Holland', 'jaho7942@colorado.edu', '$2y$10$PR7KkBpvggA6Hr9VhNJQPe5PLBw2GAy6GmTfksFWDr1p0OvuRCUku', '7203608625', 0),
(375, 'kapl1914', 'Katie', 'Plain', 'kapl1914@colorado.edu', '$2y$10$q0JC0b6/i8GNan1dDZNbw.aNVKDk4NLGRVtntFkgm/f1lcUgTlRw6', '4144773527', 0);
INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `phone`, `clearance`) VALUES
(376, 'Brendan', 'Brendan', 'Rishavy', 'br031000@gmail.com', '$2y$10$/flXlAzw3X/ceh7oiB2xjOCdBkOk2RAxyHJEU7K6jT8krc2RKle2W', '7192137347', 0),
(377, 'ButtMcFuggins', 'Jeremy', 'Lamb', 'jela5842@colorado.edu', '$2y$10$tkJuETAY7wi.XZ4UtKwH5.KxFhU8VkzWXmBq3WrObDXO8ZR56NbH2', '8189669827', 0),
(378, 'Rosco', 'Thomas', 'Adgate', 'rosco.adgate@gmail.com', '$2y$10$gk8/ugJJ39H1iAMIeG3jruep9Zxzfot6SkNCPXahbuzVaFECeXiIm', '9704567997', 0),
(379, 'Davidkoon25', 'David', 'Koon', 'dako2807@colorado.edu', '$2y$10$VAYDAvbaRkBz8SKSqYxeDu2m7puGfa8HI2mAV0D.KcGzP5NJETj3S', '3035472111', 0),
(380, 'Calebhanson', 'Caleb', 'Hanson', 'caha9531@colorado.edu', '$2y$10$9UbSopXwqSrm4whr2HkkSekN2UhGeBEtyZJHLezRCTt3bj1l.PcyW', '6508049249', 0),
(381, 'gabriellalettow', 'Gabriella', 'Lettow', 'gale8501@colorado.edu', '$2y$10$eAXnjUbD2BzYg9nV9ZjnAOshdK42EMSDP1HtuP6bIUHBaDhjT2Coq', '3037753017', 0),
(382, 'Brendanmulcahy44', 'Brendan', 'Mulcahy ', 'brmu1856@colorado.edu', '$2y$10$eIDxHgs3wmU5bwilCZtlTuyUoiEPQJIz0ttttYZRVlPgvtQNrM9/G', '9499030163', 0),
(383, 'Kabe1130', 'Kayla', 'Berry', 'kabe1130@colorado.edu', '$2y$10$TTN1NshGoUwAyQbGXWvrp.ToPpWzvjwe89l2JyqYi6zCn88KDrK16', '9702611586', 0),
(384, 'Nol7333', 'Noelle', 'Ireland', 'noelle.m.ireland@gmail.com', '$2y$10$grGCPkQNud7LMOmJrfJvmeXXreIZKhwdjM3s9M2d7Bb8v5IFRK0fK', '7209756941', 0),
(385, 'Patrickmaisto', 'Patrick', 'Maisto', 'Pama7339@colorado.edu', '$2y$10$RLHFWWRvX2SXDsqze6DG..uAFltYqxDrRYyJt/ip.CLP7TkIoSPzW', '9084337337', 0),
(386, 'frank', 'Franky', 'Borges', 'frbo5265@colorado.edu', '$2y$10$LnIk50URU.L84ytVklc5.ObfPX.RdV1Q2cwm9bOWokqsDYvS1ptI6', '7737338017', 0),
(387, 'barkode', 'George', 'De Marigny', 'george.demarigny@gmail.com', '$2y$10$lR/ynELmUkcTRIYXnJ/qF.GDXqRsqPFhlll74dlhEyfGbIvAzcMKG', '2108626051', 0),
(388, 'Westwood', 'Westwood', 'Sutherland', 'wesu2739@colorado.edu', '$2y$10$0VzOFIa.v1f0uofvMINwtev6CpDr0M18aC4VAQ/2JJF5RT0s1xTe.', '2032288861', 0),
(389, 'Jeff', 'Reid', 'Teren', 'rete9290@colorado.edu', '$2y$10$ET8pjZpy8mXczBUB7Jpziu9nd3AZY5SinvnnaJEr4BAvxVyrP/qMi', '3102834010', 0),
(390, 'PostApocalypticPythagoras', 'max', 'sherwin', 'maxsherwin12@gmail.com', '$2y$10$ME9I23z/z5VprYbmLJhXX.iPKx/2mAYXYjWiUWGmd/AFpxWWdKmnu', '2165432388', 0),
(391, 'Zachm22', 'Zach', 'Marks', 'zachlmarks@gmail.com', '$2y$10$4tyR8iFCpCkPEOGnLlRSeue8LH6vSeXDX1vTe3GcPbLIGUPo396eK', '3107406536', 0),
(392, 'JaredKonigsberg', 'Jared', 'Konigsberg', 'jako3362@gmail.com', '$2y$10$IBeRFG7gDLAOpfh0RQf.iOlPXhqcLPQPjegKgOKXPSAXexpaYQZ9.', '8474774032', 0),
(393, 'c88borus', 'Cameron', 'Borusiewicz', 'cabo8693@colorado.edu', '$2y$10$2.dLory6ztW9sAnCdsMFDu9NKyf/Dizfr7lgzXS7ft3s7akiLHY7O', '2156224024', 0),
(394, 'Brh0504', 'Brittany', 'Harris', 'brh0504@yahoo.com', '$2y$10$JgFbQ.2Ya05pZ/Ct5krTZucZiTY0CQVzsDyVpMhAqFXUuNZWo2WDm', '5052058199', 0),
(395, 'Oaxaca', 'Mitch', 'Trahan', 'mitr9556@colorado.edu', '$2y$10$7CAd77vSmRt/dsKmFcRra.Zi2DSbFCuhQ464irvJ931d1evsIgPWS', '7194596562', 0),
(396, 'BEANS', 'Leanne', 'Rubinstein', 'leanne.jgelrub@gmail.com', '$2y$10$/BxuasbDkMYjEPSvYWLjPO.55WhCHUbGPcy1Ns.m7K01nKaeYTFOi', '7192092509', 0),
(397, 'Kahshmick', 'Kyle', 'Neubarth', 'kyne7959@colorado.edu', '$2y$10$ZwLkS3M.KCCyt3deDBOwwekoMhPteGDeXV78E/hEiEBBLD084QZPS', '6506860616', 0),
(398, 'bbiancadd', 'Bianca', 'Dibbern', 'bbiancadd@outlook.com', '$2y$10$3LduwNlAq/3hzeYDl1fKeOp9iO/ldYUTdx8L32OBFrrkxrhw4bQL.', '3214272063', 0),
(399, 'nona8035', 'Noopur', 'Naik', 'naik.noopur13@gmail.com', '$2y$10$UvoCKZQuwfDl3/SukPHN3OiDNAG9/yaDCMj2Oe10ygKg7Q3Ty2lHG', '7194251494', 0),
(400, 'Garrett', 'Garrett', 'Roerick', 'garo6689@colorado.edu', '$2y$10$vJ2eMUWNwPDcbBcT0gva/.HOB6J3RqVeE0k3Ywfw8NkbVp482PvdW', '6184022220', 0),
(401, 'alexmeldrum', 'Alex', 'Meldrum', 'alme4959@colorado.edu', '$2y$10$2Edfykh9x17TyOlH2e.kP.yw97vAh8OYZXCA3kGG62IQD1iIr6wCS', '8103916908', 0),
(402, 'Mani2257', 'Maria', 'Nino', 'mani2257@colorado.edu', '$2y$10$h/O2vfjY3M/hQ2AU/bPAneBjdptAFcFHC4g4s8NTZs5zZwIdFvx1W', '7203090661', 0),
(403, 'moke', 'Galal ', 'keshk', 'gkeshk@gmail.com', '$2y$10$Ljz0.DbsayumznuiP07n5uxzgjhSRcLRdnPMjRPtFKd/5ilSjqzAe', '7033626611', 0),
(404, 'skywalka', 'Luke', 'Roberson', 'luke.roberson@colorado.edu', '$2y$10$/PKGvbCOG4vlgbfW72k1NOK4p8HO7AysQKJ4id9K5sipC5SJYLgHm', '9139059442', 0),
(405, 'chbe3912', 'Christopher', 'Benben', 'chbe3912@colorado.edu', '$2y$10$NZCF29aT/KE4L5w3bndBF.o1/IExip9iie.IbP837cnEG3Y2GDTrm', '9148261202', 0),
(406, 'RiFitz', 'Riley', 'Fitzpatrick', 'riley.fitzpatrick@comcast.net', '$2y$10$c3ZufQcUtwM7WBT50Ht3Me7Rb49BDxT767O8Usm3zMvD.TyK2oHZy', '3037259009', 0),
(407, 'FitzyP', 'Riley', 'Fitzpatrick', 'rifi2703@colorado.edu', '$2y$10$4VfdFvnsKvTSdH1h4Y2QYONW1RPSVt3AvCqbkGAc4u3ip5Bigkgdu', '3037259009', 0),
(408, 'TheMonster', 'JAKE', 'HUGENBERG', 'hugenbergja@gmail.com', '$2y$10$84fcNZMTKH6mmUZ635GObewVu.lIG5rnZfb/qBCndTjBtxGxIdZdq', '3038868877', 0),
(409, 'kevin', 'Kevin', 'Kuptz', 'kmkuptz@gmail.com', '$2y$10$27Wy9Afci3WSU.7AlA2GDOZzEecbd45qxMKi5rcMelJxIdtdqvwNm', '9256833462', 0),
(410, 'KrispyKreamPie', 'Ben', 'Goldsmith', 'bego9298@colorado.edu', '$2y$10$Lffi6cfmLM.2I9UTh9ZaouqqmZJs38hk1JEQjL9wZY6p0VqKhm6h6', '2395710101', 0),
(411, 'kjaiserlp', 'Laura', 'Kaiser', 'laka4851@colorado.edu', '$2y$10$YE5m8plkaOVZc/BAGIy4jOEGjCxavLgmPS/cOKRiMZhOW38AnEPhO', '7203630928', 0),
(412, 'jackspicer', 'Jack', 'Spicer', 'jack.spicer@colorado.edu', '$2y$10$owOoqePJO3trwn7rX8G.TOwtMzreP5.JP4CEXRepi3K7YYccwyn3u', '7205325122', 0),
(413, 'Lingling', 'Danny', 'Guo', 'dagu8740@colorado.edu', '$2y$10$htDYDHOllEyv5D1hnvDbGOc4quy8nD/n5XJ9o0SbaVOmPhfGG02Ou', '3343328515', 0),
(414, 'chbr4046', 'Christopher', 'Brown', '28thlegion@gmail.com', '$2y$10$yV62NAPCWncdFRkXDdcrWehbeGyV7KjKB/PEp2kvG2tBkagfqK7hW', '9704859381', 0),
(415, 'Choate11', 'Christopher', 'Choate', 'chch9991@colorado.edu', '$2y$10$HMYQvH25af94OXjeEX6BhOP6YEd1XzyRr.Wl33DJ3ShLjlV.mEAry', '5099513118', 0),
(416, 'Jwarren', 'Jamie', 'Warren', 'jamiewaski@gmail.com', '$2y$10$yBc1fi2.b5joLN5b.PUKneyIjm24VGILPtt6.Gfiy3itdWya9wj0m', '3032148188', 0),
(417, 'Aric', 'aric', 'mccarty', 'armc8346@colorado.edu', '$2y$10$Y7oj3vRpYaiJhY7rndh3FOLgY013dnifQU18mCM2isE.c0X2a6wOa', '5739995188', 0),
(418, 'isabellelavery', 'isabelle', 'lavery', 'isla3747@colorado.edu', '$2y$10$poGy0a65zZFSoT8UZIztkO8w/LITEJCxTrHnv1ba2npp2A3.pdl72', '6507409244', 0),
(419, 'Meximo1233', 'Zachary', 'Younger', 'zacharyyounger@gmail.com', '$2y$10$8pceZtI820aTqaVFU0eDAe2f.FPX8EMJQjfwzDKHCSkaRPWbK5QLC', '7194249494', 0),
(420, 'ajberry445', 'Anuja', 'Gore', 'ango8123@colorado.edu', '$2y$10$88xvw/IGaWcR2NuvjZHZrOhNfqP/Ik4ujVoy2DkEJ2Dqkq7umbQX.', '9704492336', 0),
(421, 'Luna', 'Isabella', 'Luna', 'islu0754@colorado.edu', '$2y$10$uca7Ip1WD71YhJzbEiGVSeVj9q/J9p18/1x2dpUqKYJ/eMRCQNQuS', '7202753008', 0),
(422, 'dewildchild', 'Jacob', 'DeWild', 'jacobd2340@gmail.com', '$2y$10$wb/nPs21mDwWlTnW5U4PLeZenGbWgF57rQ8haYjkciO44Oyxw9iem', '7204403091', 0),
(423, 'MarioBrah', 'Mario ', 'Hanson', 'gmahanson@gmail.com', '$2y$10$YoVG0SNkTHoaJRC7le3rJuvgr9xJrfJKjy91waFegkJ/zRWwnsFWG', '7193231273', 0),
(424, 'T-Bear', 'Antonio', 'Feula', 'anfe1742@colorado.edu', '$2y$10$97PL4B5DoPMcgSEmPbQQwuMjM85meQLWAH8nA/TkG6agBTVQm5ArK', '7206849041', 0),
(425, 'WillXue', 'William', 'Xue', 'wixu0246@colorado.edu', '$2y$10$hRAZ9z9f1JMQIb9LcBy/9ODl7.IYqDCHBvZ1JQ837OYZdtfyJPngq', '7207257045', 0),
(426, 'pickettmap', 'Mikayla', 'Pickett', 'mipi6515@colorado.edu', '$2y$10$DBDy8g.MSgqSxT2BMb7aCOo/RSs0dXhLMbe4M0xpNDXRtyueR5zwS', '3309218096', 0),
(427, 'TheLegend27', 'Jacob', 'Toray', 'jacob.toray@gmail.com', '$2y$10$D8ipSFeRBSxrlUDaNboNo.GTukFxq9ai9zz3nH1ungJ36op5gYKR.', '7203183207', 0),
(428, 'Cinnamon', 'Ethan', 'Cohen', 'ethan.comjaycohen@yahoo.com', '$2y$10$iomtOiBEIc2lM6drsp1TWOpGkX5CX/Lr/cyHD70fu6m9qN7ef.W7m', '7203439756', 0),
(429, 'Cinnamon292', 'Ethan', 'Cohen', 'zipo116@yahoo.com', '$2y$10$aQaBALf6FFxWiSOwqcQ0U.rHvNfs0awXd3xYcFMFZb7PvSDirlm5O', '7203439756', 0),
(430, 'geofish', 'George', 'Fisher', 'george.fisher@colorado.edu', '$2y$10$aTu5cSIM8WMVhoB8xV4elulSHURWsdlUClE9Peal6WkyrK0tiCxva', '6505189246', 0),
(431, 'aleixlyon', 'Aleix', 'Lyon', 'ally3917@colorado.edu', '$2y$10$w9.66h3wuuz/fRvmKyuyAu6btxly3JlAT7LwpeeabC2I71c/gohoa', '3034371788', 0),
(432, 'Tjovanovich', 'Taylor', 'Jovanovich', 'taylor.jovanovich@colorado.edu', '$2y$10$TdO9fJnl47T0t/vv9uTdPeG4MmEwRKShNFzbHOaSDsvHZbmMCQRlq', '3032531435', 0),
(433, 'ConnerJ', 'Conner', 'John', 'sleepybirdcj@gmail.com', '$2y$10$1/egTJdj9BJ1gzB0P.3ySe8bEdffvBpcxqSJFUf5oBmYDncvOvoNG', '3036385268', 0),
(434, 'Carlybennett', 'Carly', 'Bennett', 'cabe1223@colorado.edu', '$2y$10$tBfgc91SQ6dZ1v5VhEKvzewO1gPVePyTMsQIhAPePWIjffWjhgVRy', '7203349597', 0),
(435, 'tesssssss', 'Tess', 'Richey', 'tess.richey@colorado.edu', '$2y$10$cm3/SrfVvMDozmhfL7Jk8uwHT5Fj./IRHveWFvXTxzHLVNR32oPdy', '9708192214', 0),
(436, 'AnaO2008', 'Ana', 'Oldham', 'Anastasia.Oldham@colorado.edu', '$2y$10$Q/yqfJVqnHYhNmRC9Fc74Oswidpy17v1xRmDXIeAE.KaI5js49mLK', '7203880432', 0),
(437, 'asandridge', 'Alex', 'Sandridge', 'alsa6908@colorado.edu', '$2y$10$iB.8RIa3i80DDUpTlYya6ewkM2THho2y424giTKuGJgckjlR.3EVm', '3033301197', 0),
(438, 'bluurrg', 'Alex', 'Chang', 'alch2627@colorado.edu', '$2y$10$IJ9kVZBxXl1BEBwGaJfTfekytChe1xqarrzB9T2GxaQjNNRWfYW4i', '4157125260', 0),
(439, 'Briguy', 'Brian', 'Farrar', 'briguy18f@gmail.com', '$2y$10$fhAPt.8FOd2fZKix3dJMeu.KxbY1hJ7MqKtrCD6Ik7hTgaLPXN3YK', '7202205925', 0),
(440, 'D3v1ld0g', 'Brandyn', 'Blea', 'brandyntblea@gmail.com', '$2y$10$fo2I1y5bcdgJqeUKiGOzC.S7SvUCkzjEuxwV2LENWQjwtRvP7tjUK', '3035236657', 0),
(441, 'BigPapa', 'Matthew', 'Faust', 'mafa7413@colorado.edu', '$2y$10$TFGBD6EADKzHMYrrEzM2Ae6h5Se5YilZBRJRmWbThqNizo2hTS5em', '7175253187', 0),
(442, 'row2019', 'Rowena', 'Uwizeye', 'muuw3692@colorado.edu', '$2y$10$OsGvvwLVmwoxH/n4mJGxg.A4s42ARt7cBg9Hi7FNxDnW6HCwYIzzO', '7205325476', 0),
(443, 'cthomson', 'Caroline', 'Thomson', 'cath4793@colorado.edu', '$2y$10$z2ojDph2tMJw252gcBpYfulkOPsPrGgUkNNw.sTRPAuovJ/ehP89u', '7202801552', 0),
(444, 'Bairdude', 'Matt', 'Bair', 'matthewbairr@gmail.com', '$2y$10$iLlGZUPhCzDL0W38t4M6a.PrGUMjj7qcolYGGWOnvSpXZUsbMBZLK', '8143863897', 0),
(445, 'zesu0094', 'Zengda', 'Sun', 'zesu0094@colorado.edu', '$2y$10$OtEI7XccmyUfc/nAjAYr7e021CYKQnJPehlEtY/lGPdGB.DkdVemO', '7209035131', 0),
(446, 'PlanetaryMax', 'Maxwell', 'Panetta', 'maxeatstacos@gmail.com', '$2y$10$e9Ac71QnGBnTgRKUuqDRT.Z9Qkp/v4qOhbL4y1zyYIC08qDBESvuO', '7072102894', 0),
(447, 'kaka', 'kak', 'laura', 'jadnana50@yahoo.com', '$2y$10$SwibEUhNIXJ2mSHJ9uhmie8aW7K/TIHg7IGUJ5OtzM8iUKSte8UES', '0671445187', 0),
(448, 'TheNerfAlchemist', 'Connor', 'Britt', 'connor626britt@gmail.com', '$2y$10$MH9adasctPSmfwKaUcFhrO375SFK6uQSR/BhFi17hPoqUin6pbC4C', '8175059949', 0),
(449, 'oleasjuan', 'Juan', 'Oleas', 'oleas.juan92@gmail.com', '$2y$10$H8aIO05WeaUZQ82reXtxKe88pszlyNTW9.PQtaPGpuahBXVUZS/yi', '9546639390', 0),
(450, 'Jakpattamasaevi', 'Jak', 'Pattamasaevi', 'jakrapongp@gmail.com', '$2y$10$uZ/OyOXynW/KPttMcMW1veON1BjOT05XpmEOry9ahtoKckrvwjfhm', '3033301117', 0),
(451, 'Gh0ul', 'Samuel', 'Flowers', 'flowersyoyosj@gmail.com', '$2y$10$H/mpQEiDa8W859BbJqhXfeTrDN6m1AINtcYzIuG5Hi38e3VzNTWNa', '7196605497', 0),
(452, 'dagr2622', 'Danny', 'Griffith', 'dagr2622@colorado.edu', '$2y$10$lCoiIJhAv23R/2UdXR9ZIeszu0e.SyTTBkefVonC/hC4RuH5GOzfm', '8605101068', 0),
(453, 'BanhBao123', 'Bao', 'Nguyen', 'bang3478@colorado.edu', '$2y$10$MXVk3Kj9NH7lKUSmnXLhNOXsPU0jwGgZ5l4cOpCUpYYtJ9b5zjw0G', '7205795728', 0),
(454, 'Bao', 'Bao Phuc', 'Nguyen ', 'bao2722@gmail.com', '$2y$10$Sh5n4S0v6DxmaBKmsVymAeKc/la45/V3viKTEFhQqyqoVm8fooEpa', '7205795728', 0),
(455, 'joeatspizza', 'Lawrence', 'Cohen', 'laco6897@colorado.edu', '$2y$10$m.SxPbPUYNyEUr2iXT/Ye.4QHBZEkc8E.nFjJtvG8rUm/hrEmufOS', '3036188318', 0),
(456, 'scottscheraga', 'Scott', 'Scheraga', 'scottscheraga@gmail.com', '$2y$10$.GMrzv6loCwVzid7aKZSJ.i1.nOWhxWg.4jWjihAlR7QQmDRnh2rK', '2014216673', 0),
(457, 'anyavallentin', 'Anya', 'Vallentin', 'anva4669@colorado.edu', '$2y$10$vPGYLtDdgihH4WfLA0C1t.GMOwfG7AGgNVTMlpjBa72N5cWUEytBu', NULL, 0),
(458, 'LucyS15', 'Lucy', 'Steed', 'lust2939@colorado.edu', '$2y$10$G7TBPp1o9xvBvoduETb3NeSdBvXe3K4BxbSHuvyLTbmHOxoHVIpv6', '7206962332', 0),
(459, 'ConfusedCourier', 'Tyler', 'Morris', 'tybo@q.com', '$2y$10$Y9uFFScEtW/TBlNMToK1c..X7Ql6Uw.sjGSKzBme6Hpn/Dm5I0IuS', '7193310645', 0),
(460, 'Madelynalbright', 'Madelyn', 'Albright ', 'madelyn.albright@colorado.edu', '$2y$10$744zFQCC1JWQrfMs8CJ2AO0EHjDFUzWzD/.No6oegWXf.3Jzr1n/m', '3363926996', 0),
(461, 'clha4473', 'Clifford', 'Hardin', 'clha4473@colorado.edu', '$2y$10$ly7CnPCT3kTn3Vg2EaKt0.OZ.sT0EAJqMzDKbx4j6r0VICyVeIcW.', '3147754007', 0),
(462, 'TalaV', 'Tala', 'Vicknair', 'tavi7698@colorado.edu', '$2y$10$8Qeyid5pD.zDGl1kzNTTou6y4EeF.W43bZdsNQVdSTAr.AF.CYz7e', '7193235823', 0),
(463, 'DanielBoiko', 'Daniel', 'Boiko', 'gorinich555@gmail.com', '$2y$10$TplYqkH5bLj2n6d67WhXNeDNiDKphz7pdmG0O.P9svMJdoVysLFAW', '3033305542', 0),
(464, 'LisaLynn', 'Lisa', 'Amore', 'liam7199@colorado.edu', '$2y$10$iZ/2HbdIQSCw4AUc7.FSZe5OCNm4X3wGrc2ydOPPL/uXoYhd8ySsG', '3059032885', 0),
(465, 'DomDaBomb', 'Dominic', 'Lee', 'dole2690@colorado.edu', '$2y$10$BaJWdWxxomfPnQnbUas12OS105Z6VPbzj6AqwqrfQ2PBrjyPuduAy', '7209854508', 0),
(466, 'abraheem007', 'Abraheem', 'Abu-shanab', 'abab5755@colorado.edu', '$2y$10$/3lWOZaIo3zgMZ4i5CCpsuctN7ABq.BpkP1x/je0nGvZPOSwS.OsO', '7637030483', 0),
(467, 'dwysie', 'Emily', 'Dwyer', 'emdw7672@colorado.edu', '$2y$10$7CYaT5C4vCY6iMcGAK5sm.l09Nwg6737wRlo71P4cnecivgSSF0P.', '4155727739', 0),
(468, 'Sarah', 'Sarah', 'Koppenjan', 'sarah.koppenjan@gmail.com', '$2y$10$MrhBQs/iSepzz82kE20aqeld0WeiToPOhhIQdLtpv8Y.6WQeYxpKq', '8058869977', 0),
(469, 'camo7370', 'Caroline', 'Morrison', 'carolinecmorr@gmail.com', '$2y$10$5zlseg.135dLz3GXCRq52O8t0arf9v4c.di2HlJpfJ203x27zJb9W', '2185769508', 0),
(470, 'adra2698', 'Adam', 'Ramirez', 'ramirezadam513@gmail.com', '$2y$10$UxlzhRl6525zGKGViDVn1Op6M3GkGNbCf3bCSiinUj82FJrytK19m', '3035876582', 0),
(471, 'maes4595', 'Martha', 'Esparza', 'maes4595@colorado.edu', '$2y$10$0lLNZy2SttfJFJM.sK3EaeUrrohqbevb4KAI1SoBDQg4ieC8lN3iq', '9709873102', 0),
(472, 'Luc', 'Luc', 'Bollen', 'lubo2884@colorado.edu', '$2y$10$BquXgjvoC7ZWHGRWSNDeieR.RodIAmdVuJeJbTwaPBmRSXLoKIJ22', '4434660647', 0),
(473, 'Martinibomb', 'Martin', 'Allsbrook', 'maal5844@colorado.edu', '$2y$10$t/2XX9WNpnVkOPPNeqGn0.gubJjszZ6wle.ABPfdd/yvOxXuj4AxS', '3232046868', 0),
(474, 'AHavi1', 'Anna', 'Haviland ', 'anha6516@colorado.edu', '$2y$10$469Sbi9a8gUnsAE0plXeheXUKre0DtcrWHYNjX3sYiaSBSYhsfNOu', '7202451816', 0),
(475, 'TheBeau', 'Beau', 'Shaw', 'besh4317@colorado.edu', '$2y$10$td6FTDzeak8d40cXUx0uOuZnUXt8ZdWWxGxOXh42P7H5N15vQ7xs2', '3035914888', 0),
(476, 'Major.Tom', 'Tom', 'U', 'thum3835@colorado.edu', '$2y$10$BYtJSnN7vXaxMFYrt3qESu5F5/GKqdUsRrvuTuCkhqlqraM/ZbW8G', '3037750524', 0),
(477, 'Gnatty-bug', 'Nathalie', 'Costello', 'natcostello@gmail.com', '$2y$10$HzSIC4XLyn.ON1B7UG12Be18BD3WHbZi48ld2nN5A//W3WUQ5rPKu', '2812454934', 0),
(478, 'Critter70', 'Lauryn', 'Crittenden ', 'critterlc7@gmail.com', '$2y$10$wB87BzsOJFtee0rv2ytGaecoMvk5wMyvOjW09rq2OWun8cPsy/RGi', '9704153580', 0),
(479, 'joch7841', 'Joreen', 'Chua', 'joch7841@colorado.edu', '$2y$10$2dRlxxI8/r4QlAGJh0F/vOo3D50cy.2roGcUnyjC86S2yEiXBSygC', NULL, 0),
(480, 'ekab', 'Ben', 'Courlang', 'beco3052@colorado.edu', '$2y$10$jyfrWPaAFMqnvTuso.bPzuAhdiHe.82KxTeZk7g0PYxhEY8lTw/Om', '4153186483', 0),
(481, 'Greencat9', 'Nicholas', 'Layton', 'nicholasanthonylayton@gmail.com', '$2y$10$jT6S3McpBPBlHNS0KMx4fO.qP5iwJhsNeIRb2LIpcIvgDkvvjegVa', '7196506192', 0),
(482, 'HoodPope', 'darryl', 'cronon', 'darrylcronon@gmail.com', '$2y$10$GusUWxcQWRvkwakd/ZAQxOW2nL3RHbhsh9Nphdl44wTJcoqNyniqS', '7209792299', 0),
(483, 'br247', 'Brianna', 'Sondakh', 'brianna.akh@gmail.com', '$2y$10$UW2ojvh76yj0CVYr6tSwBO3poMT10PPkIatpR8KCMUXrTz1aV9uk6', '7204129717', 0),
(484, 'HYEHN', 'Hayley', 'Hong', 'haho9581@colorado.edu', '$2y$10$wUckGYc58Z9gnCDffq6dqezweQWHBEXzYl9Rgcijl7WFC4E1ZXxDy', '2137001824', 0),
(485, 'CaptMoistFart', 'Hunter', 'Reichers', 'hure3435@colorado.edu', '$2y$10$BJECvzrosAAmFbV0MmPuWOjsXJ3jo2oLK0dBufPGqnzySKBB0iQ76', '7202347028', 0),
(486, 'daniel.loewito', 'Daniel', 'Loewito', 'daniel.loewito@colorado.edu', '$2y$10$RmZFm7Ef6ApIMYXHEIEC4O6Q4.BgwtePSh90f1TypNgF1p44v/Dbu', '2063711587', 0),
(487, 'anna.benerman', 'Anna', 'Benerman', 'wheretofindabenerman@gmail.com', '$2y$10$bEleRU.elERogOsnukhGB.yms.0UNy9zFMnd1WYnic1s6q8hmZZUu', '7208797047', 0),
(488, 'robbayy', 'Robert', 'Hellums', 'rohe5584@colorado.edu', '$2y$10$thQw9/1uhheISsLy.eM.XuW8gmBc6FxTE5SEYSjve1cd47bi.ySSO', '7138706139', 0),
(489, 'PraisedList0', 'Alex', 'Hersch', 'alhe0529@colorado.edu', '$2y$10$uIUpwgpZZ1qvLbiasXzi8umPp6.C549sEDp8F9tTdejTL0Ly2IAEW', '9085789901', 0),
(490, 'master864', 'kangmin', 'kim', 'kaki5229@colorado.edu', '$2y$10$9sOjNDUzJ5j.QeIIKbAeQu8rDaHc/jdv1Uklub0KYFJmPjxSqJFrW', NULL, 0),
(491, 'Joyyyyy', 'Joy', 'Johnson', 'jojo8583@colorado.edu', '$2y$10$m8ZYJ7qGuzn8hzydSZLPuud37erequu5SaXkWr15C7HAKUzhxjXMO', '7206605790', 0),
(492, 'littlemisspiggy', 'Katie ', 'Megerle', 'kame9790@colorado.edu', '$2y$10$s6PgmiptUVD5PNCzthToluF7QEo15rBt7zsWR8dQs3BCL/P0GG0AC', '7206260616', 0),
(493, 'littlemisspigggy', 'Katie ', 'Megerle', 'katiemegerle@gmail.com', '$2y$10$N99OFkLol1VOaVhCzsXQ2O2H6B5W261DkJP74LZ93aBVTI8c5XAde', '7206260616', 0),
(494, 'littlemisspigggyyyy', 'Katie ', 'Megerle', 'katiemegerlee@gmail.com', '$2y$10$C4S5O31NgJUkUDkcedbWFO3WiZseIdXhHphS6gVuHxcf1yaG0hKei', '7206260616', 0),
(495, 'graciekelly', 'GRACE', 'MACHEN', 'gracemachen127@GMAIL.COM', '$2y$10$2KzIk3LuCdqbFFtjoGxey.MgovCejHfS8nJGbpgt1QQ7UQoGAYTb2', '9795993368', 0),
(496, 'ajjacobi', 'Adrienne', 'Jacobi', 'adja8452@colorado.edu', '$2y$10$b3FVjjlkujqe3D2OAKLkv.N8qBz/PvR44Wruqvd2AenSd.NApyRJC', '7204389914', 0),
(497, 'skyc123', 'Skylar', 'Cohn', 'skco8647@colorado.edu', '$2y$10$48te1/MwK0CIIxe9SPiBqOPQjzlbfYEaURYzKptOKg5Edn9.MtKLW', '4438332020', 0),
(498, 'GavvySavvy', 'Gavyn', 'Draveen', 'elda3053@colorado.edu', '$2y$10$ypnFJ5xdwhrgpVHImerK9u3MStMfgbE9jz4ijEPD04gLRax2NA88e', '3035142023', 0),
(499, 'Tenno', 'Michael', 'Walley', 'michaelcwalley21@gmail.com', '$2y$10$kTiZHV4StgH0OV7/f8F4YeoS76BfiS/wdQLY6eqjWGCEd/4KYtbl.', '9496143655', 0),
(500, 'KeatonAdams', 'Keaton', 'Foster-Adams', 'keatonadams37@gmail.com', '$2y$10$apeSKOpxEqHsadDup5/sAul1bjh6isfLeHIx95zprXy2IMLuuDvhK', '8054709885', 0),
(501, 'Cecily', 'Cecily', 'Coors', 'kaco1900@colorado.edu', '$2y$10$0A.14EMEGdKs1z.2Q1EOfO4tn7G1Y/FadSbK3JXTBfM2s/SUz15SW', '3035216330', 0),
(502, 'Absolution', 'Max', 'Banks', 'maxwell.banks@colorado.edu', '$2y$10$m8Cub8LV7gXt51JGiKLOZOhUSHWSq1NTTs5POCNsQGw7Ja0IlcjFW', '9703051670', 0),
(503, 'NathanLevinson', 'nathan', 'levinson', 'nathanlevinson260@gmail.com', '$2y$10$xLVQBRXLVWwjt90ailH.D.HFIEhxlmYzgXPYOCVzoequxbn3EpdW6', '5739532522', 0),
(504, 'Klieg', 'Jack', 'Kliegerman', 'jakliegerman@gmail.com', '$2y$10$y8liX9FF0fG5PIDNLI9P7eNMLMwAE2rq0/BOGLlpPAQzebe6MaCGC', '9703898133', 0),
(505, 'kaycepurcell', 'Kayce', 'Purcell', 'kapu7569@colorado.edu', '$2y$10$oVrG8Egvds1rfXLhjVh6letCdSPTi.cjKAsbI9nJVo1A60INc/ECu', '7195571156', 0),
(506, 'kyto3825', 'Kyle', 'Towstik', 'kyle.towstik@colorado.edu', '$2y$10$0U.1xmHQrnIor4xq5YP/Dujqwdhd4XkDr3DXALkJZyJBZVDUY0egK', '7203468829', 0),
(507, 'mach6496', 'Max', 'Chambers', 'mach6496@colorado.edu', '$2y$10$jRjF7MMr1nT56Hw1sSNgUOXb9GL0i5DXQblJFr5De6AVJIxferyUm', '7202738090', 0),
(508, 'adamgarb', 'Adam', 'Garb', 'adamdavid142@gmail.com', '$2y$10$tGkM.IK/SxxliI5JtXXGBO1sDxUdoZ24oCcPt0.pakuekeMmKTZzG', '9032453056', 0),
(509, 'nateberm', 'Nate', 'Berman', 'nabe9398@colorado.edu', '$2y$10$DEWo6CPh0Er9CZFXF8vNGuEvbAtMwfNhkUPG/rGAp0Udmbf6LIMDm', NULL, 0),
(510, 'cbumpus', 'Chris', 'Bumpus', 'chbu3885@colorado.edu', '$2y$10$yWEAjhQJtNt51jWPFda62epXuoyu5C2fDB23NG33C1pHBQ44ananC', NULL, 0),
(511, 'Kiara', 'Kiara', 'Rodriguez', 'kiro3364@colorado.edu', '$2y$10$P1pakPA1s129crHM2RvMT.W1U8NeUePC3GslosmCd/mvzsWSYz2I.', '7192905226', 0),
(512, '19scohen', 'Samantha', 'Cohen', 'saco9094@colorado.edu', '$2y$10$KUEbVNlmDoL.jrAfBGecPONwZBPxXctq9La88MxyU45y9O66EGup.', '2153852510', 0),
(513, 'mahubbeling', 'Maggie', 'Hubbeling', 'mahu7554@colorado.edu', '$2y$10$QpB.sLzTl68dJgWkrGJOTON8OGrg/9F3atFJ.ieEStcJ0Hxhjt4o.', '9702189669', 0),
(514, 'isga', 'ishan', 'gandhi', 'isga2105@colorado.edu', '$2y$10$1yvqexje2KwMQaVOncXMweqAe.trNvBHGB9ZQmEdnXvVxcFOMFleK', NULL, 0),
(515, 'Switzy', 'Caitlin', 'Jentz', 'cjentz01@gmail.com', '$2y$10$57BJz9hELzk3clSVkQdnTun0fpxTKWL7nLi6i0hE7F78kGfhPj0D2', '6082794391', 0),
(516, 'ahyo', 'Ahyo', 'Falick', 'ahfa0599@colorado.edu', '$2y$10$96cT7A0hpYarvzphvZmFJuyN57PIH2b4cssFuNukslerhH8z9khpW', NULL, 0),
(517, 'rachelmiller206', 'Rachel', 'Miller', 'rami5506@colorado.edu', '$2y$10$wSmL7XGfGEFKVFtf/4/Bau7pZXi4xBV1xdqTcB0j7cvombYbAawQa', '2069027897', 0),
(518, 'maje7033', 'Maymuna', 'Jeylani', 'maje7033@colorado.edu', '$2y$10$GDaRgUfeHFIUVpY3KLDNXOccAfhmrLZpfLdRkJPQ6bsA/VxUoeuKm', NULL, 0),
(519, 'Esraa', 'Esraa', 'Aldhufairi', 'esraa.alsayer@gmail.com', '$2y$10$L19dJmHaaCYBUXPXeSD7ueXcpp1ny.m.ofR1zLeF7IqIjktP1887O', '7207057277', 0),
(520, 'Abdulrahman.boush', 'Abdulrahman ', 'Boush', 'hamnii.36ali@gmail.com', '$2y$10$K2CciTKrXxXxZ3I.9lhVreZn2b6x4WPtfQelS996bimsIlhah.THW', '7202437112', 0),
(521, 'anjo7843', 'Andre', 'Johnson', 'anjo7843@colorado.edu', '$2y$10$.F1t1arDvJtvzIXgU/xU9eOiIImHD/yhsYA7hhAkdi8TFO5Rp8jbe', '7194538200', 0),
(522, 'gauy1985', 'Garrett', 'Uythoven', 'gauy0122@colorado.edu', '$2y$10$pg3eBI9Ho5.nIMWUuSdmgepUazhuaf.FXHgF.KSv7.YUyiKICO6Sa', NULL, 0),
(523, 'Bagel87', 'Eva', 'Spiegel', 'evsp6686@colorado.edu', '$2y$10$QUJjtD4uqVYF.tWigUEETO4WDTPn0/XOBUzVygbQmgh7jnKR92ziG', '8605434232', 0),
(524, 'Sydthekid420', 'Sydney', 'Mcphail', 'mcphailsydney@gmail.com', '$2y$10$6yS/BWKd/3jqB.fbQHaZCeE.cuE7CMM51MClk4dcG0Hg3Q.cPvJ7m', '8432149652', 0),
(525, 'Kebabs4806', 'Sierra', 'George', 'sige1751@colorado.edu', '$2y$10$Lqv3inTflcuLkVGoDNdGM.MN4hN2fqqk4bz6nEBeRmyfkoggxVo52', '3039092424', 0),
(526, 'RatatatRattata', 'Sabela ', 'Vasquez ', 'thebutyraceous@gmail.com', '$2y$10$GHCVRXvZ/FmjTzbWklcMYuB3qzS1gxG3V5cH1aqgFUeo6HR2KIQTG', NULL, 0),
(527, 'lillymcnichols', 'Lilly', 'McNichols', 'lilmc806@gmail.com', '$2y$10$V/64aT4O3twC1LupSJsClOR3tsBzp/StQYWfZG2kFRsvpOMJX..86', '6302104008', 0),
(528, 'capr4391', 'Cali', 'Pran', 'capr4391@colorado.edu', '$2y$10$dBtnHmwQ4eGpAKAK4ipry.wH2D3Q2gsKvs5K7cwrsLropptdHsmVW', NULL, 0),
(529, 'gabib', 'Gabi', 'Butvilofsky', 'butvilofskygabi@gmail.com', '$2y$10$PP12e19dbSNZhOFASra0HOkBwn2kbbWsr8Wzwss45N449UPT2AtQO', NULL, 0),
(530, 'than0553', 'Tom', 'Anderson', 'than0553@colorado.edu', '$2y$10$VbeMezKPIj7Eqv0aUbSZ1OFnWD0EjzHB0gm5Ti6c4X.hCqrTVaWfO', '7206267638', 0),
(531, 'Redtea', 'minerva', 'kasayapanand', 'mika9215@colorado.edu', '$2y$10$cTSYqsSsTCOXRgExn8KzFeOf8KNzhmqeDX73VoiwJruH0rjLz6eBi', '7203439564', 0),
(532, 'canthecat', 'Elijah', 'none', 'canthecat10@gmail.com', '$2y$10$tFUavndVkYxUlA3Aexub1Ort0F8fMIPBdQiQVz7GzVQuP3Tb.mwuS', '5206645870', 0),
(533, 'NoahHIcks', 'Noah', 'Hicks ', 'nghicks33@gmail.com', '$2y$10$Ngy4SwuZndX8ACknnZ5.BONX3MUCVUFRVrQvq8YmOatjMthovNXDS', '7209345636', 0),
(534, 'CafeteriaFruit', 'Cole', 'Reddish', 'coleinco@gmail.com', '$2y$10$KlxOUuuHaWMkb8RGLJuSdeuRLK.9.nu.OpQuqWQN0dMSbM8Ic3BxW', '7193672811', 0),
(535, 'FratBroJosh', 'Caroline ', 'Farris ', 'caroline.farris35@gmail.com', '$2y$10$LUfSwbU7E4AHJU1.3fKQg.YFU1YjyuzPe76iM4FNSsL1kOmB0F6uO', '9706188529', 0),
(536, 'scooterwoo', 'scott', 'cohn', 'scooter725@icloud.com', '$2y$10$/F3b24FYneMJlwcLpN0isuo/dMORJAwpfgzXeNsZlcVjCBd05kMkS', '5163536584', 0),
(537, 'shoveldick666', 'lando', 'hennessy', 'lahe7796@colorado.edu', '$2y$10$cV0euZ0avt3Qg/Sq/HC6h.pjp6QRy90qyywKtxq8uKuPVLbpVKVUi', '2155189161', 0),
(538, 'Kyle.Mitchiner', 'Kyle', 'Mitchiner', 'kylemitchiner@gmail.com', '$2y$10$ysKbM7bqZXVy4sD5uWhRxOSCbPBYv4fxbFd45WNnQ1jGVkLJuAN/S', '7205572766', 0),
(539, 'ctezera', 'Token', 'Brown', 'caleb.tezera@colorado.edu', '$2y$10$mgl3rBXTn8m.ZQOFqSBpj.CLmNLcVUbRrhvOTW7RP3Mx27H0IiDHO', '3036693830', 0),
(540, 'Epost7437', 'E', 'Post', 'empo6914@colorado.edu', '$2y$10$E9j2v22dF4qKD5xt11L8Lu0LXK9MjtIbK2LB9x9VvwS/Rj66o8djC', '3039179985', 0),
(541, 'zasullivan', 'Zoe', 'Sullivan', 'z.sully2000@gmail.com', '$2y$10$HUmLFQ1GCIuBcR55/BF5wu0ovDfRWAof7b2twqrDoZucAWRC84z.O', '6126194995', 0),
(542, 'trevtrev', 'Trevor', 'Reece', 'trre1556@colorado.edu', '$2y$10$./cxmRGpxIh90kp2NijbfujRonbREW5mj41wilEnW7oN6BcNiPUgG', '3035628245', 0),
(543, 'Nataliescheeoe', 'natalie', 'Scheele', 'natalie.scheele.10@gmail.com', '$2y$10$Wf7ZJgUDxsmimLxp.CqH.ufJHZLmf8sovkpFf1FQqy/Xzy3NLSrQK', '4155298842', 0),
(544, 'crasyluke', 'Lucas', 'Batista', 'lbatista01@yahoo.com', '$2y$10$0kM0Mk4HO23BnGLm5fsDz.i7krVgqaDh9MnE6T4/Wln1BE8G4Vbz.', NULL, 0),
(545, 'SeanThiltgen', 'Sean', 'Thiltgen', 'sean.thiltgen@gmail.com', '$2y$10$RvYd.W7shDGHqKqA3FaAY.6n79ggI9B/YC1zOjKlCVk93r9W8lgY6', '3103657080', 0),
(546, 'SeanT', 'Sean', 'Thiltgen', 'sean.thiltgen@colorado.edu', '$2y$10$fBUlOXGpbGk8TaWLCMbEEuzEl7JrrhBfDAtOE2JEHH8k4uQfngxeq', '3103657080', 0),
(547, 'Emaline', 'Emaline', 'Kerwin', 'emke8810@colorado.edu', '$2y$10$J/v2QozwYc9zQxncx7Bdt.gxRaco7ljg/bSHNUcCiDtGdEkhDav7a', '6309171556', 0),
(548, 'Aliammar', 'Ali', 'Alameer', 'aliammarq80@outlook.com', '$2y$10$lVfzBybowF61EWQh8Sny4Oqxvr9hyZrVRIZWE7FyeGW7.PwSw75B.', '7202438991', 0),
(549, 'Alaa', 'Alaa', 'Alnajar', 'alaaoojuly2001@hotmail.com', '$2y$10$bbgMMFwQMLfSMxHWSCJFdeiKDdR1LY1X5uNkEW5tZvk/o4r9JpADy', '9495168318', 0),
(550, 'Ajsalbannai', 'Ahmad', 'Albannay', 'azkar365@gmail.com', '$2y$10$iHVCedL5XPfFukjJly7vn.35I78c8S/rzFHYurzIO4R3m22TWlRZq', '3038026302', 0),
(551, 'mbusafar', 'MOHAMMAD', 'BUSAFAR', 'mkusafat@outlook.com', '$2y$10$.pSFLvWT5px2Ks7oeawuMurARczGlT4l8qGahUAzn2AGM8jzkuyPq', '7202511281', 0),
(552, 'Lillithwinchester', 'Anissa', 'Lujan', 'anlu3931@colorado.edu', '$2y$10$WpINeHfeu7fDldgqlkFLKuig9oJKV1mxB0/ZSlJSkkV6SZom7DOHS', '7192489241', 0),
(553, 'Niko', 'Niko', 'von Unger', 'niko@vonunger.de', '$2y$10$SxWv8t3Gu7Vbe/4c41c.qeRcR9BD98dfxBeao567PdMnNls.Thdyq', NULL, 0),
(554, 'AeroSophia', 'Anna Sophia', 'Rorrer Warren', 'annasophiaonice@icloud.com', '$2y$10$RRyfJALmYvNxMyuAVUOklOUiKN7PTWJ5Umsi3z9/Af5.zQXfriOB.', '3854147575', 0),
(555, 'Rickys1414', 'Ricky', 'Reyes', 'rickysreyes@gmail.com', '$2y$10$1bcsc7/MAIdziYGeCAB1QOcZwf63hP4qPFFFdMFeGQ1JsdNiw/Tn.', NULL, 0),
(556, 'SPiiKeSS', 'Poorn', 'Mehta', 'Poorn.Mehta@Colorado.EDU', '$2y$10$p8Jlz1Y2EV5mWoMQLG5uDe/zavGkFALLuSFSwu5omIAsYUYGtdjBC', '7209400389', 0),
(557, 'vyski1', 'Vanessa', 'Gluchowski', 'vagl6989@colorado.edu', '$2y$10$7Ac4FqJI1ZVIlG8EhubBb.OlBhU0uUemCaeSiR8U26CKdCYLXkr8W', NULL, 0),
(558, 'Dania', 'Dania', 'Alhamli', 'daal9113@colorado.edu', '$2y$10$R/jDOcHewtrOSbBHcOYfWO/kkI/NNrpcqnsXq/3ZA4cjVaYSuEKFi', NULL, 0),
(559, 'Ray', 'Oliver', 'Doig', 'oliverdoig@gmail.com', '$2y$10$Z.RBfnV8JlVM3QcsYrT5xuLpXrvHKZw02/N9ScDykpGAlTdaHkJwi', '4083169778', 0),
(560, 'yash1595', 'Yash', 'Gupte', 'yash.gupte@colorado.edu', '$2y$10$XOvTUb0WPVFodDJu4GckH.LhkQsGedwgIf8.baBbtbJfN73aQUGla', '7204538422', 0),
(561, 'small-angry-and-ready-to-fight', 'Kelly', 'Eisen', 'keei3508@colorado.edu', '$2y$10$cqd3aVOOVL5WNkTePDyeEuW161daGlwS9mjEmY6A3WKgaUCPq7u1C', NULL, 0),
(562, 'Janesy', 'Jingqi', 'Liu', 'jili3523@colorado.edu', '$2y$10$QEtxKpkobBkEaLhaMrWRYOC87CU9dWBzdX7ejkZANXZa61bSDChaK', NULL, 0),
(563, 'Abdullah', 'Abdullah', 'Ghounaim ', 'Abdullahghunaim55@gmail.com', '$2y$10$jf6wqKHOdgdVaTSF2RvMDOaCu1C2LZs7YTc91nJ091BdtuYVE/Dd2', '7207274219', 0),
(564, 'Alexalv', 'Alexis', 'Alvarez', 'alexis9530@yahoo.com', '$2y$10$m.Ed.TERGu5Li94CMYUwEOhEbSJOoV/BdN4yv96KxddsSBPzrkCyG', '7203729072', 0),
(565, 'Communistjk', 'Cole', 'Rockwood', 'colerockwood97@gmail.com', '$2y$10$XetY/EHxVyH8aXck4WHxq.yTeJj5FZQ9coe1y5xGDCfyMZXgN.gxm', '8134207338', 0),
(566, 'AlexPichler', 'Alex', 'Pichler', 'ALPI9677@colorado.edu', '$2y$10$/GWnGTaegx7x5P7GIYgteutK2hDXcxOykMLC/9yMfYmr/VQUHM4za', NULL, 0),
(567, 'maro4763', 'Madison', 'Roche', 'madison.roche13@gmail.com', '$2y$10$KMAaICrqi.HCLzgzLdbXSeTF.saf7ELUBQrYnnkwoJ5i.PJTjxZ3K', '5053920696', 0),
(568, 'lucymbdavis', 'Lucy', 'Davis', 'luda4286@colorado.edu', '$2y$10$ttCPQR6zoWGm8OrNfkESh.dyh5K4cYb6gUwKc.0mad7T47pHAKWBm', NULL, 0),
(569, 'Moosta', 'Mostafa', 'AL Hrbi', 'mostafa.1419@hotmail.com', '$2y$10$b/XLiYOfIbxD5DTkSex9GO6yQ4q5XZ2meIfd5llocHdgAJnKuEWuq', '7209089100', 0),
(570, 'jennals311', 'Jenna', 'Snyder', 'jesn4512@colorado.edu', '$2y$10$9Z8cJwLaJxTousdpuq5.M.PsdHXfA16Bb8lg.t7kkt6pT9oQRJCvi', NULL, 0),
(571, 'jenna.l.snyder', 'Jenna', 'Snyder', 'jenna.lee.snyder@gmail.com', '$2y$10$ehSsoHC0MIBcFizwyi9YIOJp/XE.FI.47uta8pO6Ikqy21zWdQFdK', '7205567324', 0),
(572, 'Mittyfresh', 'Owen', 'Ahlers', 'owen.ahlers@colorado.edu', '$2y$10$BacxMbM4l5UzQXGhgbCOSuNZOoBjFp/EmPve8aCnY4c/Sr85rFZq2', NULL, 0),
(573, 'Pizzafoot', 'Spencer', 'Stepanek', 'spencer.stepanek@colorado.edu', '$2y$10$1jdFzbvpzMnzdRYbsv6Nr.ZNZkDUArSlLizC/eMcvnzyTB8d4WJWS', '7193511225', 0),
(574, 'xire0381', 'Alex', 'Ren', 'xire0381@colorado.edu', '$2y$10$DGPMc9CSyfJ.z9RakBDbxuTnPcnpZpfY.Odlzffig9QTiGB4YiYJi', '7205205579', 0),
(575, 'yuti3188', 'Lavender', 'Tian', 'yuti3188@colorado.edu', '$2y$10$bsJQ5Y6IUgQhpQUSVA/I9.6rH7fpO2MNCLwrcjLX4q1F47ag0QfK.', '7206219950', 0),
(576, 'Belindapolynice24', 'Belinda', 'Polynice', 'belindap1999@gmail.com', '$2y$10$/108jRyLM.IqL7qS3EQPheMm13dB/DIWfJuuo5Ltm3J1XqesyBUcG', '6613098578', 0),
(577, 'tickles', 'Jack', 'Spicer', 'jack.spicer@coloraod.edu', '$2y$10$UBrLlZRB69yTMZR4jxLsNeyzs0VhZ5fn61SQcJTpGn6GEa5mI9n3G', NULL, 0),
(578, 'Yojo', 'Ben', 'Massik', 'Ben.massik@gmail.com', '$2y$10$0MDyJu5Oeti6okM2RacYT..KIIG9GbG25gSnDbNAoGm46oQBFH7xe', '4156863392', 0),
(579, 'qmorton', 'Quentin', 'Morton', 'quentin.morton@colorado.edu', '$2y$10$SMNLVN2UUWGqxOi0nios5ePJ8xxWTITebMZfhY1Wt8xX9PVbPS1ai', '5183919591', 0),
(580, 'untraceable', 'Nathan', 'Mick', 'nmickski@gmail.com', '$2y$10$zE/32EsnhWGHylBJQChec.ji.8PoxadEBJEQe7HI9GaTTE.NvWRQi', NULL, 0),
(581, 'ribl6345', 'Riley', 'Blackwood', 'ribl6345@gmail.com', '$2y$10$vqejGKUaXLRa6VEFe2.06.0jzZ4aql.yNcG9SA80xq6yKQKOKpQlq', '7272711415', 0),
(582, 'riley32599', 'Riley', 'Blackwood', 'ribl6345@colorado.edu', '$2y$10$TYIN/m5xBorqppFLM7ov1emG3Ve18MtGpm.ortvVLyjWqxAbm626W', '7272711415', 0),
(583, 'Mimi5526', 'Mikayla ', 'Michels ', 'mimi5526@colorado.edu', '$2y$10$jN92ok6OkFDezddqKHDZiuaRObohxTKNfzMsyi6NrFA7.hlJFa9ci', NULL, 0),
(584, 'emmarinz', 'Emma', 'Rinzler', 'emma@rinzler.net', '$2y$10$fkzRhupo3daqalCT3oMkPOYIVDnxuCO7I84TeIWRFvu5R9OJprCJ6', NULL, 0),
(585, 'Plea80s', 'Klaudia', 'Brooks', 'klaudia.lenore@gmail.com', '$2y$10$/AUJh4qazdFgpXGUFIfnqOnVzMuxemsC1YoPFOP2OIXi4EB6n9E36', '7194194661', 0),
(586, 'anferguson', 'Alexandra', 'Ferguson', 'alfe6135@colorado.edu', '$2y$10$/vG6lP561b.oXCKtvivhwOXXoIhGnpZwKq/dEfomgX.5Tpnvn4JvK', '7203084590', 0),
(587, 'Jlarry04', 'Jacob', 'Lawrence', 'w00dstok@hotmail.com', '$2y$10$5hGg7VOCSw4an0dNtHGuhOmAyDeW/oM2Jn4drl/LqlaTkSvDumdcC', NULL, 0),
(588, '123456789', 'Nathan', 'Curtis', 'nathanielcurtis01@gmail.com', '$2y$10$dmA2g/swPuyWuoy1uDjY1eUtX8BcxVs..2wsmQAOle5BmpLoWpCk6', NULL, 0),
(589, 'SkoNavyBuffs', 'Christian', 'Dean', 'chde0402@colorado.edu', '$2y$10$ykvh7HrsGj4u.7CA3vQNvessPVbFtwK8oxP2sy3xsLuRsme4phhZG', NULL, 0),
(590, 'NickHasPants', 'Nick', 'Smyrnios', 'nhsmyrnios@gmail.com', '$2y$10$hqQfXHya78Tgx/pHJYajv.9bCBiMWrhQjtiOmPpFKjwtz5mwWvpS.', '9258782392', 0),
(591, 'Slytiger', 'Henry', 'Anderson', 'climbanderson@gmail.com', '$2y$10$pe9.It7W/dlU4EqW1KOH2e.Qw/YoSrdRc5ta2OFhTRrD0ZqIeHEDq', '9706902979', 0),
(592, 'sank180', 'Kiernan', 'Sanders-Reed', 'kisa4985@colorado.edu', '$2y$10$vN85MTzhNl5tIFbWLuuYQOqQ85FWysagRzUBKs1DIedi9NP0dxcm2', '5052214422', 0),
(593, 'Duke', 'Dulguun', 'Baatarkhuyag', 'duba9823@colorado.edu', '$2y$10$AZHvSD9rEgrV7QKxESJJIuseK.9GtIz2yKIfV7chEXv8Fu3cSoxVC', '7209386906', 0),
(594, 'dash4703', 'Darby', 'Shepherd', 'darby.shepherd@colorado.edu', '$2y$10$pJzlIuOsUOXaVHN/dur/bu.N.uxutR9VSw3n3E0D7YbmsOSL82vC2', '3037106037', 0),
(595, 'OhDang', 'Jack', 'Mc Hale', 'Jamc3850@colorado.edu', '$2y$10$Lq1eHTZKQRdUPeYpen9o5eplffIK7.c8.t.JlyD29UBbFDmBzT9Lm', '7206512227', 0),
(596, 'huha49000', 'Hunter', 'Hajdu', 'hunterh531@yahoo.com', '$2y$10$BIY5PNg714JlQr1/Rc03Xejn6DjXdbK2plde/OwsX7Ns0YX6Yvuyy', NULL, 0),
(597, 'Moon', 'Junhyeon', 'Moon', 'jmoon0125@gmail.com', '$2y$10$SuuXQVTVHtuI/FQmm.QTnea6XvQNiZob4cYmInGaS00BKLv50FZca', NULL, 0),
(598, 'SquabJ', 'AJ', 'Dawkins', 'ali.jrox77@gmail.com', '$2y$10$RN3xZ8rsQLp3MfR4aLCm6OEkoHpqth0KTaPDc1Aked.O3y34dEXku', '7203635418', 0),
(599, 'LcSwift', 'Landin', 'Chesne', 'lach2535@colorado.edu', '$2y$10$P5NCuNZIlLXb2MhUILGhtOOD8DRxI5KhP3MH9k4x6vOAjSCtVFKQK', '3038345156', 0),
(600, 'a.malikfd', 'Abdulmalik', 'Aldosary', 'abal5428@colorad.edu', '$2y$10$P/yJ3D8ROmre09cfMxiRNuiwMeArSLIBoqksZWbkK/HuRyzyWM8NW', '7206623027', 0),
(601, 'Lampard8-2000', 'Mohammed', 'AlDarwish', 'moal7758@colorado.edu', '$2y$10$pIpLgJhLmtfrLK4VF/rQiea.ypi2qMqLTyDAeO1VoHv9QNZzsE/mW', '7209983836', 0),
(602, 'MisterTwisterII', 'Toby', 'Renfro', 'tore2722@colorado.edu', '$2y$10$mr7Foh0oJkYPWYfg..bX.OYtoS/rcGajsnm79M.PptA1BrgvSjdsS', '3038813032', 0),
(603, 'Juanj.v', 'Juan', 'Jimenez', 'juve8936@colorado.edu', '$2y$10$MPzQi5OAWnut/mPnOvvBcO8hAw8UNDMOjeKolWJ7Tbs6PY7BG398W', NULL, 0),
(604, 'GravMaster', 'Will', 'Riley', 'wiri1105@colorado.edu', '$2y$10$juXTd0hAZb6gPB9vOYW7ZuA.D9WQkuydSeyTJt8HvNZGuVv4LRXcy', '7204001048', 0),
(605, 'arumidden', 'Leah', 'Topilow', 'leto0509@colorado.edu', '$2y$10$y2VXkTcStH2cPYwCEhsPu.xsn78eY.otroQx3k4ESZYWsW1NCp/di', NULL, 0),
(606, 'Dlimusa', 'Darryl ', 'Lim', 'dali5246@colorado.edu', '$2y$10$UbarJrskb4SyJkg7xNB8aOlbfLad8y38DQBrCKbkggKSEfCWPQmoC', '7208787332', 0),
(607, 'galeprinster', 'Gale', 'Prinster', 'abpr9862@colorado.edu', '$2y$10$xOdSC2xckzxrR5S93djU9ehWWQ8.wQOV3ZLqSCsllY2ku0M9zp/p6', '3037463300', 0),
(608, 'Caufwee', 'Alexandros', 'Cormican', 'alexcormican@gmail.com', '$2y$10$Soh2gyw8.A92AjvDbM6yxObRQAtTTl24zGOY2CDfEInONtXirrZra', '9085009069', 0),
(609, 'Greybear', 'Dakota', 'Greybear', 'Dgreybear69@gmail.com', '$2y$10$UsTFi7nRPVish/OF.UkL/u0DMTexldTbkjaD8djsgHoOL3/rfcQem', NULL, 0),
(610, 'anmi0664', 'Andrew', 'Minder', 'anmi0664@colorado.edu', '$2y$10$J.CUBFIHDiToqSnM9mgS2O.baATb796iaeVlbfMrGH1gpF4EItuzu', '2036451687', 0),
(611, 'Zlatin', 'Dillon', 'Clark', 'diglooclark@gmail.com', '$2y$10$08eVPfjqpFe9YOrfvoFKG.zmaO3IUa4FhCy0DcltnKJcupIZ4QIwy', NULL, 0),
(612, 'Jackomitus', 'Jack', 'Clark', 'jackomitus@yahoo.com', '$2y$10$XkYQt1.27rSmqaGVNRIwI.HaVd2jk7ln7hLbL8X8S5R0bkUGSgeHa', '5125478778', 0),
(613, 'noahxn', 'Noah', 'Nguyen', 'noahxn@gmail.com', '$2y$10$U4UwZdIhWN4erhgTEJPbY.nM1pTw9lS7y1TaRqtGUc.DL9RwI6rgu', '3034761133', 0),
(614, 'jamo0590', 'Jacob', 'Morris', 'jamo0590@colorado.edu', '$2y$10$IYI9FlhKoWQj3Z6zdG6l9OQ5sXUzp0SBS50FaoafIrvJZelivM79a', '7206708331', 0),
(615, 'rkshearon', 'ROB', 'SHEARON', 'shearon@colorado.edu', '$2y$10$eLRRGJOYlLbtTwoDs3dMwuMSk3YqQCE.2.1ZLs5y4dtpRaMkLUq42', '9703432297', 0),
(616, 'maddio33', 'maddison', 'orosz', 'maddison.orosz@colorado.edu', '$2y$10$oBLCJjOjWQiff..M5QVdGe.rTstbo.1NyvtDxIDPfTk5BFtLHwqhG', '8582451057', 0),
(617, 'yibo', 'yibo', 'fan', 'yifa8872@colorado.edu', '$2y$10$DztDlUot/UnRf9QdyHJvz.mfo7DD/dFdjGdX0eWKvwx17r3I.4Y4a', NULL, 0),
(618, 'ashleysh17', 'Ashley', 'Howard', 'asho7012@colorado.edu', '$2y$10$mJQo7nntViH8ZXmWjbOFKeJsaKiHLHHhCbCKcm5xzg41MRNsniO9e', '7206352821', 0),
(619, 'courteneybm', 'Courteney', 'McGowan', 'comc4919@colorado.edu', '$2y$10$yZbLWJN2XcyuHnDehBQJBuofbP0i4zmyjcI8J0ihJNK2XFrEjq0AO', '8026815704', 0),
(620, 'froschty', 'Jacob', 'Frosch', 'jafr5256@colorado.edu', '$2y$10$9Gamgg5OEhCGqlsZN2kH9.eccktncrWoEQxl6S2TcNQ4WsevHf8y2', '3034890547', 0),
(621, 'xxlunaxx', 'Josh', 'Florencio', 'doctork910@gmail.com', '$2y$10$YBtLoXBn0cy4IfwGPpH1q.gRnVckG4xU2/PslBbpmqnJGfrdl9BWK', '3034888239', 0),
(622, 'Kushagra', 'Kushagra', 'Pandey', 'Kushagra.Pandey@colorado.edu', '$2y$10$06bybyXNmTg9LpS0D5JNwetAfSqolR2.P2dwusa0SBko/BIEAssOS', '7209804416', 0),
(623, 'Vaidehi', 'Vaidehi', 'Salway', 'vaidehi.salway@colorado.edu', '$2y$10$gP8u9/IBtreuDRhgXLyvWOid2QI61WSEyof1CM6UJmFJsjICNzydm', NULL, 0),
(624, 'apfefer', 'Andrew', 'Pfefer', 'anpf9194@colorado.edu', '$2y$10$IfXgavGhEOFv6Vm8ws7IG.wXBMCwlrDrqmHsW28uea6vEGCfVHYzC', '3035198777', 0),
(625, 'Kavanwaves', 'Kavan', 'Ganapathy', 'kavanganapathi23@gmail.com', '$2y$10$wKQc6gRSWArK4HL510jnVOGuWX7IDHfMj8Zo2cAHSmu9k8aJk3zRi', '7206437690', 0),
(626, 'Edge3.0', 'Eoghan', 'Edginton', 'dominicedginton@yahoo.com', '$2y$10$aMskcLShqXBUMQDvzMoUo.k8BAGIOIKQgq4KBi6x9NJkw.p.HmGjq', '2108675369', 0),
(627, 'Edge06UK', 'Dominic', 'Edginton', 'doed2896@colorado.edu', '$2y$10$jSoDvbhj7womW3cdjbh/bONAEgKwy6XtuJpcQtXp5eizYV/NbMo96', '2108675369', 0),
(628, 'halobuffs', 'Christian', 'Dean', 'christianjdean117@gmail.com', '$2y$10$n2C8SJGRXPl69Bfiq5tcguWJun3/YHxZhlFqqXK5e8YTarHG.Jvai', NULL, 0),
(629, 'chadsworthboolington', 'Corey', 'Sherman', 'cosh1912@gmail.com', '$2y$10$ysQUVsdK8IXuL98tMkgxQunnNa8nKxQQ/82MYXKrAnNSu/9Aebqcu', '8159732934', 0),
(630, 'chadsworthboolington2', 'Corey', 'Sherman', 'cosh1912@colorado.edu', '$2y$10$7iDd.Pp9.Ln/Hg6H3Nt8.O8P5VfovxBIjswk0NzskXZvXJiRsKhF6', '8159732934', 0),
(631, 'MrDoubleWW', 'Samuel', 'McCullough', 'samc9731@colorado.edu', '$2y$10$ynbMF9PNzWzXolGHSVPqtuESrkqIsyu57zzVWfrYOMWfw98TmfBeu', '8156775696', 0),
(632, 'Hannah', 'Hannah', 'Phelps', 'haph8993@colorado.edu', '$2y$10$ngOxjWWr1aAzv7t8wz2jqOJmMV9me00fN6jlJXZMve/MdgUgo1x8a', '2068490554', 0);

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=633;


--
-- Dumping data for table `user_details`
--

INSERT INTO `user_details` (`id`, `join_date`, `activated`) VALUES
(1, '2019-03-31 01:50:31', 1),
(28, '2019-03-31 01:50:31', 1),
(29, '2019-03-31 01:50:31', 1),
(31, '2019-03-31 01:50:31', 1),
(32, '2019-03-31 01:50:31', 1),
(33, '2019-03-31 01:50:31', 1),
(34, '2019-03-31 01:50:31', 1),
(35, '2019-03-31 01:50:31', 1),
(36, '2019-03-31 01:50:31', 1),
(37, '2019-03-31 01:50:31', 1),
(38, '2019-03-31 01:50:31', 1),
(39, '2019-03-31 01:50:31', 1),
(40, '2019-03-31 01:50:31', 1),
(41, '2019-03-31 01:50:31', 1),
(42, '2019-03-31 01:50:31', 1),
(43, '2019-03-31 01:50:31', 1),
(44, '2019-03-31 01:50:31', 1),
(45, '2019-03-31 01:50:31', 1),
(46, '2019-03-31 01:50:31', 1),
(47, '2019-03-31 01:50:31', 1),
(48, '2019-03-31 01:50:31', 1),
(49, '2019-03-31 01:50:31', 1),
(50, '2019-03-31 01:50:31', 1),
(51, '2019-03-31 01:50:31', 1),
(52, '2019-03-31 01:50:31', 1),
(53, '2019-03-31 01:50:31', 1),
(54, '2019-03-31 01:50:31', 1),
(55, '2019-03-31 01:50:31', 1),
(56, '2019-03-31 01:50:31', 1),
(57, '2019-03-31 01:50:31', 1),
(58, '2019-03-31 01:50:31', 1),
(59, '2019-03-31 01:50:31', 1),
(60, '2019-03-31 01:50:31', 1),
(61, '2019-03-31 01:50:31', 1),
(62, '2019-03-31 01:50:31', 1),
(63, '2019-03-31 01:50:31', 1),
(64, '2019-03-31 01:50:31', 1),
(65, '2019-03-31 01:50:31', 1),
(66, '2019-03-31 01:50:31', 1),
(67, '2019-03-31 01:50:31', 1),
(68, '2019-03-31 01:50:31', 1),
(69, '2019-03-31 01:50:31', 1),
(70, '2019-03-31 01:50:31', 1),
(71, '2019-03-31 01:50:31', 1),
(72, '2019-03-31 01:50:31', 1),
(73, '2019-03-31 01:50:31', 1),
(74, '2019-03-31 01:50:31', 1),
(75, '2019-03-31 01:50:31', 1),
(76, '2019-03-31 01:50:31', 1),
(77, '2019-03-31 01:50:31', 1),
(78, '2019-03-31 01:50:31', 1),
(79, '2019-03-31 01:50:31', 1),
(80, '2019-03-31 01:50:31', 1),
(81, '2019-03-31 01:50:31', 1),
(82, '2019-03-31 01:50:31', 1),
(83, '2019-03-31 01:50:31', 1),
(85, '2019-03-31 01:50:31', 1),
(86, '2019-03-31 01:50:31', 1),
(87, '2019-03-31 01:50:31', 1),
(88, '2019-03-31 01:50:31', 1),
(89, '2019-03-31 01:50:31', 1),
(90, '2019-03-31 01:50:31', 1),
(91, '2019-03-31 01:50:31', 1),
(92, '2019-03-31 01:50:31', 1),
(93, '2019-03-31 01:50:31', 1),
(94, '2019-03-31 01:50:31', 1),
(95, '2019-03-31 01:50:31', 1),
(96, '2019-03-31 01:50:31', 1),
(97, '2019-03-31 01:50:31', 1),
(98, '2019-03-31 01:50:31', 1),
(99, '2019-03-31 01:50:31', 1),
(100, '2019-03-31 01:50:31', 1),
(101, '2019-03-31 01:50:31', 1),
(102, '2019-03-31 01:50:31', 1),
(103, '2019-03-31 01:50:31', 1),
(104, '2019-03-31 01:50:31', 1),
(105, '2019-03-31 01:50:31', 1),
(106, '2019-03-31 01:50:31', 1),
(107, '2019-03-31 01:50:31', 1),
(108, '2019-03-31 01:50:31', 1),
(109, '2019-03-31 01:50:31', 1),
(110, '2019-03-31 01:50:31', 1),
(111, '2019-03-31 01:50:31', 1),
(112, '2019-03-31 01:50:31', 1),
(113, '2019-03-31 01:50:31', 1),
(114, '2019-03-31 01:50:31', 1),
(115, '2019-03-31 01:50:31', 1),
(116, '2019-03-31 01:50:31', 1),
(117, '2019-03-31 01:50:31', 1),
(118, '2019-03-31 01:50:31', 1),
(119, '2019-03-31 01:50:31', 1),
(120, '2019-03-31 01:50:31', 1),
(121, '2019-03-31 01:50:31', 1),
(122, '2019-03-31 01:50:31', 1),
(123, '2019-03-31 01:50:31', 1),
(124, '2019-03-31 01:50:31', 1),
(125, '2019-03-31 01:50:31', 1),
(126, '2019-03-31 01:50:31', 1),
(127, '2019-03-31 01:50:31', 1),
(128, '2019-03-31 01:50:31', 1),
(129, '2019-03-31 01:50:31', 1),
(130, '2019-03-31 01:50:31', 1),
(131, '2019-03-31 01:50:31', 1),
(132, '2019-03-31 01:50:31', 1),
(133, '2019-03-31 01:50:31', 1),
(134, '2019-03-31 01:50:31', 1),
(135, '2019-03-31 01:50:31', 1),
(136, '2019-03-31 01:50:31', 1),
(137, '2019-03-31 01:50:31', 1),
(138, '2019-03-31 01:50:31', 1),
(139, '2019-03-31 01:50:31', 1),
(140, '2019-03-31 01:50:31', 1),
(141, '2019-03-31 01:50:31', 1),
(142, '2019-03-31 01:50:31', 1),
(143, '2019-03-31 01:50:31', 1),
(144, '2019-03-31 01:50:31', 1),
(145, '2019-03-31 01:50:31', 1),
(146, '2019-03-31 01:50:31', 1),
(147, '2019-03-31 01:50:31', 1),
(148, '2019-03-31 01:50:31', 1),
(149, '2019-03-31 01:50:31', 1),
(150, '2019-03-31 01:50:31', 1),
(151, '2019-03-31 01:50:31', 1),
(152, '2019-03-31 01:50:31', 1),
(153, '2019-03-31 01:50:31', 1),
(154, '2019-03-31 01:50:31', 1),
(155, '2019-03-31 01:50:31', 1),
(156, '2019-03-31 01:50:31', 1),
(157, '2019-03-31 01:50:31', 1),
(158, '2019-03-31 01:50:31', 1),
(159, '2019-03-31 01:50:31', 1),
(160, '2019-03-31 01:50:31', 1),
(161, '2019-03-31 01:50:31', 1),
(162, '2019-03-31 01:50:31', 1),
(163, '2019-03-31 01:50:31', 1),
(164, '2019-03-31 01:50:31', 1),
(165, '2019-03-31 01:50:31', 1),
(166, '2019-03-31 01:50:31', 1),
(167, '2019-03-31 01:50:31', 1),
(168, '2019-03-31 01:50:31', 1),
(169, '2019-03-31 01:50:31', 1),
(170, '2019-03-31 01:50:31', 1),
(171, '2019-03-31 01:50:31', 1),
(172, '2019-03-31 01:50:31', 1),
(173, '2019-03-31 01:50:31', 1),
(174, '2019-03-31 01:50:31', 1),
(175, '2019-03-31 01:50:31', 1),
(176, '2019-03-31 01:50:31', 1),
(177, '2019-03-31 01:50:31', 1),
(178, '2019-03-31 01:50:31', 1),
(179, '2019-03-31 01:50:31', 1),
(180, '2019-03-31 01:50:31', 1),
(181, '2019-03-31 01:50:31', 1),
(182, '2019-03-31 01:50:31', 1),
(183, '2019-03-31 01:50:31', 1),
(184, '2019-03-31 01:50:31', 1),
(185, '2019-03-31 01:50:31', 1),
(186, '2019-03-31 01:50:31', 1),
(187, '2019-03-31 01:50:31', 1),
(188, '2019-03-31 01:50:31', 1),
(189, '2019-03-31 01:50:31', 1),
(190, '2019-03-31 01:50:31', 1),
(191, '2019-03-31 01:50:31', 1),
(192, '2019-03-31 01:50:31', 1),
(193, '2019-03-31 01:50:31', 1),
(194, '2019-03-31 01:50:31', 1),
(195, '2019-03-31 01:50:31', 1),
(196, '2019-03-31 01:50:31', 1),
(197, '2019-03-31 01:50:31', 1),
(198, '2019-03-31 01:50:31', 1),
(199, '2019-03-31 01:50:31', 1),
(200, '2019-03-31 01:50:31', 1),
(201, '2019-03-31 01:50:31', 1),
(202, '2019-03-31 01:50:31', 1),
(203, '2019-03-31 01:50:31', 1),
(204, '2019-03-31 01:50:31', 1),
(205, '2019-03-31 01:50:31', 1),
(206, '2019-03-31 01:50:31', 1),
(207, '2019-03-31 01:50:31', 1),
(208, '2019-03-31 01:50:31', 1),
(209, '2019-03-31 01:50:31', 1),
(210, '2019-03-31 01:50:31', 1),
(211, '2019-03-31 01:50:31', 1),
(212, '2019-03-31 01:50:31', 1),
(213, '2019-03-31 01:50:31', 1),
(214, '2019-03-31 01:50:31', 1),
(215, '2019-03-31 01:50:31', 1),
(216, '2019-03-31 01:50:31', 1),
(217, '2019-03-31 01:50:31', 1),
(218, '2019-03-31 01:50:31', 1),
(219, '2019-03-31 01:50:31', 1),
(220, '2019-03-31 01:50:31', 1),
(221, '2019-03-31 01:50:31', 1),
(222, '2019-03-31 01:50:31', 1),
(223, '2019-03-31 01:50:31', 1),
(224, '2019-03-31 01:50:31', 1),
(225, '2019-03-31 01:50:31', 0),
(226, '2019-03-31 01:50:31', 1),
(227, '2019-03-31 01:50:31', 1),
(228, '2019-03-31 01:50:31', 0),
(229, '2019-03-31 01:50:31', 1),
(230, '2019-03-31 01:50:31', 1),
(231, '2019-03-31 01:50:31', 1),
(232, '2019-03-31 01:50:31', 1),
(233, '2019-03-31 01:50:31', 1),
(234, '2019-03-31 01:50:31', 1),
(235, '2019-03-31 01:50:31', 1),
(236, '2019-03-31 01:50:31', 1),
(237, '2019-03-31 01:50:31', 1),
(238, '2019-03-31 01:50:31', 0),
(239, '2019-03-31 01:50:31', 1),
(240, '2019-03-31 01:50:31', 0),
(241, '2019-03-31 01:50:31', 1),
(242, '2019-03-31 01:50:31', 0),
(243, '2019-03-31 01:50:31', 0),
(244, '2019-03-31 01:50:31', 0),
(245, '2019-03-31 01:50:31', 1),
(246, '2019-03-31 01:50:31', 0),
(247, '2019-03-31 01:50:31', 0),
(248, '2019-03-31 01:50:31', 0),
(249, '2019-03-31 01:50:31', 1),
(250, '2019-03-31 01:50:31', 0),
(251, '2019-03-31 01:50:31', 0),
(252, '2019-03-31 01:50:31', 0),
(253, '2019-03-31 01:50:31', 0),
(254, '2019-03-31 01:50:31', 0),
(255, '2019-03-31 01:50:31', 0),
(256, '2019-03-31 01:50:31', 0),
(257, '2019-03-31 01:50:31', 1),
(258, '2019-03-31 01:50:31', 0),
(259, '2019-03-31 01:50:31', 0),
(260, '2019-03-31 01:50:31', 0),
(261, '2019-03-31 01:50:31', 0),
(262, '2019-03-31 01:50:31', 0),
(263, '2019-03-31 01:50:31', 0),
(264, '2019-03-31 01:50:31', 0),
(265, '2019-03-31 01:50:31', 1),
(266, '2019-03-31 01:50:31', 0),
(269, '2019-03-31 01:50:31', 0),
(270, '2019-03-31 01:50:31', 0),
(271, '2019-03-31 01:50:31', 1),
(273, '2019-03-31 01:50:31', 1),
(274, '2019-03-31 23:31:37', 1),
(275, '2019-04-01 19:09:55', 1),
(276, '2019-04-02 17:06:38', 1),
(277, '2019-04-02 18:05:06', 1),
(278, '2019-04-02 18:07:12', 1),
(279, '2019-04-04 16:06:41', 1),
(280, '2019-04-04 16:29:03', 0),
(281, '2019-04-04 17:10:16', 0),
(282, '2019-04-04 17:12:09', 0),
(283, '2019-04-04 17:25:45', 0),
(284, '2019-04-04 17:26:19', 0),
(285, '2019-04-04 17:59:19', 1),
(286, '2019-04-04 18:03:24', 1),
(287, '2019-04-04 18:20:03', 0),
(288, '2019-04-04 18:22:36', 1),
(289, '2019-04-04 18:25:39', 1),
(290, '2019-04-04 18:28:34', 0),
(291, '2019-04-04 18:30:10', 0),
(292, '2019-04-04 18:31:52', 0),
(293, '2019-04-04 19:08:29', 0),
(294, '2019-04-04 20:00:34', 0),
(295, '2019-04-04 21:45:45', 0),
(296, '2019-04-05 21:40:22', 1),
(297, '2019-04-05 22:49:45', 1),
(298, '2019-04-08 16:03:30', 0),
(299, '2019-04-08 17:29:48', 1),
(300, '2019-04-09 00:28:29', 1),
(301, '2019-04-09 00:32:22', 1),
(302, '2019-04-09 01:29:18', 1),
(303, '2019-04-09 03:45:48', 1),
(304, '2019-04-09 04:19:44', 1),
(305, '2019-04-09 04:20:42', 1),
(306, '2019-04-09 04:21:30', 1),
(307, '2019-04-09 07:47:40', 1),
(308, '2019-04-09 12:59:20', 1),
(309, '2019-04-09 13:18:08', 1),
(310, '2019-04-09 14:13:28', 0),
(311, '2019-04-09 16:24:58', 0),
(312, '2019-04-09 16:27:45', 0),
(313, '2019-04-09 16:33:50', 1),
(314, '2019-04-09 16:39:54', 1),
(315, '2019-04-09 16:58:28', 1),
(316, '2019-04-09 17:36:08', 1),
(317, '2019-04-09 18:28:51', 1),
(318, '2019-04-09 18:30:25', 1),
(319, '2019-04-09 18:41:56', 1),
(320, '2019-04-09 18:53:06', 1),
(321, '2019-04-09 19:04:45', 1),
(322, '2019-04-09 19:28:27', 1),
(323, '2019-04-09 19:57:52', 1),
(324, '2019-04-09 19:57:54', 1),
(325, '2019-04-09 20:16:41', 1),
(326, '2019-04-09 20:41:22', 1),
(327, '2019-04-09 20:42:45', 1),
(328, '2019-04-09 22:07:22', 1),
(329, '2019-04-10 01:13:29', 0),
(330, '2019-04-10 01:13:52', 1),
(331, '2019-04-10 01:13:58', 0),
(332, '2019-04-10 02:10:28', 1),
(333, '2019-04-10 03:31:48', 1),
(334, '2019-04-10 04:36:59', 1),
(335, '2019-04-10 06:40:13', 1),
(336, '2019-04-10 06:50:40', 1),
(337, '2019-04-10 15:34:40', 0),
(338, '2019-04-10 15:53:05', 0),
(339, '2019-04-10 17:11:29', 1),
(340, '2019-04-10 18:23:11', 1),
(341, '2019-04-10 19:41:19', 1),
(342, '2019-04-10 20:28:21', 1),
(343, '2019-04-10 20:32:10', 0),
(344, '2019-04-10 22:35:54', 1),
(345, '2019-04-11 00:11:59', 0),
(346, '2019-04-11 02:10:02', 1),
(347, '2019-04-11 02:53:46', 1),
(348, '2019-04-11 03:02:55', 1),
(349, '2019-04-11 03:05:28', 1),
(350, '2019-04-11 13:33:28', 1),
(351, '2019-04-11 15:55:03', 1),
(352, '2019-04-11 18:22:05', 1),
(353, '2019-04-11 19:31:25', 1),
(354, '2019-04-11 20:44:50', 1),
(355, '2019-04-11 20:55:00', 1),
(356, '2019-04-11 21:20:56', 1),
(357, '2019-04-11 21:22:24', 1),
(358, '2019-04-11 21:28:45', 1),
(359, '2019-04-11 21:39:53', 1),
(360, '2019-04-12 01:30:35', 1),
(361, '2019-04-12 01:32:13', 1),
(362, '2019-04-12 01:32:45', 1),
(363, '2019-04-12 01:47:30', 1),
(364, '2019-04-12 01:51:22', 1),
(365, '2019-04-12 01:53:41', 1),
(366, '2019-04-12 01:53:44', 1),
(367, '2019-04-12 03:00:48', 1),
(368, '2019-04-12 07:51:25', 1),
(369, '2019-04-12 13:51:40', 1),
(370, '2019-04-12 16:48:47', 1),
(371, '2019-04-12 17:24:54', 1),
(372, '2019-04-12 18:08:36', 1),
(373, '2019-04-12 19:10:36', 1),
(374, '2019-04-12 20:00:43', 1),
(375, '2019-04-12 20:01:43', 1),
(376, '2019-04-12 21:17:43', 1),
(377, '2019-04-12 21:20:45', 1),
(378, '2019-04-12 22:15:39', 0),
(379, '2019-04-12 23:15:59', 1),
(380, '2019-04-12 23:16:42', 1),
(381, '2019-04-13 00:41:24', 1),
(382, '2019-04-13 02:47:53', 1),
(383, '2019-04-13 04:10:23', 1),
(384, '2019-04-13 04:23:32', 1),
(385, '2019-04-13 04:57:56', 1),
(386, '2019-04-13 05:33:11', 1),
(387, '2019-04-13 05:47:16', 0),
(388, '2019-04-13 05:50:55', 1),
(389, '2019-04-13 05:52:33', 1),
(390, '2019-04-13 06:26:07', 1),
(391, '2019-04-13 06:44:28', 0),
(392, '2019-04-14 02:28:00', 0),
(393, '2019-04-14 06:17:25', 1),
(394, '2019-04-14 08:37:22', 1),
(395, '2019-04-14 18:20:45', 1),
(396, '2019-04-14 18:38:47', 1),
(397, '2019-04-14 18:45:57', 1),
(398, '2019-04-14 19:41:15', 1),
(399, '2019-04-14 19:41:58', 1),
(400, '2019-04-14 20:16:17', 1),
(401, '2019-04-14 20:56:08', 0),
(402, '2019-04-14 21:44:14', 1),
(403, '2019-04-14 22:57:52', 1),
(404, '2019-04-15 03:13:08', 1),
(405, '2019-04-15 09:19:25', 1),
(406, '2019-04-15 13:49:06', 1),
(407, '2019-04-15 13:50:31', 0),
(408, '2019-04-15 14:11:09', 1),
(409, '2019-04-15 15:00:08', 0),
(410, '2019-04-15 16:06:11', 1),
(411, '2019-04-15 17:05:11', 1),
(412, '2019-04-15 17:07:30', 0),
(413, '2019-04-15 17:28:55', 0),
(414, '2019-04-15 17:58:53', 1),
(415, '2019-04-15 18:06:05', 1),
(416, '2019-04-15 18:20:06', 1),
(417, '2019-04-15 19:00:20', 1),
(418, '2019-04-15 19:42:00', 0),
(419, '2019-04-15 19:44:00', 1),
(420, '2019-04-15 19:58:55', 1),
(421, '2019-04-15 20:04:56', 1),
(422, '2019-04-15 20:08:34', 0),
(423, '2019-04-15 20:12:32', 1),
(424, '2019-04-15 21:07:13', 0),
(425, '2019-04-15 21:09:31', 1),
(426, '2019-04-15 22:14:12', 0),
(427, '2019-04-15 22:33:54', 1),
(428, '2019-04-15 22:58:50', 0),
(429, '2019-04-15 22:59:28', 1),
(430, '2019-04-15 23:03:09', 0),
(431, '2019-04-16 00:52:05', 1),
(432, '2019-04-16 00:56:24', 1),
(433, '2019-04-16 01:00:11', 1),
(434, '2019-04-17 04:32:24', 0),
(435, '2019-04-17 04:40:05', 1),
(436, '2019-04-17 09:44:21', 1),
(437, '2019-04-17 16:48:31', 1),
(438, '2019-04-17 20:52:10', 0),
(439, '2019-04-18 16:17:04', 1),
(440, '2019-04-18 17:29:24', 1),
(441, '2019-04-18 19:01:35', 0),
(442, '2019-04-18 19:07:34', 0),
(443, '2019-04-19 14:49:23', 1),
(444, '2019-04-19 19:01:55', 0),
(445, '2019-04-19 22:09:17', 1),
(446, '2019-04-24 19:42:12', 1),
(447, '2019-05-16 23:32:23', 0),
(448, '2019-07-04 21:13:08', 1),
(449, '2019-07-08 09:18:44', 1),
(450, '2019-07-16 22:42:40', 1),
(451, '2019-07-27 06:01:27', 1),
(452, '2019-08-25 03:20:05', 1),
(453, '2019-08-29 01:10:54', 0),
(454, '2019-08-29 01:24:06', 1),
(455, '2019-08-29 19:18:52', 1),
(456, '2019-08-29 19:34:14', 1),
(457, '2019-08-29 19:45:16', 1),
(458, '2019-08-29 20:01:53', 1),
(459, '2019-08-29 20:13:02', 1),
(460, '2019-08-29 21:00:19', 1),
(461, '2019-08-29 21:05:59', 1),
(462, '2019-08-29 21:20:55', 1),
(463, '2019-08-29 21:36:22', 1),
(464, '2019-08-30 01:18:46', 1),
(465, '2019-08-30 06:18:40', 1),
(466, '2019-08-31 07:29:27', 1),
(467, '2019-08-31 23:19:47', 1),
(468, '2019-09-03 04:09:31', 1),
(469, '2019-09-03 22:36:30', 1),
(470, '2019-09-04 14:48:37', 1),
(471, '2019-09-04 17:52:58', 1),
(472, '2019-09-05 04:57:39', 1),
(473, '2019-09-13 22:11:58', 1),
(474, '2019-09-14 13:49:18', 1),
(475, '2019-09-18 22:23:05', 1),
(476, '2019-09-20 02:56:27', 1),
(477, '2019-10-01 03:24:18', 1),
(478, '2019-10-20 14:48:08', 1),
(479, '2019-11-04 16:28:19', 1),
(480, '2019-11-04 17:55:23', 1),
(481, '2019-11-04 18:38:08', 1),
(482, '2019-11-04 19:22:35', 0),
(483, '2019-11-04 20:56:50', 1),
(484, '2019-11-04 21:00:14', 1),
(485, '2019-11-04 22:19:04', 0),
(486, '2019-11-04 22:21:04', 0),
(487, '2019-11-04 22:23:27', 1),
(488, '2019-11-04 22:24:24', 0),
(489, '2019-11-04 22:34:34', 1),
(490, '2019-11-05 03:25:55', 0),
(491, '2019-11-05 18:36:06', 0),
(492, '2019-11-05 21:20:27', 0),
(493, '2019-11-05 21:21:08', 0),
(494, '2019-11-05 21:22:19', 0),
(495, '2019-11-05 21:26:56', 0),
(496, '2019-11-05 21:54:08', 1),
(497, '2019-11-06 03:56:53', 1),
(498, '2019-11-06 16:29:28', 0),
(499, '2019-11-06 17:02:08', 0),
(500, '2019-11-06 17:54:46', 0),
(501, '2019-11-06 18:08:26', 0),
(502, '2019-11-06 18:09:56', 1),
(503, '2019-11-06 18:42:27', 1),
(504, '2019-11-06 18:45:11', 1),
(505, '2019-11-06 18:53:06', 0),
(506, '2019-11-06 18:58:20', 1),
(507, '2019-11-06 18:59:10', 1),
(508, '2019-11-06 19:00:04', 1),
(509, '2019-11-06 19:06:14', 1),
(510, '2019-11-06 19:09:11', 0),
(511, '2019-11-06 19:11:55', 1),
(512, '2019-11-06 19:17:08', 0),
(513, '2019-11-06 19:45:32', 1),
(514, '2019-11-06 19:48:10', 0),
(515, '2019-11-06 20:08:36', 1),
(516, '2019-11-06 20:43:35', 0),
(517, '2019-11-06 21:13:56', 1),
(518, '2019-11-06 22:04:46', 0),
(519, '2019-11-06 22:38:13', 1),
(520, '2019-11-06 22:38:35', 0),
(521, '2019-11-06 22:38:48', 0),
(522, '2019-11-06 22:52:20', 1),
(523, '2019-11-07 02:30:29', 1),
(524, '2019-11-07 02:32:33', 1),
(525, '2019-11-07 02:32:57', 1),
(526, '2019-11-07 03:34:30', 1),
(527, '2019-11-07 06:45:43', 1),
(528, '2019-11-07 19:20:31', 1),
(529, '2019-11-07 19:21:58', 0),
(530, '2019-11-07 20:23:17', 1),
(531, '2019-11-07 20:34:30', 0),
(532, '2019-11-08 00:36:00', 1),
(533, '2019-11-08 01:14:19', 1),
(534, '2019-11-08 01:17:53', 1),
(535, '2019-11-08 17:46:38', 1),
(536, '2019-11-08 17:48:23', 1),
(537, '2019-11-08 18:10:26', 0),
(538, '2019-11-08 18:34:10', 1),
(539, '2019-11-08 18:37:37', 1),
(540, '2019-11-08 18:58:42', 1),
(541, '2019-11-08 22:06:14', 0),
(542, '2019-11-08 22:07:49', 0),
(543, '2019-11-08 23:09:02', 0),
(544, '2019-11-09 00:02:09', 1),
(545, '2019-11-09 05:59:35', 0),
(546, '2019-11-09 06:03:41', 1),
(547, '2019-11-10 21:45:28', 1),
(548, '2019-11-10 22:24:32', 1),
(549, '2019-11-10 22:30:10', 1),
(550, '2019-11-10 23:53:22', 0),
(551, '2019-11-11 04:17:37', 0),
(552, '2019-11-11 07:24:54', 1),
(553, '2019-11-11 17:16:16', 0),
(554, '2019-11-11 17:59:27', 1),
(555, '2019-11-11 19:02:44', 1),
(556, '2019-11-11 19:42:17', 1),
(557, '2019-11-11 19:49:17', 1),
(558, '2019-11-11 20:34:12', 1),
(559, '2019-11-11 20:39:56', 1),
(560, '2019-11-11 20:39:59', 1),
(561, '2019-11-11 21:19:34', 1),
(562, '2019-11-11 22:57:23', 1),
(563, '2019-11-12 18:35:23', 1),
(564, '2019-11-12 20:14:39', 1),
(565, '2019-11-12 21:52:40', 1),
(566, '2019-11-14 06:22:55', 0),
(567, '2019-11-16 00:55:28', 1),
(568, '2019-11-16 05:22:46', 1),
(569, '2019-11-16 19:50:07', 1),
(570, '2019-11-18 19:04:10', 0),
(571, '2019-11-18 19:25:39', 1),
(572, '2019-11-18 20:23:35', 0),
(573, '2019-11-19 01:00:06', 0),
(574, '2019-11-19 21:53:39', 0),
(575, '2019-11-19 21:54:25', 0),
(576, '2019-11-20 03:50:51', 1),
(577, '2019-11-20 20:10:52', 0),
(578, '2019-11-21 03:23:26', 1),
(579, '2019-11-21 04:25:08', 1),
(580, '2019-11-22 16:44:07', 1),
(581, '2019-11-22 21:18:57', 0),
(582, '2019-11-22 21:23:09', 1),
(583, '2019-11-23 03:36:50', 1),
(584, '2019-11-23 20:50:56', 1),
(585, '2020-02-05 23:31:30', 1),
(586, '2020-02-24 17:43:24', 1),
(587, '2020-02-24 18:12:59', 0),
(588, '2020-02-24 19:58:46', 1),
(589, '2020-02-24 20:33:18', 1),
(590, '2020-02-24 23:30:13', 0),
(591, '2020-02-25 19:39:15', 1),
(592, '2020-02-25 23:09:49', 0),
(593, '2020-02-26 17:10:42', 1),
(594, '2020-02-26 18:38:07', 1),
(595, '2020-02-26 19:08:10', 1),
(596, '2020-03-02 18:53:30', 0),
(597, '2020-03-02 19:18:46', 1),
(598, '2020-03-02 19:49:40', 1),
(599, '2020-03-02 21:00:51', 1),
(600, '2020-03-03 17:03:00', 0),
(601, '2020-03-03 17:49:39', 1),
(602, '2020-03-03 21:05:04', 1),
(603, '2020-03-03 22:42:34', 1),
(604, '2020-03-04 17:49:29', 0),
(605, '2020-03-04 18:16:29', 1),
(606, '2020-03-04 18:41:32', 1),
(607, '2020-03-04 18:54:26', 1),
(608, '2020-03-05 18:10:22', 1),
(609, '2020-03-05 18:49:34', 1),
(610, '2020-03-05 19:36:56', 0),
(611, '2020-03-05 20:25:49', 0),
(612, '2020-03-05 20:55:11', 0),
(613, '2020-03-05 21:25:00', 0),
(614, '2020-03-06 17:11:46', 1),
(615, '2020-03-06 19:05:49', 0),
(616, '2020-03-06 19:18:08', 1),
(617, '2020-03-06 19:24:10', 0),
(618, '2020-03-06 19:46:16', 0),
(619, '2020-03-06 20:27:35', 0),
(620, '2020-03-06 21:40:34', 1),
(621, '2020-03-07 00:37:15', 1),
(622, '2020-03-07 20:17:28', 1),
(623, '2020-03-07 20:22:23', 1),
(624, '2020-03-08 16:45:35', 1),
(625, '2020-03-09 04:17:50', 0),
(626, '2020-03-09 15:45:11', 1),
(627, '2020-03-09 15:47:10', 1),
(628, '2020-03-09 19:58:12', 1),
(629, '2020-03-12 06:34:29', 0),
(630, '2020-03-12 06:45:33', 1),
(631, '2020-03-12 23:35:45', 1),
(632, '2020-03-13 00:39:03', 0);


DROP TABLE IF EXISTS `CUHvZ`.`weeklong_details` ;
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_missions` ;
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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_missions`
-- -----------------------------------------------------

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

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `CUHvZ`;

DELIMITER $$

USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`weeklongs_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`weeklongs_AFTER_INSERT` AFTER INSERT ON `weeklongs` FOR EACH ROW
BEGIN
INSERT INTO weeklong_details (id) VALUES (NEW.id);
END$$

DELIMITER ;

INSERT INTO `weeklongs` (`id`, `title`, `start_date`, `end_date`, `state`) VALUES
(1, 'Close Encounters of the Undead Kind', '2018-09-24 09:00:00', '2018-09-28 17:00:00', 4),
(2, 'Lovecraft', '2017-11-12 09:00:00', '2017-11-20 17:00:00', 4),
(3, 'Souljourn Preamble', '2017-04-20 09:00:00', '2017-03-24 17:00:00', 4),
(4, 'Ragnarok', '2019-04-15 13:00:00', '2019-04-19 21:00:00', 4),
(5, 'Ivy\'s Infection', '2019-11-11 14:00:00', '2019-11-15 22:00:00', 4),
(6, 'Blood Nation', '2020-03-09 13:00:00', '2020-03-13 21:00:00', 4);


UPDATE weeklong_details SET stun_timer = 300, details =
'Fight through hordes of zombies... but also aliens.

LINK[Join the Discord!][https://discord.gg/wV6SqQ] Choose your role from role-reqest by clicking on the indicated emoji for a human or a zomnbie. Please be honest and play fair.
', monday =
'Mission email:
[SUBJECT] EYES ONLY not hands or teeth

All forces near checkpoint Omega should converge to Beach park. Hostile agents are attracted to unidentified noodle shaped objects which have been detected near a playground and should be handled with extreme care. Civilians have been told that we will be performing fumigation in the area. Get your stories straight. Any unauthorized personnel should be diverted. Secure the objects from any and all hostiles and wait for item extraction.


[SUBJECT] Monday Mission Update

The objects have been secured thanks to shakz, the lone survivor of the mission. Thanks to shakz the alien objects have been secured for observation and the outbreak has been contained so far.

Tomorrow Dr. Wolf will need assistance gathering research on campus. He will be making to runs during the day, one at 10am and the other at 2pm. Escort him according to the following route UMC Fountains -> Theatre -> Koi pond/Hale -> Old Main -> Norlin Fountains -> REC -> Ralphie.

Possible mission points:
All humans that are present for the start of the mission are awarded 10 points
All humans that are alive by the end of the mission are awarded 10 points.

Failure to complete the either escort mission will have consequences.',
tuesday = '', wednesday = '', thursday = '', friday = '' WHERE id = 1;
UPDATE weeklong_details SET stun_timer = 300, details =
'In a nutshell, the missions are designed as follows: successful completion of an on-campus mission lets the humans who completed it either choose to lengthen the zombie stun timer for the following day, or get a clue to help with that day\'s code.
Solving the code will give the location of the off-campus game, which starts at 5:00pm each day. Off-campus missions involve finding and defending one or more deely-boppers, which the zombies are trying to capture. When a zombie captures a deely-bopper, that zombie becomes a special infected.
',monday = '', tuesday = '', wednesday = '', thursday = '', friday = '' WHERE id = 2;
UPDATE weeklong_details SET stun_timer = 300, details =
'In a nutshell, the missions are designed as follows: successful completion of an on-campus mission lets the humans who completed it either choose to lengthen the zombie stun timer for the following day, or get a clue to help with that day\'s code.
Solving the code will give the location of the off-campus game, which starts at 5:00pm each day. Off-campus missions involve finding and defending one or more deely-boppers, which the zombies are trying to capture. When a zombie captures a deely-bopper, that zombie becomes a special infected.
',monday = '', tuesday = '', wednesday = '', thursday = '', friday = '' WHERE id = 3;
UPDATE weeklong_details SET stun_timer = 60, details =
'Don\'t forget to sign and bring your wavier when you pick up your bandanna!
LINK_NEW_TAB[Ragnarok Weeklong waiver][/weeklong/waiver/Spring19WeeklongWaiver.pdf]

LINK[Join the Discord!][https://discord.gg/nzqG7Wk] Choose your role from role-reqest by clicking on the indicated emoji for a human or a zomnbie. Please be honest and play fair.

This weeklong will be different than past weeklongs. This time we have Nerf blasters for the top 3 players! The players with the most points at the end of the weeklong will get to choose their prize blaster as well as securing a ticket to the lockin event that Friday night. Players can earn points by participating in off-campus missions, collecting supply drops and getting kills.

1st place: Hyperfire or Hades
2nd place: Surgefire or Hera
3rd place: Strongarm or Kronos
IMAGE[/images/weeklongS19_prizes.png]

Zombie stun timer will start at 5 minutes but can be reduced if humans fail their daily missions.

We\'ve also changed up how are humans have to play. Now humans have a starve timer and inactive humans will die if they don\'t go out and collect supply drops.
Here are all the sign locations for potential supply drops. Humans must enter the 5 character code, located on the bottom of the signs, in order to receive the supply drop. Keep in mind that there will be a limited number of supply drops at each location so make sure you get there before other humans! You can also receive supply drops by going to off-campus missions.
IMAGE[/images/sign_locations_map.png]


The skies weep
o\'er fire and ice
the gods
now risen
the earth
now fallen

Great Odin
the gates of
Valhalla
he shall open
and come forth
warriors of light

On this day,
brave warriors,
while thine
might now stand
who among you
will fall?

Ragnarok
is upon you
and with it comes
the final stone is turned
as humanity falls
to chaos,

Come now warriors
will you die
like trampled flowers
or will you stand
and make the darkness
fear your cry?


Chaos is here, friends, as it has been foretold. The army of the dead have risen to their God\'s command, and we must stand to face them. The gods are at out back, out weapons blessed by their hands, we must fight so that they might survive so that we might live to see the light of the sun once more. Surtr is coming, we are the last hope. If he triumphs, all will burn in his rage.
Will you answer the call?',monday =
'Greetings Warriors,

The first signs of Ragnarok are shown, the seer V\ölva has warned me of treachery on the part of my adoptive son Loki and my grandson. On this first day we require more strength to repel the forces of chaos, should they be upon us. On campus today will be late registration and bandanna pick up at the UMC.

Off campus at Scott Carpenter Park is where we will be hunting down my grandson in hopes of halting his plans. The mission will be capture the flag and will start 6 PM when the sun is low.

Farewell my children,
The All Father


Off-campus Rewards:
All players that participate in the off-campus mission will earn 15 points

Mission Success:
Humans present earn 10 points

Mission Failure:
Zombie stun timer reduced by 1 minute for all zombies', tuesday =
'Greetings Warriors,

Yesterday\'s mission at Scott Carpenter park proved to be a failure, resulting in the zombie stun timer to be reduced to 4 minutes.

My son Loki is hiding himself in the form a fish. We must obtain pieces of a net that have been scattered throughout campus. To obtain these pieces you must locate these statues and take "selfies" and submit them on discord using the instructions provided below. These "selfies" will capture the pieces of the net in the picture. All four locations must be captured for the piece of the net to be obtained. Warriors must work together to collect a total of 10 pieces in order to build the net.

Please locate these statues and take a "selfie":
IMAGE[/images/selfie_locations_S19.png]

Once the net pieces have been collected we can construct the net at Central Park and capture Loki at 6 PM. We must hold the area until the net can be constructed and then we may catch my son.

My children, I understand that you are needing sustenance to continue forth, I have sent you food for you and your families. The supplies have been sent to the following locations with the given amount of supplies at each location:

Sign #2: 25 supplies
Sign #6: 25 supplies
Sign #11: 25 supplies
Sign #18: 25 supplies
By aware the humans may only take one supply drop from any given location but they are allowed to collect from as many locations as they wish. Supply drops will increase the human stun timer by 24 hours with a cap for 48 hours. Collecting a supply drop also rewards that player with 10 points. Zombies cannot collect supply drops but are allowed to stalk those locations.
These supply drops will expire at 5pm today and new ones will be deployed tomorrow.
LINK_NEW_TAB[Here\'s a link for the sign locations][/images/sign_locations_map.png]

Discord picture submission instructions:
Today there will be a chat on our discord players tab called "Tuesday-photo-submissions". Use this chat to submit your photos by 5pm today. The earlier the better. Your messages and photos will not be seen by others and after submitting your photos will disappear from your view, but don\'t worry, they have been submitted. Please submit all photos at the same time as well as your username and/or player code. Have fun. And be creative.

Farewell my children,

The All Father

On-campus Rewards:
Humans earn 5 points per correct selfie submitted
Humans earn bonus 10 points for all correct selfie locations

Mission Failure:
Zombie stun timer reduced by 1 minute for all zombies

Off-campus Rewards:
All players that participate in the off-campus mission will earn 15 points

Mission Success:
Humans that survive receive a supply drop
Humans that win receive 10 bonus points

Mission Failure:
Zombie stun timer reduced by 1 minute for all zombies', wednesday =
'Greetings Warriors,

Tuesday missions report
The on-campus mission resulted in the humans being successful! With a total of 11 full sets of "selfies" submitted we were able to retrieve pieces of the net. Unfortunately the off-campus mission proved to be a failure, the humans could not put together the in time and hence forth the zombie stun timer has been reduced to 3 minutes.

On this day I fear the prophesied winters are come, Today we are called to defend the remnants of civilization. There remains two mid-guardian cities who have not fallen to the forces of chaos, and on this day, brave warriors, we are called to defend. On campus at Wolf Law Soccer Field will be soccer defense at 1:30 PM. As well, warriors, today more sustenance will be delivered, humans must gather supplies while they can to avoid starvation.

My children, survival is necessary, we are the last pillars of the realms. We must gather and prepare our forces for the days ahead, at Beach Park at 6 PM. There will be much needed supplies and we must race to retrieve them before the forces of death.

I have sent out more supplies to those in need. Unfortunately these supply drops are not protected by magic and now the zombies can steal the supplies. Luckily these supplies are not made from human flesh and are less effective in feeding the zombies. I also seem to have misplaced one of the supply drops, all I can remember is that it was at an odd sign location. Further rewards will be given to those who find it, please find it before the dead do.
Sign #4: 25 supplies, worth 10 points
Sign #10: 25 supplies, worth 10 points
Sign #16: 25 supplies, worth 10 points
Missing supply drop: 10 supplies, worth 40 points

Farewell my children,
The All Father


On-campus Rewards:
All players that participate in the on-campus mission will earn 15 points

Mission Failure:
Zombie stun timer reduced by 45 seconds for all zombies


Off-campus Rewards:
All players that participate in off-campus mission will earn 15 points

Mission Success:
Surviving humans earn 20 points + 1 supply drop

Mission Failure:
Zombie stun timer reduced by 45 seconds for all zombies', thursday =
'Greetings Warriors,

Yesterday proved to be disastrous as humans lost both the on and off campus missions resulting in the zombie stun timer being 1 minute and 30 seconds.

Loki has broken free from his chains and the Earth has started to rumble. Buildings are crumbling and are being overrun by Hel\'s undead army. You must hold your outposts or there will be dire consequences.On campus is tower defense, poles with bandannas tied to them are defenses, humans must hold the towers by putting the bandanna above the line. Zombies must hold the tower by putting the bandanna below the line. Points will be recorded every half hour and posted on Discord. Refer to this map for locations of the control towers.
IMAGE[/images/control_tower_map.png]

The last of the supplies have been sent out but Loki has taken it upon himself to hide one of the supply drops and all I can see is that it\'s located somewhere within the marked area. Here are the supply drops to collect.
Sign #12: 10 uses, +24 hours, +20 points
Sign #3: 10 uses, +24 hours, +20 points
Stolen supply drop: 10 uses, +24 hours, + 40 points
IMAGE[/images/stolen_supply_drop.png]

Tonight we must preserve what we can and protect our ancient bloodlines. Warriors must rendezvous at Martin Park to help escort friends and families to safety. The undead will be upon us so come prepared. Off-campus is escort at Martin Park at 6 PM.

The day is growing dark my children.
Farewell,
The All Father

On-campus Rewards:
Mission Failure:
Zombie stun timer reduced by 15 seconds for all zombies


Off-campus Rewards:
All players that participate in off-campus mission will earn 15 points

Mission Success:
Surviving humans receive a supply drop

Mission Failure:
Zombie stun timer reduced by 15 seconds for all zombie
Zombies are fed +12 hours', friday =
'Greetings Warriors,

Yesterday humans took heavy losses and were unable to hold their stations and failed at saving their family members. The zombie stun timer has reached its lowest at 1 minute. I wish you good luck to those who are left standing, you are our last hope.

Today my message to you is one of grief. Ragnarok is upon us. The giants are overtaking the realms and now the gods must step in to protect the last survivors. Today my children, you must write your name on a scroll to ensure the protection of the gods. We will preserve you, warriors, to ensure the greatest success in the battle for peace but you must still be human at the end of the day to receive that protection. On campus mission is to write your name an a book in the area with the LINK_NEW_TAB[Rock with a square cut out of it.][https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656]

Come now brave warriors, the time for battle is near. The Lock-in is Tonight, doors open at 9pm and close at 10pm.
LINK_NEW_TAB[Reserve your spot and accepting this invitation.][https://www.eventbrite.com/e/cu-hvz-ragnarok-tickets-60309888500]
LINK_NEW_TAB[If you require weaponry we have some that you may rent, free of course.][https://www.eventbrite.com/e/cu-hvz-ragnarok-blaster-rental-tickets-60286249796]

Farewell my children,
The All Father

On-campus Rewards:
Humans earn 50 points if their USERNAME is written in the notebook and they are still human at 5pm today.' WHERE id = 4;
update weeklong_details set stun_timer = 60, details =
"Boulder is in chaos. Poison Ivy has created a super-virus that’s turning people into her zombie slaves. But she’s not alone. She’s teamed up with villains from all over the multiverse so that they’re powerful enough to take over the city. We need your help to stop them.

Details/Rules:
- Off-campus is not perma death for humans, just for fun and points. Humans that ger tagged during off-campus missions will remain human after the mission and zombies will still get their points.
- Yellow bandana must be worn around your leg to identify you as a player of the game.
- The green bandana is worn on your head for zombies and around arm for humans.
- Poisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.
IMAGE[/images/human.jpg][45]IMAGE[/images/zombie.jpg][45]

Suppy Drop Locations:
IMAGE[/images/signs-fall19.png]", monday =
'[SUBJECT]: Villainy is Afoot
Attention League of Heroes,

This is Commissioner Gordon from the Gotham City Police Department.

We recently had an alarming report reach the Gotham Police. Poison Ivy and a band of villains have been planning something dastardly; there’s been increased activity targeting chemical transports and chemical storage centers. We think they may be planning to create some sort of poison. Those affected by the poison have turned into zombie-like slaves.

I will be dispatched to Boulder, Colorado to attempt to track down these villains before they can complete their plan.

We need you to come and agree to help us track down these fiends. Today at the BOLD[UMC is the final day to receive bandanas and turn in your waiver]. We will have a table set up for you to do so. There will be BOLD[no off campus mission] today on account of weather.

Stay Vigilant,
Commissioner Gordon', tuesday =
"[SUBJECT]: The Riddler
Attention Heroes,

This is Commissioner Gordon.

I have danINCLUDE[riddler.txt]

Hello, hello, hello, mindless people of Boulder.

I have a dangerous game to play, for those of you who are able. My games and riddles will bring you down to the cable.

I have many gifts set, now it's time for you to fret. Three by three you must find for me, carefully placed will be the key. Central Park you must go, or let the zombie horde grow.

Follow my riddles, disable my tricks, and you may live to see another day.

So what do you say,
Want to play?

- The Riddler

I have one more riddle for you friends,
We are what is necessary for your life
But if you eat us you may be dead
Pick a number, a supply for you
Beware whether it’s aid is false or true.
Poison can be deadly.

——————————————CONNECTION REESTABLISHED————————————--

Heroes, this is commissioner Gordon. I do not know what the Riddler is planning but we know he will be active at Central park at 5pm. Please aid me in capturing him and foiling his plans. Careful when collecting these supply drops as it seems The Riddler may have poisoned one of them.

Stay Vigilant,
Commissioner Gordon", wednesday =
"[SUBJECT] Winter is Coming and Frost is Leading It
Attention Heroes,

This is Commissioner Gordon. I must first inform you that yesterday's mission failed. The Riddler was able to denote his packages releasing more of Poison Ivy's gas, this has resulted in these 'zombies' becoming more powerful.

---- Zombie stun timer has been reduced to 4 minutes ----

We’ve recently had reports of Killer Frost being active in the Boulder area. She is dangerous, and anyone who has tried to stop her has been frozen and reanimated as one of Ivy’s Zombies. She has been attempting to speed up the process of winter to make people more susceptible to the toxin Poison Ivy is making.
We have a plan on how to stop her: Frost is extremely self-conscious about her appearance and jealousy can be a way to drive her into the open. We need you to take 'selfies' at specific locations showing off yourself and your friends. This should demoralize Frost and make her easier to capture. See image below for locations where the selfies must be taken, we're not sure where these are but we do know that these locations are the ones that will bring Killer Frost out in the open. At least 30 total correct selfies must be achieved to draw her out.
IMAGE[/images/selfie-pics.jpg]

I've also sent out more supplies to those who need it but this batch seems to attract the zombies and they are eating it. Get to those supply drops fast before the zombies steal them all
We have also received information about a robbery that is going to occur at Martin park at 5 pm. Meet there to intercept the thieves.

Best of luck Heroes,
Gordon", thursday =
"[SUBJECT] Infectious Laughter

Attention Heroes,

Yesterday was a dark day. Both missions failed and as a result the zombies have grown more powerful.
****** Zombie stun timer reduced to 2 minutes ******

INCLUDE[joker.txt]

HAHAHAHAHHAHAHAHAHAHAHAHHA
<div class='center'>
<img src='/images/smile.png' style='width: 150px'>
</div>
HELLOO COMMISSIONER

heheHAHAHAHAhahehaha I have a game thAtS sUrE to make you DIE from LAuGHTeR. I’ve put some of mY TOYS around your city, they’re tick-TOCKING down as we SPEAK. Try to deactivate them if you wiSH but a big THANKS to Ivy for her little poison. Her little pets can FIX what you try to do, commissioner.

Let's HAVE SOME FUN BOYS

MR. J

———————— CONNECTION REESTABLISHED ————————

Hello? Hello, this is Commissioner Gordon.
The Joker is up to his schemes and we need to stop him. His towers have been set up at 3 locations on CU Boulder's campus. These towers go off every 30 minutes and must be deactivated to prevent them from releasing more of Poison Ivy's gas into the atmosphere. Shutting down these towers won't be enough to stop them alone, the zombies can reactivate the towers so you must make sure to keep deactivating them. LINK_NEW_TAB[Here are the locations of the towers.][/images/control_tower_map.png]

The joker has also hinted at causing more mayhem at Scott Carpenter at 5pm. Please come and help stop his evil plans.

We need your help heroes.
Commissioner Gordon", friday =
"Attention Heroes,

Yesterdays missions proved to be failures and the zombies are reaching staggeringly dangerous levels.

****** Zombie stun timer is now 1 minute ******

The city is in grave parrel. Lex Luthor plans to launch an attack on the city. We must evacuate all remaining heroes and citizens that have not yet been infected. I have set up a log that you can write your name in so we know who to evacuate and we will send a chopper to get you at Beach park at 5pm today. LINK_NEW_TAB[Here is the location of the log][https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656].

I have also sent out the last of our supplies for those in need.

Good luck heroes,
Commissioner Gordan"
where id=5;

UPDATE weeklong_details SET stun_timer = 120, details =
'Years after the return of the Avatar and the war had ended a new nation emerged, a nation of blood. Powered by dark spirits and fueled by rage and revenge for their people, a group of blood benders formed Blood Nation.

The blood benders made a deal with the dark spirits, allowing the spirits to inhabit their bodies in exchange for enhancing their blood bending capabilities beyond imagination. The dark spirits bestowed the ability to control anyone from anywhere as long as they have been infected with dark spirit energy.

They have declared war on the Fire Nation and have begun to advance their brainwashed armies. Coming into contact with anyone infected with the dark spirit energy results in the infection immediately spreading and taking control of their mind, joining the Blood Nation.

BOLD[When to turn in your waiver and get your bandanas:]
We will be tabling in the UMC during these times
Tuesday 3/3, 9 am - 5pm
Wednesday 3/4, 9 am - 5pm:
Thursday 3/5, 9 am - 5pm
Friday 3/6, 9 am - 5pm
Monday 3/9, 9 am - 5pm

BOLD[Details/Rules:]
- Off-campus is not perma death for humans, just for fun and points. Humans that get tagged during off-campus missions will remain human after the mission and zombies will still get their points.
- Yellow bandana must be worn around your leg to identify you as a player of the game.
- The green bandana is worn on your head for zombies and around your arm for humans.
- Poisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.
IMAGE[/images/human.jpg][45]IMAGE[/images/zombie.jpg][45]


Suppy Drop Locations:
IMAGE[/images/signs-fall19.png]',monday =
'[SUBJECT]: Investigate the Rig

Defenders of the Fire Nation,

We’ve received reports of Blood Nation forces inhabiting the abandoned Fire Nation prison rig. We need volunteers to go investigate if the rumors are true. Be careful, as the rig is old, unstable and has begun to collapse. Remove any Blood Nation forces that reside there and return home safely.

Remember, don’t come into contact with any of the Blood Nation forces. We must stop the dark spirits from spreading.

- General Zuko', tuesday =
'[SUBJECT]: Defend the Moon Spirit

Defenders of the Fire Nation,

In the aftermath of yesterday’s events, it has come to our attention that the citizens of the Northern Water tribe have been disappearing. We believe that the Blood Nation is behind these disappearances and that they plan to steal the Moon spirit to further increase their blood bending abilities. Go and protect the Moon spirit at all costs.

I have sent out supplies to any of those who may need it but beware that Blood Nation soldiers may try to steal them.

- General Zuko

[LINE]

[SUPPLY_DROPS]
One of these has been poisoned
Sign #9: 15 supplies
Sign #15: 15 supplies
Sign #17: 15 supplies
Sign #22: 15 supplies
Poisoned supply drops will reduce the effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.
LINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', wednesday =
'[SUBJECT]: Rock Slides in the Kolau Mountains

Defenders of the Fire Nation,

We have received reports of an unusual number of large rock slides in the Kolau Mountains in the Earth Kingdom. This could be related to Blood Nation activity. We’re sending you in to investigate and determine if there is any threat.

While you’re in the Earth Kingdom we’d like you to recruit Toph Beifong to aid in our efforts against the Blood Nation. She may be stubborn about it, so you will have to prove you’re worthy of her help… I wish you good luck.

- General Zuko

[LINE]

[SUPPLY_DROPS]
One of these has been poisoned
Sign #4: 10 supplies
Sign #7: 10 supplies
Sign #11: 10 supplies
Sign #19: 10 supplies
Poisoned supply drops will reduce the effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.
LINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', thursday =
'[SUBJECT]: Blue Spirit

Defenders of the Fire Nation,

A Blue Spirit imposter is wreaking havoc in the Fire Nation capital, setting fire to buildings and setting off explosives. Put out the fires and save anyone you can. Stopping this Blue Spirit imposter is of utmost importance.

- General Zuko

[LINE]

[SUPPLY_DROPS]
One of these has been poisoned. Zombies can still steal but can not be poisoned.
Sign #6: 10 supplies
Sign #12: 10 supplies
LINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]', friday =
'[SUBJECT]: Invasion

Defenders of the Fire Nation,

We have failed: the invasion has begun. All citizens that are not infected by the Dark Spirits must be evacuated immediately. We will send in an airship at 5 pm to pick up all survivors that have registered themselves in the logbook.

Our last hope is the Avatar. Avatar Aang will travel to the Spirit world to talk to Koh in hopes of learning of a way to stop the Dark Spirits. Aang must be protected while in the Avatar state. If he falls under the control of the Blood Nation… all hope will be lost.

- General Zuko' WHERE id = 6;

INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES
(1, "monday", "on", "Late sign up, check in, bandanna retrieval", "9am - 5pm", "UMC indoors", "", ""),
(1, "monday", "off", "Defense", "6pm - 7pm", "Beach park", "https://www.google.com/maps/place/Beach+Park/@40.0048439,-105.2777321,16.71z/data=!4m8!1m2!2m1!1sbeach+park!3m4!1s0x0:0x68c652cd71473e8f!8m2!3d40.0048652!4d-105.2767923", ""),
(1, "tuesday", "on", "Escort", "10am and 2pm", "UMC Fountains -> Theatre -> Koi pond/Hale -> Old Main -> Norlin Fountains -> REC -> Ralphie", "", ""),
(1, "tuesday", "off", "Capture the flag", "6pm - 7pm", "Scott Carpenter park", "https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038", ""),
(1, "wednesday", "on", 'Station controll', "11am - 5pm", "Norlin quad, Farrand field", "", "To control a station: \nHumans: Move bandanna above marked line\nZombies: Move bandanna below marked line\nFlags will be checked hourly and the score will be tracked."),
(1, "wednesday", "off", "Scavenger hunt", "6pm - 7pm", "Martin Park", "https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520229,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342", ""),
(1, "thursday", "on", "Soccer defense", "2pm - 3pm", "Soccer field by Wolf Law", "", ""),
(1, "thursday", "off", "Transport", "6pm - 7pm", "Harlow Platts Park", "https://www.google.com/maps/place/Harlow+Platts+Community+Park/@39.9732298,-105.2512539,16.22z/data=!4m5!3m4!1s0x876bed11894519ef:0xece9795e891ae36e!8m2!3d39.9746374!4d-105.2486266", ""),
(1, "friday", "on", 'Data entry', "9am - 5pm", "Rock with square hole", "https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656", "Enter your username into the data log for identification during extraction."),
(1, "friday", "off", "Retrieval and evacuation", "6pm - 7pm", "Chautauqua", "https://www.google.com/maps/place/Chautauqua+Park/@39.9992037,-105.2836883,17z/data=!3m1!4b1!4m5!3m4!1s0x876bec4712c4dfc1:0x761597124a9e2eab!8m2!3d39.9991996!4d-105.2814996", "");
INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `description`) VALUES
(2, "monday", "on", "Late registration, last minute waiver hand in, trick or treat and sign sheet"),
(2, "monday", "off", "Scavenger hunt for deely boppers* (Location - Will Vill fields)"),
(2, "tuesday", "on", "Take pictures in front of designated buildings on campus in their halloween costumes with bandanas clearly visible email pictures to us"),
(2, "tuesday", "off", "Have a mod be a “pumpkin person” and zombies have to collect pumpkins from around the park and bring them to the “pumpkin person” (Location - Beach Park)"),
(2, "wednesday", "on", "Escort “newsperson” mission  from: C4C to: UMC fountains middle stops: circle patch of grass outside the engineering center, Ralphie Buffalo statue, Norlin fountains, Rock statue with the loop, UMC fountains. (Head north and loop around CHEM to the UMC.)"),
(2, "wednesday", "off", "half-priced halloween candy defend the supply drop escort mission (Location - Boulder Creek Path; start under Folsom St bridge)"),
(2, "thursday", "on", "riddle mission, use words on lawn signs around campus (different phrases on each sign with one word capitalized). Potential reward: vaccine? Email the final phrase to a proxy email. We will then email out vaccine codes to first 5 or 10."),
(2, "thursday", "off", "(Deely bopper reward) Humans have to rotate around 3 spots, carrying (heavy) object (or two) to reset timers that last 5mins? And object has to remain in human hands for humans to win. If the object passes to and remains with zombies at any point during the mission, humans lose. Also if 2 or more timers get fucked also if even one timer gets to 12 minutes zombies win (Location - Martin Park)"),
(2, "friday", "on", "Zombies must join hands in a giant circle around the patch of grass in the biking roundabout in front of the EC. If they surround the entire circle with unstunned zombies, they win, and get deely boppers for Chautauqua. If they cannot succeed at this within 45 minutes, humans win a shortened time for Chautauqua. Zombies may not enter the circle itself, but humans may."),
(2, "friday", "off", "Per tradition, the off-campus mission takes place at Chautauqua park. Before starting the game, any remaining Deely Boppers are distributed to the surviving humans. During the mission, if a zombie kills a human who is carrying deely-boppers, then the zombie gets those boppers and becomes a Special Infected. In order to win, humans must defend the gazebo from the zombies for the full 45 minutes. Zombies win by having SPECIAL INFECTED touching both main pillars of the gazebo simultaneously for a eight-count, or by killing all the humans. In this way, the humans must defend the gazebo from the Special Infected for the entire duration of the game. Note that if the zombies win the on-campus mission that day, then the Special Infected will have a stun timer of only 1 minute.

So, the humans and zombies arrive at the park. At 5:00, the zombies begin attacking the gazebo. If, at any point, at least two Special Infected enter the gazebo and are simultaneously touching the pillars for a full eight-count, then the humans lose and the weeklong ends.");
INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `description`) VALUES
(3, "monday", "on", "Between 10:00 and 4:00, humans must LINK[go here][https://goo.gl/maps/T3qu61iSeds], to the stone monument in the center of the little park,
and sign their name to the list. By the time 4:00 rolls around, if 2/3 of the human population has not signed their name to the list, the zombies win. If there are enough signatures, then the humans win and receive the location of the first off-campus mission.
If the humans win - they will receive a hint to the code which gives them the location of the off-campus mission
If the zombies win - they will get that hint
(This mission has essentially two purposes: It is easy, and can be accomplished by individuals without too much effort and in accordance with their schedule, while also giving them opportunities to see and interact with each other. It also reinforces the idea that humans are united in their goals.  At the same time, it also gives the OZs a much higher chance of finding humans to kill on that first day, since there will be high traffic through that one area. The humans will likely win the mission, but many of them will be tagged nonetheless.)"),
(3, "monday", "off", "The first off-campus mission will be at Martin Park. This is where we will introduce the deely-bopper game element, and humans will likely win this mission. There will be a single bopper, located at the far end of the park away from the street/bus stop. Humans will have to defend this single, stationary area from 5:00 to 5:45. If a zombie is able to grab the deely bopper (not just touch it, but physically grab it) then that zombie becomes a Special Infected and the humans lose the mission.

If the zombies win - Stun Timers for the next day will decrease by 1 minute."),
(3, "tuesday", "on", "For day two, humans must escort an NPC around campus, taking photos at major locations to demonstrate that there\'s no real zombie threat. The NPC will spawn in front of the C4C, and humans must take a photo of him at each of the three locations:
- Standing in the fountain of the UMC
- With the buffalo statue of the stadium in the background
- In front of Old Main

The photos must contain at least three posed human players and NO ZOMBIES. Any photo with a zombie in it will be invalidated. Meanwhile, the zombies are trying to zombify the NPC. To zombify the NPC, at least one zombie must touch and maintain touch with the NPC for an out-loud count of five-mississippi. (the NPC, when initially touched, will freeze in horror.)

If the humans win - they will receive a clue to the day\'s code, OR, the zombie stun timer will be increased by one minute for the next day.
If the zombies win - they will receive a clue for the day\'s code, OR, the zombie stun timer will be decreased by one minute."),
(3, "tuesday", "off", "The second off-campus mission will be at LINK[Beach park][https://goo.gl/maps/9L62BGE9eFB2], and will feature two deely boppers, placed on opposite ends (northeast and southwest) of the small square park. As before, the humans are attempting to protect both deely boppers for the entire hour between 5:00 and 5:45. If one of the deely-boppers is taken during the mission, the zombie who took it has his spawn time lowered to 30 seconds.

If the humans are able to defend both points - The zombie stun timer is raised by one minute, and 10 vaccines will be distributed among the surviving human (maximum one per player.)
For each bopper the zombies are able to recover, the zombie stun timer is lowered by one minute for the next day."),
(3, "wednesday", "on", "Humans must collect twelve doodads (pictured below) which are planted across Norlin Quad.
Humans will start at the stairs leading up to the front of Norlin.
Zombies will start at the opposite end of Norlin, near the Hale science building. Humans have an hour to gather all twelve doodads, but if any of them leave the rectangle of Norlin quad, they may not re-join the mission.

If humans win - they get a clue for that day\'s code, OR, they may raise the zombie stun timer by one minute.
If Zombies win - they get a clue for that day\'s code, OR, they may lower the zombie stun timer by one minute."),
(3, "wednesday", "off", "The third off-campus mission will be at LINK[Scott Carpenter park][https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038]. There will be three stationary deely-boppers to defend, one at the top of the hill to the Northwest (near the playground) one at the top of the hill to the Southwest, and one at the bottom of the hill to the East.
As before, humans will attempt to defend these three points until 5:45. Each time a deely-bopper is successfully taken by a zombie, that zombie\'s stun timer decreases by 45 seconds.

If the humans successfully defend all 3 deely boppers - the zombie stun timer is raised by one minute, and 10 vaccines are distributed among the surviving players (limit 1 each)
For each deely-bopper the zombies steal, the zombie stun-timer is lowered by one minute for the following day."),
(3, "thursday", "on", "For day four, humans will have to defend a certain number of zones of the soccer pitch near Smith dormitory. Humans will arrange themselves in the zones. If a zombie is able to pick up the cone in each of the zones, no humans may enter that zone, but they may leave it. In this way, as zombies overrun each zone, the humans flee and cannot return. A human who leaves the soccer pitch entirely is out of the game, but is not zombified.

In order to win, humans must defend at least 1/3 of the zones of the soccer pitch for 20 minutes (or more/less depending upon player turnout). Zombie stun timer during this event is also based on player turnout.

If the humans win - they can either get a clue for the day\'s code, OR they can increase the zombie stun timer by one minute for the next day.
If the zombies win - they can either get a clue for that day\'s code, OR they can lower the zombie stun timer for one minute for the following day."),
(3, "thursday", "off", "For day four, the humans must defend three deely boppers at Harlow Platts park. There will be two stationary deely boppers, and one which is being worn by an NPC. The NPC will circle the lake repeatedly for the 45 minutes. The other two deely boppers will be located at the Southwest and Northwest areas of the park (see map). If a zombie tags the NPC, that zombie gets the deely boppers and becomes a special infected.

If the humans successfully defend all 3 deely boppers - the zombie stun timer is raised by one minute, and 20 vaccines are distributed among the surviving players (limit 1 each)
For each deely-bopper the zombies steal, the zombie stun-timer is lowered by one minute for the following day."),
(3, "friday", "on", "For the final on-campus mission, human players must make a human pyramid on Farrand field. Mods will mark out an area using the flag football cones near the center. The pyramid must be built within that area, must contain at least 10 players, and from the moment the 10th player is in the top spot, it must stand for a full 10 count (ten “mississippis”). Having achieved that, the humans win the mission, and are granted safe passage off of Farrand Field. If the pyramid is toppled, or is not built within the necessary time period, the zombies win.

If the humans win - they increase the zombie stun timer by one minute for the final mission.
If the zombies win - the final mission will have a stun timer of 3 minutes, not 5."),
(3, "friday", "off", "Per tradition, the off-campus mission takes place at Chautauqua park. Before starting the game, any remaining Deely Boppers are distributed to the surviving humans. During the mission, if a zombie kills a human who is carrying deely-boppers, then the zombie gets those boppers and becomes a Special Infected. In order to win, humans must defend the gazebo from the zombies for the full 45 minutes. Zombies win by having SPECIAL INFECTED touching both main pillars of the gazebo simultaneously for a eight-count, or by killing all the humans. In this way, the humans must defend the gazebo from the Special Infected for the entire duration of the game. Note that if the zombies win the on-campus mission that day, then the Special Infected will have a stun timer of only 1 minute.

So, the humans and zombies arrive at the park. At 5:00, the zombies begin attacking the gazebo. If, at any point, at least two Special Infected enter the gazebo and are simultaneously touching the pillars for a full eight-count, then the humans lose and the weeklong ends.");
INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES
(4, "monday", "on", "Late sign up, check in, bandanna retrieval", "9am - 5pm", "UMC indoors", "", ""),
(4, "monday", "off", "Capture the flag", "6pm - 7pm", "Scott Carpenter park", "https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0116189,-105.2552645,140m/data=!3m1!1e3!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038", ""),
(4, "tuesday", "on", "Selfie scavenger hunt", "9am - 5pm", "Selfie locations", "/images/selfie_locations_S19.png", ""),
(4, "tuesday", "off", "Scavenger hunt and king of the hill", "6pm - 7pm", "Central park", "https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274", ""),
(4, "wednesday", "on", "Soccer defense", "1:30pm", "Wolf Law soccer fields", "", ""),
(4, "wednesday", "off", "3 legged humans survival", "6pm - 7pm", "Beach park", "https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923", ""),
(4, "thursday", "on", "Tower Control", "9am - 5pm", "Station locations", "/images/control_tower_map.png", ""),
(4, "thursday", "off", "Eggscort / Checkpoint", "6pm - 7pm", "Martin Park", "https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520229,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342", ""),
(4, "friday", "on", "Data entry", "9am - 5pm", "Rock with square hole", "https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656", "Enter your username into the data log for identification during extraction."),
(4, "friday", "off", "", "", "", "", "LINK_NEW_TAB[The story continues at the Ragnarok Lock-in.][https://www.eventbrite.com/e/cu-hvz-ragnarok-tickets-60309888500]");
INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES
(5, "monday", "on", "Late sign up", "9am - 5pm", "UMC indoors", "", ""),
(5, "monday", "off", "", "", "", "", "Canceled due to weather"),
(5, "tuesday", "on", "Supply Drops", "9am - 5pm", "", "",
"One of these has been poisoned
Sign #10: 25 supplies
Sign #12: 25 supplies
Sign #15: 25 supplies
Sign #23: 25 supplies
Poisoned supply drops will reduce effectiveness of the next 3 supply drops used. After 3 unpoisoned supply drops have been collected the poison is cured.
LINK_NEW_TAB[Sign Location Map][/images/signs-fall19.png]"),
(5, "tuesday", "off", "Scavenger Hunt", "5pm", "Central Park", "https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274",
"Success: All humans alive at the end of the mission receive extra points
Fail: Zombie stun timer reduced by 1 minute"),
(5, "wednesday", "on", "Selfies", "9am - 5pm", "Selfie Picture Locations", "/images/selfie-pics.jpg",
"Total of 30 selfies must be submitted in order to complete the mission
Mission failure: Zombie stun timer reduced by 1 minute
Mission Rewards:
1/4 correct selfies = 5 points
2/4 correct selfies = 10 points
3/4 correct selfies = 20 points
4/4 correct selfies = 40 points
Best voted selfie (with permission from player) will receive 10 bonus points.
How to submit selfies:- All selfies must be submitted at the same time along with your username and player code.
- Selfies must be submitted to the photo-submissions chat on discord by 5pm.
- Player must be clearly visible and recognizable in picture. Group pictures are fine as long as we can identify the player submitting the photos, so circle yourself in one of the selfies so we know it's you.
- Submissions that are missing the username and player code will not be counted"),
(5, "wednesday", "off", "Checkpoints", "5pm", "Martin park", "https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520282,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342",
"Attending players will receive 20 bonus points for attending and will have their hunger fed.
Mission failure: Zombie stun timer reduced by 1 minute"),
(5, "thursday", "on", "Tower control", "9am - 5pm", "Tower locations", "/images/control_tower_map.png",
"- Towers are made of PVC and are leaned against trees
- Towers will be checked every half an hour and updates will be posted on Discord
- Stations will be checked every half hour and points recorded
- Humans must move the bandana above the line- Zombies must move the bandana below the line
- Humans must have more points than zombies to winMission failure: Zombie stun timer reduced by 1 minute"),
(5, "thursday", "off", "Capture the Flag", "5pm", "Scott Carpenter Park", "https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0117331,-105.2570978,17z/data=!3m1!4b1!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038",
"Attending players will receive 20 bonus points for attending and will have their hunger fed.
Mission failure: Zombie stun timer reduced by 1 minute"),
(5, "friday", "on", "Notebook", "9am - 5pm", "Rock with square hole", "https://www.google.com/maps/@40.0079274,-105.2711151,3a,75y,35.01h,74.28t/data=!3m6!1e1!3m4!1sf2hKqkG6UyTgThoKv6XnOQ!2e0!7i13312!8i6656",
"- Humans must write their username in the notebook
- Players in the notebook will receive 50 points at the end of the day if they are still human
- Username MUST be legible"),
(5, "friday", "off", "Timed Defense", "5pm", "Beach Park", "https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923", "Attending players will receive 30 bonus points for attending");

INSERT INTO `weeklong_missions` (`weeklong_id`, `day`, `campus`, `mission`, `time`, `location`, `location_link`, `description`) VALUES
(6, "monday", "on", "Late sign up", "9am - 5pm", "UMC indoors", "", ""),
(6, "monday", "off", "Shrinking Zone Control", "5:30 pm", "Beach Park", "https://www.google.com/maps/place/Beach+Park/@40.004847,-105.276902,19z/data=!4m5!3m4!1s0x876bec376bb59e5f:0x68c652cd71473e8f!8m2!3d40.0048653!4d-105.2767923", "All players present receive 10 points and +6 hours on their starve timer"),
(6, "tuesday", "on", "Soccer Defense", "1 pm", "Kittredge Soccer Fields", "", "All players present receive 10 points and +6 hours on their starve timer"),
(6, "tuesday", "off", "Capture the flag", "5 pm", "Scott Carpenter Park", "https://www.google.com/maps/place/Scott+Carpenter+Park/@40.0117331,-105.2570978,17z/data=!3m1!4b1!4m5!3m4!1s0x876bedcf78916ba5:0x1d4e20b0486c7c12!8m2!3d40.011729!4d-105.2549038", "All players present receive 10 points and +6 hours on their starve timer"),
(6, "wednesday", "on", "Selfies", "9am - 5pm", "Find them", "",
"Total of 16 selfies must be submitted in order to complete the mission
Mission failure: Zombie stun timer reduced by 1 minute
Mission Rewards:
1/4 correct selfies = 5 points
2/4 correct selfies = 10 points
3/4 correct selfies = 20 points
4/4 correct selfies = 40 points
Best voted selfie (with permission from the player) will receive 10 bonus points.
How to submit selfies:
- All selfies must be submitted at the same time along with your username and player code through Discord photo-submissions channel.
- Selfies must be submitted to the photo-submissions chat on discord by 5 pm.
- Player must be clearly visible and recognizable in the picture. Group pictures are fine as long as we can identify the player submitting the photos, so circle yourself in one of the selfies so we know it\'s you.
- Submissions that are missing the username and player code will not be counted
IMAGE[/images/selfies-spring2020.jpg]"),
(6, "wednesday", "off", "King of the Hill", "5 pm", "Central Park", "https://www.google.com/maps/place/Central+Park/@40.0149835,-105.2780824,18z/data=!4m8!1m2!2m1!1scentral+park!3m4!1s0x0:0xfbc3400e4a4953f6!8m2!3d40.0155847!4d-105.2785274", "All players present receive 10 points and +6 hours on their starve timer"),
(6, "thursday", "on", "Tower defense", "9am - 5pm", "Tower locations", "/images/control_tower_map.png",
"- Towers are made of PVC and are leaned against trees
- Towers will be checked every half an hour and updates will be posted on Discord
- Stations will be checked every half hour and points recorded
- Humans must move the bandana above the line- Zombies must move the bandana below the line
- Humans must have more points than zombies to winMission failure: Zombie stun timer reduced by 1 minute"),
(6, "thursday", "off", "Egg-scort", "5:30 pm", "Martin park", "https://www.google.com/maps/place/Martin+Park/@39.9889483,-105.2520282,17z/data=!3m1!4b1!4m12!1m6!3m5!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!2sMartin+Park!8m2!3d39.9889442!4d-105.2498342!3m4!1s0x876beda6c350f9cd:0xbfe19b6c4417032e!8m2!3d39.9889442!4d-105.2498342", "All players present receive 10 points and +6 hours on their starve timer"),
(6, "friday", "on", "", "", "", "",
"Canceled
Due to the rising risks of Covid-19 we have decided to cancel Friday's on and off-campus missions. Stay safe out there."),
(6, "friday", "off", "", "", "", "",
"Canceled
Due to the rising risks of Covid-19 we have decided to cancel Friday's on and off-campus missions. Stay safe out there.");


-- -----------------------------------------------------
-- Table `CUHvZ`.`weeklong_players`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_players` ;

CREATE TABLE IF NOT EXISTS `CUHvZ`.`weeklong_players` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weeklong_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `player_code` VARCHAR(55) NOT NULL,
  `type` ENUM('normal', 'oz', 'suicide','starved', 'inactive') NOT NULL DEFAULT 'normal',
  `status` ENUM('human', 'zombie', 'deceased') NOT NULL,
  `poisoned` INT NOT NULL DEFAULT 0,
  `points` INT NOT NULL DEFAULT 0,
  `kills` INT NOT NULL DEFAULT 0,
  `starve_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `weeklong_idx` (`weeklong_id` ASC),
  UNIQUE INDEX `weeklong_player_code` (`player_code` ASC, `weeklong_id` ASC),
  INDEX `player_idx` (`user_id` ASC),
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

INSERT INTO `weeklong_players` (`weeklong_id`, `user_id`, `player_code`, `status`, `type`, `points`, `kills`, `starve_date`) VALUES
(1, 69, '5674b', 'human', 'normal', 0, 0, NULL),
(1, 67, '967a5', 'human', 'normal', 0, 0, NULL),
(1, 113, 'ffb6b', 'human', 'normal', 0, 0, NULL),
(1, 70, 'f8ed0', 'human', 'normal', 0, 0, NULL),
(1, 71, '25e69', 'human', 'normal', 0, 0, NULL),
(1, 72, '7ae7a', 'human', 'normal', 0, 0, NULL),
(1, 75, 'efee6', 'human', 'normal', 0, 0, NULL),
(1, 73, 'f75b1', 'human', 'normal', 0, 0, NULL),
(1, 74, 'cf90d', 'human', 'normal', 0, 0, NULL),
(1, 80, '1bfd1', 'human', 'normal', 0, 0, NULL),
(1, 81, 'fd71f', 'human', 'normal', 0, 0, NULL),
(1, 83, '4e887', 'zombie', 'normal', 10, 1, '2018-09-29 22:55:00'),
(1, 85, '84400', 'human', 'normal', 0, 0, NULL),
(1, 87, '8067e', 'human', 'normal', 0, 0, NULL),
(1, 91, 'a6462', 'zombie', 'normal', 35, 3, '2018-09-30 16:40:19'),
(1, 92, '5fb5d', 'zombie', 'normal', 40, 0, '2018-09-29 01:10:41'),
(1, 93, 'd65d0', 'zombie', 'normal', 20, 0, '2018-09-29 01:09:42'),
(1, 95, '1a0d8', 'human', 'normal', 0, 0, NULL),
(1, 101, '003f8', 'zombie', 'normal', 20, 4, '2018-09-30 14:56:50'),
(1, 104, '176c4', 'zombie', 'normal', 20, 0, '2018-09-29 21:17:22'),
(1, 105, '81ede', 'human', 'normal', 0, 0, NULL),
(1, 99, 'c2760', 'human', 'normal', 0, 0, NULL),
(1, 1, 'a88b4', 'zombie', 'oz', 10, 2, '2018-09-29 22:55:00'),
(1, 110, 'b235a', 'human', 'normal', 0, 0, NULL),
(1, 111, '0dc90', 'zombie', 'normal', 45, 1, '2018-09-29 21:43:41'),
(1, 114, 'd1b6b', 'human', 'normal', 0, 0, NULL),
(1, 115, '7b7d4', 'zombie', 'normal', 0, 0, '2018-09-30 14:56:50'),
(1, 116, '3eae9', 'human', 'normal', 0, 0, NULL),
(1, 118, '44de8', 'human', 'normal', 0, 0, NULL),
(1, 119, 'f7031', 'human', 'normal', 0, 0, NULL),
(1, 28, 'db77a', 'human', 'normal', 0, 0, NULL),
(1, 120, '1a7a8', 'human', 'normal', 0, 0, NULL),
(1, 123, '825e5', 'human', 'normal', 0, 0, NULL),
(1, 124, 'cce86', 'human', 'normal', 0, 0, NULL),
(1, 125, '6a1c8', 'zombie', 'normal', 0, 0, '2018-09-29 21:01:37'),
(1, 126, '164ea', 'zombie', 'normal', 10, 2, '2018-09-30 20:34:00'),
(1, 127, '5bc04', 'zombie', 'normal', 0, 0, '2018-09-30 20:34:00'),
(1, 121, 'a5d72', 'human', 'normal', 0, 0, NULL),
(1, 128, 'e3dcf', 'human', 'normal', 0, 0, NULL),
(1, 129, '611b3', 'human', 'normal', 0, 0, NULL),
(1, 131, 'd72c2', 'human', 'normal', 0, 0, NULL),
(1, 132, '9ec78', 'zombie', 'normal', 10, 0, '2018-09-30 18:15:31'),
(1, 133, '80dd9', 'zombie', 'normal', 20, 2, '2018-09-30 18:15:31'),
(1, 134, '72794', 'human', 'normal', 0, 0, NULL),
(1, 96, '4bed2', 'human', 'normal', 0, 0, NULL),
(1, 135, '4845a', 'human', 'normal', 0, 0, NULL),
(1, 136, '8feff', 'human', 'normal', 0, 0, NULL),
(1, 137, '574f5', 'human', 'normal', 0, 0, NULL),
(1, 130, '9f839', 'human', 'normal', 0, 0, NULL),
(1, 140, 'a0aa4', 'human', 'normal', 0, 0, NULL),
(1, 94, 'a5575', 'human', 'normal', 0, 0, NULL),
(1, 106, '10fb1', 'deceased', 'normal', 5, 1, '2018-09-26 17:14:16'),
(1, 142, '9b87e', 'human', 'normal', 0, 0, NULL),
(1, 147, '649ff', 'zombie', 'normal', 45, 3, '2018-09-29 17:53:12'),
(1, 148, '965c3', 'human', 'normal', 0, 0, NULL),
(1, 149, '9e3f4', 'human', 'normal', 0, 0, NULL),
(1, 108, '03644', 'human', 'normal', 0, 0, NULL),
(1, 151, 'cdd7b', 'human', 'normal', 0, 0, NULL),
(1, 90, 'f379b', 'zombie', 'oz', 30, 6, '2018-09-29 17:53:12'),
(1, 152, '68e11', 'human', 'normal', 0, 0, NULL),
(1, 153, '0a7b8', 'human', 'normal', 0, 0, NULL),
(1, 155, 'ec280', 'zombie', 'normal', 5, 1, '2018-09-30 19:35:27'),
(1, 158, '1085d', 'zombie', 'normal', 5, 1, '2018-09-30 16:40:19'),
(1, 162, '85552', 'human', 'normal', 0, 0, NULL),
(1, 164, 'e524f', 'zombie', 'normal', 0, 0, '2018-09-29 16:25:01'),
(1, 165, '01dc6', 'zombie', 'normal', 0, 0, '2018-09-29 21:52:32'),
(1, 171, '37f6d', 'zombie', 'normal', 20, 0, '2018-09-30 16:17:58'),
(1, 172, 'db707', 'human', 'normal', 0, 0, NULL),
(1, 174, '602ad', 'zombie', 'normal', 0, 0, '2018-09-29 17:58:44'),
(1, 176, '62dd0', 'zombie', 'normal', 10, 2, '2018-09-29 01:12:08'),
(1, 177, '885c8', 'human', 'normal', 0, 0, NULL),
(1, 63, '26e3d', 'zombie', 'normal', 30, 2, '2018-09-29 17:53:12'),
(1, 88, '98778', 'human', 'normal', 0, 0, NULL),
(1, 178, '8e04d', 'human', 'normal', 0, 0, NULL),
(1, 144, '3d601', 'human', 'normal', 0, 0, NULL),
(1, 179, 'b219c', 'human', 'normal', 0, 0, NULL),
(1, 157, '3579b', 'zombie', 'normal', 0, 0, '2018-09-30 16:40:19'),
(1, 156, 'a9fa2', 'zombie', 'normal', 15, 1, '2018-09-29 21:56:53'),
(1, 180, '3ecfe', 'human', 'normal', 0, 0, NULL),
(1, 181, '8c128', 'human', 'normal', 0, 0, NULL),
(1, 98, '4379f', 'human', 'normal', 0, 0, NULL),
(1, 182, 'e9b21', 'human', 'normal', 0, 0, NULL),
(1, 183, 'b3034', 'zombie', 'normal', 0, 0, '2018-09-29 01:12:08'),
(1, 186, '141ff', 'zombie', 'normal', 15, 1, '2018-09-30 18:15:31'),
(1, 188, '25ef0', 'human', 'normal', 0, 0, NULL),
(1, 190, 'a8c2f', 'human', 'normal', 0, 0, NULL),
(1, 189, 'c31da', 'human', 'normal', 0, 0, NULL),
(1, 191, '7ce62', 'human', 'normal', 0, 0, NULL),
(1, 192, '51cb5', 'human', 'normal', 0, 0, NULL),
(1, 163, 'b743d', 'human', 'normal', 0, 0, NULL),
(1, 193, '885a3', 'zombie', 'normal', 0, 0, '2018-09-29 21:52:32'),
(1, 194, 'c88b0', 'human', 'normal', 0, 0, NULL),
(1, 195, 'db0a9', 'human', 'normal', 0, 0, NULL),
(1, 202, 'f472a', 'human', 'normal', 0, 0, NULL),
(1, 200, '489b3', 'human', 'normal', 0, 0, NULL),
(1, 203, '1e969', 'zombie', 'normal', 0, 0, '2018-09-30 18:15:31'),
(1, 204, 'd528e', 'zombie', 'normal', 56, 0, '2018-09-29 21:01:37'),
(1, 112, '08408', 'zombie', 'normal', 0, 0, '2018-09-29 21:52:32'),
(1, 206, '90fcc', 'human', 'normal', 0, 0, NULL),
(1, 198, 'd6307', 'human', 'normal', 0, 0, NULL),
(1, 76, '4df84', 'human', 'normal', 0, 0, NULL),
(1, 208, 'd9553', 'human', 'normal', 0, 0, NULL),
(1, 211, 'fa72f', 'human', 'normal', 0, 0, NULL),
(1, 210, 'dc454', 'human', 'normal', 0, 0, NULL),
(1, 212, '9b8b5', 'zombie', 'normal', 0, 0, '2018-09-30 19:35:27'),
(1, 209, '2e71f', 'human', 'normal', 0, 0, NULL),
(1, 214, '760f8', 'human', 'normal', 0, 0, NULL),
(1, 215, 'e28c4', 'human', 'normal', 0, 0, NULL),
(1, 201, '87d45', 'human', 'normal', 0, 0, NULL),
(1, 159, '2adda', 'zombie', 'normal', 0, 0, '2018-09-30 16:17:58'),
(1, 216, '1e6db', 'human', 'normal', 0, 0, NULL),
(1, 217, '5e4be', 'human', 'normal', 0, 0, NULL),
(1, 218, '9e835', 'human', 'normal', 0, 0, NULL),
(1, 219, '80a5b', 'human', 'normal', 0, 0, NULL),
(1, 220, '442a7', 'human', 'normal', 0, 0, NULL),
(1, 221, '5f748', 'zombie', 'normal', 0, 0, '2018-09-29 17:53:12'),
(1, 222, 'd596e', 'zombie', 'oz', 0, 0, '2018-09-29 21:01:37'),
(1, 223, 'cefbd', 'human', 'normal', 0, 0, NULL),
(1, 224, '2bdc5', 'human', 'normal', 0, 0, NULL),
(1, 227, 'ce3c5', 'human', 'normal', 0, 0, NULL),
(1, 232, '5c597', 'human', 'normal', 0, 0, NULL);

INSERT INTO `weeklong_players` (`weeklong_id`, `user_id`, `player_code`, `status`, `type`, `points`, `kills`, `starve_date`) VALUES
(4, 174, 'acc50', 'zombie', 'oz', 160, 1, '2019-04-20 10:35:30'),
(4, 1, 'df563', 'zombie', 'oz', 230, 3, '2019-04-20 14:16:42'),
(4, 234, '4ecaa', 'zombie', 'normal', 195, 1, '2019-04-20 10:47:38'),
(4, 133, 'f6552', 'zombie', 'normal', 230, 3, '2019-04-20 13:42:35'),
(4, 275, '2fbff', 'zombie', 'normal', 70, 1, '2019-04-20 09:00:08'),
(4, 83, 'da808', 'zombie', 'normal', 70, 0, '2019-04-20 15:00:08'),
(4, 239, '4cddd', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 276, 'ba674', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 101, '0528d', 'deceased', 'inactive', 0, 0, '2019-04-18 03:00:08'),
(4, 58, 'd93de', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 132, 'd88e9', 'zombie', 'normal', 270, 6, '2019-04-20 15:00:34'),
(4, 64, 'fd1ee', 'zombie', 'normal', 230, 0, '2019-04-20 15:18:42'),
(4, 249, 'b1d46', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 90, 'f403a', 'zombie', 'oz', 295, 5, '2019-04-20 15:19:50'),
(4, 171, '3acb0', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 63, '463bb', 'zombie', 'normal', 185, 1, '2019-04-20 16:23:06'),
(4, 279, 'df377', 'human', 'normal', 185, 0, '2019-04-20 14:42:25'),
(4, 280, '52a3a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 281, '4c5dd', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 282, '01ccc', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 285, '1d23a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 286, '1939d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 287, 'ecd38', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 288, '8f06e', 'deceased', 'inactive', 0, 0, '2019-04-18 03:00:08'),
(4, 289, '697f4', 'deceased', 'oz', 50, 0, '2019-04-19 15:00:08'),
(4, 290, '704e5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 291, '34282', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 292, '0869b', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 293, 'e53e4', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 294, 'ae1bd', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 295, '6c1b5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 177, '7ab0c', 'deceased', 'inactive', 0, 0, '2019-04-18 03:00:08'),
(4, 296, 'ef0af', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 127, '348cf', 'zombie', 'normal', 70, 1, '2019-04-20 18:07:42'),
(4, 298, '8b4c1', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 299, 'bf054', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 88, 'c67e5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 300, '2e107', 'human', 'normal', 75, 0, '2019-04-20 13:23:30'),
(4, 278, 'f758d', 'deceased', 'normal', 50, 0, '2019-04-18 09:00:08'),
(4, 305, 'f086e', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 306, '132cd', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 304, '946a7', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 307, '5cd85', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 309, '0303e', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 315, 'c60da', 'deceased', 'starved', 10, 0, '2019-04-19 15:00:18'),
(4, 316, 'ea29e', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 317, '6fedb', 'deceased', 'normal', 25, 1, '2019-04-18 10:35:57'),
(4, 318, 'bd982', 'deceased', 'inactive', 0, 0, '2019-04-18 05:31:05'),
(4, 349, 'd2f2a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 319, 'c77c0', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 405, '6cae9', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 321, '4160a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 186, '3f29e', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 322, '03d3d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 144, 'c439c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 324, '17e4d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 326, 'ee291', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 329, 'a9db5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 331, '07aea', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 330, 'fe22b', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 332, 'a88e6', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 333, '54aef', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 334, '30582', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 335, '37e22', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 336, 'b0be5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 337, '82fca', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 338, 'b3d7d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 339, '1ebe4', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 340, 'e5497', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 341, '4c396', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 61, 'eecc3', 'zombie', 'normal', 90, 1, '2019-04-21 03:00:08'),
(4, 342, '797d5', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 344, 'aaf69', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 345, '122f2', 'deceased', 'normal', 10, 1, '2019-04-18 07:57:45'),
(4, 346, 'fa391', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 347, '1bba3', 'deceased', 'starved', 10, 0, '2019-04-19 15:00:18'),
(4, 350, '39676', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 351, 'eac91', 'zombie', 'normal', 225, 0, '2019-04-20 13:35:54'),
(4, 352, 'af535', 'zombie', 'normal', 175, 0, '2019-04-20 15:00:08'),
(4, 241, '93ee1', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 111, '92b72', 'deceased', 'oz', 50, 0, '2019-04-18 06:09:31'),
(4, 354, '1533d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 356, '5db85', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 357, '0728b', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 358, 'c4474', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 360, '6286b', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 235, '0d5e9', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 372, 'de21c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 373, '38477', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 375, '24ac1', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 116, '903b3', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 374, '06996', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 376, '40386', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 377, '14a9a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 378, '026b6', 'deceased', 'normal', 15, 0, '2019-04-18 10:41:34'),
(4, 380, 'cbebe', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 379, '4a2a4', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 383, '8c12b', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 384, '80a1a', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 387, 'b561f', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 389, 'ad435', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 390, '7f6fd', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 391, 'e08e7', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 348, '60d95', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 392, 'f449d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 393, 'dbd1c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 397, '40429', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 399, 'bd339', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 400, 'd6577', 'deceased', 'normal', 20, 0, '2019-04-19 14:32:58'),
(4, 402, 'dd222', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 404, 'b569d', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 314, '2a8a3', 'human', 'normal', 120, 0, '2019-04-20 13:21:40'),
(4, 407, '74db0', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 301, '75c7c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 408, '9ad0e', 'zombie', 'normal', 120, 0, '2019-04-20 15:05:41'),
(4, 156, '63448', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 409, 'd8029', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 410, 'd3965', 'deceased', 'normal', 10, 0, '2019-04-18 15:00:08'),
(4, 411, 'f63f0', 'zombie', 'normal', 20, 2, '2019-04-20 04:54:32'),
(4, 412, '348fa', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 106, '678c6', 'deceased', 'suicide', 5, 0, '2019-04-18 11:21:58'),
(4, 413, 'cc9ab', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 415, '51a0c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 416, '90c70', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 117, 'f948c', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 417, '430b6', 'deceased', 'inactive', 0, 0, '2019-04-17 15:00:08'),
(4, 418, '3fd3f', 'deceased', 'inactive', 0, 0, '2019-04-17 17:42:20'),
(4, 308, 'b8850', 'human', 'normal', 255, 0, '2019-04-20 14:46:20'),
(4, 420, '9f8bf', 'deceased', 'inactive', 0, 0, '2019-04-17 17:59:27'),
(4, 91, '238ac', 'deceased', 'normal', 55, 1, '2019-04-19 04:38:45'),
(4, 421, '1a8a1', 'deceased', 'normal', 15, 0, '2019-04-18 06:05:08'),
(4, 422, 'ff5c4', 'deceased', 'inactive', 0, 0, '2019-04-18 06:08:47'),
(4, 424, 'c6663', 'deceased', 'inactive', 0, 0, '2019-04-17 19:07:33'),
(4, 425, '3430f', 'deceased', 'inactive', 0, 0, '2019-04-17 19:09:50'),
(4, 365, '8de7e', 'deceased', 'normal', 15, 0, '2019-04-18 10:41:29'),
(4, 426, 'ec098', 'deceased', 'inactive', 0, 0, '2019-04-17 20:14:36'),
(4, 364, 'c7c58', 'deceased', 'normal', 15, 0, '2019-04-18 08:29:43'),
(4, 427, 'dc443', 'zombie', 'normal', 100, 1, '2019-04-21 13:51:39'),
(4, 367, 'f2fbc', 'deceased', 'inactive', 0, 0, '2019-04-17 20:39:40'),
(4, 430, '3210f', 'deceased', 'inactive', 0, 0, '2019-04-17 21:03:35'),
(4, 363, '5804c', 'deceased', 'inactive', 0, 0, '2019-04-17 23:30:55'),
(4, 438, '33ea1', 'zombie', 'normal', 0, 0, '2019-04-20 06:52:19');

INSERT INTO `weeklong_players` (`weeklong_id`, `user_id`, `player_code`, `status`, `type`, `points`, `kills`, `starve_date`) VALUES
(5, 1, 'be3e0', 'zombie', 'oz', 142, '2', '2019-11-17 16:10:09'),
(5, 174, '48c21', 'zombie', 'normal', 42, '0', '2019-11-16 16:10:25'),
(5, 83, '42d3d', 'human', 'normal', 190, '0', '2019-11-17 15:40:33'),
(5, 439, '5ff5c', 'zombie', 'normal', 95, '0', '2019-11-16 17:15:44'),
(5, 101, '9c23b', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 116, '25af0', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 111, 'f7d96', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 479, '9b1b5', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 460, 'dd30d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 45, '56db2', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 133, '93295', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 327, '8ce01', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 122, '9cf06', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 480, '26841', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 90, '95573', 'deceased', 'oz', 68, '1', '2019-11-15 16:48:24'),
(5, 481, '6a81d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 482, '8f180', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 427, 'a55c8', 'zombie', 'normal', 32, '0', '2019-11-16 00:14:51'),
(5, 276, '642c4', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 483, '3706b', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 484, '74e04', 'human', 'normal', 30, '0', '2019-11-16 17:50:27'),
(5, 88, '9a018', 'deceased', 'oz', 50, '0', '2019-11-15 14:00:08'),
(5, 485, '7e85d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 486, '92404', 'deceased', 'oz', 50, '0', '2019-11-14 14:00:08'),
(5, 487, '5d07c', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 488, '0503c', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 489, 'dfd50', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 257, '16228', 'human', 'normal', 130, '0', '2019-11-16 18:48:28'),
(5, 490, '33c84', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 132, 'a1987', 'zombie', 'oz', 78, '2', '2019-11-16 04:48:24'),
(5, 279, '727d1', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 491, '2df6d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 494, '49e6a', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 495, '4af8b', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 497, '23624', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 498, 'c9987', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 499, 'da879', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 500, '3c805', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 501, '40d11', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 502, '8b3a9', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 503, '5a369', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 504, '65662', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 505, '643b5', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 506, 'd2782', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 507, '311fc', 'deceased', 'oz', 50, '0', '2019-11-14 14:00:08'),
(5, 508, '5feba', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 509, '543db', 'deceased', 'starved', 30, '0', '2019-11-15 18:37:57'),
(5, 510, 'dcb37', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 511, '16aac', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 512, '048e5', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 514, '8faa8', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 515, '12d83', 'deceased', 'normal', 18, '0', '2019-11-15 14:00:08'),
(5, 64, '8402f', 'human', 'normal', 20, '0', '2019-11-16 14:00:08'),
(5, 516, '52e74', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 517, '28a8c', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 518, '0cbae', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 519, '8c761', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 520, '4ad4d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 521, '41dd9', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 522, 'fa259', 'zombie', 'normal', 164, '7', '2019-11-17 17:00:13'),
(5, 524, '79306', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 523, '04992', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 525, '7691d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 526, '04a71', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 278, '6386b', 'deceased', 'starved', 10, '0', '2019-11-15 14:05:11'),
(5, 527, '9859b', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 528, 'a4d71', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 529, 'b5a78', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 411, 'b78ff', 'zombie', 'normal', 80, '0', '2019-11-16 14:00:08'),
(5, 530, 'e5d11', 'zombie', 'normal', 54, '0', '2019-11-16 08:00:08'),
(5, 531, '7908e', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 532, '36fce', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 533, '83857', 'deceased', 'oz', 50, '0', '2019-11-14 14:00:08'),
(5, 534, '03453', 'deceased', 'oz', 50, '0', '2019-11-14 14:00:08'),
(5, 100, '21719', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 535, '0077a', 'zombie', 'oz', 66, '0', '2019-11-16 14:00:08'),
(5, 536, '308c4', 'deceased', 'oz', 60, '1', '2019-11-14 14:00:08'),
(5, 537, '616b9', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 538, 'fabb8', 'deceased', 'oz', 50, '0', '2019-11-14 14:00:08'),
(5, 539, '8277c', 'deceased', 'oz', 50, '0', '2019-11-14 02:00:08'),
(5, 540, '62344', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 541, '2971d', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 542, '82359', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 544, 'dd055', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 63, '00226', 'human', 'normal', 155, '0', '2019-11-16 17:12:25'),
(5, 234, 'c9242', 'zombie', 'normal', 70, '0', '2019-11-16 14:00:08'),
(5, 545, '4d799', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 546, '48a60', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 548, 'e6120', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 549, '95420', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 171, 'fb0de', 'zombie', 'starved', 25, '0', '2019-11-16 17:50:03'),
(5, 408, 'f44fe', 'human', 'normal', 295, '0', '2019-11-17 21:30:38'),
(5, 551, '9739e', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 552, '2eb2e', 'deceased', 'inactive', 0, '0', '2019-11-14 14:00:08'),
(5, 553, '4bf68', 'deceased', 'inactive', 0, '0', '2019-11-13 15:16:32'),
(5, 554, 'df701', 'deceased', 'inactive', 0, '0', '2019-11-13 15:59:33'),
(5, 555, 'a563e', 'deceased', 'inactive', 0, '0', '2019-11-13 17:02:51'),
(5, 324, '744a3', 'deceased', 'inactive', 0, '0', '2019-11-13 17:04:45'),
(5, 556, '98b9b', 'zombie', 'normal', 103, '0', '2019-11-16 21:38:05'),
(5, 557, '83f45', 'deceased', 'inactive', 0, '0', '2019-11-13 17:49:25'),
(5, 558, '04f45', 'deceased', 'inactive', 0, '0', '2019-11-13 18:34:17'),
(5, 296, '0355d', 'zombie', 'normal', 80, '0', '2019-11-16 03:58:25'),
(5, 561, '5c70d', 'deceased', 'inactive', 0, '0', '2019-11-13 19:19:38'),
(5, 562, 'bb556', 'deceased', 'inactive', 0, '0', '2019-11-13 20:57:27');

INSERT INTO `weeklong_players` (`weeklong_id`, `user_id`, `player_code`, `status`, `type`, `points`, `kills`, `starve_date`) VALUES
(6, 1, '6ab20', 'zombie', 'oz', 110, 1, '2020-03-14 16:43:42'),
(6, 586, '16e8d', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 587, '00ff1', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 133, 'b72ad', 'deceased', 'normal', 8, 0, '2020-03-12 13:01:26'),
(6, 588, '27fbf', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 589, '82ec2', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 590, '1007a', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 239, 'a52be', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 591, '0645c', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 556, '7c752', 'zombie', 'starved', 42, 0, '2020-03-14 10:20:28'),
(6, 592, '0757a', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 375, 'd7bb8', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 593, 'f5d0b', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 490, 'fb51c', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 174, '3640c', 'deceased', 'normal', 20, 0, '2020-03-12 21:30:26'),
(6, 234, '121ea', 'zombie', 'oz', 108, 0, '2020-03-13 21:17:10'),
(6, 90, '956ad', 'human', 'normal', 150, 0, '2020-03-14 20:02:17'),
(6, 596, 'f675d', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 597, 'd33c1', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 598, 'cac41', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 296, '3fffc', 'human', 'normal', 80, 0, '2020-03-13 16:55:05'),
(6, 599, 'e37a3', 'deceased', 'starved', 20, 0, '2020-03-13 13:46:59'),
(6, 354, 'b0108', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 601, 'e6ae5', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 439, 'fb5da', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 602, 'e451a', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 279, 'c686e', 'zombie', 'starved', 15, 0, '2020-03-13 19:52:14'),
(6, 603, 'fb086', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 604, '757f1', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 605, '70c82', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 606, '6735e', 'deceased', 'starved', 10, 0, '2020-03-13 13:04:38'),
(6, 607, '7ee53', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 608, '60432', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 132, 'f8d29', 'zombie', 'oz', 74, 1, '2020-03-13 23:59:29'),
(6, 609, 'b4272', 'deceased', 'suicide', 18, 1, '2020-03-13 08:14:41'),
(6, 610, 'c2397', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 611, '02dd0', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 612, '88ed5', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 613, '7ac98', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 171, '2cff5', 'human', 'normal', 50, 0, '2020-03-14 19:53:23'),
(6, 614, '414f4', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 615, 'b48e4', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 616, '3aba8', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 617, 'f0303', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 618, 'fcc56', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 619, '887e1', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 620, 'fb82f', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 101, 'd92f3', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 621, '97687', 'human', 'normal', 120, 0, '2020-03-14 16:43:52'),
(6, 83, 'f2fdc', 'zombie', 'suicide', 22, 0, '2020-03-13 21:17:09'),
(6, 622, '6621c', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 623, '1a981', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 624, 'f96c7', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 625, '601ad', 'deceased', 'inactive', 0, 0, '2020-03-11 13:01:26'),
(6, 408, '39d32', 'human', 'normal', 70, 0, '2020-03-14 15:31:30'),
(6, 257, '843ef', 'zombie', 'starved', 40, 0, '2020-03-14 14:17:16'),
(6, 530, 'ee230', 'deceased', 'inactive', 0, 0, '2020-03-11 18:12:01'),
(6, 628, 'e6b2a', 'deceased', 'inactive', 0, 0, '2020-03-11 19:49:39');


-- -----------------------------------------------------
-- Table `CUHvZ`.`tokens`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `CUHvZ`.`tokens` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `token` VARCHAR(45) NULL,
  `type` VARCHAR(45) NOT NULL,
  `experation` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `user_idx` (`user_id` ASC),
  CONSTRAINT `fk_token_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `CUHvZ`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CUHvZ`.`activity`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `CUHvZ`.`activity` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `weeklong_id` INT NOT NULL,
  `user1_id` INT NOT NULL,
  `user2_id` INT NULL,
  `action` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
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

insert into activity (weeklong_id,user1_id,user2_id,`action`,description, time_logged) VALUES
(1,106,NULL,"starved","died of starvation", "2018-09-26 11:14:00"),
(1,90,132,"zombified","ate", "2018-09-24 10:16:00");


-- -----------------------------------------------------
-- Table `CUHvZ`.`codes`
-- -----------------------------------------------------

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
DROP TABLE IF EXISTS `CUHvZ`.`weeklong_emails` ;
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


DROP TABLE IF EXISTS `CUHvZ`.`lockin_text` ;
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

--
-- Dumping data for table `lockins`
--

INSERT INTO `lockins` (`id`, `title`, `event_date`, `waiver`, `state`) VALUES
(1, 'Entombed', '2018-03-23 04:00:00', '/lockin/waiver/lockin_waiver_fall18.pdf', 1),
(2, 'Close Encounters of the Undead Kind', '2018-11-16 05:00:00', '/lockin/waiver/lockin_waiver_spring18.pdf', 1),
(3, 'Ragnarok', '2019-04-19 04:00:00', '/lockin/waiver/lockin_waiver_spring19.pdf', 1),
(4, 'Ivy\'s Infection', '2019-11-22 05:00:00', '/lockin/waiver/Fall2019LockinWaiver.pdf', 1),
(5, 'Blood Nation', '2020-03-20 04:00:00', '/lockin/waiver/BloodNationLockinWaiver.pdf', 1);

-- --------------------------------------------------------

-- -----------------------------------------------------
-- Table `CUHvZ`.`lockin_text`
-- -----------------------------------------------------

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


--
-- Dumping data for table `lockin_text`
--

INSERT INTO `lockin_text` (`id`, `details`) VALUES
(1,
"BOLD[Important note to all player under the age of 18:]
Due to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.
If your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.
[LINE]
In the 6th dynasty of the golden age of Ancient Egypt, there lived the son of Montu, a Pharaoh of divine blood with Sekhmet’s fury raging in his soul. A Pharaoh whose soul was tainted, who became a harbinger of destruction; his name so cursed that few dare to speak it. His reign was paved with blood and fire, and so too was his death.

As soon as he became of age to be pharaoh, he killed his father. He brutally stabbed him into the sand, blade driven directly into the old man’s heart. He allowed his father no burial, no guide, and no means of obtaining eternal life with the gods.

He was Pharaoh, his will was the will of the gods.

After his rise, he waged a war on the Nile.

Soon it became evident that this man of war cared not for the gods: he craved bloodshed, craved conquering, and would go to Duat and back for his bloodlust.

Guided by the light of Ra, a peasant boy brought together a revolution, claiming he had seen the god in a dream, had been ordered by the fallen king of the gods, Osiris, to end the reign of a madman.

Soldiers and simple folk alike joined, overthrowing the slave prisons, freeing those who were taken from families, killing those loyal to the pharaoh.

Then the pharaoh’s guards, who, it was said, carried a piece of the pharaoh’s soul, came with pails of liquid fire. They set the cities ablaze, burning men, women and children alike.

From her window, the queen watched the Nile burn. She watched the people run screaming into the water, watched children lose family and friends. She watched the Nile burn and turn red with the blood of those seeking refuge from the flames. A single solitary tear slipped down her cheek, the mark of a mother mourning her young.

She sought the oracle of Pakhet, pleading for knowledge of what to do, how to stop this madness.

The oracle’s words were simple, “the madness of Pharaoh will never cease, nor will his bloodshed. If you wish for his end and the end of the wars he has wrought, you must drive a poisoned blade through his throat and trap his soul in the pieces of his sceptre. Should you fail to trap his soul, his fury will remain, his soul, once whole, will be too powerful to limit.”

Emboldened by these words, while seeking forgiveness for the sin she would commit, the queen and her handmaidens laced five daggers with the venom of the cobra. Each woman would kill one man that night, after Pharaoh had tired himself of his victory.

Each handmaiden entered the room of one of the guards, and the Queen entered the room of her husband.

She slit his throat where he slept, broke his sceptre and trapped pieces of his soul in the shards. She fled to her bed chambers, only to be awoken by screams when her work had been discovered.

Pharaoh’s reign had ended, and his burial was swift. His tomb was a maze, laden with the warriors who had served him most faithfully, with his royal guards around the entrance to Pharaoh’s final resting place.

With time, his cursed name faded, and his deeds were forgotten.

But mankind cannot leave demons to rest.

An Archaeologist by the name of Pierce Wolf stumbled upon the cursed tomb of the king, found the sceptre of the fallen Pharaoh. Unknowingly, he stole from that tomb the Pharaoh’s gold.

In anger at their disturbed place of rest, his soldiers and his guards rose to reclaim what was theirs, and to reawaken the Pharaoh’s fury once more."),
(2,
"BOLD[Important note to all player under the age of 18:]
Due to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.
If your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in."),
(3,
"BOLD[Important note to all player under the age of 18:]
Due to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.
If your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in."),
(4,
"BOLD[Important note to all player under the age of 18:]
Due to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.
If your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in."),
(5,
"Years after the return of the Avatar and the war had ended a new nation emerged, a nation of blood. Powered by dark spirits and fueled by rage and revenge for their people, a group of blood benders formed Blood Nation.

The blood benders made a deal with the dark spirits, allowing the spirits to inhabit their bodies in exchange for enhancing their blood bending capabilities beyond imagination. The dark spirits bestowed the ability to control anyone from anywhere as long as they have been infected with dark spirit energy.

They have declared war on the Fire Nation and have begun to advance their brainwashed armies. Coming into contact with anyone infected with the dark spirit energy results in the infection immediately spreading and taking control of their mind, joining the Blood Nation.

BOLD[Important note to all player under the age of 18:]
Due to rules placed on us that are out of our control we require a parent/guardian to be present to sign your wavier in order to prove that a signature was not forged.
If your parent cannot be present to sign your wavier you will not be allowed to participate in the lock-in.

BOLD[Tentative schedule:]
BOLD[Please not that there is roughly 2.5 - 3 hours between doors opening and when gameplay starts.]
9:00 pm: Doors open and check-in begins
9:15 pm: Rules presentation
9:30 pm: Rules presentation
9:45 pm: Rules presentation
10:00 pm: Doors close
10:15 pm: Final rules presentation
10:30 - 11:00 pm: First round begins
(Note: This when we aim to start the first round and is subject to change)
~12:00 pm First round ends
Next 15-30 minutes is dedicated to clean up and next round setup
~12:30 pm Second round begins
~ 1:30: Second round ends
The rest of the time is dedicated to cleaning up


Parking:
IMAGE[/images/where-to-park.png]");


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `CUHvZ`;

DELIMITER $$


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`lockins_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`lockins_AFTER_INSERT` AFTER INSERT ON `lockins` FOR EACH ROW
BEGIN
INSERT INTO lockin_text (id) VALUES (LAST_INSERT_ID());
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


USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`users_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
INSERT INTO user_details (id, join_date) VALUES (NEW.id, DATE_ADD(NOW(), INTERVAL (select offset from time_offset where id=1) HOUR));
INSERT INTO subscriptions (id) VALUES (NEW.id);
END$$

USE `CUHvZ`$$
DROP TRIGGER IF EXISTS `CUHvZ`.`activity_AFTER_INSERT` $$
USE `CUHvZ`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CUHvZ`.`activity_AFTER_INSERT` AFTER INSERT ON `activity` FOR EACH ROW
BEGIN
IF (NEW.time_logged IS NULL) THEN
	UPDATE activity set time_logged=(DATE_ADD(NOW(), INTERVAL (select offset from time_offset where id=1) HOUR)) where id=NEW.id;
END IF;
END$$

DELIMITER ;
