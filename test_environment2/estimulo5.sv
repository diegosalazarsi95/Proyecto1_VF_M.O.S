`ifndef SCOREBOARD2_SV
  `include "scoreboard.sv"
  `include "Monitor.sv"
  `include "Driver.sv"
`endif

//########################################################
// estimulo4
// Escritura en diferente banco, diferente, misma 
// columna/diferente columna (G/H)
//########################################################


class estimulo5;
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
    //  with cfg_col bit configured as: 01
    //    <12 Bit Row> <2 Bit Bank> <9 Bit Column>
    //
  task run();
    reg [8:0]   column;
    reg [11:0]  row;
    reg [1:0]   bank;
    int total;
    driv.reset();
    //Escritura en mismo banco, misma fila, misma/diferente columna (A/B)
    $display("[ Estimulo 5 ] ----- Prueba A Write -----");
    column = $urandom_range(2**9-1,0);
    row = $urandom_range(2**12-1,0);
    for (int i = 0; i < 10; i++) begin
      driv.burst_write({row,2'b00,column}, 8'h0F);
      score.random_element_t();
      mon.burst_read(); 
      #100;
    end
    $display("[ Estimulo 5 ] ----- Prueba B Write -----");
    row = $urandom_range(2**12-1,0);
    for (int i = 0; i < 10; i++) begin
      column = $urandom_range(2**9-1,0);
      driv.burst_write({row,2'b10,column}, 8'h02);
      #100;
    end
    total = $size(score.address_fifo);
    for (int i = 0; i < total; i++) begin
      score.random_element_t();
      mon.burst_read(); 
      #100;
    end
  endtask : run

endclass : estimulo5