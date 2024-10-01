--------------------------------------------------------------------------------
--
-- This VHDL file was generated by EASE/HDL 7.4 Revision 4 from HDL Works B.V.
--
-- Ease library  : work
-- HDL library   : work
-- Host name     : S212065
-- User name     : df768
-- Time stamp    : Tue Aug 19 08:05:18 2014
--
-- Designed by   : L.Maarsen
-- Company       : LogiXA
-- Project info  : eSoC
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Object        : Entity work.esoc_port_interface
-- Last modified : Mon Apr 14 12:51:18 2014.
--------------------------------------------------------------------------------



library ieee, std, work;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.package_esoc_configuration.all;

entity esoc_port_interface is
  generic(
    esoc_port_nr : integer := 0);
  port(
    clk_control          : in     std_logic;
    clk_rgmii_125m       : in     STD_LOGIC;
    clk_rgmii_25m        : in     STD_LOGIC;
    clk_rgmii_2m5        : in     STD_LOGIC;
    ctrl_address         : in     std_logic_vector(15 downto 0);
    ctrl_rd              : in     std_logic := '0';
    ctrl_rddata          : out    std_logic_vector(31 downto 0);
    ctrl_wait            : out    std_logic;
    ctrl_wr              : in     std_logic;
    ctrl_wrdata          : in     std_logic_vector(31 downto 0);
    inbound_data         : out    std_logic_vector(31 downto 0);
    inbound_data_full    : in     std_logic;
    inbound_data_write   : out    std_logic;
    inbound_header       : out    std_logic_vector(111 downto 0);
    inbound_header_write : out    std_logic;
    inbound_info         : out    std_logic_vector(31 downto 0);
    inbound_info_write   : out    std_logic;
    mac_mdc              : out    std_logic;
    mac_mdio             : inout  std_logic;
    outbound_data        : in     std_logic_vector(31 downto 0);
    outbound_data_read   : out    std_logic;
    outbound_info        : in     std_logic_vector(15 downto 0);
    outbound_info_empty  : in     std_logic;
    outbound_info_read   : out    std_logic;
    reset                : in     std_logic;
    rgmii_rxc            : in     std_logic;
    rgmii_rxctl          : in     std_logic;
    rgmii_rxd            : in     std_logic_vector(3 downto 0);
    rgmii_txc            : out    std_logic;
    rgmii_txctl          : out    std_logic;
    rgmii_txd            : out    std_logic_vector(3 downto 0));
end entity esoc_port_interface;

--------------------------------------------------------------------------------
-- Object        : Architecture work.esoc_port_interface.structure
-- Last modified : Mon Apr 14 12:51:18 2014.
--------------------------------------------------------------------------------

