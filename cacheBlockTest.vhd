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
  Hit : in std_logic;
  sBlock : in std_logic;
  sByte1 : in std_logic;
  sByte2 : in std_logic;
  sByte3 : in std_logic;
  sByte4 : in std_logic;
  r_w : in std_logic;
  CPU_bits : in std_logic_vector(1 downto 0);
  rdD : inout std_logic_vector(7 downto 0);
  clk9 : in std_logic;
  clk10 : in std_logic;
  clk12 : in std_logic;
  clk14 : in std_logic;
  MEM_D : in std_logic_vector(7 downto 0);
  clk8bar : in std_logic;
  clk16 : in std_logic);--;
 -- debug : out std_logic);
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
    signal rdD : std_logic_vector(7 downto 0);
    signal MEM_D : std_logic_vector(7 downto 0);
    signal clk9,clk10, clk12, clk14, clk8bar, clk16  : std_logic;
    signal Hit : std_logic;
    signal debug : std_logic;

    begin
    inst1 : cacheBlock port map(clk, rst, Hit, sBlock, sByte1,sByte2,sByte3,sByte4, r_w, CPU_bits, rdD, clk9, clk10, clk12, clk14, MEM_D, clk8bar, clk16);--, debug);

    tclk : process begin  -- process clk

        clk<='0','1' after 5 ns;
        wait for 10 ns;

    end process tclk;

 clks : process begin  -- process clk
 rst<='0';
sBlock<='0';
sByte1<='0';
sByte2<='0';
sByte3<='0';
sByte4<='0';
CPU_Bits(0)<='0';
CPU_Bits(1)<='1';
        clk8bar<='1';
        clk9<='0';
        clk10<='0';
        clk12<='0';
        clk14<='0';
        clk16<='0';
        r_w<='1';
        Hit<='0';
        MEM_D(0)<='0';
MEM_D(1)<='0';
MEM_D(2)<='0';
MEM_D(3)<='0';
MEM_D(4)<='0';
MEM_D(5)<='0';
MEM_D(6)<='0';
MEM_D(7)<='1';
        
        wait for 80ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='1';
MEM_D(7)<='1';
        Hit <='1';
        clk9<='1';
        clk8bar<='0';
        r_w<='0';
        wait for 10 ns;

        wait for 10 ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='1';
MEM_D(7)<='0';
        clk10<='1';
        clk9<='0';
        clk8bar<='0';
        
        wait for 10 ns;

        wait for 10 ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='0';
MEM_D(7)<='0';
        clk10<='0';
        clk12<='1';
        
        wait for 10 ns;

        wait for 10 ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='0';
MEM_D(6)<='0';
MEM_D(7)<='0';
        clk14<='1';
        clk12<='0';
        
        wait for 10 ns;

        wait for 10 ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='1';
MEM_D(7)<='1';
        clk14<='0';
        clk16<='1';
        clk8bar<='1';
         r_w<='1';

        
        wait for 10ns;
        wait for 10ns;
        clk16<='0';
        Hit <='0';
        wait for 20ns;
--        CPU_Bits(0)<='0';
--        CPU_Bits(1)<='0';
        sBlock<='1';
        sByte1<='1';
        Hit<='1';
        
        wait for 20ns;
--        CPU_Bits(0)<='1';
--        CPU_Bits(1)<='0';
        sByte1<='0';
        sByte2<='1';
        
        wait for 20ns;
--        CPU_Bits(0)<='0';
--        CPU_Bits(1)<='1';
        sByte2<='0';
        sByte3<='1';
        
        wait for 20ns;
--        CPU_Bits(0)<='1';
--        CPU_Bits(1)<='1';
        sByte3<='0';
        sByte4<='1';
        
        wait;
    end process clks;



--    io_process: process
--        file infile  : text is in "cBlk_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
--        file outfile : text is out "cBlk_out.txt"; -- Put output results in file called "alu_4out.txt"
--        variable clk_i, rst_i, sBlock_i, sByte1_i, sByte2_i, sByte3_i, sByte4_i,r_w_i: std_logic; -- Declare 4-bit input variable
--        variable CPU_bits_i : std_logic_vector(1 downto 0);
--        variable wrD_i, rdD_i: std_logic_vector(7 downto 0); -- Declare more input varaibles
--        variable buf : line;

--        begin

--        while not (endfile(infile)) loop
--            -- Readline for input file declared below
--            readline(infile,buf);
--            read (buf,rst_i);
--            rst <= rst_i;
        
--            readline(infile,buf);
--            read (buf,sBlock_i);
--            sBlock <= sBlock_i;

--            readline(infile,buf);
--            read (buf,sByte1_i);
--            sByte1 <= sByte1_i;

--            readline(infile,buf);
--            read (buf,sByte2_i);
--            sByte2 <= sByte2_i;

--            readline(infile,buf);
--            read (buf,sByte3_i);
--            sByte3 <= sByte3_i;

--            readline(infile,buf);
--            read (buf,sByte4_i);
--            sByte4 <= sByte4_i;

--            readline(infile,buf);
--            read (buf,CPU_bits_i);
--            CPU_bits <= CPU_bits_i;

--            readline(infile,buf);
--            read (buf,r_w_i);
--            r_w <= r_w_i;

--            readline(infile,buf);
--            read (buf,wrD_i);
--            wrD <= wrD_i;

--            wait until falling_edge(clock);
--            -- output
--            rdD_i := rdD;

--            write(buf,rdD_i);
--            writeline(outfile,buf);

--        end loop;

--    end process io_process;

end test;

-- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder cacheBlockTest.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var cacheBlockTest
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var cacheBlockTest