-------------------------------------------------------------------------------
-- Funbase IP library Copyright (C) 2011 TUT Department of Computer Systems
--
-- This source file may be used and distributed without
-- restriction provided that this copyright statement is not
-- removed from the file and that any derivative work contains
-- the original copyright notice and the associated disclaimer.
--
-- This source file is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Lesser General
-- Public License as published by the Free Software Foundation;
-- either version 2.1 of the License, or (at your option) any
-- later version.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE.  See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from http://www.opencores.org/lgpl.shtml
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Title      : Hibi toplevel using r4 wrappers
-- Project    : 
-------------------------------------------------------------------------------
-- File       : hibiv3_r4.vhd
-- Author     : Lasse Lehtonen, modified from Jussi Nieminen's HWTG hibi
--              top level
--            : Lauri Matilainen, merged r3 and r4 wrappers to the same top level
-- Company    : 
-- Last update: 2012-02-07
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Semi-generic toplevel, add as many agents as you like.  Just
--              be sure to create enough addresses in the tables (scroll down).
--              Every segment has equal number of wrappers and are connected
--              as a chain.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2009/06/23  1.0      niemin95        Created
-- (missing revisions)
-- 2012/02/07  2.0      alhonena First, there are revision listings missing.
--                               This is NOT Nieminen's original. Second, this
--                               was completely broken. Didn't even compile.
--                               It tried to create multiple drivers. I made a quick
--                               fix. I hope it is as originally intended now.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.hibiv3_pkg.all;


entity hibi_segment_v3 is
  
  generic (
    -- HIBI generics
    id_width_g          : integer := 4;
    addr_width_g        : integer := 32;
    data_width_g        : integer := 32;
    comm_width_g        : integer := 5;
    counter_width_g     : integer := 8;
    rel_agent_freq_g    : integer := 1;
    rel_bus_freq_g      : integer := 1;
    arb_type_g          : integer := 3;
    fifo_sel_g          : integer := 0;
    rx_fifo_depth_g     : integer := 4;
    rx_msg_fifo_depth_g : integer := 4;
    tx_fifo_depth_g     : integer := 4;
    tx_msg_fifo_depth_g : integer := 4;
    max_send_g          : integer := 20;
    n_cfg_pages_g       : integer := 1;
    n_time_slots_g      : integer := 0;
    keep_slot_g         : integer := 0;
    n_extra_params_g    : integer := 1;

    cfg_re_g            : integer := 1;
    cfg_we_g            : integer := 1;
    debug_width_g       : integer := 0;

    n_r3_agents_g   : integer := 3;
    n_r4_agents_g   : integer := 1;
    n_segments_g : integer := 1;

    separate_addr_g : integer := 0
    );

  port (
    clk_in  : in std_logic;
    -- clk_noc : in std_logic;
    rst_n   : in std_logic;

    -- r4_wrapper ip ports
    
    r4_agent_comm_in   : in  std_logic_vector(n_r4_agents_g*comm_width_g-1 downto 0);
    r4_agent_data_in   : in  std_logic_vector(n_r4_agents_g*data_width_g-1 downto 0);
    r4_agent_av_in     : in  std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_we_in     : in  std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_re_in     : in  std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_comm_out  : out std_logic_vector(n_r4_agents_g*comm_width_g-1 downto 0);
    r4_agent_data_out  : out std_logic_vector(n_r4_agents_g*data_width_g-1 downto 0);
    r4_agent_av_out    : out std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_full_out  : out std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_one_p_out : out std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_empty_out : out std_logic_vector(n_r4_agents_g-1 downto 0);
    r4_agent_one_d_out : out std_logic_vector(n_r4_agents_g-1 downto 0);

    -- r3_wrapper ip ports
    
    r3_agent_comm_in   : in  std_logic_vector(n_r3_agents_g*comm_width_g-1 downto 0);
    r3_agent_data_in   : in  std_logic_vector(n_r3_agents_g*data_width_g-1 downto 0);
    r3_agent_addr_in   : in  std_logic_vector(n_r3_agents_g*addr_width_g-1 downto 0);
    r3_agent_we_in     : in  std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_re_in     : in  std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_comm_out  : out std_logic_vector(n_r3_agents_g*comm_width_g-1 downto 0);
    r3_agent_data_out  : out std_logic_vector(n_r3_agents_g*data_width_g-1 downto 0);
    r3_agent_addr_out  : out std_logic_vector(n_r3_agents_g*addr_width_g-1 downto 0);
    r3_agent_full_out  : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_one_p_out : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_empty_out : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_one_d_out : out std_logic_vector(n_r3_agents_g-1 downto 0);

    r3_agent_msg_comm_in   : in  std_logic_vector(n_r3_agents_g*comm_width_g-1 downto 0);
    r3_agent_msg_data_in   : in  std_logic_vector(n_r3_agents_g*data_width_g-1 downto 0);
    r3_agent_msg_addr_in   : in  std_logic_vector(n_r3_agents_g*addr_width_g-1 downto 0);
    r3_agent_msg_we_in     : in  std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_msg_re_in     : in  std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_msg_comm_out  : out std_logic_vector(n_r3_agents_g*comm_width_g-1 downto 0);
    r3_agent_msg_data_out  : out std_logic_vector(n_r3_agents_g*data_width_g-1 downto 0);
    r3_agent_msg_addr_out  : out std_logic_vector(n_r3_agents_g*addr_width_g-1 downto 0);
    r3_agent_msg_full_out  : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_msg_one_p_out : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_msg_empty_out : out std_logic_vector(n_r3_agents_g-1 downto 0);
    r3_agent_msg_one_d_out : out std_logic_vector(n_r3_agents_g-1 downto 0)


    
    );

