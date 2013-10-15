use `ppdb`;

drop trigger if exists `before_insert_bonds`;

Delimiter $$

Create Trigger `before_insert_bonds`
before insert on `bonds`
for each row
begin
	if EXISTS(	SELECT 1 
				FROM `bonds` 
				WHERE `bonds`.`FKBondPrefix` = New.`FKBondPrefix`
					and `bonds`.`PowerNumber` = New.`PowerNumber`) then
		Signal sqlstate '45000'
			set message_text = 'You cannot create two of the same power number, add an existing power';
	end if;
end$$