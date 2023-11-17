library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity cacheByteTest is
end cacheByteTest;

architecture test of cacheByteTest is 
    component cacheByte
        port (
        wrEn : in std_logic;
        rdEn : in std_logic;
        wrD : in std_logic_vector(7 downto 0);
        rdD : out std_logic_vector(7 downto 0)
    );
  end component;

for inst1: cacheByte use entity work.cacheByte(structural);
signal wrEn : std_logic;
signal rdEn : std_logic;
signal wrD : std_logic_vector(7 downto 0);
signal rdD : std_logic_vector(7 downto 0);
signal clock : std_logic;
begin
    inst1 : cacheByte port map(wrEn=>wrEn, rdEn=>rdEn, wrD=>wrD, rdD=>rdD);

tclk : process
        begin  -- process clk

    clock<='0','1' after 5 ns;
    wait for 10 ns;

  end process tclk;

io_process: process
    file infile  : text is in "cByte_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
    file outfile : text is out "cByte_out.txt"; -- Put output results in file called "alu_4out.txt"
    variable wrEn_i, rdEn_i: std_logic; -- Declare 4-bit input variable
    variable wrD_i, rdD_i: std_logic_vector(7 downto 0); -- Declare more input varaibles
    variable buf : line;

begin

    while not (endfile(infile)) loop
        -- Readline for input file declared below
        readline(infile,buf);
        read (buf,wrEn_i);
        wrEn <= wrEn_i;
    
        readline(infile,buf);
        read (buf,rdEn_i);
        rdEn <= rdEn_i;

        readline(infile,buf);
        read (buf,wrD_i);
        wrD <= wrD_i;

        wait until falling_edge(clock);
        -- output
        rdD_i := rdD;

        write(buf,rdD_i);
        writeline(outfile,buf);

        end loop;

end process io_process;

end test;

-- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder cacheByteTest.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var cacheByteTest
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var cacheByteTest