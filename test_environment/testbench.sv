`include "Test.sv"
`include "Interface.sv"
`include "clk.sv"
//`include "../rtl/sdrc_top.v"
//`include "../rtl/model/mt48lc2m32b2.v"
//`include "../rtl/model/IS42VM16400K.V"
//`include "../rtl/model/mt48lc8m8a2.v"


module tbench_top;
wire sdram_clk;

intf i_inter();

test tb(i_inter);

clk reloj(
	.wb_clk_i(i_inter.wb_clk_i),
	.sdram_clk(i_inter.sdram_clk)
	);


wire [7:0] sdr_dq;
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
          .wb_rst_i           (!i_inter.wb_rst_i            ),
          .wb_clk_i           (i_inter.wb_clk_i            ), //linea original:           .wb_clk_i           (i_inter.sys_clk            ),

          .wb_stb_i           (i_inter.wb_stb_i           ),
          .wb_ack_o           (i_inter.wb_ack_o           ),
          .wb_addr_i          (i_inter.wb_addr_i          ),
          .wb_we_i            (i_inter.wb_we_i            ),
          .wb_dat_i           (i_inter.wb_dat_i           ),
          .wb_sel_i           (i_inter.wb_sel_i           ),
          .wb_dat_o           (i_inter.wb_dat_o           ),
          .wb_cyc_i           (i_inter.wb_cyc_i           ),
          .wb_cti_i           (i_inter.wb_cti_i           ), 

/* Interface to SDRAMs */
          .sdram_clk          (i_inter.sdram_clk          ),
          .sdram_resetn       (i_inter.wb_rst_i           ),
          .sdr_cs_n           (i_inter.sdr_cs_n           ),
          .sdr_cke            (i_inter.sdr_cke            ),
          .sdr_ras_n          (i_inter.sdr_ras_n          ),
          .sdr_cas_n          (i_inter.sdr_cas_n          ),
          .sdr_we_n           (i_inter.sdr_we_n           ),
          .sdr_dqm            (i_inter.sdr_dqm            ),
          .sdr_ba             (i_inter.sdr_ba             ),
          .sdr_addr           (i_inter.sdr_addr           ), 
          .sdr_dq             (sdr_dq             ),

    /* Parameters */
          .sdr_init_done      (i_inter.sdr_init_done      ),
          .cfg_req_depth      (2'h3               ),	        //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (sdr_dq[31:0]            ) , 
          .Addr               (i_inter.sdr_addr[10:0]     ), 
          .Ba                 (i_inter.sdr_ba             ), 
          .Clk                (sdram_clk_d                ), 
          .Cke                (i_inter.sdr_cke            ), 
          .Cs_n               (i_inter.sdr_cs_n           ), 
          .Ras_n              (i_inter.sdr_ras_n          ), 
          .Cas_n              (i_inter.sdr_cas_n          ), 
          .We_n               (i_inter.sdr_we_n           ), 
          .Dqm                (i_inter.sdr_dqm            )
     );

`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
          .dq                 (sdr_dq[15:0]             ), 
          .addr               (i_inter.sdr_addr[11:0]     ), 
          .ba                 (i_inter.sdr_ba             ), 
          .clk                (sdram_clk_d                ), 
          .cke                (i_inter.sdr_cke            ), 
          .csb                (i_inter.sdr_cs_n           ), 
          .rasb               (i_inter.sdr_ras_n          ), 
          .casb               (i_inter.sdr_cas_n          ), 
          .web                (i_inter.sdr_we_n           ), 
          .dqm                (i_inter.sdr_dqm            )
    );
`else 


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (sdr_dq                     ), 
          .Addr               (i_inter.sdr_addr[11:0]     ), 
          .Ba                 (i_inter.sdr_ba             ), 
          .Clk                (sdram_clk_d         	   ), 
          .Cke                (i_inter.sdr_cke            ), 
          .Cs_n               (i_inter.sdr_cs_n           ), 
          .Ras_n              (i_inter.sdr_ras_n          ), 
          .Cas_n              (i_inter.sdr_cas_n          ), 
          .We_n               (i_inter.sdr_we_n           ), 
          .Dqm                (i_inter.sdr_dqm            )
     );
`endif


endmodule // tbench_top