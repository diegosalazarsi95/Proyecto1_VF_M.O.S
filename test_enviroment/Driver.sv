class driver;

  virtual intf vif;
  function new(virtual intf vif);
    //getting the interface
    this.vif = vif;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.ErrCnt         <= 0;
    vif.wb_addr_i      <= 0;
    vif.wb_dat_i       <= 0;
    vif.wb_sel_i       <= 4'h0;
    vif.wb_we_i        <= 0;
    vif.wb_stb_i       <= 0;
    vif.wb_cyc_i       <= 0;
    vif.wb_rst_i <= 0;// se activa en bajo
    //wait(u_dut.sdr_init_done == 1);
    wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask

  //write task

   task burst_write;
	input [31:0] Address;
	input [7:0]  bl;
	int i;
	begin
  	   afifo.push_back(Address);
	   bfifo.push_back(bl);

   @ (negedge sys_clk);
   $display("Write Address: %x, Burst Size: %d",Address,bl);

   for(i=0; i < bl; i++) begin
      vif.wb_stb_i        <= 1;
      vif.wb_cyc_i        <= 1;
      vif.wb_we_i         <= 1;
      vif.wb_sel_i        <= 4'b1111;
      vif.wb_addr_i       <= Address[31:2]+i;
      vif.wb_dat_i        <= $random & 32'hFFFFFFFF;
      vif.dfifo.push_back(wb_dat_i);

      do begin
          @ (posedge sys_clk);
      end while(wb_ack_o == 1'b0);
          @ (negedge sys_clk);
   
       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,wb_addr_i,wb_dat_i);
   end
   vif.wb_stb_i        <= 0;
   vif.wb_cyc_i        <= 0;
   vif.wb_we_i         <= 'hx;
   vif.wb_sel_i        <= 'hx;
   vif.wb_addr_i       <= 'hx;
   vif.wb_dat_i        <= 'hx;
end
endtask

endclass
