
module foo (
input clk,
input reset,
input head,
input tail,
input valid
);

parameter STATE_IDLE = 2'b00,
STATE_HEAD = 2'b01,
STATE_DATA = 2'b10,
STATE_TAIL = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clock)
state <= reset ? STATE_IDLE : next_state;

(* covered_fsm, channel, is="state", os="next_state",
trans="STATE_IDLE->STATE_IDLE",
trans="STATE_IDLE->STATE_HEAD",
trans="STATE_HEAD->STATE_DATA",
trans="STATE_HEAD->STATE_TAIL",
trans="STATE_DATA->STATE_DATA",
trans="STATE_DATA->STATE_TAIL",
trans="STATE_TAIL->STATE_HEAD",
trans="STATE_TAIL->STATE_IDLE" *)
always @(reset or state or head or valid or tail)
begin
case( state )
STATE_IDLE: next_state = (valid & head) ?
STATE_HEAD : STATE_IDLE;
STATE_HEAD: next_state = (valid & tail) ?
STATE_TAIL : STATE_DATA;
STATE_DATA: next_state = (valid & tail) ?
STATE_TAIL : STATE_DATA;
STATE_TAIL: next_state = (valid & head) ?
STATE_HEAD : STATE_IDLE;
endcase
end   

endmodule 

