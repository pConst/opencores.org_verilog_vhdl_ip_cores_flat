------------------------------------------------------------------------------
-- Author               : Timo Alho
-- e-mail               : timo.a.alho@tut.fi
-- Date                 : 23.06.2004 16:14:32
-- File                 : DCT_core_tester.vhd
-- Design               : VHDL Entity DCT_core_tester.beh
------------------------------------------------------------------------------
-- Description  :
------------------------------------------------------------------------------
-- Version history:
-- 1.0 initial version
-- 1.1 Quantizer parameter is no longer passed through DCT
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY dct;
USE dct.DCT_pkg.ALL;
LIBRARY STD;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DCT_core_tester IS
  PORT(
    DC               : IN  std_logic;
    data_out         : IN  std_logic_vector (DCT_resultw_co-1 DOWNTO 0);
    ready_for_rx     : IN  std_logic;
    wr_out           : IN  std_logic;
    clk              : OUT std_logic;
    data_in          : OUT std_logic_vector (DCT_inputw_co-1 DOWNTO 0);
    next_block_ready : OUT std_logic;
    rst_n            : OUT std_logic;
    wr_new_data      : OUT std_logic
    );

-- Declarations

END DCT_core_tester;

--
ARCHITECTURE beh OF DCT_core_tester IS
  CONSTANT period : time := 50 ns;

  SIGNAL test_clk   : std_logic := '0';
  SIGNAL test_rst_n : std_logic := '0';
  SIGNAL counter    : integer   := 0;

  SIGNAL input_counter  : integer := 0;
  SIGNAL output_counter : integer := 8;

  SIGNAL wr_new_data_r      : std_logic;
  SIGNAL next_block_ready_r : std_logic := '1';
  SIGNAL data_in_r          : std_logic_vector (DCT_inputw_co-1 DOWNTO 0);


  SIGNAL InputFinished     : std_logic := '0';
  SIGNAL LastOutputCounter : integer   := 0;
