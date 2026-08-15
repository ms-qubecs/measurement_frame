library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_kr260 is
  port(
    gt_rxp_in : in std_logic;
    gt_rxn_in : in std_logic;
    gt_txp_out : out std_logic;
    gt_txn_out : out std_logic;

    SFP0_TX_DISABLE_B : out std_logic;
 
    gt_refclk_p : in std_logic;
    gt_refclk_n : in std_logic;

    SYSCLK : in std_logic;

    USER_LED : out std_logic_vector(1 downto 0);
    pmod_a : out std_logic_vector(7 downto 0)
    );
end entity top_kr260;

architecture RTL of top_kr260 is

  attribute keep : string;
  
  component clk_wiz_0
    port (
      clk_out1 : out std_logic;
      clk_out2 : out std_logic;
      clk_out3 : out std_logic;
      reset    : in  std_logic;
      locked   : out std_logic;
      clk_in1  : in  std_logic
      );
  end component clk_wiz_0;

  component resetgen
    generic (
      RESET_NUM : integer := 3700*1000
      );
    port (
      clk : in std_logic;
      reset_n : in std_logic;
      reset_out : out std_logic
      );
  end component resetgen;

  COMPONENT xxv_ethernet_0
    PORT (
      gt_txp_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gt_txn_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gt_rxp_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gt_rxn_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      rx_core_clk_0 : IN STD_LOGIC;
      txoutclksel_in_0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      rxoutclksel_in_0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      gtwiz_reset_tx_datapath_0 : IN STD_LOGIC;
      gtwiz_reset_rx_datapath_0 : IN STD_LOGIC;
      rxrecclkout_0 : OUT STD_LOGIC;
      sys_reset : IN STD_LOGIC;
      dclk : IN STD_LOGIC;
      tx_mii_clk_0 : OUT STD_LOGIC;
      rx_clk_out_0 : OUT STD_LOGIC;
      gt_refclk_p : IN STD_LOGIC;
      gt_refclk_n : IN STD_LOGIC;
      gt_refclk_out : OUT STD_LOGIC;
      gtpowergood_out_0 : OUT STD_LOGIC;
      rx_reset_0 : IN STD_LOGIC;
      user_rx_reset_0 : OUT STD_LOGIC;
      rx_mii_d_0 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      rx_mii_c_0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      ctl_rx_test_pattern_0 : IN STD_LOGIC;
      ctl_rx_data_pattern_select_0 : IN STD_LOGIC;
      ctl_rx_test_pattern_enable_0 : IN STD_LOGIC;
      ctl_rx_prbs31_test_pattern_enable_0 : IN STD_LOGIC;
      stat_rx_framing_err_0 : OUT STD_LOGIC;
      stat_rx_framing_err_valid_0 : OUT STD_LOGIC;
      stat_rx_local_fault_0 : OUT STD_LOGIC;
      stat_rx_block_lock_0 : OUT STD_LOGIC;
      stat_rx_valid_ctrl_code_0 : OUT STD_LOGIC;
      stat_rx_status_0 : OUT STD_LOGIC;
      stat_rx_hi_ber_0 : OUT STD_LOGIC;
      stat_rx_bad_code_0 : OUT STD_LOGIC;
      stat_rx_bad_code_valid_0 : OUT STD_LOGIC;
      stat_rx_error_0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      stat_rx_error_valid_0 : OUT STD_LOGIC;
      stat_rx_fifo_error_0 : OUT STD_LOGIC;
      tx_reset_0 : IN STD_LOGIC;
      user_tx_reset_0 : OUT STD_LOGIC;
      tx_mii_d_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      tx_mii_c_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      stat_tx_local_fault_0 : OUT STD_LOGIC;
      ctl_tx_test_pattern_0 : IN STD_LOGIC;
      ctl_tx_test_pattern_enable_0 : IN STD_LOGIC;
      ctl_tx_test_pattern_select_0 : IN STD_LOGIC;
      ctl_tx_data_pattern_select_0 : IN STD_LOGIC;
      ctl_tx_test_pattern_seed_a_0 : IN STD_LOGIC_VECTOR(57 DOWNTO 0);
      ctl_tx_test_pattern_seed_b_0 : IN STD_LOGIC_VECTOR(57 DOWNTO 0);
      ctl_tx_prbs31_test_pattern_enable_0 : IN STD_LOGIC;
      gt_loopback_in_0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      ctl_rx_wdt_disable_0 : in STD_LOGIC;
      qpllreset_in_0 : IN STD_LOGIC
      );
  end component xxv_ethernet_0;
  
  component e7udpip10G_independent_clk_with_user_ether_tx
    port (
      -- Xilinx 10G PCS/PMAモジュールと、XGMIIインターフェースで接続する
      xgmii_rx_clk : in  std_logic;     -- 15625MHz
      xgmii_tx_clk : in  std_logic;     -- 15625MHz
      xgmii_txd    : out std_logic_vector(63 downto 0);
      xgmii_txc    : out std_logic_vector(7 downto 0);
      xgmii_rxd    : in  std_logic_vector(63 downto 0);
      xgmii_rxc    : in  std_logic_vector(7 downto 0);
      linkup       : in  std_logic;     -- 非同期

      -- Asynchronous Reset
      Reset_n : in std_logic;

      -- UPL interface
      pUPLGlobalClk     : in  std_logic;
      -- UDP tx input
      pUdp0Send_Data    : in  std_logic_vector(127 downto 0);
      pUdp0Send_Request : in  std_logic;
      pUdp0Send_Ack     : out std_logic;
      pUdp0Send_Enable  : in  std_logic;

      pUdp1Send_Data    : in  std_logic_vector(127 downto 0);
      pUdp1Send_Request : in  std_logic;
      pUdp1Send_Ack     : out std_logic;
      pUdp1Send_Enable  : in  std_logic;

      -- Ether tx input
      pEther_Send_Data       : in  std_logic_vector( 127 downto 0 );
      pEther_Send_Request    : in  std_logic;
      pEther_Send_Ack        : out std_logic;
      pEther_Send_Enable     : in  std_logic;

      -- UDP rx output
      pUdp0Receive_Data    : out std_logic_vector(127 downto 0);
      pUdp0Receive_Request : out std_logic;
      pUdp0Receive_Ack     : in  std_logic;
      pUdp0Receive_Enable  : out std_logic;

      pUdp1Receive_Data    : out std_logic_vector(127 downto 0);
      pUdp1Receive_Request : out std_logic;
      pUdp1Receive_Ack     : in  std_logic;
      pUdp1Receive_Enable  : out std_logic;

      -- Ethernet snoop (without Ack)
      pEther_Snoop_Data    : out std_logic_vector(127 downto 0);
      pEther_Snoop_Request : out std_logic;
      pEther_Snoop_Enable  : out std_logic;

      -- Setup
      pMyIpAddr       : in std_logic_vector(31 downto 0);
      pMyMacAddr      : in std_logic_vector(47 downto 0);
      pMyNetmask      : in std_logic_vector(31 downto 0);
      pDefaultGateway : in std_logic_vector(31 downto 0);
      pTargetIPAddr   : in std_logic_vector(31 downto 0);
      pMyUdpPort0     : in std_logic_vector(15 downto 0);
      pMyUdpPort1     : in std_logic_vector(15 downto 0);

      -- Status
      pStatus_clk                     : in  std_logic;    
      pStatus_RxByteCount             : out std_logic_vector( 63 downto 0 );
      pStatus_RxPacketCount           : out std_logic_vector( 31 downto 0 );
      pStatus_RxErrorPacketCount      : out std_logic_vector( 15 downto 0 );
      pStatus_RxDropPacketCount       : out std_logic_vector( 31 downto 0 );
      pStatus_RxARPRequestPacketCount : out std_logic_vector( 15 downto 0 );
      pStatus_RxARPReplyPacketCount   : out std_logic_vector( 15 downto 0 );
      pStatus_RxICMPPacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDP0PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDP1PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxIPErrorPacketCount    : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDPErrorPacketCount   : out std_logic_vector( 15 downto 0 );

      pStatus_TxByteCount             : out std_logic_vector(63 downto 0);
      pStatus_TxPacketCount           : out std_logic_vector(31 downto 0);
      pStatus_TxARPRequestPacketCount : out std_logic_vector(15 downto 0);
      pStatus_TxARPReplyPacketCount   : out std_logic_vector(15 downto 0);
      pStatus_TxICMPReplyPacketCount  : out std_logic_vector(15 downto 0);
      pStatus_TxUDP0PacketCount       : out std_logic_vector(15 downto 0);
      pStatus_TxUDP1PacketCount       : out std_logic_vector(15 downto 0);
      pStatus_TxMulticastPacketCount  : out std_logic_vector(15 downto 0);

      pdebug : out std_logic_vector(63 downto 0)
      );
  end component e7udpip10G_independent_clk_with_user_ether_tx;

  signal restart_tx_rx_0       : std_logic;
  signal send_continous_pkts_0 : std_logic;  -- This port can be used to send continous packets 
  signal rx_gt_locked_led_0    : std_logic;  -- Indicates GT LOCK
  signal rx_block_lock_led_0   : std_logic;  -- Indicates Core Block Lock
  signal restart_tx_rx_1       : std_logic;
  signal send_continous_pkts_1 : std_logic;  -- This port can be used to send continous packets 
  signal rx_gt_locked_led_1    : std_logic;  -- Indicates GT LOCK
  signal rx_block_lock_led_1   : std_logic;  -- Indicates Core Block Lock
  signal restart_tx_rx_2       : std_logic;
  signal send_continous_pkts_2 : std_logic;  -- This port can be used to send continous packets 
  signal rx_gt_locked_led_2    : std_logic;  -- Indicates GT LOCK
  signal rx_block_lock_led_2   : std_logic;  -- Indicates Core Block Lock
  signal restart_tx_rx_3       : std_logic;
  signal send_continous_pkts_3 : std_logic;  -- This port can be used to send continous packets 
  signal rx_gt_locked_led_3    : std_logic;  -- Indicates GT LOCK
  signal rx_block_lock_led_3   : std_logic;  -- Indicates Core Block Lock
  signal completion_status     : std_logic_vector(4 downto 0);
  signal qpllreset_in_0        : std_logic;

  component config_memory_wrapper
    port (
      clk : in std_logic;
      reset : in std_logic;
			     
      MYIPADDR0_o : out std_logic_vector(31 downto 0);
      MYNETMASK0_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY0_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR0_o : out std_logic_vector(31 downto 0);
      MYMACADDR0_o : out std_logic_vector(47 downto 0);
      
      MYIPADDR1_o : out std_logic_vector(31 downto 0);
      MYNETMASK1_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY1_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR1_o : out std_logic_vector(31 downto 0);
      MYMACADDR1_o : out std_logic_vector(47 downto 0);

      MYIPADDR2_o : out std_logic_vector(31 downto 0);
      MYNETMASK2_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY2_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR2_o : out std_logic_vector(31 downto 0);
      MYMACADDR2_o : out std_logic_vector(47 downto 0);

      MYIPADDR3_o : out std_logic_vector(31 downto 0);
      MYNETMASK3_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY3_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR3_o : out std_logic_vector(31 downto 0);
      MYMACADDR3_o : out std_logic_vector(47 downto 0);
      
      MYIPADDR4_o : out std_logic_vector(31 downto 0);
      MYNETMASK4_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY4_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR4_o : out std_logic_vector(31 downto 0);
      MYMACADDR4_o : out std_logic_vector(47 downto 0);

      MYIPADDR5_o : out std_logic_vector(31 downto 0);
      MYNETMASK5_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY5_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR5_o : out std_logic_vector(31 downto 0);
      MYMACADDR5_o : out std_logic_vector(47 downto 0);

      MYIPADDR6_o : out std_logic_vector(31 downto 0);
      MYNETMASK6_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY6_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR6_o : out std_logic_vector(31 downto 0);
      MYMACADDR6_o : out std_logic_vector(47 downto 0);
      
      MYIPADDR7_o : out std_logic_vector(31 downto 0);
      MYNETMASK7_o : out std_logic_vector(31 downto 0);
      MYDEFAULTGATEWAY7_o : out std_logic_vector(31 downto 0);
      MYTARGETIPADDR7_o : out std_logic_vector(31 downto 0);
      MYMACADDR7_o : out std_logic_vector(47 downto 0)
      );
  end component config_memory_wrapper;

  signal MyIpAddr       : std_logic_vector(31 downto 0);
  signal MyMacAddr      : std_logic_vector(47 downto 0);
  signal MyNetMask      : std_logic_vector(31 downto 0);
  signal DefaultGateway : std_logic_vector(31 downto 0);
  signal TargetIPAddr   : std_logic_vector(31 downto 0);
  signal MyUdpPort_0    : std_logic_vector(15 downto 0);
  signal MyUdpPort_1    : std_logic_vector(15 downto 0);

  signal network_override_en      : std_logic;
  signal network_override_ipaddr  : std_logic_vector(31 downto 0);
  signal network_override_macaddr : std_logic_vector(47 downto 0);
  signal network_override_netmask : std_logic_vector(31 downto 0);
  signal network_override_gateway : std_logic_vector(31 downto 0);
  signal network_override_target  : std_logic_vector(31 downto 0);

  signal config_memory_ipaddr  : std_logic_vector(31 downto 0);
  signal config_memory_macaddr : std_logic_vector(47 downto 0);
  signal config_memory_netmask : std_logic_vector(31 downto 0);
  signal config_memory_gateway : std_logic_vector(31 downto 0);
  signal config_memory_target  : std_logic_vector(31 downto 0);


  component mff_sender_wrapper
    port (
      clk   : in std_logic;
      reset : in std_logic;

      UPLIn_Request : in  std_logic;
      UPLIn_Enable  : in  std_logic;
      UPLIn_Data    : in  std_logic_vector(127 downto 0);
      UPLIn_Ack     : out std_logic;

      UPLOut_Request : out std_logic;
      UPLOut_Enable  : out std_logic;
      UPLOut_Data    : out std_logic_vector(127 downto 0);
      UPLOut_Ack     : in  std_logic;

      ether_out_data : out std_logic_vector(127 downto 0);
      ether_out_req  : out std_logic;
      ether_out_en   : out std_logic;
      ether_out_ack  : in  std_logic;

      ctrl_upl_all_reset_kick  : out std_logic;
      tick_counter             : in  std_logic_vector(63 downto 0);
      wait_const               : in  std_logic_vector(15 downto 0);
      sender_measure_wait_const : in  std_logic_vector(15 downto 0);
      BASE_SRC_MAC_ADDRESS     : in  std_logic_vector(47 downto 0)
      );
  end component mff_sender_wrapper;

  --component design_1
  --end component design_1;

  component vio_0
    PORT (
      clk : IN STD_LOGIC;
      probe_out0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      probe_out1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_out4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_out5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_out6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_out7 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      probe_in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_in3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      probe_in4 : IN STD_LOGIC_VECTOR(47 DOWNTO 0)
      );
  end component vio_0;

  signal clk250mhz : std_logic;
  signal clk100mhz : std_logic;
  signal clk125mhz : std_logic;
  signal sys_reset     : std_logic := '1';
  signal sys_reset_n   : std_logic := '0';

  attribute keep of sys_reset : signal is "true";

  attribute keep of rx_gt_locked_led_0 : signal is "true";

  signal locked : std_logic;

  signal block_lock_led_0 : std_logic;

  attribute keep of block_lock_led_0 : signal is "true";

  constant gt_loopback_in_0 : std_logic_vector(2 downto 0) := "000";

  signal rx_core_clk_0                       : std_logic;
  signal rx_clk_out_0                        : std_logic;
  signal tx_mii_clk_0                        : std_logic;
  signal rx_reset_0                          : std_logic;
  signal user_rx_reset_0                     : std_logic;
  signal rxrecclkout_0                       : std_logic;
  signal rx_mii_d_0                          : std_logic_vector(63 downto 0);
  signal rx_mii_c_0                          : std_logic_vector(7 downto 0);
  signal ctl_rx_test_pattern_0               : std_logic                     := '0';
  signal ctl_rx_test_pattern_enable_0        : std_logic                     := '0';
  signal ctl_rx_data_pattern_select_0        : std_logic                     := '0';
  signal ctl_rx_prbs31_test_pattern_enable_0 : std_logic                     := '0';
  signal stat_rx_block_lock_0                : std_logic;
  signal stat_rx_framing_err_valid_0         : std_logic;
  signal stat_rx_framing_err_0               : std_logic;
  signal stat_rx_hi_ber_0                    : std_logic;
  signal stat_rx_valid_ctrl_code_0           : std_logic;
  signal stat_rx_bad_code_0                  : std_logic;
  signal stat_rx_bad_code_valid_0            : std_logic;
  signal stat_rx_error_valid_0               : std_logic;
  signal stat_rx_error_0                     : std_logic_vector(7 downto 0);
  signal stat_rx_fifo_error_0                : std_logic;
  signal stat_rx_local_fault_0               : std_logic;
  signal stat_rx_status_0                    : std_logic;
  signal tx_reset_0                          : std_logic;
  signal user_tx_reset_0                     : std_logic;
  signal tx_mii_d_0                          : std_logic_vector(63 downto 0);
  signal tx_mii_c_0                          : std_logic_vector(7 downto 0);
  signal ctl_tx_test_pattern_0               : std_logic                     := '0';
  signal ctl_tx_test_pattern_enable_0        : std_logic                     := '0';
  signal ctl_tx_test_pattern_select_0        : std_logic                     := '0';
  signal ctl_tx_data_pattern_select_0        : std_logic                     := '0';
  signal ctl_tx_test_pattern_seed_a_0        : std_logic_vector(57 downto 0) := std_logic_vector(to_unsigned(0, 58));
  signal ctl_tx_test_pattern_seed_b_0        : std_logic_vector(57 downto 0) := std_logic_vector(to_unsigned(0, 58));
  signal ctl_tx_prbs31_test_pattern_enable_0 : std_logic                     := '0';
  signal stat_tx_local_fault_0               : std_logic;
  signal gtwiz_reset_tx_datapath_0           : std_logic;
  signal gtwiz_reset_rx_datapath_0           : std_logic;
  signal gtpowergood_out_0                   : std_logic;
  signal txoutclksel_in_0                    : std_logic_vector(2 downto 0);
  signal rxoutclksel_in_0                    : std_logic_vector(2 downto 0);

  signal completion_status_0 : std_logic_vector(4 downto 0);
  
  signal gt_refclk_out : std_logic;

  signal pUdp0Send_Data    : std_logic_vector(127 downto 0);
  signal pUdp0Send_Request : std_logic;
  signal pUdp0Send_Ack     : std_logic;
  signal pUdp0Send_Enable  : std_logic;
  signal pUdp1Send_Data    : std_logic_vector(127 downto 0);
  signal pUdp1Send_Request : std_logic;
  signal pUdp1Send_Ack     : std_logic;
  signal pUdp1Send_Enable  : std_logic;
  signal pEther_Send_Data    : std_logic_vector(127 downto 0);
  signal pEther_Send_Request : std_logic;
  signal pEther_Send_Ack     : std_logic;
  signal pEther_Send_Enable  : std_logic;
  
  signal pUdp0Receive_Data    : std_logic_vector(127 downto 0);
  signal pUdp0Receive_Request : std_logic;
  signal pUdp0Receive_Ack     : std_logic;
  signal pUdp0Receive_Enable  : std_logic;
  signal pUdp1Receive_Data    : std_logic_vector(127 downto 0);
  signal pUdp1Receive_Request : std_logic;
  signal pUdp1Receive_Ack     : std_logic;
  signal pUdp1Receive_Enable  : std_logic;

  signal pStatus_RxByteCount             : std_logic_vector(63 downto 0);
  signal pStatus_RxPacketCount           : std_logic_vector(31 downto 0);
  signal pStatus_RxErrorPacketCount      : std_logic_vector(15 downto 0);
  signal pStatus_RxDropPacketCount       : std_logic_vector(31 downto 0);
  signal pStatus_RxARPRequestPacketCount : std_logic_vector(15 downto 0);
  signal pStatus_RxARPReplyPacketCount   : std_logic_vector(15 downto 0);
  signal pStatus_RxICMPPacketCount       : std_logic_vector(15 downto 0);
  signal pStatus_RxUDP0PacketCount       : std_logic_vector(15 downto 0);
  signal pStatus_RxUDP1PacketCount       : std_logic_vector(15 downto 0);
  signal pStatus_RxIPErrorPacketCount    : std_logic_vector(15 downto 0);
  signal pStatus_RxUDPErrorPacketCount   : std_logic_vector(15 downto 0);
  signal pStatus_TxByteCount             : std_logic_vector(63 downto 0);
  signal pStatus_TxPacketCount           : std_logic_vector(31 downto 0);
  signal pStatus_TxARPRequestPacketCount : std_logic_vector(15 downto 0);
  signal pStatus_TxARPReplyPacketCount   : std_logic_vector(15 downto 0);
  signal pStatus_TxICMPReplyPacketCount  : std_logic_vector(15 downto 0);
  signal pStatus_TxUDP0PacketCount       : std_logic_vector(15 downto 0);
  signal pStatus_TxUDP1PacketCount       : std_logic_vector(15 downto 0);
  signal pStatus_TxMulticastPacketCount  : std_logic_vector(15 downto 0);
  
  signal mff_sender_in_req  : std_logic;
  signal mff_sender_in_en   : std_logic;
  signal mff_sender_in_data : std_logic_vector(127 downto 0);
  signal mff_sender_in_ack  : std_logic;

  signal mff_sender_out_req  : std_logic;
  signal mff_sender_out_en   : std_logic;
  signal mff_sender_out_data : std_logic_vector(127 downto 0);
  signal mff_sender_out_ack  : std_logic;
  
  signal mff_sender_ether_out_data : std_logic_vector(127 downto 0);
  signal mff_sender_ether_out_req  : std_logic;
  signal mff_sender_ether_out_en   : std_logic;
  signal mff_sender_ether_out_ack  : std_logic;

  signal mff_sender_all_reset_kick       : std_logic;
  signal mff_sender_wait_const           : std_logic_vector(15 downto 0);
  signal sender_measure_wait_const          : std_logic_vector(15 downto 0);
  signal mff_sender_base_src_mac_address : std_logic_vector(47 downto 0);

  signal heartbeat_counter_250mhz : unsigned(23 downto 0);
  signal heartbeat_counter_100mhz : unsigned(23 downto 0);

  signal pEther_Snoop_Data    : std_logic_vector(127 downto 0);
  signal pEther_Snoop_Request : std_logic;
  signal pEther_Snoop_Enable  : std_logic;

  signal tick_counter : unsigned(63 downto 0) := (others => '0');

  component ila_ether_snoop
    port (
      clk     : in std_logic;
      probe0  : in std_logic_vector(63 downto 0);
      probe1  : in std_logic_vector(129 downto 0)
      );
  end component ila_ether_snoop;

