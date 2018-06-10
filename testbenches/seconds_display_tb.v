/* By Artur Lach
Seconds display test bench
*/

module seconds_display_tb();

reg [31:0] clock_ticks;
wire [7:0] seven_segment_MSB, seven_segment_LSB;

seconds_display DUT(.clock_ticks(clock_ticks), .seven_segment_MSB(seven_segment_MSB),
 .seven_segment_LSB(seven_segment_LSB));

// When testing the number displayed will be bigger by one since when used in real circuit this module
// Displays time remaining without ever displaying a zero
initial begin
  // 35 seconds
  clock_ticks = 32'd1750000000;
  #1
  // 20 seconds
  clock_ticks = 32'd1000000000;
  #1
  // 10 seconds
  clock_ticks = 32'd500000000;
  #1
  // 5 seconds
  clock_ticks = 32'd250000000;
  #1
  // 1 second
  clock_ticks = 32'd50000000;
  $stop;
end

endmodule