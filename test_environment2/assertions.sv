`include "Whitebox.sv"

module assertion();
  
  Whitebox wbox();
  
  `ifdef ASSERT 

  sequence pnop;
  	$rose (wbox.rst) ##10000 $stable(wbox.ras && !wbox.cs && wbox.we && wbox.cas);
  endsequence

  sequence p_precharge;
  	$rose (wbox.rst) ##10000 $stable(wbox.ras && !wbox.cs && wbox.we && wbox.cas) ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas); 
  endsequence

  sequence p_autor;
  	$rose (wbox.rst) ##10000 $stable(wbox.ras && !wbox.cs && wbox.we && wbox.cas) ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas) ##[0:$] (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) ##[0:$] (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) [=3];
  endsequence

// ~~~~~~~~~~~~~~~~~~~~~ Aserciones para la inicialización de la SDRAM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// check 
//====================================  assertion init  =====================================================
	property sdram_init;
		@(posedge wbox.clk)
		$rose (wbox.rst) |-> ##10000 $stable(~wbox.rst);
	endproperty
	a_init: assert property (sdram_init) else $error("%m: Violation inicialization time.");
	c_init: cover property  (sdram_init);
//====================================  fin init  ===========================================================


// check 
//====================================  assertion NOP  ======================================================
	property sdram_NOP;
		@(posedge wbox.clk) 
		$rose (wbox.rst) |-> ##10000 $stable(wbox.ras && !wbox.cs && wbox.we && wbox.cas);
	endproperty
	a_NOP: assert property (sdram_NOP) else $error("%m: Violation at NOP command time.");
	c_NOP: cover  property (sdram_NOP);
//====================================  fin NOP  ============================================================


// check 
//====================================  assertion sdram_precharge  ==========================================
	property sdram_precharge;
		@(posedge wbox.clk) pnop |->  ##[0:$] (!wbox.ras && !wbox.cs && !wbox.we && wbox.cas);
	endproperty
	a_precharge: assert property (sdram_precharge) else $error("%m: Violation precharge fail.");
	c_precharge: cover  property (sdram_precharge);
//====================================  fin sdram_precharge  ================================================


// check 
//====================================  assertion autorefresh  ==============================================
	property sdram_autorefresh;
		//@(posedge wbox.clk) (!wbox.ras && !wbox.cas && !wbox.cs && wbox.we) |-> not ## [1:6] (~(!wbox.ras && !wbox.cas && !wbox.cs && wbox.we));
		@(posedge wbox.clk) $rose (wbox.rst) |-> p_autor;
	endproperty
	a_autorefresh: assert property (sdram_autorefresh) else $error("%m: Violation too early autorefresh.");
	c_autorefresh: cover  property (sdram_autorefresh);
//====================================  autorefresh fin  ====================================================


//======================== Aserciones para las reglas del protocolo wishbone ================================
// check 
// 3.00: Todas las señales deben inicializarse (igual a cero) luego que el wb_rst_i sea 1.
	property rst_i;
		@(posedge wbox.clk) $rose (wbox.rst) |-> ##1 (wbox.ras && wbox.cs && wbox.we && wbox.cas);
	endproperty
	assert_rst_300 : assert property (rst_i) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.");
	cover_rst_300  :  cover  property (rst_i);



// check 
// 3.05: La señal de rst debe permanecer en alto por lo menos por un ciclo completo de reloj
	property time_rst;
		@(posedge wbox.clk) $rose(wbox.rst) |-> ##1 (wbox.rst == 1);
	endproperty
// La señal de rst va a mantener su valor de manera indefinida hasta que rst=1
	assert_time_rst_305 : assert property (time_rst) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at least one complete clk cicle");
	cover_time_rst_305  : cover  property (time_rst);


// check 
// 3.10: Todas las señales deben de ser capaz de reaccionar al rst en cualquier momento
	property all_signals_zero;
		@(posedge wbox.clk) $fell(wbox.rst) |-> ( ~wbox.strb && ~wbox.ack);
	endproperty
	
	assert_all_signals_react_310 : assert property (all_signals_zero) else $error("%m Violation of Wishbone Rule_3.10: ack didn't react to the rst");
	cover_all_signals_react_310  : cover  property (all_signals_zero);


     

// 3.25: La señal CYCLE debe asertarce siempre que STRB sea puesta en 1.
	property cyc_stb;
		@(posedge wbox.clk) disable iff(wbox.rst) wbox.strb |-> wbox.cycle;
	endproperty
	assert_cyc_stb_325 : assert property (cyc_stb) else $error("%m: Violation of Wishbone Rule_3.25: cyc not asserted when stb is.");
	cover_cyc_stb_325  : cover  property (cyc_stb);

// check 
// 3.35: La señal ACK no debe responder a menos que CYCLE y STRB hayan sido puestas en 1
	property ack_cyc_stb;
		@(posedge wbox.clk) disable iff(wbox.rst)  (wbox.cycle && wbox.strb) |-> wbox.ack ;
	endproperty
	assert_ack_335 : assert property (ack_cyc_stb) else $error("%m: Violation of Wishbone Rule_3.35: slave responding outside wb_cyc_i.");
	cover_ack_335  : cover  property (ack_cyc_stb);

/* --------------------------------------------------------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------------------------------------------------------- */
												/* Aserciones para el proyecto 3 */

// El registro MODE REG de la memoria se debe configurar de maner válida para lecturas de página completa
	parameter LOAD_MODE_REG = (~wbox.ras && ~wbox.cas && ~wbox.we && ~wbox.cs);
	parameter FULLPAGE_READ = (wbox.sdr_addr[0] && wbox.sdr_addr[1] && wbox.sdr_addr[2]);
	
	property fullpage_read;
		@(posedge wbox.clk_ram) ($rose(LOAD_MODE_REG)  && FULLPAGE_READ) |-> wbox.sdr_addr[3];
	endproperty
	assert_fullpage_read : assert property (fullpage_read) else $error("%m: SDRAM Mode Register Configuration Invalid for: Full Page Burst Read");

// La latencia CAS debe ser de 2 o 3 ciclos dependiendo del valor almacenado en MODE REG
// Esto es un checker
	parameter READ_COMMAND = (wbox.ras && ~wbox.cas && wbox.we && ~wbox.cs);
	parameter CASLATENCY_2 = (~wbox.WB_cfg_sdr_mode_reg[6] && wbox.WB_cfg_sdr_mode_reg[5] && ~wbox.WB_cfg_sdr_mode_reg[4]);
	parameter CASLATENCY_3 = (~wbox.WB_cfg_sdr_mode_reg[6] && wbox.WB_cfg_sdr_mode_reg[5] &&  wbox.WB_cfg_sdr_mode_reg[4]);

	property cas_latency_2;
		@(posedge  wbox.clk_ram) (READ_COMMAND && CASLATENCY_2) |=> ##2 ~($isunknown(wbox.sdr_dq))
	endproperty
	cover_cas_latency_2 : assert property (cas_latency_2) else $error("%m: violated CAS latency of 2 clock cycles.");

	property cas_latency_3;
		@(posedge  wbox.clk_ram) (READ_COMMAND && CASLATENCY_3) |=> ##3 ~($isunknown(wbox.sdr_dq))
	endproperty
	cover_cas_latency_3 : assert property (cas_latency_3) else $error("%m: violated CAS latency of 3 clock cycles.");

`endif

endmodule