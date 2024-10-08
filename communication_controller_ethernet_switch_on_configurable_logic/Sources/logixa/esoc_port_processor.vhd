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
-- Object        : Entity work.esoc_port_processor
-- Last modified : Mon Apr 14 12:49:21 2014.
--------------------------------------------------------------------------------



library ieee, std, work;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.package_esoc_configuration.all;

entity esoc_port_processor is
  generic(
    esoc_port_nr : integer := 0);
  port(
    clk_control          : in     std_logic;
    clk_data             : in     std_logic;
    clk_search           : in     std_logic;
    ctrl_address         : in     std_logic_vector(15 downto 0);
    ctrl_rd              : in     std_logic;
    ctrl_rddata          : out    std_logic_vector(31 downto 0);
    ctrl_wait            : out    std_logic;
    ctrl_wr              : in     std_logic;
    ctrl_wrdata          : in     std_logic_vector(31 downto 0);
    data                 : inout  std_logic_vector(63 downto 0);
    data_eof             : inout  std_logic;
    data_gnt_rd          : in     std_logic;
    data_gnt_wr          : in     std_logic;
    data_port_sel        : inout  std_logic_vector(esoc_port_count-1 downto 0);
    data_req             : out    std_logic;
    data_sof             : inout  std_logic;
    inbound_data         : in     std_logic_vector(63 downto 0);
    inbound_data_full    : in     std_logic;
    inbound_data_read    : out    std_logic;
    inbound_header       : in     std_logic_vector(111 downto 0);
    inbound_header_empty : in     std_logic;
    inbound_header_read  : out    std_logic;
    inbound_info         : in     std_logic_vector(31 downto 0);
    inbound_info_empty   : in     std_logic;
    inbound_info_read    : out    std_logic;
    outbound_data        : out    std_logic_vector(63 downto 0);
    outbound_data_full   : in     std_logic;
    outbound_data_write  : out    std_logic;
    outbound_info        : out    std_logic_vector(15 downto 0);
    outbound_info_write  : out    std_logic;
    reset                : in     std_logic;
    search_eof           : out    std_logic;
    search_gnt_wr        : in     std_logic;
    search_key           : out    std_logic_vector(63 downto 0);
    search_req           : out    std_logic;
    search_result        : in     std_logic_vector(esoc_port_count-1 downto 0);
    search_result_av     : in     std_logic;
    search_sof           : out    std_logic);
end entity esoc_port_processor;

--------------------------------------------------------------------------------
-- Object        : Architecture work.esoc_port_processor.structure
-- Last modified : Mon Apr 14 12:49:21 2014.
--------------------------------------------------------------------------------

