
module coverage (intf intf);

	`define LOAD_MODE_REG ~intf.sdr_ras_n && ~intf.sdr_cas_n && ~intf.sdr_we_n && ~intf.sdr_cs_n

	/* ------------------------------------------------------------------------------------------*/
	/* ------------------------------------------------------------------------------------------*/
	
	/* Grupo de cobertura ubicado a la salida del controlador */
	covergroup controllerOut @ (posedge intf.sdram_clk iff `LOAD_MODE_REG);
		CASLatency : coverpoint intf.sdr_addr[6:4] {
			bins lat2  = {3'b010};
			bins lat3  = {3'b011};
		}
	   	
	   	BurstLength : coverpoint intf.sdr_addr[2:0] {
		   	bins bLength1 = {3'b000};
		   	bins bLength2 = {3'b001};
		   	bins bLength4 = {3'b010};
		   	bins bLength8 = {3'b011};
		   	//bins fullPage = {3'b111 iff (intf.cfg_sdr_mode_reg[3] == 1'b0) };
	   	}

		BurstType : coverpoint intf.sdr_addr[3]{
			bins sequential = {1'b0};
			bins interleave = {1'b1};
		}

		WriteBurstMode : coverpoint intf.sdr_addr[9]{
			bins burstWrite  = {1'b0};
			bins singleWrite = {1'b1};
		}

	endgroup : controllerOut

	/* ------------------------------------------------------------------------------------------*/
	/* ------------------------------------------------------------------------------------------*/

	/* Grupo de cobertura a la entrada del controlador */
	covergroup controllerIn @ (posedge intf.wb_clk_i);
		CASLatency : coverpoint intf.cfg_sdr_mode_reg[6:4] {
			bins lat2  = {3'b010};
			bins lat3  = {3'b011};
		}
	   	
	   	BurstLength : coverpoint intf.cfg_sdr_mode_reg[2:0] {
		   	bins bLength1 = {3'b000};
		   	bins bLength2 = {3'b001};
		   	bins bLength4 = {3'b010};
		   	bins bLength8 = {3'b011};
		   	//bins fullPage = {3'b111 iff (intf.cfg_sdr_mode_reg[3] == 1'b0) };
		}

		BurstType : coverpoint intf.cfg_sdr_mode_reg[3]{
			bins sequential = {1'b0};
			bins interleave = {1'b1};
		}

		WriteBurstMode : coverpoint intf.cfg_sdr_mode_reg[9]{
			bins burstWrite  = {1'b0};
			bins singleWrite = {1'b1};
		}

	endgroup : controllerIn

	/* ------------------------------------------------------------------------------------------*/
	/* ------------------------------------------------------------------------------------------*/

	/* Grupo de cobertura de los parámetros de funcionamiento del controlador */
	
	/* Forman parte de la cobertura de entrada del controlador, se ponen aparte
	   para diferenciar que son parámetros de configuración del mismo */
	
	/* NOTA: se debe verificar que los parámetros de funcionamiento del controlador 
	   correspondan a los mismos que se cargan al rregistro MODE de la memoria (para
	   que el controlador y la memoria trabajen igual) */
	covergroup cntrlrParams @ (posedge intf.wb_clk_i);
		CASLatency : coverpoint intf.cfg_sdr_cas {
			bins lat2  = {3'b010};
			bins lat3  = {3'b011};
		}

		CntrlrEnable : coverpoint intf.cfg_sdr_en {
			//bins disable = {1'b0};
			bins enable  = {1'b1};
		}

	endgroup : cntrlrParams

	/* Grupo de cobertura del acceso a diferentes regiones de memoria */
	covergroup memoryAccess @ (posedge intf.wb_clk_i);
	   	bankAccess : coverpoint intf.wb_addr_i[10:9] {
	   		bins bankA = {2'b00};
	   		bins bankB = {2'b01};
	   		bins bankC = {2'b10};
	   		bins bankD = {2'b11};
	   	}

	   	colAccess : coverpoint intf.wb_addr_i[8:0] {
	   		bins colsA = {0,   127};
	   		bins colsB = {128, 255};
	   		bins colsC = {256, 383};
	   		bins colsD = {384, 511};
	   	}

	   	rowAccess : coverpoint intf.wb_addr_i[22:11] {
	   		bins rowsA = {0, 511};
	   		bins rowsB = {512, 1023};
	   		bins rowsC = {1024, 1535};
	   		bins rowsD = {1536, 2047};
	   		bins rowsE = {2048, 2559};
	   		bins rowsF = {2560, 3071};
	   		bins rowsG = {3072, 3583};
	   		bins rowsH = {3584, 4095};
	   	}
	endgroup : memoryAccess

	controllerOut assert1 = new();
	controllerIn  assert2 = new();
	cntrlrParams  assert3 = new();
	memoryAccess  assert4 = new();
	/* ------------------------------------------------------------------------------------------*/
	/* ------------------------------------------------------------------------------------------*/

endmodule