//`include "Interface.sv"
`ifndef SCOREBOARD_SV
  `include "scoreboard.sv"
`endif


class driver;
  //Variables
  virtual intf vif;
  scoreboard score;
function new(virtual intf vif, scoreboard score);
  //getting the interface
  this.vif = vif;
  this.score = score;
endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
task reset();
  $display("[ DRIVER ] ----- Reset Started -----");
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
  #10000;
  // Releasing reset
  vif.wb_rst_i      = 1'h1;
  #1000;
  wait(vif.sdr_init_done);
  $display("[ DRIVER ] ----- Reset Ended   -----");
endtask

  //write task

task burst_write();
  input [31:0] Address;
  input [7:0]  bl;
  int i;
	begin
    score.bl_fifo.push_back(bl);
    score.address_fifo.push_back(Address);
  //afifo.push_back(Address);
	//bfifo.push_back(bl);
    @(negedge vif.wb_clk_i);
    $display("Write Address: %x, Burst Size: %d",Address,bl);

    for(i=0; i < bl; i++) begin
      vif.wb_stb_i        = 1;
      vif.wb_cyc_i        = 1;
      vif.wb_we_i         = 1;
      vif.wb_sel_i        = 4'b1111;
      vif.wb_addr_i       = Address[31:2]+i;
      vif.wb_dat_i        = $random & 32'hFFFFFFFF;
      score.data_fifo.push_back(vif.wb_dat_i);

      do begin
        @ (posedge vif.wb_clk_i);
      end while(vif.wb_ack_o == 1'b0);
        @ (negedge vif.wb_clk_i);
        $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,vif.wb_addr_i,vif.wb_dat_i);
    end
    vif.wb_stb_i        = 0;
    vif.wb_cyc_i        = 0;
    vif.wb_we_i         = 'hx;
    vif.wb_sel_i        = 'hx;
    vif.wb_addr_i       = 'hx;
    vif.wb_dat_i        = 'hx;
  end

endtask

endclass
