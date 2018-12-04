`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV


class scoreboard; 
	//A queue is declared like an array, but using $ for the range
	//X Optionally, a maximum size for the queue can be specified
	int address_fifo[$]; // direccion fifo
	int data_fifo[$]; //datos fifo
	int bl_fifo[$]; //Profundidad de fifo

	int random_oper;
	int random_element;

	task random_element_t();
		int j= 0;
		int address;
		int data;
		int bl;

		j=$size(address_fifo);
		if(j==1) begin
			random_oper = 0;
		end
		else begin
			random_oper = $urandom_range(1,0);
		end // else

		if(random_oper == 0)begin
			random_element = 0;
		end
		if(random_oper == 1)begin
			random_element = $urandom_range(j,0);
			for (int i = 0; i < random_element-1; i++) begin
				address = address_fifo.pop_front();
				bl = bl_fifo.pop_front();
				address_fifo.push_back(address);
				bl_fifo.push_back(bl);
				for(int k = 0; k < bl ; k++)begin
					data = data_fifo.pop_front();
					data_fifo.push_back(data);
				end // for(int k = 0; k < bl ; k++)
			end
		end
		$display("j: %d Operation random: %d  Number of element: %d ",j,random_oper,random_element);
		random_element = 0;
		random_oper = 0;
	endtask : random_element_t

endclass
`endif