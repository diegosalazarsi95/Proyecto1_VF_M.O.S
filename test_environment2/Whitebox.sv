parameter 		TOP_PATH = top.u_dut;
parameter       APP_AW   = 26 ;  // Application Address Width
parameter       APP_DW   = 32 ;  // Application Data Width 
parameter       APP_BW   = 4  ;   // Application Byte Width
parameter       APP_RW   = 9  ;   // Application Request Width

parameter       SDR_DW   = 16 ;  // SDR Data Width 
parameter       SDR_BW   = 2  ;   // SDR Byte Width
             
parameter       dw       = 32 ;  // data width
parameter       tw       = 8  ;   // tag id width
parameter       bl       = 9  ;   // burst_lenght_width 

interface Whitebox();
	//--------------------------------------------
	// SDRAM controller Interface 
	//--------------------------------------------
	logic                  WB_app_req            ; // SDRAM request
	logic 	[APP_AW-1:0]   WB_app_req_addr       ; // SDRAM Request Address
	logic 	[bl-1:0]       WB_app_req_len        ;
	logic                  WB_app_req_wr_n       ; // 0 - Write, 1 -> Read
	logic                  WB_app_req_ack        ; // SDRAM request Accepted
	logic                  WB_app_busy_n         ; // 0 -> sdr busy
	logic 	[dw/8-1:0]     WB_app_wr_en_n        ; // Active low sdr byte-wise write data valid
	logic                  WB_app_wr_next_req    ; // Ready to accept the next write
	logic                  WB_app_rd_valid       ; // sdr read valid
	logic                  WB_app_last_rd        ; // Indicate last Read of Burst Transfer
	logic                  WB_app_last_wr        ; // Indicate last Write of Burst Transfer
	logic 	[dw-1:0]       WB_app_wr_data        ; // sdr write data
	logic 	[dw-1:0]       WB_app_rd_data        ; // sdr read data

	/****************************************
	*  These logic has to be implemented using Pads
	*  **************************************/
	logic 	[SDR_DW-1:0]   WB_pad_sdr_din        ; // SDRA Data Input
	logic 	[SDR_DW-1:0]   WB_sdr_dout           ; // SDRAM Data Output
	logic 	[SDR_BW-1:0]   WB_sdr_den_n          ; // SDRAM Data Output enable

	/*  Assigns  */
	assign WB_app_req 		  = `TOP_PATH.app_req 		 	 ;
	assign WB_app_req_addr    = `TOP_PATH.app_req_addr	 	 ;
	assign WB_app_req_len     = `TOP_PATH.app_req_len 		 ;
	assign WB_app_req_wr_n    = `TOP_PATH.app_req_wr_n 		 ;
	assign WB_app_req_ack     = `TOP_PATH.app_req_ack 		 ;
	assign WB_app_busy_n      = `TOP_PATH.app_busy_n 		 ;
	assign WB_app_wr_en_n     = `TOP_PATH.app_wr_en_n 		 ;
	assign WB_app_wr_next_req = `TOP_PATH.app_wr_next_req 	 ;
	assign WB_app_rd_valid    = `TOP_PATH.app_rd_valid 		 ;
	assign WB_app_last_rd     = `TOP_PATH.app_last_rd 		 ;
	assign WB_app_last_wr     = `TOP_PATH.app_last_wr 		 ;
	assign WB_app_wr_data     = `TOP_PATH.app_wr_data 		 ;
	assign WB_app_rd_data     = `TOP_PATH.app_rd_data 		 ;

	assign WB_pad_sdr_din     = `TOP_PATH.pad_sdr_din        ;
	assign WB_sdr_dout        = `TOP_PATH.sdr_dout           ;
	assign WB_sdr_den_n       = `TOP_PATH.sdr_den_n          ;

endinterface