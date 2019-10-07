-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 28, 2019 at 04:58 PM
-- Server version: 5.7.26
-- PHP Version: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `user_management`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `SP_Delete_User`$$
CREATE DEFINER=`mysql_dev`@`localhost` PROCEDURE `SP_Delete_User` (IN `userId` INT)  BEGIN

delete from tbl_users where id = userId;

END$$

DROP PROCEDURE IF EXISTS `SP_List_Users`$$
CREATE DEFINER=`mysql_dev`@`localhost` PROCEDURE `SP_List_Users` (IN `page_count` INT)  BEGIN

SET @page_no = page_count;

SET @per_page = 3;

SET @total = (select count(*) from tbl_users);

SET @total_pages = @total / @per_page;

IF page_count > 1 THEN

SET @page_offset = (page_count - 1) * 3;

ELSEIF page_count = 1 THEN

SET @page_offset = 0;

END IF;

PREPARE STMT FROM 'select * from tbl_users order by id LIMIT 3 OFFSET ?';

EXECUTE STMT USING @page_offset;

select @page_no as 'page_no', @per_page as 'per_page', @total as 'total', CAST(@total_pages as signed) as 'total_pages';
END$$

DROP PROCEDURE IF EXISTS `SP_Login_User`$$
CREATE DEFINER=`mysql_dev`@`localhost` PROCEDURE `SP_Login_User` (IN `email` TEXT, IN `t_password` TEXT)  BEGIN

select token from tbl_users where email = email and password = t_password;

END$$

DROP PROCEDURE IF EXISTS `SP_Register_User`$$
CREATE DEFINER=`mysql_dev`@`localhost` PROCEDURE `SP_Register_User` (IN `firstName` TEXT, IN `lastName` TEXT, IN `t_email` TEXT, IN `job` TEXT, IN `userToken` TEXT)  BEGIN

declare insertedId INT;
declare duplicate_count INT;

SELECT 
    COUNT(*)
INTO duplicate_count FROM
    tbl_users
WHERE
    email = t_email;

IF duplicate_count != 0 THEN

SELECT 'Email address is already registered' as 'error';

ELSE

INSERT INTO tbl_users (first_name,last_name,email,job,token,password) VALUES(firstName,lastName,t_email,job,userToken,'cityslicka');

SELECT LAST_INSERT_ID() INTO insertedId;

SELECT 
    insertedId AS id, token
FROM
    tbl_users
WHERE
    id = insertedId;

END IF;

END$$

DROP PROCEDURE IF EXISTS `SP_Update_User`$$
CREATE DEFINER=`mysql_dev`@`localhost` PROCEDURE `SP_Update_User` (IN `userId` INT, IN `firstName` TEXT, IN `lastName` TEXT, IN `t_email` TEXT, IN `job` TEXT)  BEGIN
declare duplicate_count INT;

SELECT 
    COUNT(*)
INTO duplicate_count FROM
    tbl_users
WHERE
    email = t_email;

IF duplicate_count > 1 THEN

SELECT 'Email address is already registered' as 'error';

ELSE

UPDATE tbl_users SET first_name = firstName, last_name = lastName, email = t_email, job = job where id = userId;

SELECT 
    first_name, last_name, modified_at
FROM
    tbl_users
WHERE
    id = userId;

END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

DROP TABLE IF EXISTS `tbl_users`;
CREATE TABLE IF NOT EXISTS `tbl_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `email` text NOT NULL,
  `job` text,
  `password` text NOT NULL,
  `token` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id`, `first_name`, `last_name`, `email`, `job`, `password`, `token`, `created_at`, `modified_at`) VALUES
(1, 'Eve', 'Holt', 'eve.holt@reqres.in', NULL, 'cityslicka', '2c2cabdb-d51d-4ae1-8960-04a94b4e92af', '2019-06-23 16:18:53', '2019-06-23 16:18:53'),
(2, 'Charles', 'Morris', 'charles.morries@reqres.in', NULL, 'cityslicka', '96217c8b-7261-4fa2-8325-6aecdd5db4b3', '2019-06-23 16:18:53', '2019-06-23 16:18:53'),
(3, 'Tracey', 'Ramos', 'tracy.ramos@reqres.in', NULL, 'cityslicka', '44141762-460d-464b-b0d4-831ef0b9665b', '2019-06-23 16:18:53', '2019-06-23 16:18:53'),
(4, 'Tony', 'Stark', 'tony.stark@reqres.in', NULL, 'cityslicka', '5fe29e89-cfee-4ab0-a863-d36893bbf2a9', '2019-06-23 16:18:53', '2019-06-23 16:18:53'),
(5, 'Bruce', 'Banner', 'bruce.banner@reqres.in', NULL, 'cityslicka', '0c25a0b3-3adb-4820-95b5-e6c5f5f06171', '2019-06-23 16:18:53', '2019-06-23 16:18:53'),
(6, 'Spider', 'Man', 'spider.man@reqres.in', 'Avengers', 'cityslicka', '57b422c3-2ee0-403e-b39d-6e39ace358e5', '2019-06-23 16:18:53', '2019-06-23 16:18:53');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
