library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity HitMiss_test is

end HitMiss_test;

architecture test of HitMiss_test is
component HitMiss
    port (
        clk : in std_logic;
        CacheTag : in std_logic_vector(1 downto 0);
        TagInp   : in std_logic_vector(1 downto 0);
        r_w      : in std_logic;
        valid    : in std_logic;
        readhit   : out std_logic;
        writemiss : out std_logic;
        writehit  : out std_logic;
        readmiss  : out std_logic);
end component;

for inst1: HitMiss use entity work.HitMiss(structural);
    signal clk : std_logic;
    signal CacheTag : std_logic_vector(1 downto 0);
    signal TagInp   : std_logic_vector(1 downto 0);
    signal r_w      : std_logic;
    signal valid    : std_logic;
    signal readhit   : std_logic;
    signal writemiss : std_logic;
    signal writehit  : std_logic;
    signal readmiss  : std_logic;
    signal clock : std_logic;

    begin
    inst1 : HitMiss port map(clock, CacheTag, TagInp, r_w, valid, readhit, writemiss, writehit, readmiss);

    tclk: process begin
        clock<='0','1' after 5 ns;
        wait for 10 ns;
    end process tclk;

    io_process: process
        file infile  : text is in "HM_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "HM_out.txt"; -- Put output results in file called "alu_4out.txt"
        variable clk_i, r_w_i, valid_i, readhit_i, writemiss_i, writehit_i, readmiss_i: std_logic; -- Declare 4-bit input variable
        variable CacheTag_i, TagInp_i : std_logic_vector(1 downto 0);
        variable buf : line;

        begin

            while not (endfile(infile)) loop
                -- Readline for input file declared below
                readline(infile,buf);
                read (buf,r_w_i);
                r_w <= r_w_i;
            
                readline(infile,buf);
                read (buf,valid_i);
                valid <= valid_i;
    
                readline(infile,buf);
                read (buf,CacheTag_i);
                CacheTag <= CacheTag_i;
    
                readline(infile,buf);
                read (buf,TagInp_i);
                TagInp <= TagInp_i;
    
                wait until falling_edge(clock);
                -- output
                readhit_i:= readhit;
                writemiss_i := writemiss;
                writehit_i := writehit;
                readmiss_i := readmiss;

    
                write(buf,readhit_i);
                write(buf,writemiss_i);
                write(buf,writehit_i);
                write(buf,readmiss_i);
                writeline(outfile,buf);
    
            end loop;
    
        end process io_process;
    
    end test;
    

    -- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder HitMiss_test.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var HitMiss_test
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var HitMiss_test