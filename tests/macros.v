
`define HEADER_GUARD 0

`define BUS_RANGE 31:0

`undef HEADER_GUARD

module bus_snooper(
    input [31:0]        safe_buslines,
    input [`BUS_RANGE]  bus_lines_1,
    input [`BUS_RANGE]  bus_lines_2
);

`undef BUS_WIDTH

`undef BUS_RANGE

endmodule
