#!/bin/bash

MODEL_PREFIX=http://www.asic-world.com/code/hdl_models
TUTORIAL_PREFIX=http://www.asic-world.com/code/verilog_tutorial

WGET_OPTS=" -c -q "

function downloadTutorialTest {
    if [ ! -e $1 ]
    then
        echo -n "Fetching $TUTORIAL_PREFIX/$1 "
        wget $WGET_OPTS $TUTORIAL_PREFIX/$1
        echo "[DONE]"
    fi
}

function downloadModelTest {
    if [ ! -e $1 ] 
    then
        echo -n "Fetching $MODEL_PREFIX/$1 "
        wget $WGET_OPTS $MODEL_PREFIX/$1
        echo "[DONE]"
    fi
}

echo "Unzipping SPARC test set..."
unzip -o ../bin/sparct1.zip -d ./

echo "Downloading Tests..."

downloadModelTest arbiter_tb.v
downloadModelTest clk_div_45.v
downloadModelTest concatenation.v
downloadModelTest d_latch_gates.v
downloadModelTest d_latch_switch.v
downloadModelTest decoder_2to4_gates.v
downloadModelTest decoder_using_assign.v
downloadModelTest decoder_using_case.v
downloadModelTest delay_example.v
downloadModelTest dff_udp.v
downloadModelTest dlatch_reset.v
downloadModelTest encoder_4to2_gates.v
downloadModelTest encoder_using_case.v
downloadModelTest full_adder_gates.v
downloadModelTest jkff_udp.v
downloadModelTest latch_udp.v
downloadModelTest lfsr.v
downloadModelTest lfsr_updown.v
downloadModelTest lfsr_updown_tb.v
downloadModelTest misc1.v
downloadModelTest mux21_switch.v
downloadModelTest mux_21_udp.v
downloadModelTest mux_using_assign.v
downloadModelTest mux_using_case.v
downloadModelTest mux_using_if.v
downloadModelTest n_in_primitive.v
downloadModelTest nand_switch.v
downloadModelTest not_switch.v
downloadModelTest parity_using_assign.v
downloadModelTest port_declaration.v
downloadModelTest pri_encoder_using_assign.v
downloadModelTest pri_encoder_using_if.v
downloadModelTest primitives.v
downloadModelTest ram_dp_ar_aw.v
downloadModelTest ram_dp_sr_sw.v
downloadModelTest ram_sp_ar_aw.v
downloadModelTest rom.v
downloadModelTest serial_crc.v
downloadModelTest srff_udp.v
downloadModelTest syn_fifo.v
downloadModelTest t_gate_switch.v
downloadModelTest uart.v
downloadModelTest xor2_input.v
downloadModelTest xor_switch.v
downloadTutorialTest addbit.v
downloadTutorialTest adder_hier.v
downloadTutorialTest and_from_nand.v
downloadTutorialTest ansiport_example.v
downloadTutorialTest arbiter.v
downloadTutorialTest avoid_latch_else.v
downloadTutorialTest bitwise_operators.v
downloadTutorialTest buf_gate.v
downloadTutorialTest buf_gate1.v
downloadTutorialTest bus_wr_rd_task.v
downloadTutorialTest casex_example.v
downloadTutorialTest comma_example.v
downloadTutorialTest concatenation_operator.v
downloadTutorialTest conditional_operator.v
downloadTutorialTest counterMonitor.v
downloadTutorialTest counterTestGen.v
downloadTutorialTest decoder.v
downloadTutorialTest decoder_always.v
downloadTutorialTest defparam_example.v
downloadTutorialTest delay.v
downloadTutorialTest delay_example.v
downloadTutorialTest dff_async_reset_async_preset.v
downloadTutorialTest dff_from_nand.v
downloadTutorialTest dff_sync_reset_sync_preset.v
downloadTutorialTest fifo_tb.v
downloadTutorialTest first_counter.v
downloadTutorialTest first_counter_tb.v
downloadTutorialTest flip_flop.v
downloadTutorialTest fsm_full_tb.v
downloadTutorialTest gates.v
downloadTutorialTest hello_pli.v
downloadTutorialTest hello_world.v
downloadTutorialTest implicit.v
downloadTutorialTest initial_fork_join.v
downloadTutorialTest logical_operators.v
downloadTutorialTest multi_array.v
downloadTutorialTest mux.v
downloadTutorialTest mux_from_gates.v
downloadTutorialTest mux_from_gates.v
downloadTutorialTest n_in_primitive
downloadTutorialTest n_out_primitive.v
downloadTutorialTest named_block_disable.v
downloadTutorialTest parallel.v
downloadTutorialTest param_more_then_one.v
downloadTutorialTest param_more_then_one1.v
downloadTutorialTest param_overide_instance_example.v
downloadTutorialTest quest_for_in.v
downloadTutorialTest quest_for_out.v
downloadTutorialTest switch_primitives.v
downloadTutorialTest syn_fifo_psl.v
downloadTutorialTest task_calling.v
downloadTutorialTest task_global.v
downloadTutorialTest test_tri.v
downloadTutorialTest test_trireg.v
downloadTutorialTest test_wor.v
downloadTutorialTest transmission_gates.v
downloadTutorialTest udp_body_tb.v
downloadTutorialTest which_clock.v
