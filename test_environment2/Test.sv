`include "Environment2.sv"

program test(intf i_intf);
  //declaring environment instance
  environment2 env2;

  initial begin
    //creating environment
    env2 = new(i_intf);
    env2.driv.reset();
    `ifdef EST1
    	env2.run_estimulo1();
    `endif
    env2.run_estimulo2();
   #100;
   $finish;
 end
endprogram