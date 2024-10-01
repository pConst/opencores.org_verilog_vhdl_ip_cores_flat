-------------------------------------------------------------------------------
-- Title      : UDP/IP and LAN91C111 Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : udp_ip_lan91c111.vhd
-- Author     :   <alhonena@AHVEN>
-- Company    : 
-- Created    : 2011-09-19
-- Last update: 2011-11-07
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Direct interface for TX and RX operations on UDP/IP protocol
-- level with external LAN91C111 chip (e.g. Altera Stratix II S180 dev board)
-- This toplevel uses a 16-bit mode of LAN91C111 controller!
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-09-19  1.0      alhonena	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity udp_ip_lan91c111 is

  generic (
    disable_rx_g  : integer := 0;
    disable_arp_g : integer := 0);      -- If you disable ARP, you must provide
                                        -- target MAC address (no_arp_target_MAC_in)
                                        -- with target IP address (target_addr_in)

  port (
    clk               : in  std_logic;  -- 25 MHz clock to ensure proper timing. LAN91C111 is used asynchronously.
    rst_n             : in  std_logic;

    -- to/from application

    -- TX
    new_tx_in         : in  std_logic;
    tx_len_in         : in  std_logic_vector( 10 downto 0 );
    target_addr_in    : in  std_logic_vector( 31 downto 0 );
    -- Use this with target_addr_in when disable_arp_g = 1:
    no_arp_target_MAC_in     : in  std_logic_vector( 47 downto 0 ) := (others => '0');
    target_port_in    : in  std_logic_vector( 15 downto 0 );
    source_port_in    : in  std_logic_vector( 15 downto 0 );
    tx_data_in        : in  std_logic_vector( 15 downto 0 );
    tx_data_valid_in  : in  std_logic;
    tx_re_out         : out std_logic;

    -- RX
    new_rx_out        : out std_logic;
    rx_data_valid_out : out std_logic;
    rx_data_out       : out std_logic_vector( 15 downto 0 );
    rx_re_in          : in  std_logic;
    rx_erroneous_out  : out std_logic;
    source_addr_out   : out std_logic_vector( 31 downto 0 );
    source_port_out   : out std_logic_vector( 15 downto 0 );
    dest_port_out     : out std_logic_vector( 15 downto 0 );
    rx_len_out        : out std_logic_vector( 10 downto 0 );
    rx_error_out      : out std_logic;   -- this means system error, not error
                                        -- in data caused by network etc.
    -- Status:
    link_up_out       : out std_logic;
    fatal_error_out   : out std_logic;  -- Something wrong with LAN91C111.

    -- To the external ethernet chip (SMSC LAN91C111)
    eth_data_inout    : inout std_logic_vector( 31 downto 0 );
    eth_addr_out      : out   std_logic_vector( 14 downto 0 );  -- note that they start indexing from 1! A1 on the datasheet goes to eth_addr_out(0).
    eth_interrupt_in  : in    std_logic;
    eth_read_out      : out   std_logic;
    eth_write_out     : out   std_logic;
    eth_nADS_out      : out   std_logic;
    eth_nAEN_out      : out   std_logic;
    eth_nBE_out       : out   std_logic_vector(3 downto 0)
    
    );

end udp_ip_lan91c111;

architecture structural of udp_ip_lan91c111 is

  signal tx_data       : std_logic_vector(15 downto 0);
  signal tx_data_valid : std_logic;
  signal tx_re         : std_logic;
  signal rx_re         : std_logic;
  signal rx_data       : std_logic_vector(15 downto 0);
  signal rx_data_valid : std_logic;
  signal target_MAC    : std_logic_vector(47 downto 0);
  signal new_tx        : std_logic;
  signal tx_len        : std_logic_vector(10 downto 0);
  signal tx_frame_type : std_logic_vector(15 downto 0);
  signal new_rx        : std_logic;
  signal rx_len        : std_logic_vector(10 downto 0);
  signal rx_frame_type : std_logic_vector(15 downto 0);
  signal rx_erroneous  : std_logic;
  
begin  -- structural

  assert not (disable_rx_g = 1 and disable_arp_g = 0) report "RX must be enabled if ARP is enabled" severity failure;
  assert disable_rx_g = 0 or disable_rx_g = 1 report "illegal value of disable_rx_g" severity failure;
  assert disable_arp_g = 0 or disable_arp_g = 1 report "illegal value of disable_arp_g" severity failure;
  
