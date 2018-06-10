/* By Artur Lach
Module that displays a number using seven segment display
*/

module digit_display(number, seven_segment);

input [3:0] number;
output reg [7:0] seven_segment;

parameter ZERO = 8'b11000000, ONE = 8'b11111001, TWO = 8'b10100100 , THREE = 8'b10110000, FOUR = 8'b10011001,
FIVE = 8'b10010010, SIX = 8'b10000010, SEVEN = 8'b11111000, EIGHT = 8'b10000000, 
NINE = 8'b10010000;

always @(*) begin
  case (number)
  4'd0: begin
  seven_segment = ZERO;
  end
  4'd1: begin
  seven_segment = ONE;
  end
  4'd2: begin
  seven_segment = TWO;
  end
  4'd3: begin
  seven_segment = THREE;
  end
  4'd4: begin
  seven_segment = FOUR;
  end
  4'd5: begin
  seven_segment = FIVE;
  end
  4'd6: begin
  seven_segment = SIX;
  end
  4'd7: begin
  seven_segment = SEVEN;
  end
  4'd8: begin
  seven_segment = EIGHT;
  end
  4'd9: begin
  seven_segment = NINE;
  end
  default: begin
  seven_segment = ZERO;
  end
  endcase
end

endmodule
