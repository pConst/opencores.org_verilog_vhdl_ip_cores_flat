
-- description generated by Pat driver v107
--			date : Sat Sep  8 02:32:20 2001


--		sequence : comp2_beh

-- input / output list :
in       vdd B;;
in       vss B;;
in       p (15 downto 0) X;;
in       q (15 downto 0) X;;
out      kout2 (15 downto 0) X;;

begin

-- Pattern description :

--                                 v v p    q     k     
--                                 d s            o     
--                                 d s            u     
--                                                t     
--                                                2     

path_1                           : 1 0 0000 0000 ?0001 ;
path_2                           : 1 0 2222 2222 ?0001 ;
path_3                           : 1 0 cccc cccc ?0001 ;
path_4                           : 1 0 dddd dddd ?0001 ;
path_5                           : 1 0 eeee eeee ?0001 ;
path_6                           : 1 0 ffff ffff ?0001 ;
path_7                           : 1 0 3333 6666 ?0001 ;
path_8                           : 1 0 3333 5678 ?0001 ;
path_9                           : 1 0 1234 1235 ?0001 ;
path_10                          : 1 0 0000 0001 ?0001 ;
path_11                          : 1 0 0001 0010 ?0001 ;
path_12                          : 1 0 cccc 2222 ?0000 ;
path_13                          : 1 0 ff3a 1110 ?0000 ;
path_14                          : 1 0 2220 1100 ?0000 ;
path_15                          : 1 0 3345 0000 ?0000 ;
path_16                          : 1 0 ffff 0000 ?0000 ;

end;
