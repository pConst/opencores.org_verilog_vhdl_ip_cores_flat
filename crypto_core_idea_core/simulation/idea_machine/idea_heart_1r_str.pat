
-- description generated by Pat driver v107
--			date : Thu Sep 13 23:47:27 2001


--		sequence : idea_heart_1r

-- input / output list :
in       vdd B;;
in       vss B;;
in       x1 (15 downto 0) X;;
in       x2 (15 downto 0) X;;
in       x3 (15 downto 0) X;;
in       x4 (15 downto 0) X;;
in       z1 (15 downto 0) X;;
in       z2 (15 downto 0) X;;
in       z3 (15 downto 0) X;;
in       z4 (15 downto 0) X;;
in       z5 (15 downto 0) X;;
in       z6 (15 downto 0) X;;
in       en (1 to 7) B;;
in       reset B;;
out      y1 (15 downto 0) X;;
out      y2 (15 downto 0) X;;
out      y3 (15 downto 0) X;;
out      y4 (15 downto 0) X;;

begin

-- Pattern description :

--                                 v v x    x    x    x    z    z    z    z    z    z    e       r  y     y     y     y     
--                                 d s 1    2    3    4    1    2    3    4    5    6    n       e  1     2     3     4     
--                                 d s                                                           s                          
--                                                                                               e                          
--                                                                                               t                          

path_1                           : 1 0 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000000 1 ?0000 ?0000 ?0000 ?0000 ;
path_2                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 1000000 0 ?0000 ?0000 ?0000 ?0000 ;
path_3                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0100000 0 ?0000 ?0000 ?0000 ?0000 ;
path_4                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0010000 0 ?0000 ?0000 ?0000 ?0000 ;
path_5                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0001000 0 ?0000 ?0000 ?0000 ?0000 ;
path_6                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0000100 0 ?0000 ?0000 ?0000 ?0000 ;
path_7                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0000010 0 ?0000 ?0000 ?0000 ?0000 ;
path_8                           : 1 0 000b 000c 000d 000e 0002 0004 0006 0008 000a 000c 0000001 0 ?06ce ?06cb ?071a ?077a ;
path_9                           : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 1000000 0 ?06ce ?06cb ?071a ?077a ;
path_10                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0100000 0 ?06ce ?06cb ?071a ?077a ;
path_11                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0010000 0 ?06ce ?06cb ?071a ?077a ;
path_12                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0001000 0 ?06ce ?06cb ?071a ?077a ;
path_13                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0000100 0 ?06ce ?06cb ?071a ?077a ;
path_14                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0000010 0 ?06ce ?06cb ?071a ?077a ;
path_15                          : 1 0 06ce 06cb 071a 077a 000e 0010 0800 0c00 1000 1400 0000001 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_16                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 1000000 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_17                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0100000 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_18                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0010000 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_19                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0001000 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_20                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0000100 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_21                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0000010 0 ?1e43 ?4e1d ?1ad9 ?aba5 ;
path_22                          : 1 0 000b 000c 000d 000e 000e 0010 0800 0c00 1000 1400 0000001 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_23                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 1000000 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_24                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0100000 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_25                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0010000 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_26                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0001000 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_27                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0000100 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_28                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0000010 0 ?7ab3 ?7224 ?e9bc ?41a0 ;
path_29                          : 1 0 207a e46d 49ce e46d 0060 0080 00a0 00c0 0001 4000 0000001 0 ?5538 ?32e2 ?048b ?b173 ;

end;
