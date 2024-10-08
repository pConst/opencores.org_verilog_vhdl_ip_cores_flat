-------------------------------------------------------------------------------
--
-- SD/MMC Bootloader
--
-- $Id: tb_elem-mmc-c.vhd 77 2009-04-01 19:53:14Z arniml $
--
-------------------------------------------------------------------------------

configuration tb_elem_behav_mmc of tb_elem is

  for behav

    for dut_b : chip
      use configuration work.chip_mmc_c0;
    end for;

    for card_b : card
      use configuration work.card_behav_c0;
    end for;

  end for;

end tb_elem_behav_mmc;
