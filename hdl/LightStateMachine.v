
/*
By Artur Lach
State machine responsible for controlling one traffic lights on the intersection
Include control for pedestrian walk/don't walk signal and left turn arrow
*/

module light_state_machine(in_reset_state, in_reset, in_issue,
in_clock, out_red_light, out_green_light, out_yellow_light, out_left_turn_light,
out_pedestrian_light, counter);

input in_reset, in_issue, in_clock;
input in_reset_state; // This input decides which state is selected upon reset
output reg out_green_light, out_yellow_light, out_left_turn_light,
out_pedestrian_light;
output out_red_light;
reg red_light_flashing_enable, temp_red_light;

reg [2:0] state;

// Time on/off for red and green lights will change depending on this scaler
wire [31:0] config_time_scaler;
assign config_time_scaler = in_reset_state ? 32'd500000000 : 32'd0;

// Constant used to determine which state to reset to
parameter RESET_TO_RED = 1'b0, RESET_TO_GREEN_LEFT_TURN = 1'b1;

// Used to count ticks of the clock to determine timings for lights
output reg [31:0] counter;

// States constants
parameter  RED = 3'b000, LEFT_TURN = 3'b001, GREEN_PEDES = 3'b010,
GREEN = 3'b011, YELLOW = 3'b100, ISSUE = 3'b101;

// ON OFF Constants
parameter ON = 1'b1, OFF = 1'b0;


// Settings for 5mhz clock (clock frequency on the board) 
parameter RESET_CLOCK_TICK_COUNT = 32'd0;
parameter RED_ON_CLOCK_TICKS_COUNT = 32'd1750000000; // 35 seconds
parameter YELLOW_ON_CLOCK_TICKS_COUNT = 32'd250000000; // 5 seconds 
parameter GREEN_PEDES_ON_CLOCK_TICKS_COUNT = 32'd500000000; // 10 seconds
parameter GREEN_ON_WITHOUT_PEDESTRIAN_CLOCK_TICKS_COUNT = 32'd1000000000; // 20 seconds          
parameter LEFT_TURN_ON_CLOCK_TICK_COUNT = 32'd500000000; // 10 seconds
parameter PEDESTRIAN_ON_CLOCK_TICK_COUNT = 32'd500000000; // 10 seconds


/*
// Setting for 5mhz clock for making simulation easier to read
parameter RESET_CLOCK_TICK_COUNT = 32'd0;
parameter RED_ON_CLOCK_TICKS_COUNT = 32'd1750000; // 35 ms
parameter YELLOW_ON_CLOCK_TICKS_COUNT = 32'd250000; // 5s  
parameter GREEN_PEDES_ON_CLOCK_TICKS_COUNT = 32'd500000; // 10ms
parameter GREEN_ON_WITHOUT_PEDESTRIAN_CLOCK_TICKS_COUNT = 32'd1000000; // 20 ms        
parameter LEFT_TURN_ON_CLOCK_TICK_COUNT = 32'd500000; // 10 ms
parameter PEDESTRIAN_ON_CLOCK_TICK_COUNT = 32'd500000; // 10 ms
*/


// States and their outputs - triggered on every state variable update
always@(state) begin
  case (state)
  RED: begin
  red_light_flashing_enable = OFF;
  temp_red_light = ON;
  out_green_light = OFF;
  out_yellow_light = OFF;
  out_left_turn_light = OFF;
  out_pedestrian_light = OFF;
  end
  LEFT_TURN: begin
  red_light_flashing_enable = OFF;
  temp_red_light = OFF;
  out_green_light = OFF;
  out_yellow_light = OFF;
  out_left_turn_light = ON;
  out_pedestrian_light = OFF;
  end
  GREEN_PEDES: begin
  red_light_flashing_enable = OFF;
  temp_red_light = OFF;
  out_green_light = ON;
  out_yellow_light = OFF;
  out_left_turn_light = OFF;
  out_pedestrian_light = ON;
  end
  GREEN: begin
  red_light_flashing_enable = OFF;
  temp_red_light = OFF;
  out_green_light = ON;
  out_yellow_light = OFF;
  out_left_turn_light = OFF;
  out_pedestrian_light = OFF;
  end
  YELLOW: begin
  red_light_flashing_enable = OFF;
  temp_red_light = OFF;
  out_green_light = OFF;
  out_yellow_light = ON;
  out_left_turn_light = OFF;
  out_pedestrian_light = OFF;
  end
  ISSUE: begin
  red_light_flashing_enable = ON;
  temp_red_light = OFF;
  out_green_light = OFF;
  out_yellow_light = OFF;
  out_left_turn_light = OFF;
  out_pedestrian_light = OFF;
  end
  endcase
end


// State machine
always@(posedge in_clock or posedge in_reset or posedge in_issue) begin
    // Issue triggered, stay in issue untill in_issue is 0 and reset has been set
    if (in_issue) begin
        state <= ISSUE;
        counter <= RESET_CLOCK_TICK_COUNT;
    end
    // Reset has been triggered
    else if (in_reset) begin
        // Determine reset configuration and reset to that state
        case (in_reset_state)
        RESET_TO_RED: begin
        state <= RED;
        counter <= (RED_ON_CLOCK_TICKS_COUNT + config_time_scaler);
        end
        RESET_TO_GREEN_LEFT_TURN: begin
        state <= LEFT_TURN;
        counter <= LEFT_TURN_ON_CLOCK_TICK_COUNT;
        end
        endcase
    end
    else begin
		  // Guard so that display always displays same when in issue state
		  if (state != ISSUE) begin
		  counter <= counter - 1;
        end
		  case (state)
        RED: begin
            if (counter == 32'd0) begin
            state <= LEFT_TURN;
            counter <= LEFT_TURN_ON_CLOCK_TICK_COUNT;
            end
        end
        LEFT_TURN: begin
            if (counter == 32'd0) begin
                state <= GREEN_PEDES;
                counter <= GREEN_PEDES_ON_CLOCK_TICKS_COUNT;
            end
        end
        GREEN_PEDES: begin
            if (counter == 32'd0) begin
                state <= GREEN;
                counter <= (GREEN_ON_WITHOUT_PEDESTRIAN_CLOCK_TICKS_COUNT - config_time_scaler);
            end
        end
        GREEN: begin
            if (counter == 32'd0) begin
                state <= YELLOW;
                counter <= YELLOW_ON_CLOCK_TICKS_COUNT;
            end
        end
        YELLOW: begin
            if (counter == 32'd0) begin
                state <= RED;
                counter <= (RED_ON_CLOCK_TICKS_COUNT + config_time_scaler);
            end
        end
        endcase
    end
end

// Create an instance for flasher module to control the red light
flasher red_flasher(.enable(red_light_flashing_enable),
 .clock(in_clock), .out_state_when_enable_off(temp_red_light), .out_to_control(out_red_light));

endmodule