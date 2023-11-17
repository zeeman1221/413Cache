----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 10:10:52 PM
-- Design Name: 
-- Module Name: cacheByte - Behavioral
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

entity cacheByte is
  port (
  wrEn : in std_logic;
  rdEn : in std_logic;
  wrD : in std_logic_vector(7 downto 0);
  rdD : out std_logic_vector(7 downto 0);
  clksig: in std_logic;
  MEM_D : in std_logic_vector(7 downto 0)
  );
end cacheByte;

architecture structural of cacheByte is
    component cachecell
  port ( 
  wrD : in std_logic;
  wrEn : in std_logic;
  rdEn : in std_logic;
  rdEnBar : in std_logic;
  rdOut : out std_logic 
  );
end component;

component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
end component;

component or2
  port (
    input1    : in  std_logic;
    input2   : in std_logic;
    output   : out std_logic);
end component;

component and2
  port (
    input1    : in  std_logic;
    input2   : in std_logic;
    output   : out std_logic);
end component;

-- signals --
signal rdEnBar, clksigbar : std_logic;
signal wrDQ,MEM_DQ, overwrite : std_logic_vector(7 downto 0);
begin
-- invert read enable --
makeInverter : inverter port map(rdEn, rdEnBar);
invclk : inverter port map(clksig, clksigbar);
-- 8 cache cells for each block --

wrD0chck : and2 port map (wrD(0), clksigbar, wrDQ(0));
wrD1chck : and2 port map (wrD(1), clksigbar, wrDQ(1));
wrD2chck : and2 port map (wrD(2), clksigbar, wrDQ(2));
wrD3chck : and2 port map (wrD(3), clksigbar, wrDQ(3));
wrD4chck : and2 port map (wrD(4), clksigbar, wrDQ(4));
wrD5chck : and2 port map (wrD(5), clksigbar, wrDQ(5));
wrD6chck : and2 port map (wrD(6), clksigbar, wrDQ(6));
wrD7chck : and2 port map (wrD(7), clksigbar, wrDQ(7));

MEM0chck : and2 port map (MEM_D(0), clksigbar, MEM_DQ(0));
MEM1chck : and2 port map (MEM_D(1), clksigbar, MEM_DQ(1));
MEM2chck : and2 port map (MEM_D(2), clksigbar, MEM_DQ(2));
MEM3chck : and2 port map (MEM_D(3), clksigbar, MEM_DQ(3));
MEM4chck : and2 port map (MEM_D(4), clksigbar, MEM_DQ(4));
MEM5chck : and2 port map (MEM_D(5), clksigbar, MEM_DQ(5));
MEM6chck : and2 port map (MEM_D(6), clksigbar, MEM_DQ(6));
MEM7chck : and2 port map (MEM_D(7), clksigbar, MEM_DQ(7));

overwrite0 : or2 port map (wrDQ(0), MEM_DQ(0), overwrite(0));
overwrite1 : or2 port map (wrDQ(0), MEM_DQ(1), overwrite(1));
overwrite2 : or2 port map (wrDQ(0), MEM_DQ(2), overwrite(2));
overwrite3 : or2 port map (wrDQ(0), MEM_DQ(3), overwrite(3));
overwrite4 : or2 port map (wrDQ(0), MEM_DQ(4), overwrite(4));
overwrite5 : or2 port map (wrDQ(0), MEM_DQ(5), overwrite(5));
overwrite6 : or2 port map (wrDQ(0), MEM_DQ(6), overwrite(6));
overwrite7 : or2 port map (wrDQ(0), MEM_DQ(7), overwrite(7));



cachecell1 : cachecell port map(overwrite(0), wrEn, rdEn, rdEnBar, rdD(0));
cachecell2 : cachecell port map(overwrite(1), wrEn, rdEn, rdEnBar, rdD(1));
cachecell3 : cachecell port map(overwrite(2), wrEn, rdEn, rdEnBar, rdD(2));
cachecell4 : cachecell port map(overwrite(3), wrEn, rdEn, rdEnBar, rdD(3));
cachecell5 : cachecell port map(overwrite(4), wrEn, rdEn, rdEnBar, rdD(4));
cachecell6 : cachecell port map(overwrite(5), wrEn, rdEn, rdEnBar, rdD(5));
cachecell7 : cachecell port map(overwrite(6), wrEn, rdEn, rdEnBar, rdD(6));
cachecell8 : cachecell port map(overwrite(7), wrEn, rdEn, rdEnBar, rdD(7));



end structural;
