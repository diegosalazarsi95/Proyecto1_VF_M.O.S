class monitor;
  
  virtual intf vif;
  
  function new(virtual intf vif);
    this.vif = vif;
  endfunction
  
  task burst_read;
     wait(vif.burst_read);
     $display("[ MONITOR ] ----- Burst Read -----");
	reg [31:0] Address;
	reg [7:0]  bl;
	int i,j;
	reg [31:0]   exp_data;
	begin
  	   Address = afifo.pop_front(); 	
	   bl      = bfifo.pop_front(); 
   	   @ (negedge sys_clk);

      	for(j=0; j < bl; j++) begin
        	 vif.wb_stb_i        <= 1;
       		 vif.wb_cyc_i        <= 1;
         	 vif.wb_we_i         <= 0;
         	 vif.wb_addr_i       <= Address[31:2]+j;
         	 vif.exp_data        <= dfifo.pop_front(); // Exptected Read Data
         do begin
             @ (posedge sys_clk);
         end while(wb_ack_o == 1'b0);
         	if(wb_dat_o !== exp_data) begin
         	    $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,wb_addr_i,wb_dat_o,exp_data);
             		ErrCnt = ErrCnt+1;
         	end else begin
             	    $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,wb_addr_i,wb_dat_o);
         end 
             @ (negedge sdram_clk);
      	end
	   vif.wb_stb_i        <= 0;
   	   vif.wb_cyc_i        <= 0;
	   vif.wb_we_i         <= 'hx;
	   vif.wb_addr_i       <= 'hx;
	end
     	wait(!vif.burst_read);
     	$display("[ MONITOR ] ----- Burst Read -----");
  endtask
endclass
