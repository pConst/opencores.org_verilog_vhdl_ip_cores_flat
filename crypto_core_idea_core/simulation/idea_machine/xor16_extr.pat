
-- description generated by Pat driver v107
--			date : Sat Sep  8 02:21:23 2001


--		sequence : xor16_str

-- input / output list :
in       vdd B;;
in       vss B;;
in       a (15 downto 0) X;;
in       b (15 downto 0) X;;
out      q (15 downto 0) X;;

begin

-- Pattern description :

--                                 v v a    b     q     
--                                 d s                  
--                                 d s                  

path_1                           : 1 0 0000 0000 ?0000 ;
path_3                           : 1 0 0000 00ab ?00ab ;
path_5                           : 1 0 0000 cdab ?cdab ;
path_7                           : 1 0 00ab 0000 ?00ab ;
path_9                           : 1 0 cdab 0000 ?cdab ;
path_11                          : 1 0 cdab 8888 ?4523 ;
path_13                          : 1 0 8888 ffff ?7777 ;
path_15                          : 1 0 eeee cccc ?2222 ;

end;
