#!/bin/bash

MODEL_PREFIX=http://www.asic-world.com/code/hdl_models
TUTORIAL_PREFIX=http://www.asic-world.com/code/verilog_tutorial

WGET_OPTS=" -c -q "

function downloadTutorialTest {
    if [ ! -e $1 ]
    then
        echo -n "Fetching $1 "
        wget $WGET_OPTS $TUTORIAL_PREFIX/$1
        echo "[DONE]"
    fi
}

function downloadModelTest {
    if [ ! -e $1 ] 
    then
        echo -n "Fetching $1 "
        wget $WGET_OPTS $MODEL_PREFIX/$1
        echo "[DONE]"
    fi
}
echo "Downloading Tests..."

downloadModelTest aFifo.v
downloadModelTest arbiter_tb.v
downloadModelTest arbiter.v
downloadModelTest clk_div_45.v
downloadModelTest decoder_2to4_gates.v
downloadModelTest decoder_using_assign.v
downloadModelTest decoder_using_case.v
downloadModelTest delay_example.v
downloadModelTest d_latch_gates.v
downloadModelTest dlatch_reset.v
downloadModelTest encoder_4to2_gates.v
downloadModelTest encoder_using_case.v
downloadModelTest full_adder_gates.v
downloadModelTest lfsr_updown_tb.v
downloadModelTest lfsr_updown.v
downloadModelTest lfsr.v
downloadModelTest mux_using_assign.v
downloadModelTest mux_using_case.v
downloadModelTest mux_using_if.v
downloadModelTest n_in_primitive.v
downloadModelTest parity_using_assign.v
downloadModelTest pri_encoder_using_assign.v
downloadModelTest pri_encoder_using_if.v
downloadModelTest ram_dp_ar_aw.v
downloadModelTest ram_dp_sr_sw.v
downloadModelTest ram_sp_ar_aw.v
downloadModelTest rom.v
downloadModelTest serial_crc.v
downloadModelTest syn_fifo.v
downloadModelTest uart.v
