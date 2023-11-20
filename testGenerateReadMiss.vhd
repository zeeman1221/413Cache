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
    CPU_DO : inout std_logic_vector(7 downto 0);
    CPU_DI : inout std_logic_vector(7 downto 0);
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
    signal CPU_DO : std_logic_vector(7 downto 0);
    signal CPU_DI : std_logic_vector(7 downto 0);
    signal MEM_A : std_logic_vector(5 downto 0);
    signal MEM_D : std_logic_vector(7 downto 0);
    signal busy : std_logic;
    signal enable : std_logic;
    signal debug : std_logic;

begin
    inst1 : generateReadMiss port map(CPU_A, CPU_DO, CPU_DI, r_w, start, clk, rst, MEM_D, busy, enable, MEM_A);

tclk : process
    begin  -- process clk

clk<='0','1' after 10 ns;
wait for 20 ns;
end process tclk;


MEMD : process
begin

MEM_D(0) <= '0';
MEM_D(1) <= '0';
MEM_D(2) <= '0';
MEM_D(3) <= '0';
MEM_D(4) <= '0';
MEM_D(5) <= '0';
MEM_D(6) <= '0';
MEM_D(7) <= '0';

wait for 180 ns;
MEM_D(0) <= '1';
MEM_D(1) <= '1';
MEM_D(2) <= '1';
MEM_D(3) <= '1';
MEM_D(4) <= '1';
MEM_D(5) <= '1';
MEM_D(6) <= '1';
MEM_D(7) <= '1';

wait for 40 ns;
MEM_D(0) <= '0';
MEM_D(1) <= '1';
MEM_D(2) <= '0';
MEM_D(3) <= '1';
MEM_D(4) <= '0';
MEM_D(5) <= '1';
MEM_D(6) <= '0';
MEM_D(7) <= '1';

wait for 40 ns;
MEM_D(0) <= '1';
MEM_D(1) <= '0';
MEM_D(2) <= '1';
MEM_D(3) <= '0';
MEM_D(4) <= '1';
MEM_D(5) <= '0';
MEM_D(6) <= '1';
MEM_D(7) <= '0';

wait for 40 ns;
MEM_D(0) <= '1';
MEM_D(1) <= '1';
MEM_D(2) <= '1';
MEM_D(3) <= '1';
MEM_D(4) <= '0';
MEM_D(5) <= '0';
MEM_D(6) <= '0';
MEM_D(7) <= '0';

wait for 40 ns;
MEM_D(0) <= '0';
MEM_D(1) <= '0';
MEM_D(2) <= '0';
MEM_D(3) <= '0';
MEM_D(4) <= '0';
MEM_D(5) <= '0';
MEM_D(6) <= '0';
MEM_D(7) <= '0';
wait;
end process MEMD;

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

wait for 20 ns;
start <= '0';

wait for 340 ns;
CPU_A(0) <= '0';
CPU_A(1) <= '0';
CPU_A(2) <= '0';
CPU_A(3) <= '0';
CPU_A(4) <= '0';
CPU_A(5) <= '0';

wait for 60 ns;
CPU_A(0) <= '0';
CPU_A(1) <= '0';
CPU_A(2) <= '1';
CPU_A(3) <= '0';
CPU_A(4) <= '0';
CPU_A(5) <= '0';
start <= '1';
wait for 20 ns;
start <= '0';

wait for 360 ns;
r_w <= '0';
CPU_DI(0) <= '1';
CPU_DI(1) <= '0';
CPU_DI(2) <= '1';
CPU_DI(3) <= '0';
CPU_DI(4) <= '1';
CPU_DI(5) <= '0';
CPU_DI(6) <= '1';
CPU_DI(7) <= '0';
start<='1';

wait for 20 ns;
start<='0';

wait for 100 ns;
CPU_A(0) <= '0';
CPU_A(1) <= '0';
CPU_A(2) <= '1';
CPU_A(3) <= '0';
CPU_A(4) <= '0';
CPU_A(5) <= '0';
r_w <= '1';
start<= '1';

wait for 20 ns;
start <= '0';

wait for 400 ns;
CPU_A(0) <= '1';
CPU_A(1) <= '1';
CPU_A(2) <= '1';
CPU_A(3) <= '1';
CPU_A(4) <= '1';
CPU_A(5) <= '0';
r_w <= '1';
start <= '1';

wait for 20 ns;
start <= '0';

wait for 160 ns;
rst <= '1';

wait for 200 ns;




end process manualInp;
end test;


