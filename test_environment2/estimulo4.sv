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


class estimulo4;
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
    int total;
    driv.reset();
    //Escritura en diferente banco, diferente fila, diferente/misma columna (G/H)
    $display("[ Estimulo ] ----- Prueba G Write -----");
    column = $urandom_range(2**9-1,0);
    for (int i = 0; i < 50; i++) begin
      row = $urandom_range(2**12-1,0);
      driv.burst_write({row,2'b00,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      driv.burst_write({row,2'b01,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      driv.burst_write({row,2'b10,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      driv.burst_write({row,2'b11,column}, 8'h01);
      #100;
    end
    $display("[ Estimulo ] ----- Prueba G Read -----");
    total = $size(score.address_fifo);
    for (int i = 0; i < total; i++) begin
      score.random_element_t();
      mon.burst_read(); 
      #100;
    end

    $display("[ Estimulo ] ----- Prueba H Write -----");
    for (int i = 0; i < 1; i++) begin
      row = $urandom_range(2**12-1,0);
      column = $urandom_range(2**9-1,0);
      driv.burst_write({row,2'b00,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      column = $urandom_range(2**9-1,0);
      driv.burst_write({row,2'b01,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      column = $urandom_range(2**9-1,0);
      driv.burst_write({row,2'b10,column}, 8'h01);

      row = $urandom_range(2**12-1,0);
      column = $urandom_range(2**9-1,0);
      driv.burst_write({row,2'b11,column,3'b000}, 8'h01);
      #100;
    end
    $display("[ Estimulo ] ----- Prueba H Read -----");
    total = $size(score.address_fifo);
    for (int i = 0; i < total; i++) begin
      score.random_element_t();
      mon.burst_read(); 
      #100;
    end
  endtask : run

endclass : estimulo4