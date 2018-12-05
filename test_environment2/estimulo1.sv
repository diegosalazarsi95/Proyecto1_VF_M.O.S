`ifndef SCOREBOARD2_SV
  `include "scoreboard.sv"
  `include "Monitor.sv"
  `include "Driver.sv"
`endif

//########################################################
// estimulo1
// En este estimulo se generara escritura random en rafaga
// de 20 elementos y luego se hará la lectura de los 20 
//  elementos
//########################################################

class estimulo1;
  virtual intf vif;
  scoreboard    score;
  driver    	driv;
  monitor   	mon;

  function new(virtual intf vif, scoreboard score, driver driv, monitor mon);//,scoreboard score);
    this.vif = vif;
    this.score = score;
    this.driv = driv;
    this.mon = mon;
  endfunction

  task run();
    int k,y;
    reg [31:0] Addr;
    reg [7:0] bl;
  	for(k=0; k < 7; k++) begin
      Addr = $random & 32'h003FFFFF;
      bl = $urandom_range(10,1);
      driv.burst_write(Addr,bl);  
      #100;
    end
    for(k=0; k < 7; k++) begin
      y = $size(score.address_fifo);
      $display("real size: %d",y);
      score.random_element_t();
      mon.burst_read();  
      #100;
    end
  endtask : run

endclass : estimulo1