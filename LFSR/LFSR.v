module LFSR (

input wire [3:0] 	seed,
input wire			RST,CLK,
output reg			valid,OUT	) ;


reg [3:0]	R;
reg [3:0]	count;
wire 		valid_comb ;
reg [2:0]	Shift_count;
wire 		Rcomb,high_flag;


//block to initialize the shift register
//and make LFSR for 8 cycles
always @ (posedge CLK or negedge RST) //reset is active low
begin
 if (!RST)
  begin
   R <= seed ;
   valid <= 1'b0;
  end
  
 else if (!high_flag)
  begin
   valid <= 1'b0 ;
   R[3] <= Rcomb ;
   R[2] <= R[3] ;
   R[1] <= R[2] ;
   R[0] <= R[1] ;
  end
 else if (!valid_comb & high_flag)
  begin
   valid <= 1'b1 ;
   R <= R >> 1 ;
  end
 else
  begin
   R <= R ;
   valid <= 1'b0 ;
  end
end

//assign to do the feedback combinantiol xor 
assign Rcomb = (R[2] ^ (R[1] ^ R[0])) ;

//counter if rst is high and stop after 8 clk cycles
always @(posedge CLK or negedge RST)
begin

if (!RST)
 begin
  count <= 4'b0000 ;
 end
 
else if (!high_flag)
 begin
  count <= count + 1 ;
 end
 
end

//assign to set flag high after 8 clk cycles
assign high_flag = (count == 4'b1000) ? 1'b1 :1'b0 ;


//counter if rst is high and stop after 4 clk cycles
always @(posedge CLK or negedge RST)
begin

if (!RST)
 begin
  Shift_count <= 3'b000 ;
 end
 
else if (!valid_comb & high_flag)
 begin
  Shift_count <= Shift_count + 1 ;
 end
 
end

//assign to set flag high after 4 clk cycles
assign valid_comb = (Shift_count == 3'b100) ? 1'b1 :1'b0 ;



always @(posedge CLK)
OUT <= R [0] ;


endmodule

/*
1001
1100
1110
0111
1011
0101
0010
1001
1100 */




/* assign Shift_valid = (Shift_count == 3'b11) ? 1'b0 : 1'b1 ;
assign valid_comb = (Shift_count == 3'b11) ? 1'b0 : 1'b1 ;
 */
 
 /* //assign to set valid to zero when the regs content zeroes
//i.e. when the reg shifted out all his content and OUT only zeroes
assign valid_comb = (R == 4'b0000) ? 1'b0 : 1'b1 ; */

