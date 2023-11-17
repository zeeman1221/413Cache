----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2023 07:08:35 PM
-- Design Name: 
-- Module Name: testGenerateReadMiss - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2023 07:08:35 PM
-- Design Name: 
-- Module Name: testGenerateReadMiss - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testGenerateReadMiss is
--  Port ( );
end testGenerateReadMiss;

architecture test of testGenerateReadMiss is
    component generateReadMiss
    port (
            CPU_A : in std_logic_vector(5 downto 0);
    CPU_D : out std_logic_vector(7 downto 0);
    r_w   : in std_logic;
    start : in std_logic;
    clk   : in std_logic;
    rst   : in std_logic;
    MEM_D : in std_logic_vector(7 downto 0);
    busy  : out std_logic;
    enable : out std_logic;
    MEM_A : out std_logic_vector(5 downto 0)
);

    end component;
    --for inst1: generateReadMiss use entity work.generateReadMiss(structural);


    signal clk : std_logic;
    signal rst : std_logic;
    signal r_w : std_logic;
    signal start : std_logic;
    signal CPU_A : std_logic_vector(5 downto 0);
    signal CPU_D : std_logic_vector(7 downto 0);
    signal MEM_A : std_logic_vector(5 downto 0);
    signal MEM_D : std_logic_vector(7 downto 0);
    signal busy : std_logic;
    signal enable : std_logic;

begin
    inst1 : generateReadMiss port map(CPU_A, CPU_D, r_w, start, clk, rst, MEM_D, busy, enable, MEM_A);

tclk : process
    begin  -- process clk

clk<='0','1' after 5 ns;
wait for 10 ns;
end process tclk;

--io_process: process
--        file infile  : text is in "GRM_in.txt"; -- Use input file called "alu_4in.txt" to test inputs
--        file outfile : text is out "GRM_out.txt"; -- Put output results in file called "alu_4out.txt"
--        variable rst_i, r_w_i, start_i, busy_i, HitMiss_i: std_logic; -- Declare 4-bit input variable
--        variable CPU_A_i , MEM_A_i: std_logic_vector(5 downto 0);
--        variable MEM_D_i , CPU_D_i: std_logic_vector(7 downto 0); -- Declare more input varaibles
--        variable buf : line;

--        begin

--        while not (endfile(infile)) loop
--            -- Readline for input file declared below
--            readline(infile,buf);
--            read (buf,rst_i);
--            rst <= rst_i;
        
--            readline(infile,buf);
--            read (buf,r_w_i);
--            r_w <= r_w_i;

--            readline(infile,buf);
--            read (buf,start_i);
--            start <= start_i;

--            readline(infile,buf);
--            read (buf,CPU_A_i);
--            CPU_A <= CPU_A_i;

--            readline(infile,buf);
--            read (buf,MEM_D_i);
--            MEM_D <= MEM_D_i;

--            readline(infile,buf);
--            read (buf,HitMiss_i);
--            HitMiss <= HitMiss_i;


--            wait until falling_edge(clk);
--            -- output
--            busy_i := busy;
--            CPU_D_i := CPU_D;
--            MEM_A_i := MEM_A;


--            write(buf,busy_i);
--            writeline(outfile,buf);

--            write(buf,CPU_D_i);
--            writeline(outfile,buf);

--            write(buf,MEM_A_i);
--            writeline(outfile,buf);

--        end loop;

--    end process io_process;
manualInp: process 
begin
rst <= '0';
r_w <= '1';
start <= '1';
CPU_A(0) <= '0';
CPU_A(1) <= '0';
CPU_A(2) <= '1';
CPU_A(3) <= '0';
CPU_A(4) <= '0';
CPU_A(5) <= '0';

MEM_D(0) <= '1';
MEM_D(1) <= '1';
MEM_D(2) <= '1';
MEM_D(3) <= '1';
MEM_D(4) <= '1';
MEM_D(5) <= '1';
MEM_D(6) <= '1';
MEM_D(7) <= '1';

--CPU_D(0) <= '0';
--CPU_D(1) <= '0';
--CPU_D(2) <= '0';
--CPU_D(3) <= '0';
--CPU_D(4) <= '0';
--CPU_D(5) <= '0';
--CPU_D(6) <= '0';
--CPU_D(7) <= '0';

wait for 10 ns;
start <= '0';

wait for 50 ns;

end process manualInp;
end test;


