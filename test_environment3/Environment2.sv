`ifndef MONITOR_SV
  `include "Monitor.sv"
`endif
`ifndef DRIVER_SV
  `include "Driver.sv"
`endif
`ifndef SCOREBOARD_SV
  `include "scoreboard.sv"
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

	function new(virtual intf vif);
    	super.new(vif);
    	est1 = new(vif,score,driv,mon);
      est2 = new(vif,score,driv,mon);
      est3 = new(vif,score,driv,mon);
      est4 = new(vif,score,driv,mon);
      est5 = new(vif,score,driv,mon);
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