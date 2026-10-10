set part xczu7ev-ffvc1156-2-e

create_project -force trident_synth ./vivado_synth_proj -part $part

add_files -norecurse {
  rtl/trident_pkg.sv
  rtl/bram_sdp.sv
  rtl/bram_wide.sv
  rtl/fifo_sync.sv
  rtl/bitslice_decoder.sv
  rtl/int8_reconstruction.sv
  rtl/weight_cache.sv
  rtl/compressed_weight_store.sv
  rtl/exp_lut.sv
  rtl/divider16.sv
  rtl/axi4_mem_if.sv
  rtl/mac_pe.sv
  rtl/token_buffer.sv
  rtl/linear_engine.sv
  rtl/patch_embed.sv
  rtl/spatial_attention_tile.sv
  rtl/temporal_sparse_tile.sv
  rtl/gelu_approx.sv
  rtl/layernorm.sv
  rtl/ln_affine_store.sv
  rtl/topk_cache.sv
  rtl/residual_add.sv
  rtl/elementwise_gelu.sv
  rtl/global_scheduler.sv
  rtl/trident_top.sv
}

set_property file_type SystemVerilog [get_files rtl/*.sv]
set_property include_dirs {rtl} [current_fileset]
set_property top trident_top [current_fileset]

synth_design -top trident_top -mode out_of_context

report_utilization -file synth_utilization.rpt
report_timing_summary -file synth_timing.rpt

write_checkpoint -force trident_top_synth.dcp

puts "Synthesis complete. See synth_utilization.rpt / synth_timing.rpt"