architecture structure of esoc_port_interface is

  signal ctrl_bus_enable : STD_LOGIC;
  signal clk_rgmii       : STD_LOGIC;
  signal mac_rd          : STD_LOGIC;
  signal mac_address     : STD_LOGIC_VECTOR(7 downto 0);
  signal mdc             : STD_LOGIC;
  signal mdio_out        : STD_LOGIC;
  signal mdio_in         : STD_LOGIC;
  signal mdio_oen        : STD_LOGIC;
  signal mac_wait        : STD_LOGIC;
  signal mac_rddata      : STD_LOGIC_VECTOR(31 downto 0);
  signal mac_wrdata      : STD_LOGIC_VECTOR(31 downto 0);
  signal mac_wr          : STD_LOGIC;
  signal xon_gen         : STD_LOGIC;
  signal xoff_gen        : STD_LOGIC;
  signal magic_wakeup    : STD_LOGIC;
  signal magic_sleep_n   : STD_LOGIC := '1';
  signal set_1000        : STD_LOGIC := '0';
  signal set_10          : STD_LOGIC := '0'; -- '0'
  signal eth_mode        : STD_LOGIC;
  signal ena_10          : STD_LOGIC;
  signal ff_tx_sop       : STD_LOGIC;
  signal ff_tx_eop       : STD_LOGIC;
  signal ff_tx_rdy       : STD_LOGIC;
  signal ff_tx_wren      : STD_LOGIC;
  signal ff_tx_data      : STD_LOGIC_VECTOR(31 downto 0);
  signal ff_tx_mod       : STD_LOGIC_VECTOR(1 downto 0);
  signal ff_tx_err       : STD_LOGIC;
  signal ff_tx_crc_fwd   : STD_LOGIC;
  signal tx_ff_uflow     : STD_LOGIC;
  signal ff_tx_a_full    : STD_LOGIC;
  signal ff_tx_a_empty   : STD_LOGIC;
  signal ff_tx_septy     : STD_LOGIC;
  signal ff_rx_sop       : STD_LOGIC;
  signal ff_rx_eop       : STD_LOGIC;
  signal ff_rx_rdy       : STD_LOGIC;
  signal ff_rx_dval      : STD_LOGIC;
  signal ff_rx_data      : STD_LOGIC_VECTOR(31 downto 0);
  signal ff_rx_mod       : STD_LOGIC_VECTOR(1 downto 0);
  signal rx_frm_type     : STD_LOGIC_VECTOR(3 downto 0);
  signal ff_rx_dsav      : STD_LOGIC;
  signal rx_err_stat     : STD_LOGIC_VECTOR(17 downto 0);
  signal ff_rx_a_full    : STD_LOGIC;
  signal ff_rx_a_empty   : STD_LOGIC;

  component esoc_port_mal
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_control          : in     STD_LOGIC;
      clk_rgmii            : out    std_logic;
      clk_rgmii_125m       : in     std_logic;
      clk_rgmii_25m        : in     std_logic;
      clk_rgmii_2m5        : in     std_logic;
      ctrl_address         : in     std_logic_vector(15 downto 0);
      ctrl_rd              : in     std_logic := '0';
      ctrl_rddata          : out    std_logic_vector(31 downto 0);
      ctrl_wait            : out    std_logic;
      ctrl_wr              : in     std_logic;
      ctrl_wrdata          : in     std_logic_vector(31 downto 0);
      ena_10               : in     STD_LOGIC;
      eth_mode             : in     STD_LOGIC;
      ff_rx_a_empty        : in     STD_LOGIC;
      ff_rx_a_full         : in     STD_LOGIC;
      ff_rx_data           : in     STD_LOGIC_VECTOR(31 downto 0);
      ff_rx_dsav           : in     STD_LOGIC;
      ff_rx_dval           : in     STD_LOGIC;
      ff_rx_eop            : in     STD_LOGIC;
      ff_rx_mod            : in     STD_LOGIC_VECTOR(1 downto 0);
      ff_rx_rdy            : out    STD_LOGIC;
      ff_rx_sop            : in     STD_LOGIC;
      ff_tx_a_empty        : in     STD_LOGIC;
      ff_tx_a_full         : in     STD_LOGIC;
      ff_tx_crc_fwd        : out    STD_LOGIC;
      ff_tx_data           : out    STD_LOGIC_VECTOR(31 downto 0);
      ff_tx_eop            : out    STD_LOGIC;
      ff_tx_err            : out    STD_LOGIC;
      ff_tx_mod            : out    STD_LOGIC_VECTOR(1 downto 0);
      ff_tx_rdy            : in     STD_LOGIC;
      ff_tx_septy          : in     STD_LOGIC;
      ff_tx_sop            : out    STD_LOGIC;
      ff_tx_wren           : out    STD_LOGIC;
      inbound_data         : out    std_logic_vector(31 downto 0);
      inbound_data_full    : in     std_logic;
      inbound_data_write   : out    std_logic;
      inbound_header       : out    std_logic_vector(111 downto 0);
      inbound_header_write : out    std_logic;
      inbound_info         : out    std_logic_vector(31 downto 0);
      inbound_info_write   : out    std_logic;
      magic_sleep_n        : out    STD_LOGIC := '1';
      magic_wakeup         : in     STD_LOGIC;
      outbound_data        : in     std_logic_vector(31 downto 0);
      outbound_data_read   : out    std_logic;
      outbound_info        : in     std_logic_vector(15 downto 0);
      outbound_info_empty  : in     std_logic;
      outbound_info_read   : out    std_logic;
      reset                : in     STD_LOGIC;
      rx_err_stat          : in     STD_LOGIC_VECTOR(17 downto 0);
      rx_frm_type          : in     STD_LOGIC_VECTOR(3 downto 0);
      set_10               : out    STD_LOGIC := '0'; -- '0'
      set_1000             : out    STD_LOGIC := '0';
      tx_ff_uflow          : in     STD_LOGIC;
      xoff_gen             : out    STD_LOGIC;
      xon_gen              : out    STD_LOGIC);
  end component esoc_port_mal;

  component esoc_port_mac
    port(
      ff_tx_crc_fwd : in     STD_LOGIC;
      ff_tx_data    : in     STD_LOGIC_VECTOR(31 downto 0);
      ff_tx_eop     : in     STD_LOGIC;
      ff_tx_err     : in     STD_LOGIC;
      ff_tx_mod     : in     STD_LOGIC_VECTOR(1 downto 0);
      ff_tx_sop     : in     STD_LOGIC;
      ff_tx_wren    : in     STD_LOGIC;
      ff_tx_clk     : in     STD_LOGIC;
      ff_rx_rdy     : in     STD_LOGIC;
      ff_rx_clk     : in     STD_LOGIC;
      address       : in     STD_LOGIC_VECTOR(7 downto 0);
      read          : in     STD_LOGIC;
      writedata     : in     STD_LOGIC_VECTOR(31 downto 0);
      write         : in     STD_LOGIC;
      clk           : in     STD_LOGIC;
      reset         : in     STD_LOGIC;
      rgmii_in      : in     STD_LOGIC_VECTOR(3 downto 0);
      rx_control    : in     STD_LOGIC;
      tx_clk        : in     STD_LOGIC;
      rx_clk        : in     STD_LOGIC;
      set_10        : in     STD_LOGIC;
      set_1000      : in     STD_LOGIC;
      xon_gen       : in     STD_LOGIC;
      xoff_gen      : in     STD_LOGIC;
      magic_sleep_n : in     STD_LOGIC;
      mdio_in       : in     STD_LOGIC;
      ff_tx_rdy     : out    STD_LOGIC;
      ff_rx_data    : out    STD_LOGIC_VECTOR(31 downto 0);
      ff_rx_dval    : out    STD_LOGIC;
      ff_rx_eop     : out    STD_LOGIC;
      ff_rx_mod     : out    STD_LOGIC_VECTOR(1 downto 0);
      ff_rx_sop     : out    STD_LOGIC;
      rx_err        : out    STD_LOGIC_VECTOR(5 downto 0);
      rx_err_stat   : out    STD_LOGIC_VECTOR(17 downto 0);
      rx_frm_type   : out    STD_LOGIC_VECTOR(3 downto 0);
      ff_rx_dsav    : out    STD_LOGIC;
      readdata      : out    STD_LOGIC_VECTOR(31 downto 0);
      waitrequest   : out    STD_LOGIC;
      rgmii_out     : out    STD_LOGIC_VECTOR(3 downto 0);
      tx_control    : out    STD_LOGIC;
      ena_10        : out    STD_LOGIC;
      eth_mode      : out    STD_LOGIC;
      ff_tx_septy   : out    STD_LOGIC;
      tx_ff_uflow   : out    STD_LOGIC;
      ff_rx_a_full  : out    STD_LOGIC;
      ff_rx_a_empty : out    STD_LOGIC;
      ff_tx_a_full  : out    STD_LOGIC;
      ff_tx_a_empty : out    STD_LOGIC;
      magic_wakeup  : out    STD_LOGIC;
      mdio_out      : out    STD_LOGIC;
      mdio_oen      : out    STD_LOGIC;
      mdc           : out    STD_LOGIC);
  end component esoc_port_mac;

