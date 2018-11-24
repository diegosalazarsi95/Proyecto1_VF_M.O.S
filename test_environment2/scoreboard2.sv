`ifndef SCOREBOARD_SV
  `include "scoreboard.sv"
`endif

`ifndef SCOREBOARD2_SV
`define SCOREBOARD2_SV


class scoreboard2 extends scoreboard;

	function new();
		super.new();
	endfunction 

	int address; // direccion fifo
	int data; //datos fifo
	int random_oper;
	int random_element;

endclass : scoreboard2
`endif