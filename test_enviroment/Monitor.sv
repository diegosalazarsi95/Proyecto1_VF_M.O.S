//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

class monitor;
  
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
//  mailbox mon2scb;
  
  //constructor
  function new(virtual intf vif);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
  endfunction
  
  task burst_read;
     wait(vif.burst_read);
     $display("[ MONITOR ] ----- Burst Read -----");
     vif.ras_n <= 1;
     vif.cas_n <= 0;
     vif.we_n <= 1;
     wait(!vif.burst_read);
     $display("[ MONITOR ] ----- Burst Read -----");
  endtask

  
  
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.clk);
      wait(vif.valid);
      trans.a   = vif.a;
      trans.b   = vif.b;
      @(posedge vif.clk);
      trans.c   = vif.c;
      @(posedge vif.clk);
      mon2scb.put(trans);
      trans.display("[ Monitor ]");
    end
  endtask
  
endclass