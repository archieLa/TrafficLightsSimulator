`timescale 10ns/1ps


/*
By Artur Lach
Test bench for light controls state machine
*/


module  light_state_machine_tb();

reg reset, issue, clock;
wire red_light_ns, green_light_ns, yellow_light_ns, left_turn_light_ns, pedestrian_light_ns;
wire red_light_ew, green_light_ew, yellow_light_ew, left_turn_light_ew, pedestrian_light_ew;



light_state_machine DUT1(.in_reset_state(1'b0), .in_reset(reset), .in_issue(issue), .in_clock(clock), 
.out_red_light(red_light_ns), .out_green_light(green_light_ns), .out_yellow_light(yellow_light_ns), 
.out_left_turn_light(left_turn_light_ns), .out_pedestrian_light(pedestrian_light_ns));

light_state_machine DUT2(.in_reset_state(1'b1), .in_reset(reset), .in_issue(issue), .in_clock(clock), 
.out_red_light(red_light_ew), .out_green_light(green_light_ew), .out_yellow_light(yellow_light_ew), 
.out_left_turn_light(left_turn_light_ew), .out_pedestrian_light(pedestrian_light_ew));


initial begin
    reset = 1'b0;
    issue = 1'b1;
    clock = 1'b0;
    # 500000 
    issue = 1'b0;
    # 500000 
    reset = 1'b1;
    #500000
    reset = 1'b0;
    # 5000000 
    // Test reset signal
    reset = 1'b1;
    #500000
    reset = 1'b0;
    # 5000000
    // Test issue signal
    issue = 1'b1;
    #5000
    issue = 1'b0;
    #500000
    reset = 1'b1;
    #5000
    reset = 1'b0;
end

always
#1 clock = ~clock;

endmodule