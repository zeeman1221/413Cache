library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity cacheMemoryTest is
end cacheMemoryTest;

architecture test of cacheMemoryTest is 
    
component cacheMemory
    port ( 
    clk : in std_logic;
    rst : in std_logic;
    r_w : in std_logic;
    CPU_A : in std_logic_vector(5 downto 0);
    CPU_D : out std_logic_vector(7 downto 0);
    Mem_D : in std_logic_vector(7 downto 0);
    HM : out std_logic;
    clk8 : in std_logic;
    clk9 : in std_logic;
    clk10 : in std_logic;
    clk12 : in std_logic;
    clk14 : in std_logic;
    clk16 : in std_logic;
    busy : in std_logic;
    WriteD : in std_logic_vector(7 downto 0);
    clk1 : in std_logic
 );
end component;

for inst1: cacheMemory use entity work.cacheMemory(structural);
    signal clk : std_logic;
    signal rst : std_logic;
    signal r_w : std_logic;
    signal CPU_A : std_logic_vector(5 downto 0);
    signal CPU_D : std_logic_vector(7 downto 0);
    signal Mem_D : std_logic_vector(7 downto 0);
    signal HM : std_logic;
    signal clk8 : std_logic;
    signal clk9 : std_logic;
    signal clk10 : std_logic;
    signal clk12 : std_logic;
    signal clk14 : std_logic;
    signal clk8bar : std_logic;
    signal clk16 : std_logic;
    signal busy : std_logic;
    signal WriteD : std_logic_vector(7 downto 0);
    signal clk1 : std_logic;

    begin
    inst1 : cacheMemory port map(clk, rst, r_w, CPU_A, CPU_D, Mem_D, HM, clk8, clk9, clk10, clk12, clk14, clk16,busy,WriteD,clk1);

    tclk : process begin  -- process clk

        clk<='0','1' after 5 ns;
        wait for 10 ns;

    end process tclk;
    
    clks : process begin  -- process clk
        WriteD(0) <= '0';
    WriteD(1) <= '0';
    WriteD(2) <= '0';
    WriteD(3) <= '0';
    WriteD(4) <= '0';
    WriteD(5) <= '0';
    WriteD(6) <= '0';
    WriteD(7) <= '0';
    busy<='1';
        CPU_A(0) <= '1';
    CPU_A(1) <= '1';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '1';
    CPU_A(5) <= '0';
        clk8 <='0';
         clk8bar<='1';
        clk9<='0';
        clk10<='0';
        clk12<='0';
        clk14<='0';
        clk16<='0';
        r_w<='1';
        MEM_D(0)<='0';
MEM_D(1)<='0';
MEM_D(2)<='0';
MEM_D(3)<='0';
MEM_D(4)<='0';
MEM_D(5)<='0';
MEM_D(6)<='0';
MEM_D(7)<='1';
clk1 <= '0';

wait for 20 ns;
clk1 <= '1';
wait for 10 ns;
clk1 <= '0';
        
        wait for 80ns;
        MEM_D(0)<='1';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='1';
MEM_D(7)<='1';
clk8<='1';
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
        MEM_D(0)<='0';
MEM_D(1)<='1';
MEM_D(2)<='1';
MEM_D(3)<='1';
MEM_D(4)<='1';
MEM_D(5)<='1';
MEM_D(6)<='1';
MEM_D(7)<='1';
        clk14<='0';
        clk16<='1';
        clk8<='0';
        clk8bar<='1';
         r_w<='1';

wait for 20 ns;
clk16<='0';
busy<='0';
    CPU_A(0) <= '0';
    CPU_A(1) <= '0';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '1';
    CPU_A(5) <= '1';

wait for 20 ns;
busy<='1';
    CPU_A(0) <= '1';
    CPU_A(1) <= '1';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '0';
    CPU_A(5) <= '0';

wait for 20 ns;
    CPU_A(0) <= '1';
    CPU_A(1) <= '1';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '0';
    CPU_A(5) <= '1';
    
    wait for 20 ns;
    CPU_A(0) <= '1';
    CPU_A(1) <= '1';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '1';
    CPU_A(5) <= '0';
    
    wait for 20 ns;
    CPU_A(0) <= '1';
    CPU_A(1) <= '1';
    CPU_A(2) <= '1';
    CPU_A(3) <= '1';
    CPU_A(4) <= '1';
    CPU_A(5) <= '1';
    
    wait for 30 ns;
    MEM_D(0)<='0';
MEM_D(1)<='0';
MEM_D(2)<='0';
MEM_D(3)<='0';
MEM_D(4)<='0';
MEM_D(5)<='0';
MEM_D(6)<='0';
MEM_D(7)<='0';
    WriteD(0) <= '1';
    WriteD(1) <= '1';
    WriteD(2) <= '1';
    WriteD(3) <= '1';
    WriteD(4) <= '1';
    WriteD(5) <= '1';
    WriteD(6) <= '1';
    WriteD(7) <= '1';
    r_w <= '0';
    
    wait for 20 ns;
    clk1 <= '1';
wait for 10 ns;
clk1 <= '0';
     wait for 30 ns;
    r_w <= '1';
    
        wait;
    end process clks;
    
    rst <= '0';

end test;
