module clk(output reg wb_clk_i, output reg sdram_clk);

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

initial wb_clk_i  = 0;
initial sdram_clk = 0;

always #(P_SYS/2) wb_clk_i  = !wb_clk_i;
always #(P_SDR/2) sdram_clk = !sdram_clk;

endmodule