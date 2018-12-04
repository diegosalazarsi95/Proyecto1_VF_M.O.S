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

class environment2 extends environment;
	estimulo1 est1;

	function new(virtual intf vif);
    	super.new(vif);
    	est1 = new(vif,score,driv,mon);
  	endfunction

	task run_estimulo1();
		est1.run();
	endtask : run_estimulo1

endclass : environment2