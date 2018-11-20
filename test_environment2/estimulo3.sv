class estimulo3;
  virtual intf vif;
  scoreboard    score;
  driver    	driv;
  monitor   	mon;

  function new(virtual intf vif, scoreboard score, driver driv, monitor mon);//,scoreboard score);
    this.vif = vif;
    this.score = score;
    this.driv = driv;
    this.mon = mon;
  endfunction

  task run();
    int k;
    reg [31:0] StartAddr;
  	for(k=0; k < 20; k++) begin
      StartAddr = $random & 32'h003FFFFF;
      driv.burst_write(StartAddr,($random & 8'h0f)+1);  
      #100;
      StartAddr = $random & 32'h003FFFFF;
      driv.burst_write(StartAddr,($random & 8'h0f)+1);  
      #100;
      mon.burst_read();  
      #100;
      mon.burst_read();  
      #100;
    end
  endtask : run

endclass : estimulo1