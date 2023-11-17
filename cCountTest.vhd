library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity cCountTest is
end cCountTest;

architecture test of cCountTest is 
    component cCount
    port (
        clk	     : in  std_logic;
        busy     : in  std_logic;
        rst      : in  std_logic;
        clk2     : out std_logic;
        clk3     : out std_logic;
        clk4     : out std_logic;
        clk5     : out std_logic;
        clk6     : out std_logic;
        clk7     : out std_logic;
        clk8     : out std_logic;
        clk9     : out std_logic;    
        clk10    : out std_logic;
        clk11     : out std_logic;
        clk12    : out std_logic;
        clk13     : out std_logic;
        clk14    : out std_logic;
        clk15     : out std_logic;
        clk16    : out std_logic;
        clk17     : out std_logic;
        clk18     : out std_logic;
        clk19    : out std_logic);
  end component;

for inst1: cCount use entity work.cCount(structural);
signal rst  : std_logic;
signal busy : std_logic;
signal clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, clk10, clk11, clk12, clk13, clk14, clk15, clk16, clk17, clk18, clk19 : std_logic;
signal clk : std_logic;
begin
    inst1 : cCount port map(clk, busy, rst, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, clk10, clk11, clk12, clk13, clk14, clk15, clk16, clk17, clk18, clk19);

tclk : process
        begin  -- process clk

    clk<='0','1' after 5 ns;
    wait for 10 ns;

  end process tclk;

io_process: process
    file infile  : text is in "cCount_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
    file outfile : text is out "cCount_out.txt"; -- Put output results in file called "alu_4out.txt"
    variable busy_i, rst_i: std_logic; -- Declare 4-bit input variable
    variable buf : line;

begin

    while not (endfile(infile)) loop
        -- Readline for input file declared below
        readline(infile,buf);
        read (buf,busy_i);
        busy <= busy_i;
    
        readline(infile,buf);
        read (buf,rst_i);
        rst <= rst_i;

        wait until falling_edge(clk);


        end loop;

end process io_process;

end test;

-- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder cacheByteTest.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var cacheByteTest
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var cacheByteTest