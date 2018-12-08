`ifndef SCOREBOARD2_SV
  `include "scoreboard.sv"
  `include "Monitor.sv"
  `include "Driver.sv"
`endif

//########################################################
// estimulo2
// En este estimulo se comprueba los diferentes feature de
// que se le pueden colocar a la memoria y que el controlador
// sea capaz de manejarlas y recibir los datos
//########################################################


class estimulo2;
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


  task load_mode_reg();
    input   [2:0]   burst_length;
    input           burst_type;
    input   [2:0]   cas_lat;
    input           write_burst_mode;
    input           enable;
    #2000;
    $display("[ Estimulo ] ----- Load Mode Register -----");
    vif.cfg_sdr_en        = enable;
    vif.cfg_sdr_mode_reg  = {4'h0,write_burst_mode,2'b00,cas_lat,burst_type,burst_length};
    vif.cfg_sdr_cas       = cas_lat;
   
    vif.wb_addr_i     = 0;
    vif.wb_dat_i      = 0;
    vif.wb_sel_i      = 4'h0;
    vif.wb_we_i       = 0;
    vif.wb_stb_i      = 0;
    vif.wb_cyc_i      = 0;
    vif.wb_rst_i      = 1'h0;
    #100
    // Applying reset
    vif.wb_rst_i      = 1'h0;
    #100;
    // Releasing reset
    vif.wb_rst_i      = 1'h1;
    #100;
    wait(vif.sdr_init_done);
    $display("[ Estimulo ] ----- Load Mode Register -----");
    #2000;
  endtask : load_mode_reg

  task rafaga();
    input           burst_type;
    input   [2:0]   cas_lat;
    input           write_burst_mode;
    input           enable;
    reg [31:0] Addr;
    reg [8:0] column;
    #2000;
    //Burst length 1
    load_mode_reg(3'h0,burst_type,cas_lat,write_burst_mode,enable);
    column =$urandom_range(2**9-1,0);
    Addr = {12'h003,2'b00,column};
    driv.burst_write(Addr,1);  
    score.random_element_t();
    mon.burst_read(); 
    //Burst length 2
    load_mode_reg(3'h1,burst_type,cas_lat,write_burst_mode,enable);
    column =$urandom_range(2**9-1,0);
    Addr = {12'h003,2'b00,column};
    driv.burst_write(Addr,2);  
    score.random_element_t();
    mon.burst_read(); 
    //Burst length 4
    load_mode_reg(3'h2,burst_type,cas_lat,write_burst_mode,enable);
    column =$urandom_range(2**9-1,0);
    Addr = {12'h003,2'b00,column};
    driv.burst_write(Addr,4);  
    score.random_element_t();
    mon.burst_read(); 
    //Burst length 8
    load_mode_reg(3'h3,burst_type,cas_lat,write_burst_mode,enable);
    column =$urandom_range(2**9-1,0);
    Addr = {12'h003,2'b00,column};
    driv.burst_write(Addr,8);  
    score.random_element_t();
    mon.burst_read(); 
    if(burst_type == 1'b0)begin 
      //Burst length full
      load_mode_reg(3'h7,burst_type,cas_lat,write_burst_mode,enable);
      Addr = {12'h000,2'b01,9'h00};
      driv.burst_write(Addr,255);  
      score.random_element_t();
      mon.burst_read(); 
    end
    #2000;
  endtask : rafaga

  task tipo_rafaga();
    input   [2:0]   cas_lat;
    input           write_burst_mode;
    input           enable;
    rafaga(1'b0,cas_lat,write_burst_mode,enable);
    rafaga(1'b1,cas_lat,write_burst_mode,enable);
  endtask : tipo_rafaga

  task lat_cas();
    input           write_burst_mode;
    input           enable;
    tipo_rafaga(3'h2,write_burst_mode,enable);
    tipo_rafaga(3'h3,write_burst_mode,enable);
  endtask : lat_cas

  task modo_wr_rafaga();
    input           enable;
    lat_cas(1'b0,enable);
    lat_cas(1'b1,enable);
  endtask : modo_wr_rafaga



  task run();
    $display("[ Estimulo 2 ] ----- Start -----");
    modo_wr_rafaga(1'b1);
    $display("[ Estimulo 2 ] ----- End -----");
  endtask : run

endclass : estimulo2