module RAM16GEN (DOUT, DIN, ADR, WE, CE);
specparam dhold = 1.0;
specparam ddly = 1.0;
parameter width = 1;
parameter regsize = dhold + 1.0;
// Illegal - can’t assign
// specparams to parameters

specify
specparam tRise_clk_q = 150, tFall_clk_q = 200;
specparam tRise_control = 40, tFall_control = 50;
endspecify

endmodule
