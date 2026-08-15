require './vivado_util.rb'

def main()
  dir="prj"
  name="top_kr260"
  
  vivado = Vivado.new(dir: dir, name: name, top: "top_kr260")
  #vivado.add_parameters({"general.maxThreads" => 1})
  
  vivado.set_target("xck26-sfvc784-2LV-c")
  vivado.set_board("xilinx.com:kr260_som:part0:1.1")

  vivado.add_sources(["./sources/ctrl_upl_parser.sv",
                      "./sources/mff_sender.sv",
                      "./sources/mff_sender_etherout.sv",
                      "./sources/dummy_sender_frame_fifo.sv",
                      "./sources/dummy_sender_storage.sv",
                      "./sources/mff_sender_wrapper.sv",
                      "./sources/resetgen.v",
                      "./sources/config_memory_wrapper.v",
                      "./sources/top_kr260_mff_sender.vhd",
                     ])
  vivado.add_sources(["./lib/e7udpip10G_independent_clk_with_user_ether_tx.edn"])

  vivado.add_constraints(["./sources/top_kr260.xdc"])
  vivado.add_testbenchs([])
  vivado.add_ipcores(["./ipcores/clk_wiz_0.xci",
                      "./ipcores/config_memory.xci",
                      "./ipcores/ila_config_memory.xci",
                      "./ipcores/ila_ctrl_upl_parser.xci",
                      "./ipcores/ila_mff_sender.xci",
                      "./ipcores/ila_mff_sender_etherout.xci",
                      "./ipcores/ila_mff_sender_wrapper.xci",
                      "./ipcores/xxv_ethernet_0.xci",
                      "./ipcores/vio_0.xci",
                      "./ipcores/ila_ether_snoop.xci",
                      ])
  
  vivado.add_bd("./scripts/design_1.tcl", "design_1")
  #vivado.add_verilog_define({"BOARD_ID" => board_id})
  
  vivado.set_write_hw_platform("./top_kr260.xsa")

  vivado.generate_tcl("create_prj.tcl")
  #vivado.run()
  
  #config = Vivado.new(dir=dir, name=name, top="top", kind=Vivado.CONFIG)
  #config.set_chip("xc7a35t_0")
  #config.generate_tcl("config_board_#{key}.tcl")
  #config.run()
end

main()
