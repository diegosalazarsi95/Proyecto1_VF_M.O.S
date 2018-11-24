
`ifndef SCOREBOARD2_SV
  `include "scoreboard2.sv"
  `include "Monitor2.sv"
  `include "Driver2.sv"
`endif

class estimulo2;
  virtual intf vif;
  scoreboard2    score2;
  driver2     driv2;
  monitor2    mon2;

  function new(virtual intf vif, scoreboard2 score2, driver2 driv2, monitor2 mon2);//,scoreboard score);
    this.vif = vif;
    this.score2 = score2;
    this.driv2 = driv2;
    this.mon2 = mon2;
  endfunction

  task run();
    int k;
    int number_oper = $random($random(1))%100;          
    reg [31:0] Addr;
    reg [31:0] data;
    $display("NUMBER_OPER: %d ", number_oper);
    for(k=0; k < number_oper; k++) begin
      Addr = $random & 32'h003FFFFF;
      data = $random & 32'hFFFFFFFF;
      driv2.burst_write2(Addr,data);  
      #100;
      mon2.burst_read_random();  
      #100;
    end

  endtask : run

endclass : estimulo2