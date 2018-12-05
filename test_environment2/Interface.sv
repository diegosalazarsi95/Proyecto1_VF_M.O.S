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
	logic	[12:0] 		sdr_addr    ;
	logic 				sdr_init_done; // SDRAM Init Done

	//--------------------------------------------
	// Configuration parameters
	//--------------------------------------------
	logic	[1:0]		cfg_req_depth		;
	logic 				cfg_sdr_en			;
    logic 	[12:0]		cfg_sdr_mode_reg	;
    logic 	[3:0]		cfg_sdr_tras_d		;
    logic 	[3:0]		cfg_sdr_trp_d		;
    logic 	[3:0]		cfg_sdr_trcd_d		;
    logic 	[2:0]		cfg_sdr_cas			;
    logic 	[3:0]		cfg_sdr_trcar_d		;
    logic 	[3:0]		cfg_sdr_twr_d		;
    
    logic 	[`SDR_RFSH_TIMER_W-1 : 0]		cfg_sdr_rfsh		;
    logic 	[`SDR_RFSH_ROW_CNT_W -1 : 0]	cfg_sdr_rfmax		;

endinterface