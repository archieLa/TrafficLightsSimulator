/*
By Artur Lach
This flasher module assumes clock input of 5Mhz and toggles the otutput every second 
if enable line is set to high 
*/

module flasher(enable, clock, out_state_when_enable_off, out_to_control);

input enable, clock, out_state_when_enable_off;
output reg out_to_control;
reg [31:0] counter;
reg init;   // Used so that counter can be properly initiliazed to 0
reg first_flip; // Used to synchronize flashing to always start with light on

parameter TIME_TO_FLIP = 50000000; // Toggle every second

/*
// For the puspose of simulation toggle every ms
parameter TIME_TO_FLIP = 32'd50000; // Toggle every ms
*/


always@(posedge clock) begin
  
  if (enable && (init == 1'b1)) begin
    counter  <= counter + 1;
    if (first_flip != 1) begin
		out_to_control <= 1'b1;
	 end
	 if (counter >= TIME_TO_FLIP) begin
        out_to_control <= ~out_to_control;
        counter <= 32'd0;
		  first_flip <= 1'b1;
    end  
  end
  else begin
    counter <= 32'd0;
    out_to_control <= out_state_when_enable_off;
    init <= 1'b1;
	 first_flip <= 1'b0;
  end
end


endmodule 