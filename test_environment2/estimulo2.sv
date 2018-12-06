`ifndef SCOREBOARD2_SV
  `include "scoreboard.sv"
  `include "Monitor.sv"
  `include "Driver.sv"
`endif

//########################################################
// estimulo2
// En este estimulo se comprueba los diferentes tipos de
// en conjunto de los largo de rafaga cuando el controlador
// esta habilitado o no
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
    $display("[ DRIVER ] ----- Reset Started -----");
    //Configuracion Controlador
    vif.cfg_req_depth     = 2'h3;
    vif.cfg_sdr_en        = 1'b1;
    vif.cfg_sdr_mode_reg  = 13'h023;
    vif.cfg_sdr_tras_d    = 4'h4;
    vif.cfg_sdr_trp_d     = 4'h2;
    vif.cfg_sdr_trcd_d    = 4'h2;
    vif.cfg_sdr_cas       = 3'h2;
    vif.cfg_sdr_trcar_d   = 4'h7;
    vif.cfg_sdr_twr_d     = 4'h1;
    vif.cfg_sdr_rfsh      = 12'h100;
    vif.cfg_sdr_rfmax     = 3'h6;

    vif.wb_addr_i     = 0;
    vif.wb_dat_i      = 0;
    vif.wb_sel_i      = 4'h0;//se cambio
    vif.wb_we_i       = 0;
    vif.wb_stb_i      = 0;
    vif.wb_cyc_i      = 0;
    vif.wb_rst_i      = 1'h0;
    #100
    // Applying reset
    vif.wb_rst_i      = 1'h0;
    #1000;
    // Releasing reset
    vif.wb_rst_i      = 1'h1;
    #100;
    wait(vif.sdr_init_done);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask : load_mode_reg

  task run();
    int k;
    reg [31:0] Addr;
    reg [7:0] bl;
    for(k=0; k < 5; k++) begin
      Addr = $random & 32'h003FFFFF;
      bl = $urandom_range(10,1);
      driv.burst_write(Addr,bl);  
      #100;
    end
    #10000;
    load_mode_reg();
    #10000;
    for(k=0; k < 5; k++) begin
      score.random_element_t();
      mon.burst_read();  
      #100;
    end
  endtask : run


endclass : estimulo2