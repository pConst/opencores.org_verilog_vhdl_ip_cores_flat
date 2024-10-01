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
-- Object        : Entity work.esoc_port_mal
-- Last modified : Mon Apr 14 12:48:57 2014.
--------------------------------------------------------------------------------



library ieee, std, work;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.package_esoc_configuration.all;

entity esoc_port_mal is
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
end entity esoc_port_mal;

--------------------------------------------------------------------------------
-- Object        : Architecture work.esoc_port_mal.esoc_port_mal
-- Last modified : Mon Apr 14 12:48:57 2014.
--------------------------------------------------------------------------------

architecture esoc_port_mal of esoc_port_mal is

  signal port_vlan_default      : std_logic_vector(15 downto 0);
  signal force_vlan_default_in  : std_logic;
  signal force_vlan_default_out : std_logic;

  component esoc_port_mal_control
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_control            : in     STD_LOGIC;
      ctrl_address           : in     std_logic_vector(15 downto 0);
      ctrl_rd                : in     std_logic := '0';
      ctrl_rddata            : out    std_logic_vector(31 downto 0);
      ctrl_wait              : out    STD_LOGIC;
      ctrl_wr                : in     std_logic;
      ctrl_wrdata            : in     std_logic_vector(31 downto 0);
      force_vlan_default_in  : out    std_logic;
      force_vlan_default_out : out    std_logic;
      magic_sleep_n          : out    STD_LOGIC := '1';
      magic_wakeup           : in     STD_LOGIC;
      port_vlan_default      : out    std_logic_vector(15 downto 0);
      reset                  : in     STD_LOGIC;
      xoff_gen               : out    STD_LOGIC;
      xon_gen                : out    STD_LOGIC);
  end component esoc_port_mal_control;

  component esoc_port_mal_inbound
    port(
      clk_control           : in     STD_LOGIC;
      ff_rx_a_empty         : in     STD_LOGIC;
      ff_rx_a_full          : in     STD_LOGIC;
      ff_rx_data            : in     STD_LOGIC_VECTOR(31 downto 0);
      ff_rx_dsav            : in     STD_LOGIC;
      ff_rx_dval            : in     STD_LOGIC;
      ff_rx_eop             : in     STD_LOGIC;
      ff_rx_mod             : in     STD_LOGIC_VECTOR(1 downto 0);
      ff_rx_rdy             : out    STD_LOGIC;
      ff_rx_sop             : in     STD_LOGIC;
      force_vlan_default_in : in     std_logic;
      inbound_data          : out    std_logic_vector(31 downto 0);
      inbound_data_full     : in     std_logic;
      inbound_data_write    : out    std_logic;
      inbound_header        : out    std_logic_vector(111 downto 0);
      inbound_header_write  : out    std_logic;
      inbound_info          : out    std_logic_vector(31 downto 0);
      inbound_info_write    : out    std_logic;
      port_vlan_default     : in     std_logic_vector(15 downto 0);
      reset                 : in     STD_LOGIC;
      rx_err_stat           : in     STD_LOGIC_VECTOR(17 downto 0);
      rx_frm_type           : in     STD_LOGIC_VECTOR(3 downto 0));
  end component esoc_port_mal_inbound;

  component esoc_port_mal_outbound
    port(
      clk_control            : in     STD_LOGIC;
      ff_tx_a_empty          : in     STD_LOGIC;
      ff_tx_a_full           : in     STD_LOGIC;
      ff_tx_crc_fwd          : out    STD_LOGIC;
      ff_tx_data             : out    STD_LOGIC_VECTOR(31 downto 0);
      ff_tx_eop              : out    STD_LOGIC;
      ff_tx_err              : out    STD_LOGIC;
      ff_tx_mod              : out    STD_LOGIC_VECTOR(1 downto 0);
      ff_tx_rdy              : in     STD_LOGIC;
      ff_tx_septy            : in     STD_LOGIC;
      ff_tx_sop              : out    STD_LOGIC;
      ff_tx_wren             : out    STD_LOGIC;
      force_vlan_default_out : in     std_logic;
      outbound_data          : in     std_logic_vector(31 downto 0);
      outbound_data_read     : out    std_logic;
      outbound_info          : in     std_logic_vector(15 downto 0);
      outbound_info_empty    : in     std_logic;
      outbound_info_read     : out    std_logic;
      port_vlan_default      : in     std_logic_vector(15 downto 0);
      reset                  : in     STD_LOGIC;
      tx_ff_uflow            : in     STD_LOGIC);
  end component esoc_port_mal_outbound;

  component esoc_port_mal_clock
    port(
      clk_control    : in     STD_LOGIC;
      clk_rgmii      : out    std_logic;
      clk_rgmii_125m : in     std_logic;
      clk_rgmii_25m  : in     std_logic;
      clk_rgmii_2m5  : in     std_logic;
      ena_10         : in     STD_LOGIC;
      eth_mode       : in     STD_LOGIC;
      reset          : in     STD_LOGIC;
      set_10         : out    STD_LOGIC := '0'; -- '0'
      set_1000       : out    STD_LOGIC := '0');
  end component esoc_port_mal_clock;

