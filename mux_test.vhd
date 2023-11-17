library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity mux_test is
end mux_test;

architecture test of mux_test is 

component mux
    port (
        inp1 : in std_logic;
        inp2 : in std_logic;
        inp3 : in std_logic;
        inp4 : in std_logic;
        sig1 : in std_logic;
        sig2 : in std_logic;
        output : out std_logic
    );
end component;

for inst1: mux use entity work.mux(structural);

    signal inp1 : std_logic;
    signal inp2 : std_logic;
    signal inp3 : std_logic;
    signal inp4 : std_logic;
    signal sig1 : std_logic;
    signal sig2 : std_logic;
    signal O : std_logic;
    signal clock : std_logic;

    begin
    inst1 : mux port map(inp1, inp2, inp3, inp4,sig1,sig2,O);

    tclk : process begin  -- process clk
        clock<='0','1' after 5 ns;
        wait for 10 ns;
    end process tclk;


    io_process: process
        file infile  : text is in "mux_i.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "mux_o.txt"; -- Put output results in file called "alu_4out.txt"
        variable inp1_i, inp2_i, inp3_i, inp4_i, sig1_i, sig2_i: std_logic; -- Declare 4-bit input variable
        variable output_i: std_logic; -- Declare more input varaibles
        variable buf : line;


        begin

            while not (endfile(infile)) loop
                -- Readline for input file declared below
                readline(infile,buf);
                read (buf,inp1_i);
                inp1 <= inp1_i;
                
                readline(infile,buf);
                read (buf,inp2_i);
                inp2 <= inp2_i;
            
                readline(infile,buf);
                read (buf,inp3_i);
                inp3 <= inp3_i;
            
                readline(infile,buf);
                read (buf, inp4_i);
                inp4 <= inp4_i;
            
            
                readline(infile,buf);
                read (buf,sig1_i);
                sig1 <= sig1_i;
            
                readline(infile,buf);
                read (buf,sig2_i);
                sig2 <= sig2_i;

                wait until falling_edge(clock);
                -- output
                output_i := O;
            
                write(buf,output_i);
                writeline(outfile,buf);

            end loop;

    end process io_process;

end test;

                -- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder mux_test.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var mux_test
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var mux_test