begin

  pmod_a <= X"00";
  SFP0_TX_DISABLE_B <= '1';

  -- design_1_i : design_1;

  rx_core_clk_0 <= rx_clk_out_0;
  rx_reset_0 <= sys_reset;
  tx_reset_0 <= sys_reset;
  gtwiz_reset_tx_datapath_0 <= '0'; 
  gtwiz_reset_rx_datapath_0 <= '0'; 
  txoutclksel_in_0 <= "101"; -- this value should not be changed as per gtwizard 
  rxoutclksel_in_0 <= "101"; -- this value should not be changed as per gtwizard
  rx_block_lock_led_0 <= block_lock_led_0 and stat_rx_status_0;

  qpllreset_in_0 <= '0'; -- Changing qpllreset_in_0 value may impact or disturb other cores in case of multicore
                         -- User should take care of this while changing.
  
  restart_tx_rx_0 <= '0';
  send_continous_pkts_0 <= '0';
  
  clk_wiz_0_i : clk_wiz_0 port map(
    clk_out1 => clk250mhz,
    clk_out2 => clk100mhz,
    clk_out3 => clk125mhz,
    reset    => '0',
    locked   => locked,
    clk_in1  => SYSCLK
    );

  resetgen_i : resetgen port map(
    clk => clk250mhz,
    reset_n => locked,
    reset_out => sys_reset
    );
  sys_reset_n <= not sys_reset;
    
  xxv_ethernet_0_i : xxv_ethernet_0 port map(
    gt_rxp_in(0)  => gt_rxp_in,
    gt_rxn_in(0)  => gt_rxn_in,
    gt_txp_out(0) => gt_txp_out,
    gt_txn_out(0) => gt_txn_out,
    tx_mii_clk_0  => tx_mii_clk_0,
    rx_core_clk_0 => rx_core_clk_0,
    rx_clk_out_0  => rx_clk_out_0,

    gt_loopback_in_0 => gt_loopback_in_0,
    rx_reset_0       => rx_reset_0,
    user_rx_reset_0  => user_rx_reset_0,
    rxrecclkout_0    => rxrecclkout_0,

    -- RX User Interface Signals
    rx_mii_d_0 => rx_mii_d_0,
    rx_mii_c_0 => rx_mii_c_0,

    -- RX Control Signals
    ctl_rx_test_pattern_0               => ctl_rx_test_pattern_0,
    ctl_rx_test_pattern_enable_0        => ctl_rx_test_pattern_enable_0,
    ctl_rx_data_pattern_select_0        => ctl_rx_data_pattern_select_0,
    ctl_rx_prbs31_test_pattern_enable_0 => ctl_rx_prbs31_test_pattern_enable_0,

    -- RX Stats Signals
    stat_rx_block_lock_0        => stat_rx_block_lock_0,
    stat_rx_framing_err_valid_0 => stat_rx_framing_err_valid_0,
    stat_rx_framing_err_0       => stat_rx_framing_err_0,
    stat_rx_hi_ber_0            => stat_rx_hi_ber_0,
    stat_rx_valid_ctrl_code_0   => stat_rx_valid_ctrl_code_0,
    stat_rx_bad_code_0          => stat_rx_bad_code_0,
    stat_rx_bad_code_valid_0    => stat_rx_bad_code_valid_0,
    stat_rx_error_valid_0       => stat_rx_error_valid_0,
    stat_rx_error_0             => stat_rx_error_0,
    stat_rx_fifo_error_0        => stat_rx_fifo_error_0,
    stat_rx_local_fault_0       => stat_rx_local_fault_0,
    stat_rx_status_0            => stat_rx_status_0,

    tx_reset_0      => tx_reset_0,
    user_tx_reset_0 => user_tx_reset_0,
    -- TX User Interface Signals
    tx_mii_d_0      => tx_mii_d_0,
    tx_mii_c_0      => tx_mii_c_0,

    -- TX Control Signals
    ctl_tx_test_pattern_0               => ctl_tx_test_pattern_0,
    ctl_tx_test_pattern_enable_0        => ctl_tx_test_pattern_enable_0,
    ctl_tx_test_pattern_select_0        => ctl_tx_test_pattern_select_0,
    ctl_tx_data_pattern_select_0        => ctl_tx_data_pattern_select_0,
    ctl_tx_test_pattern_seed_a_0        => ctl_tx_test_pattern_seed_a_0,
    ctl_tx_test_pattern_seed_b_0        => ctl_tx_test_pattern_seed_b_0,
    ctl_tx_prbs31_test_pattern_enable_0 => ctl_tx_prbs31_test_pattern_enable_0,

    -- TX Stats Signals
    stat_tx_local_fault_0 => stat_tx_local_fault_0,

    gtwiz_reset_tx_datapath_0 => gtwiz_reset_tx_datapath_0,
    gtwiz_reset_rx_datapath_0 => gtwiz_reset_rx_datapath_0,
    gtpowergood_out_0         => gtpowergood_out_0,
    txoutclksel_in_0          => txoutclksel_in_0,
    rxoutclksel_in_0          => rxoutclksel_in_0,

    qpllreset_in_0 => qpllreset_in_0,
    gt_refclk_p    => gt_refclk_p,
    gt_refclk_n    => gt_refclk_n,
    gt_refclk_out  => gt_refclk_out,
    sys_reset      => sys_reset,
    ctl_rx_wdt_disable_0 => '0',
    dclk           => clk250mhz
    );

  completion_status(0) <= completion_status_0(0);
  completion_status(1) <= completion_status_0(1);
  completion_status(2) <= completion_status_0(2);
  completion_status(3) <= completion_status_0(3);
  completion_status(4) <= completion_status_0(4);

  ----------------------------------------------------------------------
  -- #0
  ----------------------------------------------------------------------
  e7udpip10G_i_0 : e7udpip10G_independent_clk_with_user_ether_tx port map
    (
      -- Xilinx 10G PCS/PMAモジュールと、XGMIIインターフェースで接続する
      xgmii_rx_clk => rx_core_clk_0,
      xgmii_tx_clk => tx_mii_clk_0,
      xgmii_txd    => tx_mii_d_0,
      xgmii_txc    => tx_mii_c_0,
      xgmii_rxd    => rx_mii_d_0,
      xgmii_rxc    => rx_mii_c_0,
      linkup       => '1',

      -- Asynchronous Reset
      Reset_n => sys_reset_n,
      
      -- UPL interface
      pUPLGlobalClk     => clk250mhz,
      -- UDP tx input
      pUdp0Send_Data    => pUdp0Send_Data,
      pUdp0Send_Request => pUdp0Send_Request,
      pUdp0Send_Ack     => pUdp0Send_Ack,
      pUdp0Send_Enable  => pUdp0Send_Enable,

      pUdp1Send_Data    => pUdp1Send_Data,
      pUdp1Send_Request => pUdp1Send_Request,
      pUdp1Send_Ack     => pUdp1Send_Ack,
      pUdp1Send_Enable  => pUdp1Send_Enable,

      pEther_Send_Data    => pEther_Send_Data,
      pEther_Send_Request => pEther_Send_Request,
      pEther_Send_Ack     => pEther_Send_Ack,
      pEther_Send_Enable  => pEther_Send_Enable,

      -- UDP rx output
      pUdp0Receive_Data    => pUdp0Receive_Data,
      pUdp0Receive_Request => pUdp0Receive_Request,
      pUdp0Receive_Ack     => pUdp0Receive_Ack,
      pUdp0Receive_Enable  => pUdp0Receive_Enable,

      pUdp1Receive_Data    => pUdp1Receive_Data,
      pUdp1Receive_Request => pUdp1Receive_Request,
      pUdp1Receive_Ack     => pUdp1Receive_Ack,
      pUdp1Receive_Enable  => pUdp1Receive_Enable,

      -- Ethernet snoop (without Ack)
      pEther_Snoop_Data    => pEther_Snoop_Data,
      pEther_Snoop_Request => pEther_Snoop_Request,
      pEther_Snoop_Enable  => pEther_Snoop_Enable,

      -- Setup
      pMyIpAddr       => MyIpAddr,
      pMyMacAddr      => MyMacAddr,
      pMyNetmask      => MyNetMask,
      pDefaultGateway => DefaultGateway,
      pTargetIPAddr   => TargetIPAddr,
      pMyUdpPort0     => X"4000",
      pMyUdpPort1     => X"4001",

      -- Status
      pStatus_clk                     => clk250mhz,
      pStatus_RxByteCount             => pStatus_RxByteCount,
      pStatus_RxPacketCount           => pStatus_RxPacketCount,
      pStatus_RxErrorPacketCount      => pStatus_RxErrorPacketCount,
      pStatus_RxDropPacketCount       => pStatus_RxDropPacketCount,
      pStatus_RxARPRequestPacketCount => pStatus_RxARPRequestPacketCount,
      pStatus_RxARPReplyPacketCount   => pStatus_RxARPReplyPacketCount,
      pStatus_RxICMPPacketCount       => pStatus_RxICMPPacketCount,
      pStatus_RxUDP0PacketCount       => pStatus_RxUDP0PacketCount,
      pStatus_RxUDP1PacketCount       => pStatus_RxUDP1PacketCount,
      pStatus_RxIPErrorPacketCount    => pStatus_RxIPErrorPacketCount,
      pStatus_RxUDPErrorPacketCount   => pStatus_RxUDPErrorPacketCount,

      pStatus_TxByteCount             => pStatus_TxByteCount,
      pStatus_TxPacketCount           => pStatus_TxPacketCount,
      pStatus_TxARPRequestPacketCount => pStatus_TxARPRequestPacketCount,
      pStatus_TxARPReplyPacketCount   => pStatus_TxARPReplyPacketCount,
      pStatus_TxICMPReplyPacketCount  => pStatus_TxICMPReplyPacketCount,
      pStatus_TxUDP0PacketCount       => pStatus_TxUDP0PacketCount,
      pStatus_TxUDP1PacketCount       => pStatus_TxUDP1PacketCount,
      pStatus_TxMulticastPacketCount  => pStatus_TxMulticastPacketCount,

      pdebug => open
      );

  process(clk250mhz)
  begin
    if rising_edge(clk250mhz) then
      if network_override_en = '1' then
        MyIpAddr       <= network_override_ipaddr;
        MyMacAddr      <= network_override_macaddr;
        MyNetMask      <= network_override_netmask;
        DefaultGateway <= network_override_gateway;
        TargetIPAddr   <= network_override_target;
      else
        MyIpAddr       <= config_memory_ipaddr;
        MyMacAddr      <= config_memory_macaddr;
        MyNetMask      <= config_memory_netmask;
        DefaultGateway <= config_memory_gateway;
        TargetIPAddr   <= config_memory_target;
      end if;
    end if;
  end process;

  config_memory_wrapper_i : config_memory_wrapper port map(
    clk => clk250mhz,
    reset => sys_reset,
    
    MYIPADDR0_o => config_memory_ipaddr,
    MYNETMASK0_o => config_memory_netmask,
    MYDEFAULTGATEWAY0_o => config_memory_gateway,
    MYTARGETIPADDR0_o => config_memory_target,
    MYMACADDR0_o => config_memory_macaddr,
    
    MYIPADDR1_o => open,
    MYNETMASK1_o => open,
    MYDEFAULTGATEWAY1_o => open,
    MYTARGETIPADDR1_o => open,
    MYMACADDR1_o => open,

    MYIPADDR2_o => open,
    MYNETMASK2_o => open,
    MYDEFAULTGATEWAY2_o => open,
    MYTARGETIPADDR2_o => open,
    MYMACADDR2_o => open,

    MYIPADDR3_o => open,
    MYNETMASK3_o => open,
    MYDEFAULTGATEWAY3_o => open,
    MYTARGETIPADDR3_o => open,
    MYMACADDR3_o => open,
    
    MYIPADDR4_o => open,
    MYNETMASK4_o => open,
    MYDEFAULTGATEWAY4_o => open,
    MYTARGETIPADDR4_o => open,
    MYMACADDR4_o => open,

    MYIPADDR5_o => open,
    MYNETMASK5_o => open,
    MYDEFAULTGATEWAY5_o => open,
    MYTARGETIPADDR5_o => open,
    MYMACADDR5_o => open,

    MYIPADDR6_o => open,
    MYNETMASK6_o => open,
    MYDEFAULTGATEWAY6_o => open,
    MYTARGETIPADDR6_o => open,
    MYMACADDR6_o => open,
    
    MYIPADDR7_o => open,
    MYNETMASK7_o => open,
    MYDEFAULTGATEWAY7_o => open,
    MYTARGETIPADDR7_o => open,
    MYMACADDR7_o => open
    );
  
  mff_sender_wrapper_i : mff_sender_wrapper
    port map(
      clk   => clk250mhz,
      reset => sys_reset,

      UPLIn_Request => mff_sender_in_req,
      UPLIn_Enable  => mff_sender_in_en,
      UPLIn_Data    => mff_sender_in_data,
      UPLIn_Ack     => mff_sender_in_ack,

      UPLOut_Request => mff_sender_out_req,
      UPLOut_Enable  => mff_sender_out_en,
      UPLOut_Data    => mff_sender_out_data,
      UPLOut_Ack     => mff_sender_out_ack,

      ether_out_data => mff_sender_ether_out_data,
      ether_out_req  => mff_sender_ether_out_req,
      ether_out_en   => mff_sender_ether_out_en,
      ether_out_ack  => mff_sender_ether_out_ack,

      ctrl_upl_all_reset_kick => mff_sender_all_reset_kick,
      tick_counter            => std_logic_vector(tick_counter),
      wait_const              => mff_sender_wait_const,
      sender_measure_wait_const=> sender_measure_wait_const,
      BASE_SRC_MAC_ADDRESS    => mff_sender_base_src_mac_address
      );

  process(clk250mhz)
  begin
    if rising_edge(clk250mhz) then
      tick_counter <= tick_counter + 1;
    end if;
  end process;
  
  --mff_sender_wait_const <= X"0100";
  --sender_measure_wait_const <= X"00fa";
  mff_sender_base_src_mac_address <= X"FCE498100001"; -- 48'hFC_E4_98_10_00_01

  pUdp0Send_Data       <= mff_sender_out_data;
  pUdp0Send_Request    <= mff_sender_out_req;
  mff_sender_out_ack <= pUdp0Send_Ack;
  pUdp0Send_Enable     <= mff_sender_out_en;
  
  mff_sender_in_data <= pUdp0Receive_Data;
  mff_sender_in_req  <= pUdp0Receive_Request;
  pUdp0Receive_Ack     <= mff_sender_in_ack;
  mff_sender_in_en   <= pUdp0Receive_Enable;

  pEther_Send_Data           <= mff_sender_ether_out_data;
  pEther_Send_Request        <= mff_sender_ether_out_req;
  mff_sender_ether_out_ack <= pEther_Send_Ack;
  pEther_Send_Enable         <= mff_sender_ether_out_en;
  
  pUdp1Send_Data    <= pUdp1Receive_Data;
  pUdp1Send_Request <= pUdp1Receive_Request;
  pUdp1Receive_Ack  <= pUdp1Send_Ack;
  pUdp1Send_Enable  <= pUdp1Receive_Enable;

  process(clk250mhz)
  begin
    if rising_edge(clk250mhz) then
      heartbeat_counter_250mhz <= heartbeat_counter_250mhz + 1;
    end if;
  end process;

  process(clk100mhz)
  begin
    if rising_edge(clk100mhz) then
      heartbeat_counter_100mhz <= heartbeat_counter_100mhz + 1;
    end if;
  end process;

  USER_LED(0) <= std_logic(heartbeat_counter_250mhz(23));
  USER_LED(1) <= std_logic(heartbeat_counter_100mhz(23));

  vio_0_i: vio_0
    port map(
      clk => clk250mhz,
      probe_out0 => mff_sender_wait_const,
      probe_out1 => sender_measure_wait_const,
      probe_out2(0) => network_override_en,
      probe_out3 => network_override_ipaddr,
      probe_out4 => network_override_netmask,
      probe_out5 => network_override_gateway,
      probe_out6 => network_override_target,
      probe_out7 => network_override_macaddr,
      probe_in0 => MyIpAddr,
      probe_in1 => MyNetMask,
      probe_in2 => DefaultGateway,
      probe_in3 => TargetIPAddr,
      probe_in4 => MyMacAddr
      );
  
  ila_ether_snoop_i : ila_ether_snoop port map(
    clk     => clk250mhz,
    probe0 => std_logic_vector(tick_counter),
    probe1(127 downto 0) => pEther_Snoop_Data,
    probe1(128) => pEther_Snoop_Enable,
    probe1(129) => pEther_Snoop_Request
    );

end RTL;
