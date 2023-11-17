library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity or4_test is

end or4_test ;

architecture test of or4_test is 

component or4
    port (
        input1 : in std_logic;
        input2 : in std_logic;
        input3 : in std_logic;
        input4 : in std_logic;
        output : out std_logic
    );
end component;

for inst1: or4 use entity work.or4(structural);

    signal input1 : std_logic;
    signal input2 : std_logic;
    signal input3 : std_logic;
    signal input4 : std_logic;
    signal O : std_logic;
    signal clock : std_logic;

    begin
    
    inst1 : or4 port map(input1, input2, input3, input4, O);

    tclk: process begin
        clock <= '0','1' after 5 ns;
        wait for 10 ns;
    end process tclk;


    io_process: process
        file infile  : text is in "or4Input.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "or4Output.txt"; -- Put output results in file called "alu_4out.txt"
        variable input1_i, input2_i, input3_i, input4_i:std_logic; -- Declare 4-bit input variable
        variable output_i: std_logic; -- Declare more input varaibles
        variable buf : line;


        begin

            while not (endfile(infile)) loop
                -- Readline for input file declared below
                readline(infile,buf);
                read (buf,input1_i);
                input1 <= input1_i;
            
                readline(infile,buf);
                read (buf,input2_i);
                input2 <= input2_i;
        
                readline(infile,buf);
                read (buf,input3_i);
                input3 <= input3_i;
        
                readline(infile,buf);
                read (buf, input4_i);
                input4 <= input4_i;

                wait until falling_edge(clock);
                -- output
                output_i := O;
        
                write(buf,output_i);
                writeline(outfile,buf);

            end loop;

        end process io_process;

    end test;


                -- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder or4_test.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var or4_test
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var or4_test