begin
  rgmii_txc <= clk_rgmii;
  u1: esoc_port_mal
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_control          => clk_control,
      clk_rgmii            => clk_rgmii,
      clk_rgmii_125m       => clk_rgmii_125m,
      clk_rgmii_25m        => clk_rgmii_25m,
      clk_rgmii_2m5        => clk_rgmii_2m5,
      ctrl_address         => ctrl_address,
      ctrl_rd              => ctrl_rd,
      ctrl_rddata          => ctrl_rddata,
      ctrl_wait            => ctrl_wait,
      ctrl_wr              => ctrl_wr,
      ctrl_wrdata          => ctrl_wrdata,
      ena_10               => ena_10,
      eth_mode             => eth_mode,
      ff_rx_a_empty        => ff_rx_a_empty,
      ff_rx_a_full         => ff_rx_a_full,
      ff_rx_data           => ff_rx_data,
      ff_rx_dsav           => ff_rx_dsav,
      ff_rx_dval           => ff_rx_dval,
      ff_rx_eop            => ff_rx_eop,
      ff_rx_mod            => ff_rx_mod,
      ff_rx_rdy            => ff_rx_rdy,
      ff_rx_sop            => ff_rx_sop,
      ff_tx_a_empty        => ff_tx_a_empty,
      ff_tx_a_full         => ff_tx_a_full,
      ff_tx_crc_fwd        => ff_tx_crc_fwd,
      ff_tx_data           => ff_tx_data,
      ff_tx_eop            => ff_tx_eop,
      ff_tx_err            => ff_tx_err,
      ff_tx_mod            => ff_tx_mod,
      ff_tx_rdy            => ff_tx_rdy,
      ff_tx_septy          => ff_tx_septy,
      ff_tx_sop            => ff_tx_sop,
      ff_tx_wren           => ff_tx_wren,
      inbound_data         => inbound_data,
      inbound_data_full    => inbound_data_full,
      inbound_data_write   => inbound_data_write,
      inbound_header       => inbound_header,
      inbound_header_write => inbound_header_write,
      inbound_info         => inbound_info,
      inbound_info_write   => inbound_info_write,
      magic_sleep_n        => magic_sleep_n,
      magic_wakeup         => magic_wakeup,
      outbound_data        => outbound_data,
      outbound_data_read   => outbound_data_read,
      outbound_info        => outbound_info,
      outbound_info_empty  => outbound_info_empty,
      outbound_info_read   => outbound_info_read,
      reset                => reset,
      rx_err_stat          => rx_err_stat,
      rx_frm_type          => rx_frm_type,
      set_10               => set_10,
      set_1000             => set_1000,
      tx_ff_uflow          => tx_ff_uflow,
      xoff_gen             => xoff_gen,
      xon_gen              => xon_gen);

  u0: esoc_port_mac
    port map(
      ff_tx_crc_fwd => ff_tx_crc_fwd,
      ff_tx_data    => ff_tx_data,
      ff_tx_eop     => ff_tx_eop,
      ff_tx_err     => ff_tx_err,
      ff_tx_mod     => ff_tx_mod,
      ff_tx_sop     => ff_tx_sop,
      ff_tx_wren    => ff_tx_wren,
      ff_tx_clk     => clk_control,
      ff_rx_rdy     => ff_rx_rdy,
      ff_rx_clk     => clk_control,
      address       => mac_address,
      read          => mac_rd,
      writedata     => mac_wrdata,
      write         => mac_wr,
      clk           => clk_control,
      reset         => reset,
      rgmii_in      => rgmii_rxd,
      rx_control    => rgmii_rxctl,
      tx_clk        => clk_rgmii,
      rx_clk        => rgmii_rxc,
      set_10        => set_10,
      set_1000      => set_1000,
      xon_gen       => xon_gen,
      xoff_gen      => xoff_gen,
      magic_sleep_n => magic_sleep_n,
      mdio_in       => mdio_in,
      ff_tx_rdy     => ff_tx_rdy,
      ff_rx_data    => ff_rx_data,
      ff_rx_dval    => ff_rx_dval,
      ff_rx_eop     => ff_rx_eop,
      ff_rx_mod     => ff_rx_mod,
      ff_rx_sop     => ff_rx_sop,
      rx_err        => open,
      rx_err_stat   => rx_err_stat,
      rx_frm_type   => rx_frm_type,
      ff_rx_dsav    => ff_rx_dsav,
      readdata      => mac_rddata,
      waitrequest   => mac_wait,
      rgmii_out     => rgmii_txd,
      tx_control    => rgmii_txctl,
      ena_10        => ena_10,
      eth_mode      => eth_mode,
      ff_tx_septy   => ff_tx_septy,
      tx_ff_uflow   => tx_ff_uflow,
      ff_rx_a_full  => ff_rx_a_full,
      ff_rx_a_empty => ff_rx_a_empty,
      ff_tx_a_full  => ff_tx_a_full,
      ff_tx_a_empty => ff_tx_a_empty,
      magic_wakeup  => magic_wakeup,
      mdio_out      => mdio_out,
      mdio_oen      => mdio_oen,
      mdc           => mdc);


  mac_mdc   <= mdc;
  mac_mdio  <= mdio_out when mdio_oen = '0' else 'Z';
  mdio_in   <= mac_mdio when mdio_oen = '1'  else '0';


  mac_address   <= ctrl_address(mac_address'high downto 0);

  mac_wrdata    <= ctrl_wrdata;

  mac_wr        <= ctrl_wr when to_integer(unsigned(ctrl_address)) >= esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base and
                                to_integer(unsigned(ctrl_address)) <  esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base + esoc_port_mac_size
                                else '0'; 
                                
  mac_rd        <= ctrl_rd when to_integer(unsigned(ctrl_address)) >= esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base and
                                to_integer(unsigned(ctrl_address)) <  esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base + esoc_port_mac_size
                                else '0';

  ctrl_bus_enable <= '1' when to_integer(unsigned(ctrl_address))   >= esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base and
                                to_integer(unsigned(ctrl_address)) <  esoc_port_nr * esoc_port_base_offset + esoc_port_mac_base + esoc_port_mac_size
                                else '0';

  ctrl_wait     <= mac_wait when ctrl_bus_enable = '1' else 'Z';

  ctrl_rddata   <= mac_rddata when ctrl_bus_enable = '1' else (others => 'Z');
end architecture structure ; -- of esoc_port_interface