architecture structure of esoc_port_processor is

  signal Net_0               : STD_LOGIC;
  signal Net_1               : STD_LOGIC_VECTOR(15 downto 0);
  signal rdempty             : STD_LOGIC;
  signal Net_2               : STD_LOGIC;
  signal q_a                 : STD_LOGIC_VECTOR(0 downto 0);
  signal outbound_drop_cnt   : std_logic;
  signal outbound_done_cnt   : std_logic;
  signal search_done_cnt     : std_logic;
  signal inbound_done_cnt    : std_logic;
  signal inbound_drop_cnt    : std_logic;
  signal ctrl_vlan_id        : std_logic_vector(11 downto 0);
  signal ctrl_vlan_id_member : std_logic_vector(0 downto 0);
  signal outbound_vlan_id    : STD_LOGIC_VECTOR(11 downto 0);
  signal ctrl_vlan_id_wr     : std_logic;
  signal q_b                 : STD_LOGIC_VECTOR(0 downto 0);
  signal search_data         : STD_LOGIC_VECTOR(15 downto 0);
  signal u4_q_b              : STD_LOGIC_VECTOR(0 downto 0);
  signal search_drop_cnt     : std_logic;

  component esoc_port_processor_search
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_search           : in     std_logic;
      inbound_header       : in     std_logic_vector(111 downto 0);
      inbound_header_empty : in     std_logic;
      inbound_header_read  : out    std_logic;
      inbound_vlan_member  : in     STD_LOGIC_VECTOR(0 downto 0);
      reset                : in     std_logic;
      search_data          : out    STD_LOGIC_VECTOR(15 downto 0);
      search_done_cnt      : out    std_logic;
      search_drop_cnt      : out    std_logic;
      search_eof           : out    std_logic;
      search_gnt_wr        : in     std_logic;
      search_key           : out    std_logic_vector(63 downto 0);
      search_req           : out    std_logic;
      search_result        : in     std_logic_vector(esoc_port_count-1 downto 0);
      search_result_av     : in     std_logic;
      search_sof           : out    std_logic;
      search_write         : out    STD_LOGIC);
  end component esoc_port_processor_search;

  component esoc_port_processor_inbound
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_data           : in     std_logic;
      data               : inout  std_logic_vector(63 downto 0);
      data_eof           : inout  std_logic;
      data_gnt_wr        : in     std_logic;
      data_port_sel      : inout  std_logic_vector(esoc_port_count-1 downto 0);
      data_req           : out    std_logic;
      data_sof           : inout  std_logic;
      inbound_data       : in     std_logic_vector(63 downto 0);
      inbound_data_full  : in     std_logic;
      inbound_data_read  : out    std_logic;
      inbound_done_cnt   : out    std_logic;
      inbound_drop_cnt   : out    std_logic;
      inbound_info       : in     std_logic_vector(31 downto 0);
      inbound_info_empty : in     std_logic;
      inbound_info_read  : out    std_logic;
      reset              : in     std_logic;
      search_data        : in     STD_LOGIC_VECTOR(15 downto 0);
      search_empty       : in     STD_LOGIC;
      search_read        : out    STD_LOGIC);
  end component esoc_port_processor_inbound;

  component esoc_port_processor_outbound
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_data             : in     std_logic;
      data                 : in     std_logic_vector(63 downto 0);
      data_eof             : in     std_logic;
      data_gnt_rd          : in     std_logic;
      data_port_sel        : in     std_logic_vector(esoc_port_count-1 downto 0);
      data_sof             : in     std_logic;
      outbound_data        : out    std_logic_vector(63 downto 0);
      outbound_data_full   : in     std_logic;
      outbound_data_write  : out    std_logic;
      outbound_done_cnt    : out    std_logic;
      outbound_drop_cnt    : out    std_logic;
      outbound_info        : out    std_logic_vector(15 downto 0);
      outbound_info_write  : out    std_logic;
      outbound_vlan_id     : out    STD_LOGIC_VECTOR(11 downto 0);
      outbound_vlan_member : in     STD_LOGIC_VECTOR(0 downto 0);
      reset                : in     std_logic);
  end component esoc_port_processor_outbound;

  component esoc_port_processor_control
    generic(
      esoc_port_nr : integer := 0);
    port(
      clk_control             : in     std_logic;
      clk_data                : in     std_logic;
      clk_search              : in     std_logic;
      ctrl_address            : in     std_logic_vector(15 downto 0);
      ctrl_rd                 : in     std_logic;
      ctrl_rddata             : out    std_logic_vector(31 downto 0);
      ctrl_vlan_id            : out    std_logic_vector(11 downto 0);
      ctrl_vlan_id_member_in  : in     std_logic_vector(0 downto 0);
      ctrl_vlan_id_member_out : out    std_logic_vector(0 downto 0);
      ctrl_vlan_id_wr         : out    std_logic;
      ctrl_wait               : out    std_logic;
      ctrl_wr                 : in     std_logic;
      ctrl_wrdata             : in     std_logic_vector(31 downto 0);
      inbound_done_cnt        : in     std_logic;
      inbound_drop_cnt        : in     std_logic;
      outbound_done_cnt       : in     std_logic;
      outbound_drop_cnt       : in     std_logic;
      reset                   : in     STD_LOGIC := '0';
      search_done_cnt         : in     std_logic;
      search_drop_cnt         : in     std_logic);
  end component esoc_port_processor_control;

  component esoc_fifo_256x16
    port(
      aclr    : in     STD_LOGIC := '0';
      data    : in     STD_LOGIC_VECTOR(15 downto 0);
      rdclk   : in     STD_LOGIC;
      rdreq   : in     STD_LOGIC;
      wrclk   : in     STD_LOGIC;
      wrreq   : in     STD_LOGIC;
      q       : out    STD_LOGIC_VECTOR(15 downto 0);
      rdempty : out    STD_LOGIC;
      rdusedw : out    STD_LOGIC_VECTOR(7 downto 0);
      wrfull  : out    STD_LOGIC;
      wrusedw : out    STD_LOGIC_VECTOR(7 downto 0));
  end component esoc_fifo_256x16;

  component esoc_ram_4kx1
    port(
      address_a : in     STD_LOGIC_VECTOR(11 downto 0);
      address_b : in     STD_LOGIC_VECTOR(11 downto 0);
      clock_a   : in     STD_LOGIC := '1';
      clock_b   : in     STD_LOGIC;
      data_a    : in     STD_LOGIC_VECTOR(0 downto 0);
      data_b    : in     STD_LOGIC_VECTOR(0 downto 0);
      wren_a    : in     STD_LOGIC := '0';
      wren_b    : in     STD_LOGIC := '0';
      q_a       : out    STD_LOGIC_VECTOR(0 downto 0);
      q_b       : out    STD_LOGIC_VECTOR(0 downto 0);
      rden_a    : in     STD_LOGIC := '1';
      rden_b    : in     STD_LOGIC := '1');
  end component esoc_ram_4kx1;