rx_disable: if disable_rx_g = 1 generate
  lan91c111_controller_1: entity work.lan91c111_controller
    generic map (
      enable_rx_g => '0',
      interface_width_g => 16)
    port map (
      clk               => clk,
      rst_n             => rst_n,
      eth_data_inout    => eth_data_inout,
      eth_addr_out      => eth_addr_out, 
      eth_interrupt_in  => eth_interrupt_in,
      eth_read_out      => eth_read_out,
      eth_write_out     => eth_write_out,
      eth_nADS_out      => eth_nADS_out, 
      eth_nAEN_out      => eth_nAEN_out, 
      eth_nBE_out       => eth_nBE_out,
      tx_data_in        => tx_data,
      tx_data_valid_in  => tx_data_valid,
      tx_re_out         => tx_re,
      rx_re_in          => rx_re,
      rx_data_out       => rx_data,
      rx_data_valid_out => rx_data_valid,
      target_MAC_in     => target_MAC,
      new_tx_in         => new_tx,
      tx_len_in         => tx_len,
      tx_frame_type_in  => tx_frame_type,
      new_rx_out        => new_rx,
      rx_len_out        => rx_len,
      rx_frame_type_out => rx_frame_type,
      rx_erroneous_out  => rx_erroneous,
      ready_out         => link_up_out,
      fatal_error_out   => fatal_error_out);
  
end generate rx_disable;

rx_enable: if disable_rx_g = 0 generate
  lan91c111_controller_1: entity work.lan91c111_controller
    generic map (
      enable_rx_g => '1',
      interface_width_g => 16)
    port map (
      clk               => clk,
      rst_n             => rst_n,
      eth_data_inout    => eth_data_inout,
      eth_addr_out      => eth_addr_out, 
      eth_interrupt_in  => eth_interrupt_in,
      eth_read_out      => eth_read_out,
      eth_write_out     => eth_write_out,
      eth_nADS_out      => eth_nADS_out, 
      eth_nAEN_out      => eth_nAEN_out, 
      eth_nBE_out       => eth_nBE_out,
      tx_data_in        => tx_data,
      tx_data_valid_in  => tx_data_valid,
      tx_re_out         => tx_re,
      rx_re_in          => rx_re,
      rx_data_out       => rx_data,
      rx_data_valid_out => rx_data_valid,
      target_MAC_in     => target_MAC,
      new_tx_in         => new_tx,
      tx_len_in         => tx_len,
      tx_frame_type_in  => tx_frame_type,
      new_rx_out        => new_rx,
      rx_len_out        => rx_len,
      rx_frame_type_out => rx_frame_type,
      rx_erroneous_out  => rx_erroneous,
      ready_out         => link_up_out,
      fatal_error_out   => fatal_error_out);
  
end generate rx_enable;
            

  udp_ip_1: entity work.udp_ip
    generic map (
      disable_rx_g  => disable_rx_g,
      disable_arp_g => disable_arp_g)
    port map (
      clk                  => clk,
      rst_n                => rst_n,
      new_tx_in            => new_tx_in,
      tx_len_in            => tx_len_in,
      target_addr_in       => target_addr_in,
      target_port_in       => target_port_in,
      source_port_in       => source_port_in,
      tx_data_in           => tx_data_in,
      tx_data_valid_in     => tx_data_valid_in,
      tx_re_out            => tx_re_out,
      new_rx_out           => new_rx_out,
      rx_data_valid_out    => rx_data_valid_out,
      rx_data_out          => rx_data_out,
      rx_re_in             => rx_re_in,
      rx_erroneous_out     => rx_erroneous_out,
      source_addr_out      => source_addr_out,
      source_port_out      => source_port_out,
      dest_port_out        => dest_port_out,
      rx_len_out           => rx_len_out,
      no_arp_target_MAC_in => no_arp_target_MAC_in,
      tx_data_out          => tx_data,
      tx_data_valid_out    => tx_data_valid,
      tx_re_in             => tx_re,
      target_MAC_out       => target_MAC,
      new_tx_out           => new_tx,
      tx_len_out           => tx_len,
      tx_frame_type_out    => tx_frame_type,
      rx_data_in           => rx_data,
      rx_data_valid_in     => rx_data_valid,
      rx_re_out            => rx_re,
      new_rx_in            => new_rx,
      rx_len_in            => rx_len,
      rx_frame_type_in     => rx_frame_type,
      rx_erroneous_in      => rx_erroneous,
      rx_error_out         => rx_error_out);
  
end structural;
