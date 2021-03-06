interface intf;
	parameter dw = 32;
	//-------------------------------------------
	// WISH BONE Interface
	//-------------------------------------------
	logic				wb_rst_i	;
	logic				wb_clk_i	;
	logic             	wb_stb_i	;
	logic            	wb_ack_o	;
	logic	[25:0]		wb_addr_i	;
	logic             	wb_we_i		; // 1 - Write, 0 - Read
	logic	[dw-1:0]   	wb_dat_i	;
	logic	[dw/8-1:0] 	wb_sel_i	; // Byte enable
	logic	[dw-1:0]  	wb_dat_o	;
	logic             	wb_cyc_i	;
	logic	[2:0]     	wb_cti_i	;

	//--------------------------------------------
	// SDRAM I/F 
	//--------------------------------------------
	logic				sdram_clk	;
	logic				sdram_resetn;
	logic				sdr_cs_n 	;
	logic				sdr_cke 	;
	logic				sdr_ras_n 	;
	logic				sdr_cas_n 	;
	logic				sdr_we_n 	;

	logic 				sdr_init_done; // SDRAM Init Done

endinterface