begin
  --Search Engine Control
  --Inbound Control - port to switch core
  --Outbound Control - port to switch core
  --Search Result FIFO
  --VLAN Member Table
  --Port Processor Control
  --VLAN Member Table
  u0: esoc_port_processor_search
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_search           => clk_search,
      inbound_header       => inbound_header,
      inbound_header_empty => inbound_header_empty,
      inbound_header_read  => inbound_header_read,
      inbound_vlan_member  => q_a,
      reset                => reset,
      search_data          => search_data,
      search_done_cnt      => search_done_cnt,
      search_drop_cnt      => search_drop_cnt,
      search_eof           => search_eof,
      search_gnt_wr        => search_gnt_wr,
      search_key           => search_key,
      search_req           => search_req,
      search_result        => search_result,
      search_result_av     => search_result_av,
      search_sof           => search_sof,
      search_write         => Net_2);

  u1: esoc_port_processor_inbound
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_data           => clk_data,
      data               => data,
      data_eof           => data_eof,
      data_gnt_wr        => data_gnt_wr,
      data_port_sel      => data_port_sel,
      data_req           => data_req,
      data_sof           => data_sof,
      inbound_data       => inbound_data,
      inbound_data_full  => inbound_data_full,
      inbound_data_read  => inbound_data_read,
      inbound_done_cnt   => inbound_done_cnt,
      inbound_drop_cnt   => inbound_drop_cnt,
      inbound_info       => inbound_info,
      inbound_info_empty => inbound_info_empty,
      inbound_info_read  => inbound_info_read,
      reset              => reset,
      search_data        => Net_1,
      search_empty       => rdempty,
      search_read        => Net_0);

  u2: esoc_port_processor_outbound
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_data             => clk_data,
      data                 => data,
      data_eof             => data_eof,
      data_gnt_rd          => data_gnt_rd,
      data_port_sel        => data_port_sel,
      data_sof             => data_sof,
      outbound_data        => outbound_data,
      outbound_data_full   => outbound_data_full,
      outbound_data_write  => outbound_data_write,
      outbound_done_cnt    => outbound_done_cnt,
      outbound_drop_cnt    => outbound_drop_cnt,
      outbound_info        => outbound_info,
      outbound_info_write  => outbound_info_write,
      outbound_vlan_id     => outbound_vlan_id,
      outbound_vlan_member => u4_q_b,
      reset                => reset);

  u3: esoc_port_processor_control
    generic map(
      esoc_port_nr => esoc_port_nr)
    port map(
      clk_control             => clk_control,
      clk_data                => clk_data,
      clk_search              => clk_search,
      ctrl_address            => ctrl_address,
      ctrl_rd                 => ctrl_rd,
      ctrl_rddata             => ctrl_rddata,
      ctrl_vlan_id            => ctrl_vlan_id,
      ctrl_vlan_id_member_in  => q_b,
      ctrl_vlan_id_member_out => ctrl_vlan_id_member,
      ctrl_vlan_id_wr         => ctrl_vlan_id_wr,
      ctrl_wait               => ctrl_wait,
      ctrl_wr                 => ctrl_wr,
      ctrl_wrdata             => ctrl_wrdata,
      inbound_done_cnt        => inbound_done_cnt,
      inbound_drop_cnt        => inbound_drop_cnt,
      outbound_done_cnt       => outbound_done_cnt,
      outbound_drop_cnt       => outbound_drop_cnt,
      reset                   => reset,
      search_done_cnt         => search_done_cnt,
      search_drop_cnt         => search_drop_cnt);

  u5: esoc_fifo_256x16
    port map(
      aclr    => reset,
      data    => search_data,
      rdclk   => clk_data,
      rdreq   => Net_0,
      wrclk   => clk_search,
      wrreq   => Net_2,
      q       => Net_1,
      rdempty => rdempty,
      rdusedw => open,
      wrfull  => open,
      wrusedw => open);

  u6: esoc_ram_4kx1
    port map(
      address_a => inbound_header(esoc_inbound_header_vlan+11 downto esoc_inbound_header_vlan),
      address_b => ctrl_vlan_id,
      clock_a   => clk_search,
      clock_b   => clk_control,
      data_a    => (others => '0'),
      data_b    => ctrl_vlan_id_member,
      wren_a    => '0',
      wren_b    => ctrl_vlan_id_wr,
      q_a       => q_a,
      q_b       => q_b,
      rden_a    => '1',
      rden_b    => '1');

  u4: esoc_ram_4kx1
    port map(
      address_a => ctrl_vlan_id,
      address_b => outbound_vlan_id,
      clock_a   => clk_control,
      clock_b   => clk_data,
      data_a    => ctrl_vlan_id_member,
      data_b    => (others => '0'),
      wren_a    => ctrl_vlan_id_wr,
      wren_b    => '0',
      q_a       => open,
      q_b       => u4_q_b,
      rden_a    => '1',
      rden_b    => '1');

end architecture structure ; -- of esoc_port_processor

