
module primitives_2_test();

wire a,b;
wire y;
wire i1,i2,ctrl,o;

and (strong1, weak0) b(o, i1, i2);
trireg (medium) t;
buf (strong1, weak0) g1 (y, a);
buf (pull1, supply0) g2 (y, b);
buf (strong1, weak0) g1 (y, a);
buf (strong1, weak0) g1 (y, b);
buf (strong1, weak0) g1 (y, a);
buf (weak1, strong0) g1 (y, b);
bufif0 (strong1, weak0) g1 (y, i1, ctrl);
bufif0 (strong1, weak0) g2 (y, i2, ctrl);

endmodule
