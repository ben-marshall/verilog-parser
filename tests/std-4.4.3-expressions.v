module test;
reg [3:0] a;
reg [5:0] b;
reg [15:0] c;
initial begin
a = 4'hF;
b = 6'ha;
$display("a*b=%x",
a*b);
c = {a**b};
$display("a**b=%x", c);
c = a**b;
$display("c=%x", c);
end
endmodule