BEGIN

  --generate clock signal
  Clock : PROCESS

    VARIABLE clk_tmp : std_logic := '0';
  BEGIN
    WHILE (true) LOOP
      WAIT FOR PERIOD/2;
      clk_tmp                    := NOT (clk_tmp);
      test_clk <= clk_tmp;
    END LOOP;
  END PROCESS;

  --generate reset signal
  reset                     : PROCESS (test_clk)
    VARIABLE system_reseted : std_logic := '0';
  BEGIN  -- PROCESS reset
    IF test_clk'event AND test_clk = '1' THEN  -- rising clock edge
      IF (system_reseted = '0') THEN
        test_rst_n <= '0';
        system_reseted                  := '1';
      ELSE
        test_rst_n <= '1';
      END IF;
    END IF;
  END PROCESS reset;

  --feed input data!
  datain             : PROCESS (test_clk)
    FILE FileIn      : text;
    FILE FileIn_ctrl : text;

    VARIABLE files_open : std_logic := '0';
    -- V�liaikaismuutuja, johon luetaan kokonaisluku luetusta rivist�
    VARIABLE integerin  : integer;

    -- V�limuuttuja, johon luetaan tekstirivi tiedostosta
    VARIABLE linein : line;

    --temporary index variable
    VARIABLE temp_data : signed(DCT_inputw_co-1 DOWNTO 0);

  BEGIN  -- PROCESS datain
    IF (test_rst_n = '0') THEN
      --open files
      IF (files_open = '0') THEN
        File_open(Filein, "testdata/dct_test_input.txt", read_mode);
        File_open(FileIn_ctrl, "testdata/dct_input_ctrl.txt", read_mode);
        files_open := '1';
      END IF;

      -- execute the testing cycle in every test_clk cycle
    ELSIF (test_clk = '1' AND test_clk'event) THEN
      wr_new_data_r <= '0';

      IF (endfile(filein_ctrl)) THEN
        --if control file EOF is reached, reopen file.
        File_close(filein_ctrl);
        File_open(filein_ctrl, "testdata/dct_input_ctrl.txt", read_mode);
      END IF;

      IF (endfile(FileIn)) THEN
        --finished reading input data
        InputFinished <= '1';
      END IF;

      IF (input_counter /= 0) THEN
        --DCT can receive some data!
        READLINE(filein_ctrl, linein);
        READ(linein, integerin);
        IF (integerin = 1) THEN
          --new data is available
          IF (NOT ENDFILE(filein)) THEN
            READLINE(filein, linein);
            READ(linein, integerin);
            temp_data := conv_signed(integerin, DCT_inputw_co);
            data_in_r     <= conv_std_logic_vector(temp_data, DCT_inputw_co);
            wr_new_data_r <= '1';
            input_counter <= input_counter-1;
          END IF;
        ELSE
          --no new data available
          wr_new_data_r   <= '0';
          input_counter   <= input_counter;
        END IF;

      ELSIF (ready_for_rx = '1') THEN
        --DCT can receive entire column
        input_counter <= 8;            
      END IF;
    END IF;
  END PROCESS datain;

  dataout              : PROCESS (test_clk)
    FILE FileOut       : text;
    FILE FileReference : text;
    FILE FileOut_ctrl  : text;

    VARIABLE files_open : std_logic := '0';

    VARIABLE tmp       : integer;
    VARIABLE lineout   : line;
    VARIABLE tmp2      : signed(DCT_resultw_co-1 DOWNTO 0);
    VARIABLE integerin : integer;

    VARIABLE linein : line;

  BEGIN  -- PROCESS dataout
    IF (test_rst_n = '0') THEN
      IF (files_open = '0') THEN
        files_open := '1';
        File_open(FileOut, "testdata/dct_test_output.txt", write_mode);
        File_open(FileReference, "testdata/dct_reference_output.txt", read_mode);
        File_open(FileOut_ctrl, "testdata/dct_output_ctrl.txt", read_mode);
      END IF;

      
    ELSIF (test_clk = '1' AND test_clk'event) THEN

      --reopen ctrl file if EOF reached
      IF (endfile(fileout_ctrl)) THEN
        File_close(fileout_ctrl);
        File_open(fileout_ctrl, "testdata/dct_output_ctrl.txt", read_mode);
      END IF;

      --check whether test is finished
      ASSERT (NOT (LastOutputCounter = 64))
        REPORT "TEST PASSED : Peak error is no more than 1. Run matlab-script 'dct_analyze_vectors' if you want more accurate analysis."
        SEVERITY failure;

      IF (wr_out = '1') THEN
        --DCT is writing data out. Lets chech if we can receive it
        IF (output_counter /= 0) THEN
          --write output data to file
          tmp2 := signed(data_out);
          tmp  := conv_integer(tmp2);
          WRITE(LineOut, tmp, left, 6);
          WRITELINE(FileOut, lineout);

          --compare output data with reference data
          readline(FileReference, linein);
          read(linein, integerin);
          ASSERT (ABS(tmp-integerin) < 2)
            REPORT "TEST FAILED : Peak error is more than 1"
            SEVERITY failure;

          --if this is last block
          IF (InputFinished = '1') THEN
            LastOutputCounter <= LastOutputCounter + 1;
          END IF;

        END IF;

        READLINE(fileout_ctrl, linein);
        READ(linein, integerin);
        IF (integerin = 1) THEN
          --we can still receive entire column
          next_block_ready_r <= '1';
          output_counter     <= 8;
        ELSE
          --we can no longer receive entire column
          IF (output_counter > 0) THEN
            output_counter   <= output_counter - 1;
          END IF;
          next_block_ready_r <= '0';
        END IF;

      ELSIF (next_block_ready_r = '0') THEN
        --check if new data can be received
        READLINE(fileout_ctrl, linein);
        READ(linein, integerin);
        IF (integerin = 1) THEN
          --new data can be received (during next clk)
          next_block_ready_r <= '1';
          output_counter     <= 8;
        ELSE
          next_block_ready_r <= '0';
        END IF;
      END IF;
    END IF;

  END PROCESS dataout;

  next_block_ready <= next_block_ready_r;
  rst_n            <= test_rst_n;
  clk              <= test_clk;
  wr_new_data      <= wr_new_data_r;
  data_in          <= data_in_r;


END beh;




