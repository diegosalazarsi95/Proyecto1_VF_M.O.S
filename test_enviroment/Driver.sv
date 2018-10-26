        //gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
  //mailbox gen2driv;
  
  //constructor
  function new(virtual intf vif,mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
 //   this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.wb_rst_i <= 1;

    wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  
  task burst_write;
    wait(vif.burst_write);
    $display("[ DRIVER ] ----- Burst Write -----");
    vif.ras_n <= 1;
    vif.cas_n <= 0;
    vif.we_n <= 0;
    wait(!vif.burst_write);
    $display("[ DRIVER ] ----- Burst Write Ended -----");
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin

    end
  endtask
  
endclass