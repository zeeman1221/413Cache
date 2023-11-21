--
-- Entity: positive edge sr latch
-- Architecture : structural
-- Author: 
--

library STD;
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity sr is                      
  port (  
         clk : in std_logic;
         J   : in  std_logic;
         K : in  std_logic;
         q   : out std_logic); 
end sr;                          

architecture structural of sr is 

component nor2
  port (
    input1    : in  std_logic;
    input2   : in std_logic;
    output   : out std_logic);
end component;
signal qtemp : std_logic:='0';
signal qbar : std_logic:='1';  

begin
  output : process (clk, J, K)
  begin
  q <= qtemp;
  if (clk'event and clk='1') then
  --  if J = '1' and K = '1' then
   --     qtemp<='0';
    if J = '1' and K = '0' then
        qtemp<='1';
    elsif J = '0' and K = '1' then
        qtemp<='0';
    end if;
  end if;     
  end process output;  
end structural;  


