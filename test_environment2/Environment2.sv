`ifndef MONITOR2_SV
  `include "Monitor2.sv"
`endif
`ifndef DRIVER2_SV
  `include "Driver2.sv"
`endif
`ifndef SCOREBOARD2_SV
  `include "scoreboard2.sv"
`endif

`include "Environment.sv"
`include "estimulo1.sv"
`include "estimulo2.sv"
`include "estimulo3.sv"
`include "estimulo4.sv"
`include "estimulo5.sv"
class environment2 extends environment;
	estimulo1 est1;
	estimulo2 est2;
	estimulo3 est3;
	estimulo4 est4;
	estimulo5 est5;

	monitor2 mon2;
	scoreboard2 score2;
	driver2 driv2;


	function new(virtual intf vif);
    	super.new(vif);
    	score2 = new();
    	mon2 = new(vif,score,score2);
    	driv2 = new(vif,score,score2);
    	est1 = new(vif,score2,driv2,mon2);
    	est2 = new(vif,score2,driv2,mon2);
    	est3 = new(vif,score2,driv2,mon2);
    	est4 = new(vif,score2,driv2,mon2);
    	est5 = new(vif,score2,driv2,mon2);
  	endfunction

	task run_estimulo1();
		est1.run();
	endtask : run_estimulo1

	task run_estimulo2();
		est2.run();
	endtask : run_estimulo2

	task run_estimulo3();
		est3.run();
	endtask : run_estimulo3

	task run_estimulo4();
		est4.run();
	endtask : run_estimulo4

	task run_estimulo5();
		est5.run();
	endtask : run_estimulo5

endclass : environment2