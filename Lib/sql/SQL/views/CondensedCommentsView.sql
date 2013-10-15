DROP VIEW IF EXISTS `ppdb`.`vwcondensedcomments`;

CREATE VIEW `vwcondensedcomments` AS

SELECT 
	`comments`.`CommentID`,
    concat('---',DATE_FORMAT(`CommentDate`,'%c/%d/%y'),' : ',`agents`.`Initials`,'---
',`comments`.`Comment`) as 'Comment',
    `comments`.`FKCommentPayPlanID`,
    `comments`.`Agents_AgentID`
FROM `ppdb`.`comments`
	left join agents
		on Agents_AgentID = AgentID;
