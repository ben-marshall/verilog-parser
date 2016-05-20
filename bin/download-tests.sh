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

downloadTutorialTest mux.v
downloadTutorialTest bitwise_operators.v
downloadTutorialTest logical_operators.v
downloadTutorialTest first_counter_tb.v
downloadTutorialTest conditional_operator.v
downloadTutorialTest addbit.v
downloadTutorialTest param_more_then_one1.v
downloadTutorialTest initial_fork_join.v
downloadTutorialTest n_out_primitive.v
downloadTutorialTest udp_body_tb.v
downloadTutorialTest dff_async_reset_async_preset.v
downloadTutorialTest concatenation_operator.v
downloadTutorialTest decoder.v
downloadTutorialTest dff_sync_reset_sync_preset.v
downloadTutorialTest parallel.v
downloadTutorialTest avoid_latch_else.v
downloadTutorialTest test_trireg.v
downloadTutorialTest test_wor.v
downloadTutorialTest hello_world.v
downloadTutorialTest test_tri.v
downloadTutorialTest syn_fifo_psl.v
downloadTutorialTest syn_fifo_assert.v
downloadTutorialTest first_counter.v
downloadTutorialTest param_more_then_one.v
downloadTutorialTest counterTestGen.v
downloadTutorialTest which_clock.v
downloadTutorialTest decoder_always.v
downloadTutorialTest quest_for_out.v
downloadTutorialTest fsm_full_tb.v
downloadTutorialTest multi_array.v
downloadTutorialTest casex_example.v
downloadTutorialTest mux_from_gates.v
downloadTutorialTest counterMonitor.v
downloadTutorialTest hello_pli.v
downloadTutorialTest flip_flop.v
downloadTutorialTest quest_for_in.v
downloadTutorialTest fifo_tb.v
downloadTutorialTest comma_example.v
downloadTutorialTest named_block_disable.v
downloadTutorialTest defparam_example.v
downloadTutorialTest param_overide_instance_example.v
downloadTutorialTest arbiter.v
downloadTutorialTest adder_hier.v
downloadTutorialTest implicit.v
downloadTutorialTest ansiport_example.v
downloadModelTest lfsr_updown.v
downloadModelTest concatenation.v
downloadModelTest primitives.v
downloadModelTest d_latch_gates.v
downloadModelTest port_declaration.v
downloadModelTest aFifo.v
downloadModelTest CMakeLists.txt
downloadModelTest delay_example.v
downloadModelTest parity_using_assign.v
downloadModelTest n_in_primitive.v
downloadModelTest encoder_4to2_gates.v
downloadModelTest decoder_using_case.v
downloadModelTest mux_using_if.v
downloadModelTest decoder_2to4_gates.v
downloadModelTest mux_using_case.v
downloadModelTest decoder_using_assign.v
downloadModelTest arbiter_tb.v
downloadModelTest full_adder_gates.v
downloadModelTest lfsr_updown_tb.v
downloadModelTest pri_encoder_using_assign.v
downloadModelTest ram_dp_sr_sw.v
downloadModelTest lfsr.v
downloadModelTest pri_encoder_using_if.v
downloadModelTest syn_fifo.v
downloadModelTest serial_crc.v
downloadModelTest ram_dp_ar_aw.v
downloadModelTest encoder_using_case.v
downloadModelTest mux_using_assign.v
downloadModelTest ram_sp_ar_aw.v
downloadModelTest clk_div_45.v
downloadModelTest dlatch_reset.v
downloadModelTest uart.v
downloadModelTest rom.v
