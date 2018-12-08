`ifndef SCOREBOARD_SV
  `include "scoreboard.sv"
`endif

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor;
  //hay dos relojs hay que ver eso
  
  virtual intf vif;
  scoreboard score;
  
  reg [31:0] ErrCnt;
  reg readings;
  reg [31:0]   exp_data;

  function new(virtual intf vif,scoreboard score);//,scoreboard score);
    this.vif = vif;
    this.score=score;
    readings=0;
    ErrCnt=32'd0;
  endfunction
  
task burst_read;
  reg [31:0] Address;
  reg [7:0]  bl;

  int i,j;
  $display("[ MONITOR ] ----- Burst Read -----");

	begin
  	Address = score.address_fifo.pop_front(); 	
    bl      = score.bl_fifo.pop_front(); 
   	@ (negedge vif.wb_clk_i);
      for(j=0; j < bl; j++) begin
		    readings        <= 1;
        vif.wb_stb_i    <= 1;
       	vif.wb_cyc_i    <= 1;
        vif.wb_we_i     <= 0;
        vif.wb_addr_i   <= Address[31:2]+j;
        exp_data    = score.data_fifo.pop_front(); // Exptected Read Data
        do begin
          @ (posedge vif.wb_clk_i);
        end 
        while(vif.wb_ack_o == 1'b0);
        //CODIGO NUEVO
        //Se modifica para incluir largo de rafaga de 1
          if(vif.cfg_sdr_mode_reg[2:0] == 3'b000)begin
            if(vif.wb_dat_o[15:0] !== exp_data[15:0]) begin
              $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,vif.wb_addr_i,vif.wb_dat_o,exp_data);
              ErrCnt = ErrCnt+1;
            end 
            else begin
              $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,vif.wb_addr_i,vif.wb_dat_o);
            end
          end // if(vif.cfg_sdr_mode_reg[2:0] == 3'b000)
          else begin
            if(vif.wb_dat_o !== exp_data) begin
              $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,vif.wb_addr_i,vif.wb_dat_o,exp_data);
              ErrCnt = ErrCnt+1;
            end 
            else begin
              $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,vif.wb_addr_i,vif.wb_dat_o);
            end
          end
         	/*if(vif.wb_dat_o !== exp_data) begin
         	  $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,vif.wb_addr_i,vif.wb_dat_o,exp_data);
            ErrCnt = ErrCnt+1;
         	end 
          else begin
            $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,vif.wb_addr_i,vif.wb_dat_o);
          end*/ 
             @ (negedge vif.sdram_clk);
      end
	   vif.wb_stb_i        <= 0;
   	 vif.wb_cyc_i        <= 0;
	   vif.wb_we_i         <= 'hx;
	   vif.wb_addr_i       <= 'hx;
	end

  $display("[ MONITOR ] ----- Burst Read -----");
endtask

task error();
	if(ErrCnt == 0 && readings == 1)
	  $display("STATUS: SDRAM Write/Read TEST PASSED");
	else
	  $display("ERROR:  SDRAM Write/Read TEST FAILED");
    $display("###############################");
endtask 

endclass
`endif