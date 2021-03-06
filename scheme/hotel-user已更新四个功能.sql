/*
SQLyog Ultimate v12.4.1 (64 bit)
MySQL - 5.7.21-log : Database - hotel
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`hotel` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `hotel`;

/* Procedure structure for procedure `proc_login` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_login` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_login`(IN inputname VARCHAR(30),IN inputpw VARCHAR(30),OUT state INT)
BEGIN
    DECLARE name_exist VARCHAR(30);
    DECLARE pw VARCHAR(32);
    SET state=0;
    SET name_exist=(SELECT admin_name FROM `admin` WHERE inputname=admin_name);
    IF  name_exist IS NULL THEN
	SET state=-1;
    ELSE
	SET pw=(SELECT admin_pw FROM `admin` WHERE inputname=admin_name);
	IF pw!=inputpw THEN
	    SET state=-2;
	ELSE
	    UPDATE `admin` SET admin_last_visit=NOW() WHERE inputname=admin_name;
	    SET state=1;
	END IF;
    END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_login_au` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_login_au` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_login_au`(IN inputname VARCHAR(30),IN inputpw VARCHAR(30),OUT state VARCHAR(30))
BEGIN
    DECLARE name_exist VARCHAR(30);
    DECLARE pw VARCHAR(32);
    DECLARE au VARCHAR(20);
    SET state='loginInit';
    SET name_exist=(SELECT user_name FROM `user` WHERE inputname=user_name);
    IF  name_exist IS NULL THEN
	SET state='loginNameError';
    ELSE
	SET pw=(SELECT `password` FROM `user` WHERE inputname=user_name);
	IF pw!=inputpw THEN
	    SET state='loginPasswordError';
	ELSE
	    SET au=(SELECT authority FROM `user` where inputname=user_name);
	    if au='manager' then
		set state='loginManager';
	    elseif au='user' then
		set state='loginUser';
	    elseif au='guest' then
		set state='loginGuest';
	    else
	        set state='loginUnknowAu';
	    end if;
	    UPDATE `user` SET last_visit=NOW() WHERE inputname=user_name;
	END IF;
    END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_roomAdd` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_roomAdd` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_roomAdd`(IN roomNum VARCHAR(10), IN roomType VARCHAR(30),
IN roomArea TINYINT, IN roomMaxnum TINYINT, IN roomPrice SMALLINT, IN roomAircondition TINYINT, IN roomTV TINYINT,
IN roomWIFI TINYINT, roomWashroom TINYINT, IN roomIsStay TINYINT, OUT state VARCHAR(30))
BEGIN
     DECLARE id_exist SMALLINT;
     SET state='addroominit';
     SET id_exist=(SELECT room_num FROM `room` WHERE roomNum=room_num);
     IF  id_exist IS NOT NULL THEN
	SET state='addRoomFailed';
     ELSE
	INSERT INTO `room` VALUES(NULL,roomNum,roomType,roomArea,roomMaxnum,roomPrice,roomAircondition,
	roomTV,roomWIFI,roomWashroom,roomIsStay);
	SET state='addRoomSuccess';
     END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_roomDel` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_roomDel` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_roomDel`(IN roomNum varchar(10), OUT state VARCHAR(30))
BEGIN
     DECLARE id_exist smallint;
     SET state='delroominit';
     SET id_exist=(SELECT room_id FROM `room` WHERE roomNum=room_num);
	IF  id_exist IS NULL THEN
	    SET state='delRoomFailed';
	ELSE
	    DELETE FROM `room` 
	    WHERE roomNum=room_num;
	    SET state='delRoomSuccess';
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_roomSelect` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_roomSelect` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_roomSelect`(In roomNum varchar(10), out state varchar(30))
BEGIN
	set state='selectInit';
	if roomNum is NUll then
		SELECT * FROM `room` ORDER BY room_id ASC;
		SET state='selectAllRoom';
	else
		Select * from `room` where room_num=roomNum;
		set state='selectOneRoom';
	end if;
	
end */$$
DELIMITER ;

