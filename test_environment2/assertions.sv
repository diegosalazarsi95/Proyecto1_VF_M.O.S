`include "Whitebox.sv"

module assertion();
   
  Whitebox wbox();
   
  sequence pnop;
  	$fell (wbox.sdram_init_done) ##10000 (~(wbox.ras && !wbox.cs && wbox.we && wbox.cas));
  endsequence

  sequence p_precharge;
  	$fell (wbox.sdram_init_done) ##10000 (~(wbox.ras && !wbox.cs && wbox.we && wbox.cas)) ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas) ; 
  endsequence

  sequence p_autor;
  	$fell (wbox.sdram_init_done) ##10000 (~(wbox.ras && !wbox.cs && wbox.we && wbox.cas)) ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas) ##[0:$] (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) ##[0:$] (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) [=3];
  endsequence

  /*function new(virtual Whitebox wbox);
    this.wbox = wbox;
  endfunction//*/

// ~~~~~~~~~~~~~~~~~~~~~ Aserciones para la inicialización de la SDRAM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// check 
//====================================  assertion init  =====================================================
	property sdram_init;
		@(posedge wbox.clk) $fell (wbox.sdram_init_done) |-> ## 10000  (~wbox.sdram_init_done);
	endproperty
	a_init: assert property (sdram_init) else $error("%m: Violation inicialization time.");
//====================================  fin init  ===========================================================


// check 
//====================================  assertion NOP  ======================================================
	property sdram_NOP;
		@(posedge wbox.clk) $fell (wbox.sdram_init_done) |-> ## 10000 (~(wbox.ras && !wbox.cs && wbox.we && wbox.cas));
	endproperty
	a_NOP: assert property (sdram_NOP) else $error("%m: Violation at NOP command time.");
//====================================  fin NOP  ============================================================


// check 
//====================================  assertion sdram_precharge  ==========================================

	property sdram_precharge;
		//@(posedge wbox.clk) (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas) |->  ##1 (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas);
		@(posedge wbox.clk) pnop |->  ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas);
	endproperty
	a_precharge: assert property (sdram_precharge) else $error("%m: Violation precharge fail.");
//====================================  fin sdram_precharge  ================================================



//====================================  assertion autorefresh  ==============================================
	property sdram_autorefresh;
		//@(posedge wbox.clk) (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) |-> not ## [1:6] (~(!wbox.ras && !wbox.cas && !wbox.cs && wbox.we));
		@(posedge wbox.clk) $fell (wbox.sdram_init_done) |-> p_autor;
	endproperty
	a_autorefresh: assert property (sdram_autorefresh) else $error("%m: Violation too early autorefresh.");
//====================================  autorefresh fin  ====================================================



//======================== Aserciones para las reglas del protocolo wishbone ================================

// 3.00: Todas las señales deben inicializarse (igual a cero) luego que el wb_rst_i sea 1.
	property rst_i;
		@(posedge wbox.clk) wbox.rst |-> ## 1 (wbox.cycle == 0 & wbox.strb == 0 & wbox.sdr_addr == 0 & wbox.sdr_dq == 0);
	endproperty
	assert_rst_300: assert property (rst_i) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.");




// 3.05: La señal de rst debe permanecer en alto por lo menos por un ciclo completo de reloj
	property time_rst;
		@(posedge wbox.clk) wbox.rst |-> ##[1:$] (wbox.rst == 1);
	endproperty
// La señal de rst va a mantener su valor de manera indefinida hasta que rst=1
	assert_time_rst_305 : assert property (time_rst) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at least one complete clk cicle");



// 3.10: Todas las señales deben de ser capaz de reaccionar al rst en cualquier momento
	property all_signals_zero;
		@(posedge wbox.clk) ~wbox.strb |-> ( wbox.ack == 0 );
	endproperty
	
	assert_all_signals_react_310: assert property (all_signals_zero) else $error("%m Violation of Wishbone Rule_3.10: ack didn't react to the rst");




// 3.25: La señal CYCLE debe asertarce siempre que STRB sea puesta en 1.
	property cyc_stb;
		@(posedge wbox.clk) wbox.strb |-> wbox.cycle;
	endproperty

	assert_cyc_stb_325: assert property (cyc_stb) else $error("%m: Violation of Wishbone Rule_3.25: cyc not asserted when stb is.");
	


// 3.35: La señal ACK no debe responder a menos que CYCLE y STRB hayan sido puestas en 1
	property ack_cyc_stb;
		@(posedge wbox.clk)  wbox.ack |-> (wbox.cycle & wbox.strb);
	endproperty

	assert_ack_335: assert property (ack_cyc_stb) else $error("%m: Violation of Wishbone Rule_3.35: slave responding outside wb_cyc_i.");

endmodule