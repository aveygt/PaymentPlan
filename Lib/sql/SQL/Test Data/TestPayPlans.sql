use ppdb;

Call PayPlanAdd('2013-8-23', '200.08', '50.00','2','2013-8-30', 'he needs to be happy about paying us when he pays', '1',null,@PayPlanID);

call PayPlanBondAdd(@PayPlanID,BondAdd('BB','5888791','1','1','2013-08-10','100.08'));
call PayPlanBondAdd(@PayPlanID,BondAdd('BB','5888792','1','1','2013-08-10','100.08'));
call PayPlanBondAdd(@PayPlanID,BondAdd('BB','5888793','1','1','2013-08-10','50.08'));
call PayPlanBondAdd(@PayPlanID,BondAdd('BB','5888794','1','1','2013-08-10','0.08'));