`include "scoreboard.sv"
`include "Driver.sv"
`include "Monitor.sv"

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
