-- ########################################################
-- #         << ATLAS Project - Bootloader ROM >>         #
-- # **************************************************** #
-- #  2kB ROM initialized with Atlas-2k bootloader.       #
-- # **************************************************** #
-- #  Last modified: 28.11.2014                           #
-- # **************************************************** #
-- #  by Stephan Nolting 4788, Hanover, Germany           #
-- ########################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.atlas_core_package.all;

entity boot_mem is
  port	(
        -- host interface --
        clk_i   : in  std_ulogic; -- global clock line
        i_adr_i : in  std_ulogic_vector(15 downto 0); -- instruction adr
        i_dat_o : out std_ulogic_vector(15 downto 0); -- instruction out
        d_en_i  : in  std_ulogic; -- access enable
        d_rw_i  : in  std_ulogic; -- read/write
        d_adr_i : in  std_ulogic_vector(15 downto 0); -- data adr
        d_dat_i : in  std_ulogic_vector(15 downto 0); -- data in
        d_dat_o : out std_ulogic_vector(15 downto 0)  -- data out
      );
end boot_mem;

architecture boot_mem_structure of boot_mem is

  -- internal constants(configuration --
  constant mem_size_c      : natural := 2048; -- 2kb
  constant log2_mem_size_c : natural := log2(mem_size_c/2); -- address width (word boundary!)

  -- memory type --
  type mem_file_t is array (0 to (mem_size_c/2)-1) of std_ulogic_vector(15 downto 0); -- word mem!

  -- memory image (bootloader program) --
  ------------------------------------------------------
  constant boot_mem_file_c : mem_file_t :=
    (
    000000 => x"bc0e", -- B
    000001 => x"bc04", -- B
    000002 => x"bc03", -- B
    000003 => x"bc02", -- B
    000004 => x"bc01", -- B
    000005 => x"c000", -- LDIL
    000006 => x"cc00", -- LDIH
    000007 => x"ec8a", -- MCR
    000008 => x"cc19", -- LDIH
    000009 => x"ed0f", -- MCR
    000010 => x"c520", -- LDIL
    000011 => x"c907", -- LDIH
    000012 => x"be73", -- BL
    000013 => x"bc00", -- B
    000014 => x"ec11", -- MRC
    000015 => x"ec88", -- MCR
    000016 => x"ec8a", -- MCR
    000017 => x"c380", -- LDIL
    000018 => x"cff8", -- LDIH
    000019 => x"1c07", -- STSR
    000020 => x"2800", -- CLR
    000021 => x"ec08", -- MCR
    000022 => x"ec0b", -- MCR
    000023 => x"ec0d", -- MCR
    000024 => x"ec00", -- MRC
    000025 => x"ed88", -- MCR
    000026 => x"ed8b", -- MCR
    000027 => x"c064", -- LDIL
    000028 => x"ed8d", -- MCR
    000029 => x"c901", -- LDIH
    000030 => x"ed2f", -- MCR
    000031 => x"ec17", -- MRC
    000032 => x"ec97", -- MRC
    000033 => x"c160", -- LDIL
    000034 => x"c909", -- LDIH
    000035 => x"c18f", -- LDIL
    000036 => x"0923", -- ADD
    000037 => x"29b3", -- CLR
    000038 => x"2a44", -- CLR
    000039 => x"100a", -- SUBS
    000040 => x"149b", -- SBCS
    000041 => x"9003", -- BMI
    000042 => x"0241", -- INC
    000043 => x"bdfc", -- B
    000044 => x"ed49", -- MCR
    000045 => x"ec22", -- MRC
    000046 => x"d406", -- SBR
    000047 => x"ed0a", -- MCR
    000048 => x"c534", -- LDIL
    000049 => x"c905", -- LDIH
    000050 => x"be4d", -- BL
    000051 => x"c12a", -- LDIL
    000052 => x"c906", -- LDIH
    000053 => x"be4a", -- BL
    000054 => x"ee11", -- MRC
    000055 => x"be4c", -- BL
    000056 => x"c13a", -- LDIL
    000057 => x"c906", -- LDIH
    000058 => x"be45", -- BL
    000059 => x"ee97", -- MRC
    000060 => x"ee17", -- MRC
    000061 => x"be46", -- BL
    000062 => x"0250", -- MOV
    000063 => x"be44", -- BL
    000064 => x"be40", -- BL
    000065 => x"ec27", -- MRC
    000066 => x"c083", -- LDIL
    000067 => x"2001", -- AND
    000068 => x"c330", -- LDIL
    000069 => x"0b60", -- ADD
    000070 => x"bc0f", -- B
    000071 => x"c552", -- LDIL
    000072 => x"c906", -- LDIH
    000073 => x"be36", -- BL
    000074 => x"c144", -- LDIL
    000075 => x"c907", -- LDIH
    000076 => x"be33", -- BL
    000077 => x"c50a", -- LDIL
    000078 => x"c907", -- LDIH
    000079 => x"be30", -- BL
    000080 => x"be32", -- BL
    000081 => x"0300", -- MOV
    000082 => x"0080", -- MOV
    000083 => x"be2e", -- BL
    000084 => x"be2c", -- BL
    000085 => x"c0b0", -- LDIL
    000086 => x"181e", -- CMP
    000087 => x"81f0", -- BEQ
    000088 => x"c0b1", -- LDIL
    000089 => x"181e", -- CMP
    000090 => x"8085", -- BEQ
    000091 => x"c0b2", -- LDIL
    000092 => x"181e", -- CMP
    000093 => x"8052", -- BEQ
    000094 => x"c0b3", -- LDIL
    000095 => x"181e", -- CMP
    000096 => x"8019", -- BEQ
    000097 => x"c0b4", -- LDIL
    000098 => x"181e", -- CMP
    000099 => x"8021", -- BEQ
    000100 => x"c296", -- LDIL
    000101 => x"ca83", -- LDIH
    000102 => x"c0f0", -- LDIL
    000103 => x"181e", -- CMP
    000104 => x"f705", -- RBAEQ
    000105 => x"c0e4", -- LDIL
    000106 => x"181e", -- CMP
    000107 => x"80e1", -- BEQ
    000108 => x"c2c8", -- LDIL
    000109 => x"ca85", -- LDIH
    000110 => x"c0f7", -- LDIL
    000111 => x"181e", -- CMP
    000112 => x"f705", -- RBAEQ
    000113 => x"c0f2", -- LDIL
    000114 => x"181e", -- CMP
    000115 => x"85da", -- BNE
    000116 => x"2800", -- CLR
    000117 => x"c080", -- LDIL
    000118 => x"cc80", -- LDIH
    000119 => x"ec99", -- MCR
    000120 => x"3400", -- GT
    000121 => x"c14a", -- LDIL
    000122 => x"c906", -- LDIH
    000123 => x"be04", -- BL
    000124 => x"2800", -- CLR
    000125 => x"2100", -- STUB
    000126 => x"bca0", -- B
    000127 => x"bc95", -- B
    000128 => x"bc95", -- B
    000129 => x"bc95", -- B
    000130 => x"bc95", -- B
    000131 => x"bc98", -- B
    000132 => x"c528", -- LDIL
    000133 => x"c906", -- LDIH
    000134 => x"be8e", -- BL
    000135 => x"be96", -- BL
    000136 => x"edca", -- MCR
    000137 => x"be94", -- BL
    000138 => x"edc9", -- MCR
    000139 => x"c036", -- LDIL
    000140 => x"c805", -- LDIH
    000141 => x"3404", -- GTL
    000142 => x"be87", -- BL
    000143 => x"be8d", -- BL
    000144 => x"c47e", -- LDIL
    000145 => x"cc4a", -- LDIH
    000146 => x"180e", -- CMP
    000147 => x"8486", -- BNE
    000148 => x"be88", -- BL
    000149 => x"3f64", -- SFT
    000150 => x"2066", -- STUB
    000151 => x"be85", -- BL
    000152 => x"20e6", -- STUB
    000153 => x"be83", -- BL
    000154 => x"2166", -- STUB
    000155 => x"be81", -- BL
    000156 => x"21e6", -- STUB
    000157 => x"be7f", -- BL
    000158 => x"2266", -- STUB
    000159 => x"be7d", -- BL
    000160 => x"22e6", -- STUB
    000161 => x"be7b", -- BL
    000162 => x"2366", -- STUB
    000163 => x"c280", -- LDIL
    000164 => x"ecda", -- MCR
    000165 => x"ec5e", -- MCR
    000166 => x"be76", -- BL
    000167 => x"7f5a", -- STR
    000168 => x"ec06", -- MRC
    000169 => x"2806", -- EOR
    000170 => x"ec0e", -- MCR
    000171 => x"2400", -- LDUB
    000172 => x"1858", -- CMP
    000173 => x"85f9", -- BNE
    000174 => x"bc53", -- B
    000175 => x"c100", -- LDIL
    000176 => x"be28", -- BL
    000177 => x"c47e", -- LDIL
    000178 => x"cc4a", -- LDIH
    000179 => x"180d", -- CMP
    000180 => x"8465", -- BNE
    000181 => x"c102", -- LDIL
    000182 => x"be22", -- BL
    000183 => x"2055", -- STUB
    000184 => x"c104", -- LDIL
    000185 => x"be1f", -- BL
    000186 => x"20d5", -- STUB
    000187 => x"c106", -- LDIL
    000188 => x"be1c", -- BL
    000189 => x"2155", -- STUB
    000190 => x"c108", -- LDIL
    000191 => x"be19", -- BL
    000192 => x"21d5", -- STUB
    000193 => x"c10a", -- LDIL
    000194 => x"be16", -- BL
    000195 => x"2255", -- STUB
    000196 => x"c10c", -- LDIL
    000197 => x"be13", -- BL
    000198 => x"22d5", -- STUB
    000199 => x"c10e", -- LDIL
    000200 => x"be10", -- BL
    000201 => x"2355", -- STUB
    000202 => x"c200", -- LDIL
    000203 => x"ecca", -- MCR
    000204 => x"ec4e", -- MCR
    000205 => x"c010", -- LDIL
    000206 => x"0940", -- ADD
    000207 => x"be09", -- BL
    000208 => x"7eca", -- STR
    000209 => x"ec06", -- MRC
    000210 => x"2805", -- EOR
    000211 => x"ec0e", -- MCR
    000212 => x"2400", -- LDUB
    000213 => x"1848", -- CMP
    000214 => x"85f7", -- BNE
    000215 => x"bc2a", -- B
    000216 => x"0370", -- MOV
    000217 => x"be3f", -- BL
    000218 => x"3eb0", -- SFT
    000219 => x"0121", -- INC
    000220 => x"be3c", -- BL
    000221 => x"26d3", -- ORR
    000222 => x"3460", -- RET
    000223 => x"c162", -- LDIL
    000224 => x"c906", -- LDIH
    000225 => x"be33", -- BL
    000226 => x"be2c", -- BL
    000227 => x"c47e", -- LDIL
    000228 => x"cc4a", -- LDIH
    000229 => x"1818", -- CMP
    000230 => x"8433", -- BNE
    000231 => x"be27", -- BL
    000232 => x"3c94", -- SFT
    000233 => x"2011", -- STUB
    000234 => x"be24", -- BL
    000235 => x"2091", -- STUB
    000236 => x"be22", -- BL
    000237 => x"2111", -- STUB
    000238 => x"be20", -- BL
    000239 => x"2191", -- STUB
    000240 => x"be1e", -- BL
    000241 => x"2211", -- STUB
    000242 => x"be1c", -- BL
    000243 => x"2291", -- STUB
    000244 => x"be1a", -- BL
    000245 => x"2311", -- STUB
    000246 => x"2ad5", -- CLR
    000247 => x"ecda", -- MCR
    000248 => x"ec5e", -- MCR
    000249 => x"be15", -- BL
    000250 => x"7cda", -- STR
    000251 => x"ec06", -- MRC
    000252 => x"2801", -- EOR
    000253 => x"ec0e", -- MCR
    000254 => x"2400", -- LDUB
    000255 => x"1858", -- CMP
    000256 => x"85f9", -- BNE
    000257 => x"ec11", -- MRC
    000258 => x"ec8a", -- MCR
    000259 => x"c506", -- LDIL
    000260 => x"c906", -- LDIH
    000261 => x"be0f", -- BL
    000262 => x"ec06", -- MRC
    000263 => x"2491", -- LDUB
    000264 => x"1809", -- CMP
    000265 => x"8015", -- BEQ
    000266 => x"c52e", -- LDIL
    000267 => x"c907", -- LDIH
    000268 => x"be08", -- BL
    000269 => x"bccf", -- B
    000270 => x"0370", -- MOV
    000271 => x"be08", -- BL
    000272 => x"3c80", -- SFT
    000273 => x"be06", -- BL
    000274 => x"2490", -- ORR
    000275 => x"3460", -- RET
    000276 => x"bccb", -- B
    000277 => x"bcd3", -- B
    000278 => x"bcd7", -- B
    000279 => x"bcdb", -- B
    000280 => x"bc71", -- B
    000281 => x"bcc0", -- B
    000282 => x"bd33", -- B
    000283 => x"bc6f", -- B
    000284 => x"bcc2", -- B
    000285 => x"bcda", -- B
    000286 => x"c176", -- LDIL
    000287 => x"c906", -- LDIH
    000288 => x"bebf", -- BL
    000289 => x"24aa", -- LDUBS
    000290 => x"8010", -- BEQ
    000291 => x"c0a2", -- LDIL
    000292 => x"bec9", -- BL
    000293 => x"24a2", -- LDUB
    000294 => x"be20", -- BL
    000295 => x"24b3", -- LDUB
    000296 => x"be1e", -- BL
    000297 => x"24c4", -- LDUB
    000298 => x"be1c", -- BL
    000299 => x"24d5", -- LDUB
    000300 => x"be1a", -- BL
    000301 => x"24e6", -- LDUB
    000302 => x"be18", -- BL
    000303 => x"c0a2", -- LDIL
    000304 => x"bebd", -- BL
    000305 => x"beb7", -- BL
    000306 => x"c546", -- LDIL
    000307 => x"c906", -- LDIH
    000308 => x"beab", -- BL
    000309 => x"ee06", -- MRC
    000310 => x"bee6", -- BL
    000311 => x"beb1", -- BL
    000312 => x"beb0", -- BL
    000313 => x"beaf", -- BL
    000314 => x"beae", -- BL
    000315 => x"c080", -- LDIL
    000316 => x"ccc0", -- LDIH
    000317 => x"1c01", -- STSR
    000318 => x"2800", -- CLR
    000319 => x"ed0f", -- MCR
    000320 => x"ec88", -- MCR
    000321 => x"ec8b", -- MCR
    000322 => x"ec8c", -- MCR
    000323 => x"ec8a", -- MCR
    000324 => x"ec89", -- MCR
    000325 => x"3400", -- GT
    000326 => x"0370", -- MOV
    000327 => x"3c90", -- SFT
    000328 => x"bea5", -- BL
    000329 => x"3c90", -- SFT
    000330 => x"bea3", -- BL
    000331 => x"3460", -- RET
    000332 => x"c51a", -- LDIL
    000333 => x"c906", -- LDIH
    000334 => x"be91", -- BL
    000335 => x"bea8", -- BL
    000336 => x"c136", -- LDIL
    000337 => x"c905", -- LDIH
    000338 => x"3424", -- GTL
    000339 => x"ecca", -- MCR
    000340 => x"be94", -- BL
    000341 => x"c280", -- LDIL
    000342 => x"c00f", -- LDIL
    000343 => x"2058", -- ANDS
    000344 => x"840e", -- BNE
    000345 => x"be8f", -- BL
    000346 => x"c0a4", -- LDIL
    000347 => x"be92", -- BL
    000348 => x"ee12", -- MRC
    000349 => x"bebf", -- BL
    000350 => x"c0ae", -- LDIL
    000351 => x"be8e", -- BL
    000352 => x"0250", -- MOV
    000353 => x"bebb", -- BL
    000354 => x"c0ba", -- LDIL
    000355 => x"be8a", -- BL
    000356 => x"c0a0", -- LDIL
    000357 => x"be88", -- BL
    000358 => x"7a5a", -- LDR
    000359 => x"c0a0", -- LDIL
    000360 => x"be85", -- BL
    000361 => x"beb3", -- BL
    000362 => x"c00f", -- LDIL
    000363 => x"2058", -- ANDS
    000364 => x"8414", -- BNE
    000365 => x"c0a0", -- LDIL
    000366 => x"be7f", -- BL
    000367 => x"be7e", -- BL
    000368 => x"c010", -- LDIL
    000369 => x"1250", -- SUB
    000370 => x"c470", -- LDIL
    000371 => x"2240", -- AND
    000372 => x"c12e", -- LDIL
    000373 => x"78c9", -- LDR
    000374 => x"3c90", -- SFT
    000375 => x"c880", -- LDIH
    000376 => x"c020", -- LDIL
    000377 => x"1818", -- CMP
    000378 => x"f8c2", -- MVHI
    000379 => x"be72", -- BL
    000380 => x"c08f", -- LDIL
    000381 => x"2014", -- AND
    000382 => x"3409", -- TEQ
    000383 => x"85f6", -- BNE
    000384 => x"ec20", -- MRC
    000385 => x"dc0f", -- STB
    000386 => x"b804", -- BTS
    000387 => x"c5fe", -- LDIL
    000388 => x"343d", -- TEQ
    000389 => x"85d1", -- BNE
    000390 => x"be6c", -- BL
    000391 => x"2800", -- CLR
    000392 => x"3400", -- GT
    000393 => x"bc54", -- B
    000394 => x"bc92", -- B
    000395 => x"c001", -- LDIL
    000396 => x"ed0c", -- MCR
    000397 => x"c050", -- LDIL
    000398 => x"c83f", -- LDIH
    000399 => x"ed0a", -- MCR
    000400 => x"c000", -- LDIL
    000401 => x"c801", -- LDIH
    000402 => x"bea8", -- BL
    000403 => x"c154", -- LDIL
    000404 => x"c906", -- LDIH
    000405 => x"be4a", -- BL
    000406 => x"c162", -- LDIL
    000407 => x"c906", -- LDIH
    000408 => x"be47", -- BL
    000409 => x"be59", -- BL
    000410 => x"3c80", -- SFT
    000411 => x"be57", -- BL
    000412 => x"2410", -- ORR
    000413 => x"c4fe", -- LDIL
    000414 => x"ccca", -- LDIH
    000415 => x"1809", -- CMP
    000416 => x"8439", -- BNE
    000417 => x"c100", -- LDIL
    000418 => x"0290", -- MOV
    000419 => x"be2f", -- BL
    000420 => x"be4e", -- BL
    000421 => x"3c80", -- SFT
    000422 => x"be4c", -- BL
    000423 => x"2690", -- ORR
    000424 => x"3ed4", -- SFT
    000425 => x"2055", -- STUB
    000426 => x"c102", -- LDIL
    000427 => x"be27", -- BL
    000428 => x"be46", -- BL
    000429 => x"3c80", -- SFT
    000430 => x"be44", -- BL
    000431 => x"2690", -- ORR
    000432 => x"20d5", -- STUB
    000433 => x"c104", -- LDIL
    000434 => x"be20", -- BL
    000435 => x"c106", -- LDIL
    000436 => x"be3e", -- BL
    000437 => x"0180", -- MOV
    000438 => x"be8a", -- BL
    000439 => x"0121", -- INC
    000440 => x"c010", -- LDIL
    000441 => x"1828", -- CMP
    000442 => x"85fa", -- BNE
    000443 => x"2ad5", -- CLR
    000444 => x"be36", -- BL
    000445 => x"0180", -- MOV
    000446 => x"be82", -- BL
    000447 => x"0121", -- INC
    000448 => x"2400", -- LDUB
    000449 => x"02d1", -- INC
    000450 => x"1858", -- CMP
    000451 => x"85f9", -- BNE
    000452 => x"c001", -- LDIL
    000453 => x"ed0c", -- MCR
    000454 => x"c050", -- LDIL
    000455 => x"c83f", -- LDIH
    000456 => x"ed0a", -- MCR
    000457 => x"c00c", -- LDIL
    000458 => x"c801", -- LDIH
    000459 => x"be6f", -- BL
    000460 => x"c506", -- LDIL
    000461 => x"c906", -- LDIH
    000462 => x"be11", -- BL
    000463 => x"c68e", -- LDIL
    000464 => x"ca80", -- LDIH
    000465 => x"3450", -- GT
    000466 => x"0370", -- MOV
    000467 => x"3dd0", -- SFT
    000468 => x"be6c", -- BL
    000469 => x"0121", -- INC
    000470 => x"01d0", -- MOV
    000471 => x"be69", -- BL
    000472 => x"3460", -- RET
    000473 => x"c512", -- LDIL
    000474 => x"c907", -- LDIH
    000475 => x"be04", -- BL
    000476 => x"bcb9", -- B
    000477 => x"bc93", -- B
    000478 => x"bca4", -- B
    000479 => x"01f0", -- MOV
    000480 => x"78a9", -- LDR
    000481 => x"3c90", -- SFT
    000482 => x"c880", -- LDIH
    000483 => x"3419", -- TEQ
    000484 => x"8003", -- BEQ
    000485 => x"be08", -- BL
    000486 => x"bdfa", -- B
    000487 => x"3430", -- RET
    000488 => x"0170", -- MOV
    000489 => x"c08d", -- LDIL
    000490 => x"be03", -- BL
    000491 => x"c08a", -- LDIL
    000492 => x"03a0", -- MOV
    000493 => x"ec22", -- MRC
    000494 => x"dc05", -- STB
    000495 => x"b9fe", -- BTS
    000496 => x"ed18", -- MCR
    000497 => x"3470", -- RET
    000498 => x"ec20", -- MRC
    000499 => x"dc8f", -- STBI
    000500 => x"b9fe", -- BTS
    000501 => x"c800", -- LDIH
    000502 => x"3470", -- RET
    000503 => x"0170", -- MOV
    000504 => x"c200", -- LDIL
    000505 => x"c184", -- LDIL
    000506 => x"bff8", -- BL
    000507 => x"c0c7", -- LDIL
    000508 => x"1809", -- CMP
    000509 => x"9003", -- BMI
    000510 => x"c0a0", -- LDIL
    000511 => x"1001", -- SUB
    000512 => x"c0b0", -- LDIL
    000513 => x"1809", -- CMP
    000514 => x"91f8", -- BMI
    000515 => x"c0c6", -- LDIL
    000516 => x"1818", -- CMP
    000517 => x"91f5", -- BMI
    000518 => x"c0b9", -- LDIL
    000519 => x"1818", -- CMP
    000520 => x"a404", -- BLS
    000521 => x"c0c1", -- LDIL
    000522 => x"1809", -- CMP
    000523 => x"a1ef", -- BHI
    000524 => x"0080", -- MOV
    000525 => x"bfe0", -- BL
    000526 => x"c030", -- LDIL
    000527 => x"1090", -- SUB
    000528 => x"c009", -- LDIL
    000529 => x"1809", -- CMP
    000530 => x"a402", -- BLS
    000531 => x"0497", -- DEC
    000532 => x"3e42", -- SFT
    000533 => x"3e42", -- SFT
    000534 => x"3e42", -- SFT
    000535 => x"3e42", -- SFT
    000536 => x"2641", -- ORR
    000537 => x"05b9", -- DECS
    000538 => x"85e0", -- BNE
    000539 => x"3420", -- RET
    000540 => x"0370", -- MOV
    000541 => x"3d42", -- SFT
    000542 => x"3d22", -- SFT
    000543 => x"3d22", -- SFT
    000544 => x"3d22", -- SFT
    000545 => x"be0f", -- BL
    000546 => x"bfcb", -- BL
    000547 => x"3d40", -- SFT
    000548 => x"be0c", -- BL
    000549 => x"bfc8", -- BL
    000550 => x"3d45", -- SFT
    000551 => x"3d25", -- SFT
    000552 => x"3d25", -- SFT
    000553 => x"3d25", -- SFT
    000554 => x"be06", -- BL
    000555 => x"bfc2", -- BL
    000556 => x"0140", -- MOV
    000557 => x"be03", -- BL
    000558 => x"bfbf", -- BL
    000559 => x"3460", -- RET
    000560 => x"c08f", -- LDIL
    000561 => x"2121", -- AND
    000562 => x"c089", -- LDIL
    000563 => x"181a", -- CMP
    000564 => x"8803", -- BCS
    000565 => x"c0b0", -- LDIL
    000566 => x"bc02", -- B
    000567 => x"c0b7", -- LDIL
    000568 => x"0892", -- ADD
    000569 => x"3470", -- RET
    000570 => x"ed0b", -- MCR
    000571 => x"ec22", -- MRC
    000572 => x"dc03", -- STB
    000573 => x"b9fe", -- BTS
    000574 => x"ec23", -- MRC
    000575 => x"3470", -- RET
    000576 => x"00f0", -- MOV
    000577 => x"c050", -- LDIL
    000578 => x"c837", -- LDIH
    000579 => x"ed0a", -- MCR
    000580 => x"c001", -- LDIL
    000581 => x"ed0c", -- MCR
    000582 => x"c006", -- LDIL
    000583 => x"bff3", -- BL
    000584 => x"c050", -- LDIL
    000585 => x"c83f", -- LDIH
    000586 => x"ed0a", -- MCR
    000587 => x"c000", -- LDIL
    000588 => x"c805", -- LDIH
    000589 => x"bfed", -- BL
    000590 => x"dc01", -- STB
    000591 => x"b805", -- BTS
    000592 => x"c53e", -- LDIL
    000593 => x"c907", -- LDIH
    000594 => x"bf8d", -- BL
    000595 => x"bc42", -- B
    000596 => x"c040", -- LDIL
    000597 => x"c83f", -- LDIH
    000598 => x"ed0a", -- MCR
    000599 => x"c001", -- LDIL
    000600 => x"ed0c", -- MCR
    000601 => x"3c20", -- SFT
    000602 => x"c802", -- LDIH
    000603 => x"bfdf", -- BL
    000604 => x"03a0", -- MOV
    000605 => x"cb80", -- LDIH
    000606 => x"3ff0", -- SFT
    000607 => x"0030", -- MOV
    000608 => x"c800", -- LDIH
    000609 => x"2407", -- ORR
    000610 => x"bfd8", -- BL
    000611 => x"2800", -- CLR
    000612 => x"ed0c", -- MCR
    000613 => x"c050", -- LDIL
    000614 => x"c83f", -- LDIH
    000615 => x"ed0a", -- MCR
    000616 => x"c001", -- LDIL
    000617 => x"ed0c", -- MCR
    000618 => x"c000", -- LDIL
    000619 => x"c805", -- LDIH
    000620 => x"bfce", -- BL
    000621 => x"dc00", -- STB
    000622 => x"b9fc", -- BTS
    000623 => x"3410", -- RET
    000624 => x"00f0", -- MOV
    000625 => x"c040", -- LDIL
    000626 => x"c83f", -- LDIH
    000627 => x"ed0a", -- MCR
    000628 => x"c001", -- LDIL
    000629 => x"ed0c", -- MCR
    000630 => x"3c20", -- SFT
    000631 => x"c803", -- LDIH
    000632 => x"bfc2", -- BL
    000633 => x"0020", -- MOV
    000634 => x"c800", -- LDIH
    000635 => x"3c00", -- SFT
    000636 => x"bfbe", -- BL
    000637 => x"29b3", -- CLR
    000638 => x"ed3c", -- MCR
    000639 => x"0180", -- MOV
    000640 => x"c980", -- LDIH
    000641 => x"3410", -- RET
    000642 => x"e5b0", -- CDP
    000643 => x"ec30", -- MRC
    000644 => x"dc06", -- STB
    000645 => x"b9fe", -- BTS
    000646 => x"c306", -- LDIL
    000647 => x"200e", -- ANDS
    000648 => x"840a", -- BNE
    000649 => x"ecb1", -- MRC
    000650 => x"ef32", -- MRC
    000651 => x"2800", -- CLR
    000652 => x"009a", -- INCS
    000653 => x"0f60", -- ADC
    000654 => x"ed99", -- MCR
    000655 => x"edea", -- MCR
    000656 => x"ef34", -- MRC
    000657 => x"3470", -- RET
    000658 => x"c550", -- LDIL
    000659 => x"c907", -- LDIH
    000660 => x"bf4b", -- BL
    000661 => x"c55e", -- LDIL
    000662 => x"c907", -- LDIH
    000663 => x"bf48", -- BL
    000664 => x"bf5a", -- BL
    000665 => x"2800", -- CLR
    000666 => x"3400", -- GT
    000667 => x"0170", -- MOV
    000668 => x"bf56", -- BL
    000669 => x"c08d", -- LDIL
    000670 => x"1809", -- CMP
    000671 => x"f702", -- RBAEQ
    000672 => x"c088", -- LDIL
    000673 => x"1809", -- CMP
    000674 => x"8034", -- BEQ
    000675 => x"bdf9", -- B
    000676 => x"c528", -- LDIL
    000677 => x"c906", -- LDIH
    000678 => x"bf39", -- BL
    000679 => x"bf50", -- BL
    000680 => x"edca", -- MCR
    000681 => x"bf4e", -- BL
    000682 => x"edc9", -- MCR
    000683 => x"bff0", -- BL
    000684 => x"bf3c", -- BL
    000685 => x"c536", -- LDIL
    000686 => x"c906", -- LDIH
    000687 => x"bf30", -- BL
    000688 => x"bf47", -- BL
    000689 => x"02c0", -- MOV
    000690 => x"bfe9", -- BL
    000691 => x"bf35", -- BL
    000692 => x"345d", -- TEQ
    000693 => x"8021", -- BEQ
    000694 => x"06d1", -- DEC
    000695 => x"bf31", -- BL
    000696 => x"c0a4", -- LDIL
    000697 => x"bf34", -- BL
    000698 => x"ee32", -- MRC
    000699 => x"bf61", -- BL
    000700 => x"ee31", -- MRC
    000701 => x"bf5f", -- BL
    000702 => x"c0ba", -- LDIL
    000703 => x"bf2e", -- BL
    000704 => x"c0a0", -- LDIL
    000705 => x"bf2c", -- BL
    000706 => x"bfc0", -- BL
    000707 => x"0260", -- MOV
    000708 => x"bf58", -- BL
    000709 => x"c320", -- LDIL
    000710 => x"c1ae", -- LDIL
    000711 => x"00e0", -- MOV
    000712 => x"bf25", -- BL
    000713 => x"3cc0", -- SFT
    000714 => x"c880", -- LDIH
    000715 => x"181e", -- CMP
    000716 => x"f8c3", -- MVHI
    000717 => x"bf20", -- BL
    000718 => x"00c0", -- MOV
    000719 => x"c880", -- LDIH
    000720 => x"181e", -- CMP
    000721 => x"f8c3", -- MVHI
    000722 => x"bf1b", -- BL
    000723 => x"eca0", -- MRC
    000724 => x"dc9f", -- STBI
    000725 => x"b9df", -- BTS
    000726 => x"bf12", -- BL
    000727 => x"c69a", -- LDIL
    000728 => x"ca80", -- LDIH
    000729 => x"3450", -- GT
    000730 => x"0d0a", -- .DW
    000731 => x"0d0a", -- .DW
    000732 => x"4174", -- .DW
    000733 => x"6c61", -- .DW
    000734 => x"732d", -- .DW
    000735 => x"324b", -- .DW
    000736 => x"2042", -- .DW
    000737 => x"6f6f", -- .DW
    000738 => x"746c", -- .DW
    000739 => x"6f61", -- .DW
    000740 => x"6465", -- .DW
    000741 => x"7220", -- .DW
    000742 => x"2d20", -- .DW
    000743 => x"5632", -- .DW
    000744 => x"3031", -- .DW
    000745 => x"3430", -- .DW
    000746 => x"3531", -- .DW
    000747 => x"360d", -- .DW
    000748 => x"0a62", -- .DW
    000749 => x"7920", -- .DW
    000750 => x"5374", -- .DW
    000751 => x"6570", -- .DW
    000752 => x"6861", -- .DW
    000753 => x"6e20", -- .DW
    000754 => x"4e6f", -- .DW
    000755 => x"6c74", -- .DW
    000756 => x"696e", -- .DW
    000757 => x"672c", -- .DW
    000758 => x"2073", -- .DW
    000759 => x"746e", -- .DW
    000760 => x"6f6c", -- .DW
    000761 => x"7469", -- .DW
    000762 => x"6e67", -- .DW
    000763 => x"4067", -- .DW
    000764 => x"6d61", -- .DW
    000765 => x"696c", -- .DW
    000766 => x"2e63", -- .DW
    000767 => x"6f6d", -- .DW
    000768 => x"0d0a", -- .DW
    000769 => x"7777", -- .DW
    000770 => x"772e", -- .DW
    000771 => x"6f70", -- .DW
    000772 => x"656e", -- .DW
    000773 => x"636f", -- .DW
    000774 => x"7265", -- .DW
    000775 => x"732e", -- .DW
    000776 => x"6f72", -- .DW
    000777 => x"672f", -- .DW
    000778 => x"7072", -- .DW
    000779 => x"6f6a", -- .DW
    000780 => x"6563", -- .DW
    000781 => x"742c", -- .DW
    000782 => x"6174", -- .DW
    000783 => x"6c61", -- .DW
    000784 => x"735f", -- .DW
    000785 => x"636f", -- .DW
    000786 => x"7265", -- .DW
    000787 => x"0d0a", -- .DW
    000788 => x"0000", -- .DW
    000789 => x"0d0a", -- .DW
    000790 => x"426f", -- .DW
    000791 => x"6f74", -- .DW
    000792 => x"2070", -- .DW
    000793 => x"6167", -- .DW
    000794 => x"653a", -- .DW
    000795 => x"2030", -- .DW
    000796 => x"7800", -- .DW
    000797 => x"0d0a", -- .DW
    000798 => x"436c", -- .DW
    000799 => x"6f63", -- .DW
    000800 => x"6b28", -- .DW
    000801 => x"487a", -- .DW
    000802 => x"293a", -- .DW
    000803 => x"2030", -- .DW
    000804 => x"7800", -- .DW
    000805 => x"426f", -- .DW
    000806 => x"6f74", -- .DW
    000807 => x"696e", -- .DW
    000808 => x"670d", -- .DW
    000809 => x"0a00", -- .DW
    000810 => x"4275", -- .DW
    000811 => x"726e", -- .DW
    000812 => x"2045", -- .DW
    000813 => x"4550", -- .DW
    000814 => x"524f", -- .DW
    000815 => x"4d0d", -- .DW
    000816 => x"0a00", -- .DW
    000817 => x"4177", -- .DW
    000818 => x"6169", -- .DW
    000819 => x"7469", -- .DW
    000820 => x"6e67", -- .DW
    000821 => x"2069", -- .DW
    000822 => x"6d61", -- .DW
    000823 => x"6765", -- .DW
    000824 => x"2e2e", -- .DW
    000825 => x"2e0d", -- .DW
    000826 => x"0a00", -- .DW
    000827 => x"5374", -- .DW
    000828 => x"6172", -- .DW
    000829 => x"7469", -- .DW
    000830 => x"6e67", -- .DW
    000831 => x"2069", -- .DW
    000832 => x"6d61", -- .DW
    000833 => x"6765", -- .DW
    000834 => x"2000", -- .DW
    000835 => x"446f", -- .DW
    000836 => x"776e", -- .DW
    000837 => x"6c6f", -- .DW
    000838 => x"6164", -- .DW
    000839 => x"2063", -- .DW
    000840 => x"6f6d", -- .DW
    000841 => x"706c", -- .DW
    000842 => x"6574", -- .DW
    000843 => x"650d", -- .DW
    000844 => x"0a00", -- .DW
    000845 => x"5061", -- .DW
    000846 => x"6765", -- .DW
    000847 => x"2028", -- .DW
    000848 => x"3468", -- .DW
    000849 => x"293a", -- .DW
    000850 => x"2024", -- .DW
    000851 => x"0000", -- .DW
    000852 => x"4164", -- .DW
    000853 => x"6472", -- .DW
    000854 => x"2028", -- .DW
    000855 => x"3868", -- .DW
    000856 => x"293a", -- .DW
    000857 => x"2024", -- .DW
    000858 => x"0000", -- .DW
    000859 => x"2377", -- .DW
    000860 => x"6f72", -- .DW
    000861 => x"6473", -- .DW
    000862 => x"2028", -- .DW
    000863 => x"3468", -- .DW
    000864 => x"293a", -- .DW
    000865 => x"2024", -- .DW
    000866 => x"0000", -- .DW
    000867 => x"4368", -- .DW
    000868 => x"6563", -- .DW
    000869 => x"6b73", -- .DW
    000870 => x"756d", -- .DW
    000871 => x"3a20", -- .DW
    000872 => x"2400", -- .DW
    000873 => x"0d0a", -- .DW
    000874 => x"636d", -- .DW
    000875 => x"642f", -- .DW
    000876 => x"626f", -- .DW
    000877 => x"6f74", -- .DW
    000878 => x"2d73", -- .DW
    000879 => x"7769", -- .DW
    000880 => x"7463", -- .DW
    000881 => x"683a", -- .DW
    000882 => x"0d0a", -- .DW
    000883 => x"2030", -- .DW
    000884 => x"2f27", -- .DW
    000885 => x"3030", -- .DW
    000886 => x"273a", -- .DW
    000887 => x"2028", -- .DW
    000888 => x"5265", -- .DW
    000889 => x"2d29", -- .DW
    000890 => x"5374", -- .DW
    000891 => x"6172", -- .DW
    000892 => x"7420", -- .DW
    000893 => x"636f", -- .DW
    000894 => x"6e73", -- .DW
    000895 => x"6f6c", -- .DW
    000896 => x"650d", -- .DW
    000897 => x"0a20", -- .DW
    000898 => x"312f", -- .DW
    000899 => x"2730", -- .DW
    000900 => x"3127", -- .DW
    000901 => x"3a20", -- .DW
    000902 => x"426f", -- .DW
    000903 => x"6f74", -- .DW
    000904 => x"2055", -- .DW
    000905 => x"4152", -- .DW
    000906 => x"540d", -- .DW
    000907 => x"0a20", -- .DW
    000908 => x"322f", -- .DW
    000909 => x"2731", -- .DW
    000910 => x"3027", -- .DW
    000911 => x"3a20", -- .DW
    000912 => x"426f", -- .DW
    000913 => x"6f74", -- .DW
    000914 => x"2045", -- .DW
    000915 => x"4550", -- .DW
    000916 => x"524f", -- .DW
    000917 => x"4d0d", -- .DW
    000918 => x"0a20", -- .DW
    000919 => x"332f", -- .DW
    000920 => x"2731", -- .DW
    000921 => x"3127", -- .DW
    000922 => x"3a20", -- .DW
    000923 => x"426f", -- .DW
    000924 => x"6f74", -- .DW
    000925 => x"206d", -- .DW
    000926 => x"656d", -- .DW
    000927 => x"6f72", -- .DW
    000928 => x"790d", -- .DW
    000929 => x"0a00", -- .DW
    000930 => x"2034", -- .DW
    000931 => x"3a20", -- .DW
    000932 => x"426f", -- .DW
    000933 => x"6f74", -- .DW
    000934 => x"2057", -- .DW
    000935 => x"420d", -- .DW
    000936 => x"0a20", -- .DW
    000937 => x"703a", -- .DW
    000938 => x"2042", -- .DW
    000939 => x"7572", -- .DW
    000940 => x"6e20", -- .DW
    000941 => x"4545", -- .DW
    000942 => x"5052", -- .DW
    000943 => x"4f4d", -- .DW
    000944 => x"0d0a", -- .DW
    000945 => x"2064", -- .DW
    000946 => x"3a20", -- .DW
    000947 => x"5241", -- .DW
    000948 => x"4d20", -- .DW
    000949 => x"6475", -- .DW
    000950 => x"6d70", -- .DW
    000951 => x"0d0a", -- .DW
    000952 => x"2072", -- .DW
    000953 => x"3a20", -- .DW
    000954 => x"5265", -- .DW
    000955 => x"7365", -- .DW
    000956 => x"740d", -- .DW
    000957 => x"0a20", -- .DW
    000958 => x"773a", -- .DW
    000959 => x"2057", -- .DW
    000960 => x"4220", -- .DW
    000961 => x"6475", -- .DW
    000962 => x"6d70", -- .DW
    000963 => x"0d0a", -- .DW
    000964 => x"0000", -- .DW
    000965 => x"636d", -- .DW
    000966 => x"643a", -- .DW
    000967 => x"3e20", -- .DW
    000968 => x"0000", -- .DW
    000969 => x"494d", -- .DW
    000970 => x"4147", -- .DW
    000971 => x"4520", -- .DW
    000972 => x"4552", -- .DW
    000973 => x"5221", -- .DW
    000974 => x"0d0a", -- .DW
    000975 => x"0000", -- .DW
    000976 => x"0d0a", -- .DW
    000977 => x"4952", -- .DW
    000978 => x"5120", -- .DW
    000979 => x"4552", -- .DW
    000980 => x"5221", -- .DW
    000981 => x"0d0a", -- .DW
    000982 => x"0000", -- .DW
    000983 => x"4348", -- .DW
    000984 => x"4543", -- .DW
    000985 => x"4b53", -- .DW
    000986 => x"554d", -- .DW
    000987 => x"2045", -- .DW
    000988 => x"5252", -- .DW
    000989 => x"210d", -- .DW
    000990 => x"0a00", -- .DW
    000991 => x"5350", -- .DW
    000992 => x"492f", -- .DW
    000993 => x"4545", -- .DW
    000994 => x"5052", -- .DW
    000995 => x"4f4d", -- .DW
    000996 => x"2045", -- .DW
    000997 => x"5252", -- .DW
    000998 => x"210d", -- .DW
    000999 => x"0a00", -- .DW
    001000 => x"5742", -- .DW
    001001 => x"2042", -- .DW
    001002 => x"5553", -- .DW
    001003 => x"2045", -- .DW
    001004 => x"5252", -- .DW
    001005 => x"210d", -- .DW
    001006 => x"0a00", -- .DW
    001007 => x"5072", -- .DW
    001008 => x"6573", -- .DW
    001009 => x"7320", -- .DW
    001010 => x"616e", -- .DW
    001011 => x"7920", -- .DW
    001012 => x"6b65", -- .DW
    001013 => x"790d", -- .DW
    001014 => x"0a00", -- .DW
    others => x"0000"  -- NOP
   );
  ------------------------------------------------------

begin

  -- Memory Access ---------------------------------------------------------------------------------------
  -- --------------------------------------------------------------------------------------------------------
    mem_file_access: process(clk_i)
    begin
      if rising_edge(clk_i) then
        -- data read --
        if (d_en_i = '1') then -- valid access
          if (word_mode_en_c = true) then -- read data access
            d_dat_o <= boot_mem_file_c(to_integer(unsigned(d_adr_i(log2_mem_size_c-1 downto 0))));
          else
            d_dat_o <= boot_mem_file_c(to_integer(unsigned(d_adr_i(log2_mem_size_c downto 1))));
          end if;
        end if;
        -- instruction read --
        if (word_mode_en_c = true) then
          i_dat_o <= boot_mem_file_c(to_integer(unsigned(i_adr_i(log2_mem_size_c-1 downto 0))));
        else
          i_dat_o <= boot_mem_file_c(to_integer(unsigned(i_adr_i(log2_mem_size_c downto 1))));
        end if;
      end if;
    end process mem_file_access;



end boot_mem_structure;
