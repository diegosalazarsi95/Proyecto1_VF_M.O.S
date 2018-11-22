`include "Environment.sv"
`include "estimulo1.sv"
`include "estimulo2.sv"
`include "estimulo3.sv"
`include "estimulo4.sv"


class environment2 extends environment;
	estimulo1 est1;
	estimulo2 est2;
	estimulo3 est3;
	estimulo4 est4;
	
	function new(virtual intf vif);
    	super.new(vif);
    	est1 = new(vif,score,driv,mon);
    	est2 = new(vif,score,driv,mon);
    	est3 = new(vif,score,driv,mon);
    	est4 = new(vif,score,driv,mon);
  	endfunction

	task run_estimulo1();
		est1.run();
	endtask : run_estimulo1

	/*task run_estimulo2();
		est2.run();
	endtask : run_estimulo2

	task run_estimulo3();
		est3.run();
	endtask : run_estimulo3

	task run_estimulo4();
		est4.run();
	endtask : run_estimulo4*/

endclass : environment2