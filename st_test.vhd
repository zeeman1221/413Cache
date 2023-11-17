library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
library work;

entity sr_test is
end sr_test;

architecture test of sr_test is 

    component sr                      
        port (  
               clk : in std_logic;
               J   : in  std_logic;
               K : in  std_logic;
               q   : out std_logic;
               qbar: out std_logic); 
      end component; 


    signal clk : std_logic;
    signal J : std_logic;
    signal K : std_logic;
    signal q : std_logic;
    signal qbar : std_logic;

    begin
    inst1 : sr port map(clk, J, K, q, qbar);

    tclk : process begin  -- process clk
        clk<='0','1' after 5 ns;
        wait for 10 ns;
    end process tclk;


    io_process: process
        file infile  : text is in "sr_i.txt"; -- Use input file called "alu_4in.txt" to test inputs
        file outfile : text is out "sr_o.txt"; -- Put output results in file called "alu_4out.txt"
        variable J_i, K_i, q_i, qbar_i: std_logic; -- Declare 4-bit input variable
        variable buf : line;


        begin

            while not (endfile(infile)) loop
                -- Readline for input file declared below
                readline(infile,buf);
                read (buf,J_i);
                J <= J_i;
                
                readline(infile,buf);
                read (buf,K_i);
                K <= K_i;
            

                wait until falling_edge(clk);
                -- output
                q_i := q;
                qbar_i := qbar;
            
                write(buf,q_i);
                writeline(outfile,buf);

                write(buf,qbar_i);
                writeline(outfile,buf);

            end loop;

    end process io_process;

end test;

                -- Running commands:
-- run_ncvhdl.bash -messages -linedebug -cdslib cds.lib -hdlvar hdl.var -smartorder mux_test.vhd
-- run_ncelab.bash -messages -access rwc -cdslib cds.lib -hdlvar hdl.var mux_test
-- run_ncsim.bash -input ncsim.run -messages -cdslib cds.lib -hdlvar hdl.var mux_test