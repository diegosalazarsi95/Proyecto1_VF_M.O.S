`ifndef SCOREBOARD2_SV
  `include "scoreboard.sv"
  `include "Monitor.sv"
  `include "Driver.sv"
`endif

//########################################################
// estimulo3
// Escritura en diferente banco, misma fila, misma 
// columna/diferente columna (E/F)
//########################################################


class estimulo3;
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

  //----------------------------------------
    // Address Decodeing:
    //  with cfg_col bit configured as: 00
    //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
    //
  task run();
    reg [8:0]   column;
    reg [11:0]  row;
    reg [1:0]   bank;
    $display("[ Estimulo 3 ] ----- Start -----");
    driv.reset();
    //Escritura en diferente banco, misma fila, misma columna/diferente columna (E/F)
    row = $urandom_range(2**12-1,0);
    column = $urandom_range(2**9-1,0);
    driv.burst_write({row,2'b00,column}, 8'h0F);
    driv.burst_write({row,2'b01,column}, 8'h0F);
    driv.burst_write({row,2'b10,column}, 8'h0F);
    driv.burst_write({row,2'b11,column}, 8'h0F);
    column = $urandom_range(2**9-1,0);
    driv.burst_write({row,2'b10,column}, 8'h0F);
    driv.burst_write({row,2'b11,column}, 8'h0F);
    driv.burst_write({row,2'b00,column}, 8'h0F);
    driv.burst_write({row,2'b01,column}, 8'h0F);
    column = $urandom_range(2**9-1,0);
    driv.burst_write({row,2'b00,column}, 8'h0F);
    driv.burst_write({row,2'b01,column}, 8'h0F);
    driv.burst_write({row,2'b10,column}, 8'h0F);
    driv.burst_write({row,2'b11,column}, 8'h0F);
    for (int i = 0; i < 12; i++) begin
      score.random_element_t();
      mon.burst_read(); 
      #100;
    end
    $display("[ Estimulo 3 ] ----- END -----");
  endtask : run


endclass : estimulo3