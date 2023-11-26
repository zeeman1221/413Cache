----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 10:09:09 PM
-- Design Name: 
-- Module Name: cacheBlock - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cacheBlock is
port (
  Hit : in std_logic;
  sBlock : in std_logic;
  sByte1 : in std_logic;
  sByte2 : in std_logic;
  sByte3 : in std_logic;
  sByte4 : in std_logic;
  r_w : in std_logic;
  rdD : out std_logic_vector(7 downto 0);
  clk8 : in std_logic;
  clk10 : in std_logic;
  clk12 : in std_logic;
  clk14 : in std_logic;
  MEM_D : in std_logic_vector(7 downto 0);
  clk16 : in std_logic;
  WriteD : in std_logic_vector(7 downto 0);
  clk1 : in std_logic
  );
end cacheBlock;

architecture structural of cacheBlock is
component selector
port (
  chipEnable : in std_logic;
  r_w : in std_logic;
  rdEn : out std_logic;
  wrEn : out std_logic;
  Hit : in std_logic
 );
end component;

component cacheByte
  port (
  rdEn : in std_logic;
  wrD : in std_logic_vector(7 downto 0);
  rdD : out std_logic_vector(7 downto 0);
  clksig: in std_logic;
  MEM_D : in std_logic_vector(7 downto 0);
  override : in std_logic;
  clk1 : in std_logic
  );
end component;

component or4
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    input4   : in  std_logic;
    output   : out std_logic);
end component;

component and2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component or2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component dff                
  port ( d   : in  std_logic;
         clk : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
end component;  

-- signals for chip enable --
signal ce00 : std_logic;
signal ce01 : std_logic;
signal ce10 : std_logic;
signal ce11 : std_logic;
-- signals for read/ write enable --
signal readE1 : std_logic;
signal writeE1 : std_logic;
signal readE2 : std_logic;
signal writeE2 : std_logic;
signal readE3 : std_logic;
signal writeE3 : std_logic;
signal readE4 : std_logic;
signal writeE4, RMStuff1, RMStuff2, RMStuff3, RMStuff4 : std_logic;
-- signals for rd data --
signal rdD00 : std_logic_vector(7 downto 0);
signal rdD01 : std_logic_vector(7 downto 0);
signal rdD10 : std_logic_vector(7 downto 0);
signal rdD11 : std_logic_vector(7 downto 0);
-- constant --
--signal pwr : std_logic;
signal vcc : std_logic:='1';
--signal rdD_Q : std_logic_vector(7 downto 0);

begin
    -- create 4 types of 3-inp ands --
    and00 : and2 port map(sBlock, sByte1, ce00);
    and01 : and2 port map(sBlock, sByte2, ce01);
    and10 : and2 port map(sBlock, sByte3, ce10);
    and11 : and2 port map(sBlock, sByte4, ce11);
    -- create 4 selectors for 8 cache cell instantiations --
    makeSelector1 : selector port map(ce00, r_w, readE1, writeE1, Hit);
    makeSelector2 : selector port map(ce01, r_w, readE2, writeE2, Hit);
    makeSelector3 : selector port map(ce10, r_w, readE3, writeE3, Hit);
    makeSelector4 : selector port map(ce11, r_w, readE4, writeE4, Hit);
    -- create 4 cache bytes for instantiaton --

    readmissstuff1 : and2 port map(ce00, clk16, RMStuff1);
    readmissstuff2 : and2 port map(ce01, clk16, RMStuff2);
    readmissstuff3 : and2 port map(ce10, clk16, RMStuff3);
    readmissstuff4 : and2 port map(ce11, clk16, RMStuff4);

    --first instance of MEM_D eventually transisiton to CPU_D
    makeCacheByte1: cacheByte port map(readE1, WriteD, rdD00, clk8, MEM_D,RMStuff1,clk1); -- "cache00"
    makeCacheByte2: cacheByte port map(readE2, WriteD, rdD01, clk10, MEM_D,RMStuff2,clk1); -- "cache01"
    makeCacheByte3: cacheByte port map(readE3, WriteD, rdD10, clk12, MEM_D,RMStuff3,clk1); -- "cache10"
    makeCacheByte4: cacheByte port map(readE4, WriteD, rdD11, clk14, MEM_D,RMStuff4,clk1); -- "cache11"
    
    makeor41: or4 port map(rdD00(0), rdD01(0), rdD10(0), rdD11(0), rdD(0));
    makeor42: or4 port map(rdD00(1), rdD01(1), rdD10(1), rdD11(1), rdD(1));
    makeor43: or4 port map(rdD00(2), rdD01(2), rdD10(2), rdD11(2), rdD(2));
    makeor44: or4 port map(rdD00(3), rdD01(3), rdD10(3), rdD11(3), rdD(3));
    makeor45: or4 port map(rdD00(4), rdD01(4), rdD10(4), rdD11(4), rdD(4));
    makeor46: or4 port map(rdD00(5), rdD01(5), rdD10(5), rdD11(5), rdD(5));
    makeor47: or4 port map(rdD00(6), rdD01(6), rdD10(6), rdD11(6), rdD(6));
    makeor48: or4 port map(rdD00(7), rdD01(7), rdD10(7), rdD11(7), rdD(7));

end structural;
