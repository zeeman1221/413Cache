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
  sBlock : in std_logic;
  sByte1 : in std_logic;
  sByte2 : in std_logic;
  sByte3 : in std_logic;
  sByte4 : in std_logic;
  r_w : in std_logic;
  CPU_bits : in std_logic_vector(1 downto 0);
  wrD : in std_logic_vector(7 downto 0);
  rdD : out std_logic_vector(7 downto 0)
  --rE1, rE2, rE3, rE4, wE1, wE2, wE3, wE4 : std_logic
);
end cacheBlock;

architecture structural of cacheBlock is
component selector
port (
  chipEnable : in std_logic;
  r_w : in std_logic;
  rdEn : out std_logic;
  wrEn : out std_logic
 );
end component;

component cacheByte
  port (
  wrEn : in std_logic;
  rdEn : in std_logic;
  wrD : in std_logic_vector(7 downto 0);
  rdD : out std_logic_vector(7 downto 0)
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
    inp1 : std_logic;
    inp2 : std_logic;
    inp3 : std_logic;
    inp4 : std_logic;
    sig1 : std_logic;
    sig2 : std_logic;
    output : std_logic
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
signal vcc : std_logic;
signal rdD_Q : std_logic_vector(7 downto 0);

begin
    vcc <= '1';
    -- create 4 types of 3-inp ands --
    and00 : and3 port map(clk, sBlock, sByte1, ce00);
    and01 : and3 port map(clk, sBlock, sByte2, ce01);
    and10 : and3 port map(clk, sBlock, sByte3, ce10);
    and11 : and3 port map(clk, sBlock, sByte4, ce11);
    -- create 4 selectors for 8 cache cell instantiations --
    makeSelector1 : selector port map(ce00, r_w, readE1, writeE1);
    makeSelector2 : selector port map(ce01, r_w, readE2, writeE2);
    makeSelector3 : selector port map(ce10, r_w, readE3, writeE3);
    makeSelector4 : selector port map(ce11, r_w, readE4, writeE4);
    -- create 4 cache bytes for instantiaton --
    makeCacheByte1: cacheByte port map(writeE1, readE1, wrD, rdD00); -- "cache00"
    makeCacheByte2: cacheByte port map(writeE2, readE2, wrD, rdD01); -- "cache01"
    makeCacheByte3: cacheByte port map(writeE3, readE3, wrD, rdD10); -- "cache10"
    makeCacheByte4: cacheByte port map(writeE4, readE4, wrD, rdD11); -- "cache11"

    -- 8 mux for data selections --
    makeMux1: mux port map(rdD00(0), rdD01(0), rdD10(0), rdD11(0), CPU_bits(0) , CPU_bits(1), rdD_Q (0));
    makeMux2: mux port map(rdD00(1), rdD01(1), rdD10(1), rdD11(1), CPU_bits(0) , CPU_bits(1), rdD_Q (1));
    makeMux3: mux port map(rdD00(2), rdD01(2), rdD10(2), rdD11(2), CPU_bits(0) , CPU_bits(1) , rdD_Q (2));
    makeMux4: mux port map(rdD00(3), rdD01(3), rdD10(3), rdD11(3), CPU_bits(0) , CPU_bits(1) , rdD_Q (3));
    makeMux5: mux port map(rdD00(4), rdD01(4), rdD10(4), rdD11(4), CPU_bits(0) , CPU_bits(1) , rdD_Q (4));
    makeMux6: mux port map(rdD00(5), rdD01(5), rdD10(5), rdD11(5), CPU_bits(0) , CPU_bits(1) , rdD_Q (5));
    makeMux7: mux port map(rdD00(6), rdD01(6), rdD10(6), rdD11(6), CPU_bits(0) , CPU_bits(1) , rdD_Q (6));
    makeMux8: mux port map(rdD00(7), rdD01(7), rdD10(7), rdD11(7), CPU_bits(0) , CPU_bits(1) , rdD_Q (7));
    rdD <= rdD_Q;
    



end structural;
