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

class environment2 extends environment;
	estimulo1 est1;
  estimulo2 est2;
	function new(virtual intf vif);
    	super.new(vif);
    	est1 = new(vif,score,driv,mon);
      est2 = new(vif,score,driv,mon);
  	endfunction

	task run_estimulo1();
		est1.run();
	endtask : run_estimulo1

  task run_estimulo2();
    est2.run();
  endtask : run_estimulo2

endclass : environment2