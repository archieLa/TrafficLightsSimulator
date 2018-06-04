`timescale 10ns/1ps

/*
By Artur Lach
Test bench for the flasher
*/

module flasher_tb();

reg enable, clock, out_state_when_enable_off;
wire out_to_control;

flasher DUT(.enable(enable), .clock(clock), .out_state_when_enable_off(out_state_when_enable_off), 
.out_to_control(out_to_control));

initial begin
    enable = 1'b0;
    clock = 1'b0;
    out_state_when_enable_off = 1'b1; 
    # 500000 
    enable = 1'b1;
    # 500000 
    enable = 1'b0;
    out_state_when_enable_off = 1'b0;
    # 500000
    enable = 1'b1;
    
end

always
#1 clock = ~clock;

endmodule