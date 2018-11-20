`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard; 
//A queue is declared like an array, but using $ for the range
//X Optionally, a maximum size for the queue can be specified
int address_fifo[$]; // direccion fifo
int data_fifo[$]; //datos fifo
int bl_fifo[$]; //Profundidad de fifo

endclass
`endif