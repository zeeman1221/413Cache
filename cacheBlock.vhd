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
  MEM_D : in std_logic_vector(7 downto 0)
  --rE1, rE2, rE3, rE4, wE1, wE2, wE3, wE4 : std_logic
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
  wrEn : in std_logic;
  rdEn : in std_logic;
  wrD : in std_logic_vector(7 downto 0);
  rdD : out std_logic_vector(7 downto 0);
  clksig : in std_logic;
  MEM_D : in std_logic_vector(7 downto 0)
  );
end component;

component and3
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    output   : out std_logic);
end component;

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

component useVcc
  port (
  output : out std_logic
  );
end component;

component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
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
signal writeE4 : std_logic;
-- signals for rd data --
signal rdD00 : std_logic_vector(7 downto 0);
signal rdD01 : std_logic_vector(7 downto 0);
signal rdD10 : std_logic_vector(7 downto 0);
signal rdD11 : std_logic_vector(7 downto 0);
-- constant --
--signal pwr : std_logic;
signal vcc : std_logic;
--signal rdD_Q : std_logic_vector(7 downto 0);
-- signal for rw invert --
signal notRW : std_logic;

begin
    infVoltage : useVcc port map(vcc);
    invertRW : inverter port map(r_w, notRW);
    -- create 4 types of 3-inp ands --
    and00 : and3 port map(clk, sBlock, sByte1, ce00);
    and01 : and3 port map(clk, sBlock, sByte2, ce01);
    and10 : and3 port map(clk, sBlock, sByte3, ce10);
    and11 : and3 port map(clk, sBlock, sByte4, ce11);
    -- create 4 selectors for 8 cache cell instantiations --
    makeSelector1 : selector port map(ce00, notRW, readE1, writeE1, Hit);
    makeSelector2 : selector port map(ce01, notRW, readE2, writeE2, Hit);
    makeSelector3 : selector port map(ce10, notRW, readE3, writeE3, Hit);
    makeSelector4 : selector port map(ce11, notRW, readE4, writeE4, Hit);
    -- create 4 cache bytes for instantiaton --
    --first instance of MEM_D eventually transisiton to CPU_D
    makeCacheByte1: cacheByte port map(writeE1, readE1, rdD, rdD00, clk9, MEM_D); -- "cache00"
    makeCacheByte2: cacheByte port map(writeE2, readE2, rdD, rdD01, clk10, MEM_D); -- "cache01"
    makeCacheByte3: cacheByte port map(writeE3, readE3, rdD, rdD10, clk12, MEM_D); -- "cache10"
    makeCacheByte4: cacheByte port map(writeE4, readE4, rdD, rdD11, clk14, MEM_D); -- "cache11"

    -- 8 mux for data selections --
    makeMux1: mux port map(rdD00(0), rdD01(0), rdD10(0), rdD11(0), CPU_bits(0) , CPU_bits(1), rdD(0));
    makeMux2: mux port map(rdD00(1), rdD01(1), rdD10(1), rdD11(1), CPU_bits(0) , CPU_bits(1), rdD(1));
    makeMux3: mux port map(rdD00(2), rdD01(2), rdD10(2), rdD11(2), CPU_bits(0) , CPU_bits(1) , rdD(2));
    makeMux4: mux port map(rdD00(3), rdD01(3), rdD10(3), rdD11(3), CPU_bits(0) , CPU_bits(1) , rdD(3));
    makeMux5: mux port map(rdD00(4), rdD01(4), rdD10(4), rdD11(4), CPU_bits(0) , CPU_bits(1) , rdD(4));
    makeMux6: mux port map(rdD00(5), rdD01(5), rdD10(5), rdD11(5), CPU_bits(0) , CPU_bits(1) , rdD(5));
    makeMux7: mux port map(rdD00(6), rdD01(6), rdD10(6), rdD11(6), CPU_bits(0) , CPU_bits(1) , rdD(6));
    makeMux8: mux port map(rdD00(7), rdD01(7), rdD10(7), rdD11(7), CPU_bits(0) , CPU_bits(1) , rdD(07));
    --rdD <= rdD_Q;
    



end structural;
