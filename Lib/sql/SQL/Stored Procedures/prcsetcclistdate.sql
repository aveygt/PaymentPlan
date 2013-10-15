use ppdb;
drop procedure if exists `prcsetcclistdate`;

DELIMITER $$

create procedure `prcsetcclistdate`
(
	in vardate date
)
begin
	UPDATE `ppdb`.`ppdbsettings`
	SET
	`CCListDate` = vardate
	WHERE `ID` = 1;


end$$