end hibi_segment_v3;



architecture structural of hibi_segment_v3 is

  -----------------------------------------------------------------------------
  -- HIBI ADDRESSES
  -----------------------------------------------------------------------------

  constant n_agents_c : integer := n_r3_agents_g + n_r4_agents_g;
  
  type gen_addr_array_type is array (1 to 4) of integer;
  type gen_addr_array_3d_type is array (0 to 2) of gen_addr_array_type;
  type gen_bridge_addr_array is array (0 to 1) of integer;

  -- addresses_c(segment index)(wrapper index in the segment)
  constant addresses_c : gen_addr_array_3d_type :=
    ((16#00000010#, 16#00000030#, 16#00000050#, 16#00000070#),
     (16#00000110#, 16#00000130#, 16#00000150#, 16#00000170#),
     (16#00000310#, 16#00000330#, 16#00000350#, 16#00000370#));

  constant bridge_a_addr_base_c : gen_bridge_addr_array :=
    (16#00000000#, 16#00000000#);
  constant bridge_a_addr_limit_c : gen_bridge_addr_array :=
    (16#000000FF#, 16#000001FF#);
  constant bridge_b_addr_base_c : gen_bridge_addr_array :=
    (16#00000000#, 16#00000000#);
  constant bridge_b_addr_limit_c : gen_bridge_addr_array :=
    (16#000000FF#, 16#000001FF#);

  constant bridge_a_id_min_c : gen_bridge_addr_array :=
    (1, 1);
  constant bridge_a_id_max_c : gen_bridge_addr_array :=
    (5, 11);
  constant bridge_b_id_min_c : gen_bridge_addr_array :=
    (1, 1);
  constant bridge_b_id_max_c : gen_bridge_addr_array :=
    (5, 11);

  constant bridge_a_inv_addr_c : gen_bridge_addr_array :=
    (1, 1);
  constant bridge_b_inv_addr_c : gen_bridge_addr_array :=
    (0, 0);







  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  -- purpose: to resolve the number of agents in each segment
  function n_agents_in_segment (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin  -- n_agents_in_segment

    if n_segments = 1 then
      return wrappers_per_seg;
    elsif segment = 0 or segment = n_segments - 1 then
      -- end segment, only one bridge
      return wrappers_per_seg + 1;
    else
      -- middle segment
      return wrappers_per_seg + 2;
    end if;
    
  end n_agents_in_segment;

  function priority_a (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin

    if n_segments = 1 then
      return 0;
    elsif segment = 0 or segment = n_segments - 1 then
      -- end segment, only one bridge
      return wrappers_per_seg + 1;
    else
      -- middle segment
      return wrappers_per_seg + 2;
    end if;
    
  end priority_a;

  function priority_b (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin

    if n_segments = 1 then
      return 0;
    elsif segment = 0 or segment = n_segments - 1 then
      -- end segment, only one bridge
      return wrappers_per_seg + 1;
    else
      -- middle segment
      return wrappers_per_seg + 1;
    end if;
    
  end priority_b;

  function id_agent (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin

    if n_segments = 1 then
      return 1;
    elsif segment = 0 then
      -- first segment
      return 1;
    elsif segment = n_segments - 1 then
      -- last segment
      return segment*(wrappers_per_seg+2);
    else
      -- middle segment
      return segment*(wrappers_per_seg+2);
    end if;
    
  end id_agent;
  
  function id_a (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin

    if n_segments = 1 then
      return 0;
    elsif segment = 0 then
      -- first segment
      return wrappers_per_seg + 1;
    elsif segment = n_segments - 1 then
      -- last segment
      return 0;
    else
      -- middle segment
      return segment*(wrappers_per_seg+2)+wrappers_per_seg;
    end if;
    
  end id_a;

  function id_b (
    constant segment, n_segments, wrappers_per_seg : integer)
    return integer is
  begin

    if n_segments = 1 then
      return 0;
    elsif segment = 0 then
      -- first segment
      return 0;
    elsif segment = n_segments - 1 then
      return segment*(wrappers_per_seg+2)+wrappers_per_seg;
    else
      -- middle segment
      return segment*(wrappers_per_seg+2)+wrappers_per_seg+1;
    end if;
    
  end id_b;

  -- count wrappers per segemnt
  constant r4_wrappers_per_segment_c : integer := n_r4_agents_g / n_segments_g;
  constant r3_wrappers_per_segment_c : integer := n_r3_agents_g / n_segments_g;
  constant wrappers_per_segment_c : integer := r3_wrappers_per_segment_c + r4_wrappers_per_segment_c;


  type bus_data_segments_array is array (0 to n_segments_g-1) of
    std_logic_vector(data_width_g-1 downto 0);
  type bus_comm_segments_array is array (0 to n_segments_g-1) of
    std_logic_vector(comm_width_c-1 downto 0);

  signal bus_wra_data : bus_data_segments_array;
  signal bus_wra_comm : bus_comm_segments_array;
  signal bus_wra_av   : std_logic_vector(n_segments_g-1 downto 0);
  signal bus_wra_full : std_logic_vector(n_segments_g-1 downto 0);
  signal bus_wra_lock : std_logic_vector(n_segments_g-1 downto 0);

  -- +1, because there might be bridges in the segment. 
  -- extra signals should be optimized away in synthesis
  type data_to_bus_type is array (0 to wrappers_per_segment_c+1) of
    std_logic_vector(data_width_g-1 downto 0);
  type comm_to_bus_type is array (0 to wrappers_per_segment_c+1) of
    std_logic_vector(comm_width_c-1 downto 0);

  type data_segments_array is array (0 to n_segments_g-1) of data_to_bus_type;
  type comm_segments_array is array (0 to n_segments_g-1) of comm_to_bus_type;
  type cntr_segments_array is array (0 to n_segments_g-1) of std_logic_vector
    (wrappers_per_segment_c + 1 downto 0);

  signal wra_bus_data : data_segments_array;
  signal wra_bus_comm : comm_segments_array;
  signal wra_bus_av   : cntr_segments_array;
  signal wra_bus_full : cntr_segments_array;
  signal wra_bus_lock : cntr_segments_array;

-------------------------------------------------------------------------------
begin  -- structural
-------------------------------------------------------------------------------

  -- if there is more than 1 segment, wrappers must distribute evenly
  assert n_segments_g = 1 or n_agents_c mod n_segments_g = 0
    report "With more than one segment wrappers distribute evenly"
    severity failure;


  segments : for seg in 0 to n_segments_g-1 generate

    r4_wrappers : for wra in 0 to r4_wrappers_per_segment_c-1 generate
      
      
      r4_wrapper : entity work.hibi_wrapper_r4
        generic map (
          id_g                => id_agent
          (seg, n_segments_g, wrappers_per_segment_c) + wra,
          addr_g              => addresses_c(seg)(wra + 1),
          inv_addr_en_g       => 0,
          id_width_g          => id_width_g,
          addr_width_g        => addr_width_g,
          data_width_g        => data_width_g,
          separate_addr_g     => separate_addr_g,
          comm_width_g        => comm_width_g,
          counter_width_g     => counter_width_g,
          rel_agent_freq_g    => rel_agent_freq_g,
          rel_bus_freq_g      => rel_bus_freq_g,
          arb_type_g          => arb_type_g,
          fifo_sel_g          => fifo_sel_g,
          rx_fifo_depth_g     => rx_fifo_depth_g,
          rx_msg_fifo_depth_g => rx_msg_fifo_depth_g,
          tx_fifo_depth_g     => tx_fifo_depth_g,
          tx_msg_fifo_depth_g => tx_msg_fifo_depth_g,
          prior_g             => wra + 1,
          max_send_g          => max_send_g,
          -- n_agents_g should be num of ips + num of bridges in the segment
          n_agents_g          => n_agents_in_segment
          (seg, n_segments_g, wrappers_per_segment_c),
          n_cfg_pages_g       => n_cfg_pages_g,
          n_time_slots_g      => n_time_slots_g,
          keep_slot_g         => keep_slot_g,
          n_extra_params_g    => n_extra_params_g,

          cfg_re_g            => cfg_re_g,
          cfg_we_g            => cfg_we_g,
          debug_width_g       => debug_width_g
          )
        port map (
          bus_clk         => clk_in,
          agent_clk       => clk_in,
          bus_sync_clk    => clk_in,
          agent_sync_clk  => clk_in,
          rst_n           => rst_n,
          bus_comm_in     => bus_wra_comm(seg),
          bus_data_in     => bus_wra_data(seg),
          bus_full_in     => bus_wra_full(seg),
          bus_lock_in     => bus_wra_lock(seg),
          bus_av_in       => bus_wra_av(seg),
          agent_comm_in   => r4_agent_comm_in((seg*wrappers_per_segment_c+wra+1)*
                                           comm_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           comm_width_g),
          agent_data_in   => r4_agent_data_in((seg*wrappers_per_segment_c+wra+1)*
                                           data_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           data_width_g),
          agent_av_in     => r4_agent_av_in(seg*wrappers_per_segment_c+wra),
          agent_we_in     => r4_agent_we_in(seg*wrappers_per_segment_c+wra),
          agent_re_in     => r4_agent_re_in(seg*wrappers_per_segment_c+wra),
          bus_comm_out    => wra_bus_comm(seg)(wra),
          bus_data_out    => wra_bus_data(seg)(wra),
          bus_full_out    => wra_bus_full(seg)(wra),
          bus_lock_out    => wra_bus_lock(seg)(wra),
          bus_av_out      => wra_bus_av(seg)(wra),
          agent_comm_out  => r4_agent_comm_out((seg*wrappers_per_segment_c+wra+1)*
                                            comm_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            comm_width_g),
          agent_data_out  => r4_agent_data_out((seg*wrappers_per_segment_c+wra+1)*
                                            data_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            data_width_g),
          agent_av_out    => r4_agent_av_out(seg*wrappers_per_segment_c+wra),
          agent_full_out  => r4_agent_full_out(seg*wrappers_per_segment_c+wra),
          agent_one_p_out => r4_agent_one_p_out(seg*wrappers_per_segment_c+wra),
          agent_empty_out => r4_agent_empty_out(seg*wrappers_per_segment_c+wra),
          agent_one_d_out => r4_agent_one_d_out(seg*wrappers_per_segment_c+wra)
          -- synthesis translate_off
          ,
          debug_out       => open,
          debug_in        => (others => '0')
          -- synthesis translate_on
          );

      
    end generate r4_wrappers;


     r3_wrappers : for wra in 0 to r3_wrappers_per_segment_c-1 generate

      r3_wrapper : entity work.hibi_wrapper_r3
        generic map (
          id_g                => id_agent
          (seg, n_segments_g, wrappers_per_segment_c) + wra + r4_wrappers_per_segment_c,
          addr_g              => addresses_c(seg)(wra + r4_wrappers_per_segment_c + 1),
          inv_addr_en_g       => 0,
          id_width_g          => id_width_g,
          addr_width_g        => addr_width_g,
          data_width_g        => data_width_g,
          separate_addr_g     => separate_addr_g,
          comm_width_g        => comm_width_g,
          counter_width_g     => counter_width_g,
          rel_agent_freq_g    => rel_agent_freq_g,
          rel_bus_freq_g      => rel_bus_freq_g,
          arb_type_g          => arb_type_g,
          fifo_sel_g          => fifo_sel_g,
          rx_fifo_depth_g     => rx_fifo_depth_g,
          rx_msg_fifo_depth_g => rx_msg_fifo_depth_g,
          tx_fifo_depth_g     => tx_fifo_depth_g,
          tx_msg_fifo_depth_g => tx_msg_fifo_depth_g,
          prior_g             => wra + r4_wrappers_per_segment_c + 1,
          max_send_g          => max_send_g,
          -- n_agents_g should be num of ips + num of bridges in the segment
          n_agents_g          => n_agents_in_segment
          (seg, n_segments_g, wrappers_per_segment_c),
          n_cfg_pages_g       => n_cfg_pages_g,
          n_time_slots_g      => n_time_slots_g,
          keep_slot_g         => keep_slot_g,
          n_extra_params_g    => n_extra_params_g,

          cfg_re_g            => cfg_re_g,
          cfg_we_g            => cfg_we_g,
          debug_width_g       => debug_width_g
          )
        port map (
          bus_clk         => clk_in,
          agent_clk       => clk_in,
          bus_sync_clk    => clk_in,
          agent_sync_clk  => clk_in,
          rst_n           => rst_n,
          bus_comm_in     => bus_wra_comm(seg),
          bus_data_in     => bus_wra_data(seg),
          bus_full_in     => bus_wra_full(seg),
          bus_lock_in     => bus_wra_lock(seg),
          bus_av_in       => bus_wra_av(seg),
          agent_comm_in   => r3_agent_comm_in((seg*wrappers_per_segment_c+wra+1)*
                                           comm_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           comm_width_g),
          agent_data_in   => r3_agent_data_in((seg*wrappers_per_segment_c+wra+1)*
                                           data_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           data_width_g),
          agent_addr_in   => r3_agent_addr_in((seg*wrappers_per_segment_c+wra+1)*
                                           addr_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           addr_width_g),
          agent_we_in     => r3_agent_we_in(seg*wrappers_per_segment_c+wra),
          agent_re_in     => r3_agent_re_in(seg*wrappers_per_segment_c+wra),
          agent_msg_comm_in   => r3_agent_msg_comm_in((seg*wrappers_per_segment_c+wra+1)*
                                           comm_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           comm_width_g),
          agent_msg_data_in   => r3_agent_msg_data_in((seg*wrappers_per_segment_c+wra+1)*
                                           data_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           data_width_g),
          agent_msg_addr_in   => r3_agent_msg_addr_in((seg*wrappers_per_segment_c+wra+1)*
                                           addr_width_g-1 downto
                                           (seg*wrappers_per_segment_c+wra)*
                                           addr_width_g),
          agent_msg_we_in     => r3_agent_msg_we_in(seg*wrappers_per_segment_c+wra),
          agent_msg_re_in     => r3_agent_msg_re_in(seg*wrappers_per_segment_c+wra),
          bus_comm_out    => wra_bus_comm(seg)(wra+r4_wrappers_per_segment_c),
          bus_data_out    => wra_bus_data(seg)(wra+r4_wrappers_per_segment_c),
          bus_full_out    => wra_bus_full(seg)(wra+r4_wrappers_per_segment_c),
          bus_lock_out    => wra_bus_lock(seg)(wra+r4_wrappers_per_segment_c),
          bus_av_out      => wra_bus_av(seg)(wra+r4_wrappers_per_segment_c),
          agent_comm_out  => r3_agent_comm_out((seg*wrappers_per_segment_c+wra+1)*
                                            comm_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            comm_width_g),
          agent_data_out  => r3_agent_data_out((seg*wrappers_per_segment_c+wra+1)*
                                            data_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            data_width_g),
          agent_addr_out  => r3_agent_addr_out((seg*wrappers_per_segment_c+wra+1)*
                                            addr_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            addr_width_g),
          agent_full_out  => r3_agent_full_out(seg*wrappers_per_segment_c+wra),
          agent_one_p_out => r3_agent_one_p_out(seg*wrappers_per_segment_c+wra),
          agent_empty_out => r3_agent_empty_out(seg*wrappers_per_segment_c+wra),
          agent_one_d_out => r3_agent_one_d_out(seg*wrappers_per_segment_c+wra),
          agent_msg_comm_out  => r3_agent_msg_comm_out((seg*wrappers_per_segment_c+wra+1)*
                                            comm_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            comm_width_g),
          agent_msg_data_out  => r3_agent_msg_data_out((seg*wrappers_per_segment_c+wra+1)*
                                            data_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            data_width_g),
          agent_msg_addr_out  => r3_agent_msg_addr_out((seg*wrappers_per_segment_c+wra+1)*
                                            addr_width_g-1 downto
                                            (seg*wrappers_per_segment_c+wra)*
                                            addr_width_g),
          agent_msg_full_out  => r3_agent_msg_full_out(seg*wrappers_per_segment_c+wra),
          agent_msg_one_p_out => r3_agent_msg_one_p_out(seg*wrappers_per_segment_c+wra),
          agent_msg_empty_out => r3_agent_msg_empty_out(seg*wrappers_per_segment_c+wra),
          agent_msg_one_d_out => r3_agent_msg_one_d_out(seg*wrappers_per_segment_c+wra)
          -- synthesis translate_off
          ,
          debug_out       => open,
          debug_in        => (others => '0')
          -- synthesis translate_on
          );

      
    end generate r3_wrappers;



    -- bridge_needed : if seg > 0 generate

      -- i_bridge : entity work.hibi_bridge
        -- generic map (
          -- a_id_g                =>
          -- id_a(seg-1, n_segments_g, wrappers_per_segment_c),
          -- a_addr_g              => bridge_a_addr_base_c(seg-1),
          -- a_inv_addr_en_g       => bridge_a_inv_addr_c(seg-1),
          -- a_id_width_g          => id_width_g,
          -- a_addr_width_g        => addr_width_g,
          -- a_data_width_g        => data_width_g,
          -- a_separate_addr_g     => separate_addr_g,
          -- a_comm_width_g        => comm_width_g,
          -- a_counter_width_g     => counter_width_g,
          -- a_rx_fifo_depth_g     => rx_fifo_depth_g,
          -- a_tx_fifo_depth_g     => tx_fifo_depth_g,
          -- a_rx_msg_fifo_depth_g => rx_msg_fifo_depth_g,
          -- a_tx_msg_fifo_depth_g => tx_msg_fifo_depth_g,
          -- a_arb_type_g          => arb_type_g,
          -- a_fifo_sel_g          => fifo_sel_g,

          -- a_debug_width_g       => debug_width_g,
          -- a_prior_g             =>
          -- priority_a(seg-1, n_segments_g, wrappers_per_segment_c),
          -- a_max_send_g          => max_send_g,
          -- a_n_agents_g          =>
          -- n_agents_in_segment(seg-1, n_segments_g, wrappers_per_segment_c),
          -- a_n_cfg_pages_g       => n_cfg_pages_g,
          -- a_n_time_slots_g      => n_time_slots_g,
          -- a_n_extra_params_g    => n_extra_params_g,
          -- a_cfg_re_g            => cfg_re_g,
          -- a_cfg_we_g            => cfg_we_g,

          -- b_id_g                =>
          -- id_b(seg, n_segments_g, wrappers_per_segment_c),
          -- b_addr_g              => bridge_b_addr_base_c(seg-1),
          -- b_inv_addr_en_g       => bridge_b_inv_addr_c(seg-1),
          -- b_id_width_g          => id_width_g,
          -- b_addr_width_g        => addr_width_g,
          -- b_data_width_g        => data_width_g,
          -- b_separate_addr_g     => separate_addr_g,
          -- b_comm_width_g        => comm_width_g,
          -- b_counter_width_g     => counter_width_g,
          -- b_rx_fifo_depth_g     => rx_fifo_depth_g,
          -- b_tx_fifo_depth_g     => tx_fifo_depth_g,
          -- b_rx_msg_fifo_depth_g => rx_msg_fifo_depth_g,
          -- b_tx_msg_fifo_depth_g => tx_msg_fifo_depth_g,
          -- b_arb_type_g          => arb_type_g,
          -- b_fifo_sel_g          => fifo_sel_g,

          -- b_debug_width_g       => debug_width_g,
          -- b_prior_g             =>
          -- priority_b(seg, n_segments_g, wrappers_per_segment_c),
          -- b_max_send_g          => max_send_g,
          -- b_n_agents_g          =>
          -- n_agents_in_segment(seg, n_segments_g, wrappers_per_segment_c),
          -- b_n_cfg_pages_g       => n_cfg_pages_g,
          -- b_n_time_slots_g      => n_time_slots_g,
          -- b_n_extra_params_g    => n_extra_params_g,
          -- b_cfg_re_g            => cfg_re_g,
          -- b_cfg_we_g            => cfg_we_g,

          -- a_id_min_g     => bridge_a_id_min_c(seg-1),
          -- a_id_max_g     => bridge_a_id_max_c(seg-1),
          -- a_addr_limit_g => bridge_a_addr_limit_c(seg-1),

          -- b_id_min_g     => bridge_b_id_min_c(seg-1),
          -- b_id_max_g     => bridge_b_id_max_c(seg-1),
          -- b_addr_limit_g => bridge_b_addr_limit_c(seg-1)

          -- )
        -- port map (
          -- a_clk          => clk_noc,
          -- a_rst_n        => rst_n,
          -- b_clk          => clk_noc,
          -- b_rst_n        => rst_n,
          -- a_bus_av_in    => bus_wra_av(seg-1),
          -- a_bus_data_in  => bus_wra_data(seg-1),
          -- a_bus_comm_in  => bus_wra_comm(seg-1),
          -- a_bus_full_in  => bus_wra_full(seg-1),
          -- a_bus_lock_in  => bus_wra_lock(seg-1),
          -- b_bus_av_in    => bus_wra_av(seg),
          -- b_bus_data_in  => bus_wra_data(seg),
          -- b_bus_comm_in  => bus_wra_comm(seg),
          -- b_bus_full_in  => bus_wra_full(seg),
          -- b_bus_lock_in  => bus_wra_lock(seg),
          -- a_bus_av_out   => wra_bus_av(seg-1)(wrappers_per_segment_c),
          -- a_bus_data_out => wra_bus_data(seg-1)(wrappers_per_segment_c),
          -- a_bus_comm_out => wra_bus_comm(seg-1)(wrappers_per_segment_c),
          -- a_bus_lock_out => wra_bus_lock(seg-1)(wrappers_per_segment_c),
          -- a_bus_full_out => wra_bus_full(seg-1)(wrappers_per_segment_c),
          -- b_bus_av_out   => wra_bus_av(seg)(wrappers_per_segment_c+1),
          -- b_bus_data_out => wra_bus_data(seg)(wrappers_per_segment_c+1),
          -- b_bus_comm_out => wra_bus_comm(seg)(wrappers_per_segment_c+1),
          -- b_bus_lock_out => wra_bus_lock(seg)(wrappers_per_segment_c+1),
          -- b_bus_full_out => wra_bus_full(seg)(wrappers_per_segment_c+1)
			-- -- synthesis translate_off
          -- ,
          -- a_debug_out    => open,
          -- a_debug_in     => (others => '0'),
          -- b_debug_out    => open,
          -- b_debug_in     => (others => '0')
          -- -- synthesis translate_on
          -- );

      -- -- nullify extra signals
      -- nullify_first_seg : if seg = 1 generate
        -- -- no b-side on the first segment
        -- wra_bus_av(seg-1)(wrappers_per_segment_c+1)   <= '0';
        -- wra_bus_full(seg-1)(wrappers_per_segment_c+1) <= '0';
        -- wra_bus_lock(seg-1)(wrappers_per_segment_c+1) <= '0';
        -- wra_bus_comm(seg-1)(wrappers_per_segment_c+1) <= (others => '0');
        -- wra_bus_data(seg-1)(wrappers_per_segment_c+1) <= (others => '0');
      -- end generate nullify_first_seg;

      -- nullify_last_seg : if seg = n_segments_g-1 generate
        -- -- no a-side here
        -- wra_bus_av(seg)(wrappers_per_segment_c)   <= '0';
        -- wra_bus_full(seg)(wrappers_per_segment_c) <= '0';
        -- wra_bus_lock(seg)(wrappers_per_segment_c) <= '0';
        -- wra_bus_comm(seg)(wrappers_per_segment_c) <= (others => '0');
        -- wra_bus_data(seg)(wrappers_per_segment_c) <= (others => '0');
      -- end generate nullify_last_seg;
      
    -- end generate bridge_needed;


    no_bridges : if n_segments_g = 1 generate

      -- no bridges, nullify extra all signals
      wra_bus_av(seg)(wrappers_per_segment_c)     <= '0';
      wra_bus_full(seg)(wrappers_per_segment_c)   <= '0';
      wra_bus_lock(seg)(wrappers_per_segment_c)   <= '0';
      wra_bus_comm(seg)(wrappers_per_segment_c)   <= (others => '0');
      wra_bus_data(seg)(wrappers_per_segment_c)   <= (others => '0');
      wra_bus_av(seg)(wrappers_per_segment_c+1)   <= '0';
      wra_bus_full(seg)(wrappers_per_segment_c+1) <= '0';
      wra_bus_lock(seg)(wrappers_per_segment_c+1) <= '0';
      wra_bus_comm(seg)(wrappers_per_segment_c+1) <= (others => '0');
      wra_bus_data(seg)(wrappers_per_segment_c+1) <= (others => '0');
      
    end generate no_bridges;
    
    
  end generate segments;


  -- making the bus
  form_bus : process (wra_bus_data, wra_bus_comm, wra_bus_av,
                      wra_bus_full, wra_bus_lock)
    variable tmp_data_v : bus_data_segments_array;
    variable tmp_comm_v : bus_comm_segments_array;
    variable tmp_av_v   : std_logic_vector(n_segments_g-1 downto 0);
    variable tmp_full_v : std_logic_vector(n_segments_g-1 downto 0);
    variable tmp_lock_v : std_logic_vector(n_segments_g-1 downto 0);
  begin  -- process form_bus

    for seg in 0 to n_segments_g-1 loop
      
      tmp_data_v(seg) := wra_bus_data(seg)(0);
      tmp_comm_v(seg) := wra_bus_comm(seg)(0);
      tmp_av_v(seg)   := wra_bus_av(seg)(0);
      tmp_full_v(seg) := wra_bus_full(seg)(0);
      tmp_lock_v(seg) := wra_bus_lock(seg)(0);

      for n in 1 to wrappers_per_segment_c+1 loop

        tmp_data_v(seg) := wra_bus_data(seg)(n) or tmp_data_v(seg);
        tmp_comm_v(seg) := wra_bus_comm(seg)(n) or tmp_comm_v(seg);
        tmp_av_v(seg)   := wra_bus_av(seg)(n) or tmp_av_v(seg);
        tmp_full_v(seg) := wra_bus_full(seg)(n) or tmp_full_v(seg);
        tmp_lock_v(seg) := wra_bus_lock(seg)(n) or tmp_lock_v(seg);
        
      end loop;  -- n

      bus_wra_data(seg) <= tmp_data_v(seg);
      bus_wra_comm(seg) <= tmp_comm_v(seg);
      bus_wra_av(seg)   <= tmp_av_v(seg);
      bus_wra_full(seg) <= tmp_full_v(seg);
      bus_wra_lock(seg) <= tmp_lock_v(seg);
      
    end loop;  -- seg
    
  end process form_bus;

end structural;
