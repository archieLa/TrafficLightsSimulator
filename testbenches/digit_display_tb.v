/* By Artur Lach
Test bench for digit display module
*/


module digit_display_tb();

reg [3:0] number;
wire [7:0] output_to_display;

digit_display DUT(.number(number), .seven_segment(output_to_display));

initial begin
  number = 4'd0;
  #10
  number = 4'd1;
  #10
  number = 4'd2;
  #10
  number = 4'd3;
  #10
  number = 4'd4;
  #10
  number = 4'd5;
  #10
  number = 4'd6;
  #10
  number = 4'd7;
  #10
  number = 4'd8;
  #10
  number = 4'd9;
  #10
  number = 4'd10;
  $stop;
end
endmodule