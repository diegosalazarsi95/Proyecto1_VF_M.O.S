`include "Environment2.sv"

program test(intf i_intf);
  //declaring environment instance
  environment2 env2;

  initial begin
    //creating environment
    env2 = new(i_intf);
    env2.driv2.reset();
    env2.run_estimulo5();
   #100;
   $finish;
    
 end
endprogram