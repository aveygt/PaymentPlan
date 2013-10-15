drop function if exists FnAgentIDFromIn;

DELIMITER $$

Create Function FnAgentIDFromIn
(
	VInitial varchar(3)
)
returns int
Begin
	declare VID int;

	Select `agents`.`AgentID`
	into VID
	from  agents
	Where `agents`.`Initials` = Vinitial;

	return VID;
end$$