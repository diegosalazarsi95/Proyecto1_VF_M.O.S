`include "Driver.sv"
`include "Monitor.sv"
`include "scoreboard.sv"
`include "Interface.sv"
class environment;
  
  driver    	driv;
  monitor   	mon;
  scoreboard	scb;
  
  virtual intf vif;
  
  function new(virtual intf vif);
    this.vif = vif;
    scb=new();
    driv = new(vif,scb);
    mon  = new(vif,scb);
  endfunction
  
 
endclass
