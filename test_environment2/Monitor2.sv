`ifndef MONITOR_SV
	`include "Monitor.sv"
`endif

`ifndef SCOREBOARD2_SV
  `include "scoreboard2.sv"
`endif

`ifndef MONITOR2_SV
`define MONITOR2_SV

class monitor2 extends monitor;

scoreboard2 score2;

function new(virtual intf vif,scoreboard score,scoreboard2 score2);//,scoreboard score);
	super.new(vif,score);
	this.score2 = score2;
endfunction

task burst_read_random();

  int j;

  $display("[ MONITOR ] ----- Burst Read -----");
	begin
		j=$size(score2.address_fifo);
		if(j==1) begin
			score2.random_oper = 0;
		end
		else begin
			score2.random_oper = $urandom_range(1,0);
		end // else

		if(score2.random_oper == 0)begin
			score2.random_element = 0;
			score2.address = score2.address_fifo.pop_front(); 
			score2.data = score2.data_fifo.pop_front(); // Exptected Read Data
		end
		if(score2.random_oper == 1)begin
			score2.random_element = $urandom_range(j,0);
			for (int i = 0; i < score2.random_element; i++) begin
				score2.address =score2.address_fifo.pop_front();
				score2.data = score2.data_fifo.pop_front();
				if(i<=score2.random_element-2) begin
					score2.address_fifo.push_back(score2.address);
					score2.data_fifo.push_back(score2.data);
				end
			end
		end
	   	@ (negedge vif.wb_clk_i);

		readings        <= 1;
	    vif.wb_stb_i    <= 1;
	    vif.wb_cyc_i    <= 1;
	    vif.wb_we_i     <= 0;
	    vif.wb_addr_i   <= score2.address;
	    
	    do begin
	      @ (posedge vif.wb_clk_i);
	    end 
	    while(vif.wb_ack_o == 1'b0);
	     	if(vif.wb_dat_o !== score2.data) begin
	     	  $display("READ ERROR: Random_oper-No: %d Random_Element-No: %d Addr: %x Rxp: %x Exd: %x", score2.random_oper, score2.random_element,vif.wb_addr_i,vif.wb_dat_o, score2.data);
	        ErrCnt = ErrCnt+1;
	     	end 
	      else begin
	        $display("READ STATUS: Random_oper-No: %d Random_Element-No: %d Addr: %x Rxd: %x",score2.random_oper, score2.random_element,vif.wb_addr_i,vif.wb_dat_o);
	      end 
	    @ (negedge vif.sdram_clk);
		vif.wb_stb_i        <= 0;
		vif.wb_cyc_i        <= 0;
		vif.wb_we_i         <= 'hx;
		vif.wb_addr_i       <= 'hx;
	end
  $display("[ MONITOR ] ----- Burst Read -----");
endtask

endclass : monitor2

`endif