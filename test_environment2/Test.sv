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

    `ifdef EST2
      env2.run_estimulo2();
    `endif

    `ifdef EST3
      env2.run_estimulo3();
    `endif

    `ifdef EST4
      env2.run_estimulo4();
    `endif

    `ifdef EST5
      env2.run_estimulo5();
    `endif
    
    env2.mon.error();
   #100;
   $finish;
 end
endprogram