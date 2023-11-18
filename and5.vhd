library STD;
library IEEE;
use IEEE.std_logic_1164.all;
library work;

entity and5 is

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    input4   : in  std_logic;
    input5   : in std_logic;
    output   : out std_logic);
end and5;

architecture structural of and5 is

component and3 is
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    output   : out std_logic);
end component;

signal temp : std_logic;
begin

first3 : and3 port map (input1, input2, input3, temp);
last2  : and3 port map(input4, input5, temp, output);

end structural;