`include "Driver.sv"
`include "Monitor.sv"
`include "scoreboard.sv"
class environment;
  
  driver    	driv;
  monitor   	mon;
  scoreboard	scb;
  
  virtual intf vif;
  
  function new(virtual intf vif);
    //get the interface from test
    this.vif = vif;
    driv = new(vif);
    mon  = new(vif);
    //scb  = new(mon2scb);
  endfunction
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
      driv.burst_write();
      mon.burst_read();
      scb.main();
    join_any
  endtask
  
  task run;
    pre_test();
    test();
    $finish;
  endtask
  
endclass