begin
  u3: esoc_port_mal_control
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_control            => clk_control,
      ctrl_address           => ctrl_address,
      ctrl_rd                => ctrl_rd,
      ctrl_rddata            => ctrl_rddata,
      ctrl_wait              => ctrl_wait,
      ctrl_wr                => ctrl_wr,
      ctrl_wrdata            => ctrl_wrdata,
      force_vlan_default_in  => force_vlan_default_in,
      force_vlan_default_out => force_vlan_default_out,
      magic_sleep_n          => magic_sleep_n,
      magic_wakeup           => magic_wakeup,
      port_vlan_default      => port_vlan_default,
      reset                  => reset,
      xoff_gen               => xoff_gen,
      xon_gen                => xon_gen);

  u0: esoc_port_mal_inbound
    port map(
      clk_control           => clk_control,
      ff_rx_a_empty         => ff_rx_a_empty,
      ff_rx_a_full          => ff_rx_a_full,
      ff_rx_data            => ff_rx_data,
      ff_rx_dsav            => ff_rx_dsav,
      ff_rx_dval            => ff_rx_dval,
      ff_rx_eop             => ff_rx_eop,
      ff_rx_mod             => ff_rx_mod,
      ff_rx_rdy             => ff_rx_rdy,
      ff_rx_sop             => ff_rx_sop,
      force_vlan_default_in => force_vlan_default_in,
      inbound_data          => inbound_data,
      inbound_data_full     => inbound_data_full,
      inbound_data_write    => inbound_data_write,
      inbound_header        => inbound_header,
      inbound_header_write  => inbound_header_write,
      inbound_info          => inbound_info,
      inbound_info_write    => inbound_info_write,
      port_vlan_default     => port_vlan_default,
      reset                 => reset,
      rx_err_stat           => rx_err_stat,
      rx_frm_type           => rx_frm_type);

  u1: esoc_port_mal_outbound
    port map(
      clk_control            => clk_control,
      ff_tx_a_empty          => ff_tx_a_empty,
      ff_tx_a_full           => ff_tx_a_full,
      ff_tx_crc_fwd          => ff_tx_crc_fwd,
      ff_tx_data             => ff_tx_data,
      ff_tx_eop              => ff_tx_eop,
      ff_tx_err              => ff_tx_err,
      ff_tx_mod              => ff_tx_mod,
      ff_tx_rdy              => ff_tx_rdy,
      ff_tx_septy            => ff_tx_septy,
      ff_tx_sop              => ff_tx_sop,
      ff_tx_wren             => ff_tx_wren,
      force_vlan_default_out => force_vlan_default_out,
      outbound_data          => outbound_data,
      outbound_data_read     => outbound_data_read,
      outbound_info          => outbound_info,
      outbound_info_empty    => outbound_info_empty,
      outbound_info_read     => outbound_info_read,
      port_vlan_default      => port_vlan_default,
      reset                  => reset,
      tx_ff_uflow            => tx_ff_uflow);

  u2: esoc_port_mal_clock
    port map(
      clk_control    => clk_control,
      clk_rgmii      => clk_rgmii,
      clk_rgmii_125m => clk_rgmii_125m,
      clk_rgmii_25m  => clk_rgmii_25m,
      clk_rgmii_2m5  => clk_rgmii_2m5,
      ena_10         => ena_10,
      eth_mode       => eth_mode,
      reset          => reset,
      set_10         => set_10,
      set_1000       => set_1000);

end architecture esoc_port_mal ; -- of esoc_port_mal

