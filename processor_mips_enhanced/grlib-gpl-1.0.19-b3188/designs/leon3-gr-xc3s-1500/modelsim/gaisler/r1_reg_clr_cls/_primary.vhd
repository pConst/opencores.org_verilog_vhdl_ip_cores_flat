library verilog;
use verilog.vl_types.all;
entity r1_reg_clr_cls is
    port(
        r1_i            : in     vl_logic_vector(0 downto 0);
        r1_o            : out    vl_logic_vector(0 downto 0);
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        cls             : in     vl_logic;
        hold            : in     vl_logic
    );
end r1_reg_clr_cls;
