`ifndef DRIVER_SV
  `include "Driver.sv"
`endif

`ifndef SCOREBOARD2_SV
  `include "scoreboard2.sv"
`endif

`ifndef DRIVER2_SV
`define DRIVER2_SV

class driver2 extends driver;
	scoreboard2 score2;

	function new(virtual intf vif,scoreboard score,scoreboard2 score2);//,scoreboard score);
		super.new(vif,score);
		this.score2 = score2;
	endfunction

	task burst_write2();
		input [31:0] address;
		input [31:0] data;
		int i;
		begin
		    score2.address_fifo.push_back(address);
		    score2.data_fifo.push_back(data);
		    @(negedge vif.wb_clk_i);
		    $display("Write Address: %x, Data: %x",address,data);

		    vif.wb_stb_i        = 1;
		    vif.wb_cyc_i        = 1;
		    vif.wb_we_i         = 1;
		    vif.wb_sel_i        = 4'b1111;
		    vif.wb_addr_i       = address;
		    vif.wb_dat_i        = data;

		    do begin
		      @ (posedge vif.wb_clk_i);
		    end while(vif.wb_ack_o == 1'b0);
		      @ (negedge vif.wb_clk_i);
		      $display("Status: Write Address: %x  WriteData: %x ",vif.wb_addr_i,vif.wb_dat_i);
		    
		    vif.wb_stb_i        = 0;
		    vif.wb_cyc_i        = 0;
		    vif.wb_we_i         = 'hx;
		    vif.wb_sel_i        = 'hx;
		    vif.wb_addr_i       = 'hx;
		    vif.wb_dat_i        = 'hx;
		 end
	endtask

endclass : driver2
`endif