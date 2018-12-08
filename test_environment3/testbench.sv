`include "Test.sv"
`include "Interface.sv"
`include "clk.sv"
`include "assertions.sv"
`include "coverage.sv"
module tbench_top;
wire sdram_clk;

intf i_inter();


test tb(i_inter);

clk reloj(
	.wb_clk_i(i_inter.wb_clk_i),
	.sdram_clk(i_inter.sdram_clk)
	);


`ifdef SDR_32BIT
   wire [31:0]           sdr_dq; // SDRAM Read/Write Data Bus
   wire [3:0]            sdr_dqm; // SDRAM DATA Mask
`elsif SDR_16BIT 
   wire [15:0]           sdr_dq; // SDRAM Read/Write Data Bus
   wire [1:0]            sdr_dqm; // SDRAM DATA Mask
`else 
   wire [7:0]           sdr_dq; // SDRAM Read/Write Data Bus
   wire [0:0]           sdr_dqm; // SDRAM DATA Mask
`endif

wire [1:0]            sdr_ba; // SDRAM Bank Select
wire [12:0]           sdr_addr; // SDRAM ADRESS
wire                  sdr_init_done; // SDRAM Init Done 

wire #(2.0) sdram_clk_d   = i_inter.sdram_clk;


`ifdef SDR_32BIT
   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
`elsif SDR_16BIT 
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
`endif
      // System 
`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
`else 
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
`endif
          .cfg_colbits        (2'b00              ), // 8 Bit Column Address

/* WISH BONE */
          .wb_rst_i           (!i_inter.wb_rst_i       ),
          .wb_clk_i           (i_inter.wb_clk_i        ), //linea original:           .wb_clk_i           (i_inter.sys_clk            ),

          .wb_stb_i           (i_inter.wb_stb_i        ),
          .wb_ack_o           (i_inter.wb_ack_o        ),
          .wb_addr_i          (i_inter.wb_addr_i       ),
          .wb_we_i            (i_inter.wb_we_i         ),
          .wb_dat_i           (i_inter.wb_dat_i        ),
          .wb_sel_i           (i_inter.wb_sel_i        ),
          .wb_dat_o           (i_inter.wb_dat_o        ),
          .wb_cyc_i           (i_inter.wb_cyc_i        ),
          .wb_cti_i           (i_inter.wb_cti_i        ), 

/* Interface to SDRAMs */
          .sdram_clk          (i_inter.sdram_clk       ),
          .sdram_resetn       (i_inter.wb_rst_i        ),
          .sdr_cs_n           (i_inter.sdr_cs_n        ),
          .sdr_cke            (i_inter.sdr_cke         ),
          .sdr_ras_n          (i_inter.sdr_ras_n       ),
          .sdr_cas_n          (i_inter.sdr_cas_n       ),
          .sdr_we_n           (i_inter.sdr_we_n        ),
          .sdr_dqm            (sdr_dqm                 ),
          .sdr_ba             (sdr_ba                  ),
          .sdr_addr           (i_inter.sdr_addr        ), 
          .sdr_dq             (sdr_dq                  ),

    /* Parameters */
          .sdr_init_done      (i_inter.sdr_init_done   ),
          .cfg_req_depth      (i_inter.cfg_req_depth   ),	  //how many req. buffer should hold
          .cfg_sdr_en         (i_inter.cfg_sdr_en      ),   //Habilita el controlador
          .cfg_sdr_mode_reg   (i_inter.cfg_sdr_mode_reg),   //SDRAM Mode Register
          .cfg_sdr_tras_d     (i_inter.cfg_sdr_tras_d  ),   //SDRAM activa para la precarga, especificada en los relojes
          .cfg_sdr_trp_d      (i_inter.cfg_sdr_trp_d   ),   //Período de comando de precarga de SDRAM (tRP), especificado en los relojes.
          .cfg_sdr_trcd_d     (i_inter.cfg_sdr_trcd_d  ),   //SDRAM activa para leer o escribir el retardo (tRCD), especificado en los relojes.
          .cfg_sdr_cas        (i_inter.cfg_sdr_cas     ),   //Latencia SDRAM CAS, especificada en los relojes
          .cfg_sdr_trcar_d    (i_inter.cfg_sdr_trcd_d  ),   //SDRAM activa a activa / período de comando de actualización automática (tRC), especificado en los relojes.
          .cfg_sdr_twr_d      (i_inter.cfg_sdr_twr_d   ),   //Tiempo de recuperación de escritura (tWR) de SDRAM, especificado en los relojes
          .cfg_sdr_rfsh       (i_inter.cfg_sdr_rfsh    ), //Período entre los comandos de actualización automática emitidos por el controlador, especificados en los relojes.
          .cfg_sdr_rfmax      (i_inter.cfg_sdr_rfmax   )  //Número máximo de filas a renovar a la vez (tRFSH)
);


`ifdef SDR_32BIT
     mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (sdr_dq                     ), 
          .Addr               (i_inter.sdr_addr[10:0]     ), 
          .Ba                 (sdr_ba                     ), 
          .Clk                (sdram_clk_d                ), 
          .Cke                (i_inter.sdr_cke            ), 
          .Cs_n               (i_inter.sdr_cs_n           ), 
          .Ras_n              (i_inter.sdr_ras_n          ), 
          .Cas_n              (i_inter.sdr_cas_n          ), 
          .We_n               (i_inter.sdr_we_n           ), 
          .Dqm                (sdr_dqm                    )
     );

`elsif SDR_16BIT
     IS42VM16400K u_sdram16 (
          .dq                 (sdr_dq                     ), 
          .addr               (i_inter.sdr_addr[11:0]     ), 
          .ba                 (sdr_ba                     ), 
          .clk                (sdram_clk_d                ), 
          .cke                (i_inter.sdr_cke            ), 
          .csb                (i_inter.sdr_cs_n           ), 
          .rasb               (i_inter.sdr_ras_n          ), 
          .casb               (i_inter.sdr_cas_n          ), 
          .web                (i_inter.sdr_we_n           ), 
          .dqm                (sdr_dqm                    )
    );

`else 
     mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (sdr_dq                     ), 
          .Addr               (i_inter.sdr_addr[11:0]     ), 
          .Ba                 (sdr_ba                     ), 
          .Clk                (sdram_clk_d                ), 
          .Cke                (i_inter.sdr_cke            ), 
          .Cs_n               (i_inter.sdr_cs_n           ), 
          .Ras_n              (i_inter.sdr_ras_n          ), 
          .Cas_n              (i_inter.sdr_cas_n          ), 
          .We_n               (i_inter.sdr_we_n           ), 
          .Dqm                (sdr_dqm                    )
     );
`endif

assertion my_assert();
coverage my_coverage(i_inter);

endmodule // tbench_top