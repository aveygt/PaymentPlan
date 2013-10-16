use ppdb;
SET GLOBAL log_bin_trust_function_creators = 1;
DROP PROCEDURE if exists `ppdb`.`PrcPayPlanDelete`;

DELIMITER $$
CREATE PROCEDURE `PrcPayPlanDelete`(
	VarPlanID int
)
begin
	DELETE FROM `ppdb`.`paymentschedules` WHERE `FKSchedulePayPlanID`=VarPlanID;
	DELETE FROM `ppdb`.`bonds_has_payplans` WHERE `PayPlans_PayPlanID`= VarPlanID;
	DELETE FROM `ppdb`.`payplans_has_customers` WHERE `PayPlans_PayPlanID`= VarPlanID;
	DELETE FROM `ppdb`.`comments` WHERE `FKCommentPayPlanID`= VarPlanID;
	DELETE FROM `ppdb`.`payplans` WHERE `PayPlanID`= VarPlanID;
end$$