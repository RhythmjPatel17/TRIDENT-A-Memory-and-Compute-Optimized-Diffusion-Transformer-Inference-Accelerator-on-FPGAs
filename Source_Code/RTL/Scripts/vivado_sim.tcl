create_project -force trident_sim ./vivado_sim_proj -part xczu7ev-ffvc1156-2-e

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
add_files -norecurse -fileset sim_1 {
  tb/sim_mem.sv
  tb/tb_trident_top.sv
}
add_files -fileset sim_1 tb/compressed_weights.hex

set_property file_type SystemVerilog [get_files rtl/*.sv]
set_property file_type SystemVerilog [get_files tb/*.sv]
set_property include_dirs {rtl} [current_fileset]
set_property top tb_trident_top [get_filesets sim_1]

launch_simulation
run all

puts "Simulation complete."
