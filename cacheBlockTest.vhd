library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity cacheBlockTest is
end cacheBlockTest;

architecture test of cacheBlockTest is 
    
component cacheBlock
    port (
        clk : in std_logic;
        rst : in std_logic;
        sBlock : in std_logic;
        sByte1 : in std_logic;
        sByte2 : in std_logic;
        sByte3 : in std_logic;
        sByte4 : in std_logic;
        r_w : in std_logic;
        CPU_bits : in std_logic_vector(1 downto 0);
        wrD : in std_logic_vector(7 downto 0);
        rdD : inout std_logic_vector(7 downto 0));
end component;

for inst1: cacheBlock use entity work.cacheBlock(structural);
    signal clk : std_logic;
    signal rst : std_logic;
    signal sBlock : std_logic;
    signal sByte1 : std_logic;
    signal sByte2 : std_logic;
    signal sByte3 : std_logic;
    signal sByte4 : std_logic;
    signal r_w : std_logic;
    signal CPU_bits : std_logic_vector(1 downto 0);
    signal wrD : std_logic_vector(7 downto 0);
    signal rdD : std_logic_vector(7 downto 0);
    signal clock : std_logic;

    begin
    inst1 : cacheBlock port map(clock, rst, sBlock, sByte1,sByte2,sByte3,sByte4, r_w, CPU_bits, wrD, rdD);

    tclk : process begin  -- process clk

        clock<='0','1' after 5 ns;
        wait for 10 ns;

    end process tclk;

    io_process: process
        file infile  : text is in "cBlk_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "cBlk_out.txt"; -- Put output results in file called "alu_4out.txt"
        variable clk_i, rst_i, sBlock_i, sByte1_i, sByte2_i, sByte3_i, sByte4_i,r_w_i: std_logic; -- Declare 4-bit input variable
        variable CPU_bits_i : std_logic_vector(1 downto 0);
        variable wrD_i, rdD_i: std_logic_vector(7 downto 0); -- Declare more input varaibles
        variable buf : line;

        begin

        while not (endfile(infile)) loop
            -- Readline for input file declared below
            readline(infile,buf);
            read (buf,rst_i);
            rst <= rst_i;
        
            readline(infile,buf);
            read (buf,sBlock_i);
            sBlock <= sBlock_i;

            readline(infile,buf);
            read (buf,sByte1_i);
            sByte1 <= sByte1_i;

            readline(infile,buf);
            read (buf,sByte2_i);
            sByte2 <= sByte2_i;

            readline(infile,buf);
            read (buf,sByte3_i);
            sByte3 <= sByte3_i;

            readline(infile,buf);
            read (buf,sByte4_i);
            sByte4 <= sByte4_i;

            readline(infile,buf);
            read (buf,CPU_bits_i);
            CPU_bits <= CPU_bits_i;

            readline(infile,buf);
            read (buf,r_w_i);
            r_w <= r_w_i;

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
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder cacheBlockTest.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var cacheBlockTest
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var cacheBlockTest