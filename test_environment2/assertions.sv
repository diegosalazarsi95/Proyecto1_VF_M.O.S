parameter 		TOP_PATH = top.u_dut; //preguntar a Gabo este módulo???
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


	//logic var;
    //assign var = `TOP_PATH.¿tbench_top?.submodule.signal

    logic clk;
	logic rst;
	logic strb;
	logic cycle;
	logic ack;
	logic ras; 
	logic cas; 
	logic cs; 
	logic we;
	logic sdram_init_done;
	logic [12:0] sdr_addr;
	logic [SDR_DW-1:0] sdr_dq;
	assign clk				= `TOP_PATH.wb_clk_i;
	assign rst				= `TOP_PATH.wb_rst_i;
	assign strb		    	= `TOP_PATH.wb_stb_i;
	assign cycle			= `TOP_PATH.wb_cyc_i;
	assign ack	        	= `TOP_PATH.wb_ack_o;
	assign ras 				= `TOP_PATH.sdr_ras_n;
	assign cas 				= `TOP_PATH.sdr_cas_n;
	assign cs 				= `TOP_PATH.sdr_cs_n;
	assign we 				= `TOP_PATH.sdr_we_n;
	assign sdram_init_done	= `TOP_PATH.sdr_init_done;
    assign sdr_addr         = `TOP_PATH.sdr_addr;
    assign sdr_dq           = `TOP_PATH.sdr_dq;

// ~~~~~~~~~~~~~~~~~~~~~ Aserciones para la inicialización de la SDRAM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//====================================  assertion init  =====================================================
	property sdram_init;
		@(posedge clk) $fell (sdram_init_done) |-> ## 10000  (~sdram_init_done);
	endproperty
	a_init: assert property (sdram_init) else $error("%m: Violation inicialization time.");
//====================================  fin init  ===========================================================

//====================================  assertion NOP  ======================================================
	property sdram_NOP;
		@(posedge clk) $fell (sdram_init_done) |-> ## 10000 (ras && !cs && we && cas);
	endproperty
	a_NOP: assert property (sdram_NOP) else $error("%m: Violation at NOP command time.");
//====================================  fin NOP  ============================================================

//====================================  assertion sdram_precharge  ==========================================

	property sdram_precharge;
		@(posedge clk) (!ras && !cs && we && cas) |-> not ## [1:2] (!ras && !cs && we && cas);
	endproperty
	a_precharge: assert property (sdram_precharge) else $error("%m: Violation precharge fail.");
//====================================  fin sdram_precharge  ================================================

//====================================  assertion autorefresh  ==============================================
	property sdram_autorefresh;
		@(posedge clk) (!ras && !cas && !cs && we) |-> not ## [1:6] (!ras && !cas && !cs && we);
	endproperty
	a_autorefresh: assert property (sdram_autorefresh) else $error("%m: Violation too early autorefresh.");
//====================================  autorefresh fin  ====================================================


//======================== Aserciones para las reglas del protocolo wishbone ================================

// 3.00: Todas las señales deben inicializarse (igual a cero) luego que el wb_rst_i sea 1.
	property rst_i;
		@(posedge clk) rst |-> ## 1 (cycle == 0 & strb == 0 & sdr_addr == 0 & sdr_dq == 0);
	endproperty

	assert_rst_300: assert property (rst_i) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.");

// 3.05: La señal de rst debe permanecer en alto por lo menos por un ciclo completo de reloj
	property time_rst;
		@(posedge clk) rst |-> ##[1:$] (rst == 1);
	endproperty
// La señal de rst va a mantener su valor de manera indefinida hasta que rst=1
	assert_time_rst_305 : assert property (time_rst) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at least one complete clk cicle");

// 3.10: Todas las señales deben de ser capaz de reaccionar al rst en cualquier momento
	property all_signals_zero;
		@(posedge clk) ~strb |-> ( ack == 0 );
	endproperty
	
	assert_all_signals_react_310: assert property (all_signals_zero) else $error("%m Violation of Wishbone Rule_3.10: ack didn't react to the rst");


// 3.25: La señal CYCLE debe asertarce siempre que STRB sea puesta en 1.
	property cyc_stb;
		@(posedge clk) strb |-> cycle;
	endproperty

	assert_cyc_stb_325: assert property (cyc_stb) else $error("%m: Violation of Wishbone Rule_3.25: cyc not asserted when stb is.");
	
// 3.35: La señal ACK no debe responder a menos que CYCLE y STRB hayan sido puestas en 1
	property ack_cyc_stb;
		@(posedge clk)  ack |-> (cycle & strb);
	endproperty

	assert_ack_335: assert property (ack_cyc_stb) else $error("%m: Violation of Wishbone Rule_3.35: slave responding outside wb_cyc_i.");


endinterface
