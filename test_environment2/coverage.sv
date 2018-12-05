
module coverage (intf intf);

	parameter LOAD_MODE_REG = ~intf.sdr_ras_n && ~intf.sdr_cas_n && ~sdr_we_n && ~intf.sdr_cs_n;

	covergroup controllerOut @ (posedge intf.wb_clk_i);
		CASLatency : coverpoint intf.sdr_addr[6:4] {
		bins lat2  = {3'b010};
		bins lat3  = {3'b011};
		}
	   	
	endgroup : controllerIn 

endmodule