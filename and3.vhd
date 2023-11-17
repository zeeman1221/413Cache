--
-- Entity: and2
-- Architecture : structural
-- Author: cpatel2
-- Created On: 11/11/2003
--
library STD;
library IEEE;
use IEEE.std_logic_1164.all;
library work;

entity and3 is

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    output   : out std_logic);
end and3;

architecture structural of and3 is

begin

  output <= input3 and input2 and input1;

end structural;