`ifndef MONITOR_SV
  `include "Monitor.sv"
`endif
`ifndef DRIVER_SV
  `include "Driver.sv"
`endif

`ifndef SCOREBOARD_SV
  `include "scoreboard.sv"
`endif

class environment;
  scoreboard    score;
  driver    	driv;
  monitor   	mon;
  
  virtual intf vif;
  
  function new(virtual intf vif);
    this.vif = vif;
    score = new();
    driv = new(vif,score);
    mon  = new(vif,score);
  endfunction

endclass
