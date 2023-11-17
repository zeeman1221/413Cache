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
  rdD : out std_logic_vector(7 downto 0)
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

-- signals --
signal rdEnBar : std_logic;

begin
-- invert read enable --
makeInverter : inverter port map(rdEn, rdEnBar);
-- 8 cache cells for each block --
cachecell1 : cachecell port map(wrD(0), wrEn, rdEn, rdEnBar, rdD(0));
cachecell2 : cachecell port map(wrD(1), wrEn, rdEn, rdEnBar, rdD(1));
cachecell3 : cachecell port map(wrD(2), wrEn, rdEn, rdEnBar, rdD(2));
cachecell4 : cachecell port map(wrD(3), wrEn, rdEn, rdEnBar, rdD(3));
cachecell5 : cachecell port map(wrD(4), wrEn, rdEn, rdEnBar, rdD(4));
cachecell6 : cachecell port map(wrD(5), wrEn, rdEn, rdEnBar, rdD(5));
cachecell7 : cachecell port map(wrD(6), wrEn, rdEn, rdEnBar, rdD(6));
cachecell8 : cachecell port map(wrD(7), wrEn, rdEn, rdEnBar, rdD(7));



end structural;