/* Procedure structure for procedure `proc_roomUpdate` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_roomUpdate` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_roomUpdate`(IN roomNum VARCHAR(10), IN roomType VARCHAR(30),
IN roomArea TINYINT, IN roomMaxnum TINYINT, IN roomPrice SMALLINT, IN roomAircondition TINYINT, 
IN roomTV TINYINT,IN roomWIFI TINYINT, roomWashroom TINYINT, IN roomIsStay TINYINT, OUT state VARCHAR(30))
BEGIN
     DECLARE id_exist smallint;
     SET state='updateRoomInit';
     SET id_exist=(SELECT room_id FROM `room` WHERE roomNum=room_num);
	IF  id_exist IS NULL THEN
	    SET state='updateRoomFailed';
	ELSE
	   IF roomType IS NOT NULL THEN
		UPDATE `room` SET room_type=roomType WHERE roomNum=room_num;
	   END IF;
	   IF roomArea IS NOT NULL THEN
		UPDATE `room` SET room_area=roomArea WHERE roomNum=room_num;
	   END IF;
	   IF roomMaxnum IS NOT NULL THEN
		UPDATE `room` SET room_maxnum_of_people=roomMaxnum WHERE roomNum=room_num;
	   END IF;
	   IF roomPrice IS NOT NULL THEN
		UPDATE `room` SET room_price=roomPrice WHERE roomNum=room_num;
	   END IF;
	   IF roomAircondition IS NOT NULL THEN
		UPDATE `room` SET room_aircondition=roomAircondition WHERE roomNum=room_num;
	   END IF;
	   IF roomTV IS NOT NULL THEN
		UPDATE `room` SET room_TV=roomTV WHERE roomNum=room_num;
	   END IF;
	   IF roomWIFI IS NOT NULL THEN
		UPDATE `room` SET room_wifi=roomWIFI WHERE roomNum=room_num;
	   END IF;
	   IF roomWashroom IS NOT NULL THEN
		UPDATE `room` SET room_washroom=roomWashroom WHERE roomNum=room_num;
	   END IF;
	   IF roomIsStay IS NOT NULL THEN
		UPDATE `room` SET room_is_stay=roomIsStay WHERE roomNum=room_num;
	   END IF;
	   SET state='updateRoomSuccess';
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_selectAll` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_selectAll` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_selectAll`(In choice Varchar(20),out state varchar(30))
BEGIN
	SET state='initSelectAll';
	CASE choice
	WHEN 'room' THEN 
		SELECT * from `room` ORDER BY room_id ASC;
		SET state='selectAllRoom';
	       
	ELSE
		SET state='selectUnknowError';
     END CASE;
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_userAdd` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_userAdd` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_userAdd`(IN userName VARCHAR(10), IN userPassword VARCHAR(30),
IN userCredits TINYINT, IN userAuthority TINYINT, IN userLast_visit SMALLINT, IN userLast_ip TINYINT, OUT state VARCHAR(30))
BEGIN
     DECLARE id_exist SMALLINT;
     SET state='adduserinit';
     SET id_exist=(SELECT user_name FROM `user` WHERE userName=user_name);
     IF  id_exist IS NOT NULL THEN
	SET state='addUserFailed';
     ELSE
	INSERT INTO `user` VALUES(NULL,userName,userPassword,userCredits,userAuthority,userLast_visit,userLast_ip);
	SET state='addUserSuccess';
     END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_userDel` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_userDel` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_userDel`(IN userName VARCHAR(10), OUT state VARCHAR(30))
BEGIN
DECLARE id_exist SMALLINT;
     SET state='deluserinit';
     SET id_exist=(SELECT user_id FROM `user` WHERE userName=user_name);
	IF  id_exist IS NULL THEN
	    SET state='delUserFailed';
	ELSE
	    DELETE FROM `user` 
	    WHERE userName=user_name;
	    SET state='delUserSuccess';
	END IF;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_userSelect` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_userSelect` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_userSelect`(IN userName VARCHAR(10), OUT state VARCHAR(30))
BEGIN
SET state='selectInit';
	IF userName IS NULL THEN
		SELECT * FROM `user` ORDER BY user_name ASC;
		SET state='selectAllUser';
	ELSE
		SELECT * FROM `room` WHERE user_name=userName;
		SET state='selectOneUser';
	END IF;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_userUpdate` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_userUpdate` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_userUpdate`(IN userName VARCHAR(10), IN userPassword VARCHAR(30),
IN userCredits TINYINT, IN userAuthority TINYINT, IN userLast_visit SMALLINT, IN userLast_ip TINYINT, OUT state VARCHAR(30))
BEGIN
     DECLARE id_exist SMALLINT;
     SET state='updateUserInit';
     SET id_exist=(SELECT user_id FROM `user` WHERE userName=user_name);
	IF  id_exist IS NULL THEN
	    SET state='updateUserFailed';
	ELSE
	   IF userPassword IS NOT NULL THEN
		UPDATE `user` SET password=userPassword WHERE userName=user_name;
	   END IF;
	   IF userCredits IS NOT NULL THEN
		UPDATE `user` SET credits=userCredits WHERE userName=user_name;
	   END IF;
	   IF userAuthority IS NOT NULL THEN
		UPDATE `user` SET authority=userAuthority WHERE userName=user_name;
	   END IF;
	   IF userLast_visit IS NOT NULL THEN
		UPDATE `user` SET last_visit=userLast_visit WHERE userName=user_name;
	   END IF;
	   IF userLast_ip IS NOT NULL THEN
		UPDATE `user` SET last_ip=userLast_ip WHERE userName=user_name;
	   END IF;
	   
	   SET state='updateUserSuccess';
	END IF;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
