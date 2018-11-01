`include "Interface.sv"
class scoreboard; 
//A queue is declared like an array, but using $ for the range
//X Optionally, a maximum size for the queue can be specified
int address_fifo[$];
int data_fifo[$];
int bl_fifo[$];

endclass
