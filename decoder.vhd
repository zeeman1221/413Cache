library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is 

    port (
    Enable: in std_logic;
    A0 : in std_logic;
    A1 : in std_logic;
    Y0 : out std_logic;
    Y1 : out std_logic;
    Y2 : out std_logic;
    Y3 : out std_logic
);
end decoder;

architecture structural of decoder is
signal notA0 : std_logic;
signal notA1 : std_logic;


    component and3

        port (
          input1   : in  std_logic;
          input2   : in  std_logic;
          input3   : in  std_logic;
          output   : out std_logic);
    end component;

    component inverter

        port (
          input    : in  std_logic;
          output   : out std_logic);
    end component;

    for and_Y3, and_Y2, and_Y1, and_Y0: and3 use entity work.and3(structural);

begin
    inv_A0 : inverter port map(A0, notA0);
    inv_A1 : inverter port map(A1, notA1);

    and_Y3 : and3 port map(input1=>A0, input2=>A1, input3=>Enable, output=>Y3);
    and_Y2 : and3 port map(input1=>A0, input2=>notA1, input3=>Enable, output=>Y2);
    and_Y1 : and3 port map(input1=>notA0, input2=>A1, input3=>Enable, output=>Y1);
    and_Y0 : and3 port map(input1=>notA0, input2=>notA1, input3=>Enable, output=>Y0);


end structural;
