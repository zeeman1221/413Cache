library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity selector_test is
end selector_test;

architecture test of selector_test is 
component selector
    port (
        chipEnable : in std_logic;
        r_w : in std_logic;
        rdEn : out std_logic;
        wrEn : out std_logic
     );
end component;

for inst1: selector use entity work.selector(structural);

    signal chipEnable : std_logic;
    signal r_w : std_logic;
    signal rdEn : std_logic;
    signal wrEn : std_logic;
    signal clock : std_logic;

    begin
    inst1 : selector port map(chipEnable, r_w, rdEn, wrEn);

    tclk : process begin
        clock<='0','1' after 5 ns;
        wait for 10 ns;
    end process tclk;

    io_process: process
        file infile  : text is in "sel_i.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "sel_o.txt"; -- Put output results in file called "alu_4out.txt"
        variable chipEnable_i, r_w_i, rdEn_i, wrEn_i: std_logic; -- Declare 4-bit input variable
        variable buf : line;


        begin
            while not (endfile(infile)) loop
                -- Readline for input file declared below
                readline(infile,buf);
                read (buf,chipEnable_i);
                chipEnable <= chipEnable_i;
                
                readline(infile,buf);
                read (buf,r_w_i);
                r_w <= r_w_i;

                wait until falling_edge(clock);
                -- output
                wrEn_i := wrEn;
                rdEn_i := rdEn;

                write(buf,wrEn_i);
                write(buf,rdEn_i);
                writeline(outfile,buf);

            end loop;

    end process io_process;

end test;


            -- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder selector_test.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var selector_test
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var selector_test
