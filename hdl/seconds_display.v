/* By Artur Lach
Module that displays seconds remaining for each light state 
*/

module seconds_display(clock_ticks, seven_segment_MSB, seven_segment_LSB);

input [31:0] clock_ticks;
output wire [7:0] seven_segment_MSB, seven_segment_LSB;
reg [9:0] seconds;
reg [3:0] MSB, LSB;

parameter SCALER = 31'd50000000;

always @(clock_ticks) begin
  seconds = (clock_ticks / SCALER) + 10'd1 ;
  MSB = seconds / 4'd10;
  LSB = seconds % 4'd10;
end

 digit_display msb(.number(MSB), .seven_segment(seven_segment_MSB));
 digit_display lsb(.number(LSB), .seven_segment(seven_segment_LSB));

endmodule 