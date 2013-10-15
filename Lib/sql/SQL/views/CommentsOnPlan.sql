use ppdb;
drop view if exists `vwcommentsonplan`;

CREATE VIEW `vwcommentsonplan` AS

SELECT 
	`comments`.`CommentID` as 'Comment ID',
    `comments`.`FKCommentPayPlanID` as 'Pay Plan ID',
	`comments`.`Agents_AgentID` as 'Agent ID',
    Date_Format(`comments`.`CommentDate`, '%c/%d/%y') as 'Date',
	`agents`.`Initials` as 'Agent',
    `comments`.`Comment` as 'Comment'
FROM `ppdb`.`comments`
join `ppdb`.`agents`
	on `comments`.`Agents_AgentID` =`agents`.`AgentID`;


