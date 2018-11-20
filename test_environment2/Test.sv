`include "Environment2.sv"

program test(intf i_intf);
  //declaring environment instance
  environment2 env;

  initial begin
    //creating environment
    env = new(i_intf);
    env.driv.reset();
    env.run_estimulo1();
   #100;
   $finish;
    
 end
endprogram