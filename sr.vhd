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
         q   : out std_logic;
         qbar: out std_logic); 
end sr;                          

architecture structural of sr is 
signal qtemp, qbartemp : std_logic;
  
begin
  
  output: process                 

  begin                           
    wait until ( clk'EVENT and clk = '1' ); 
    if J = '1' and K = '0' then
        qtemp <= '1';
        qbartemp <= '0';
    end if;
    if J = '0' and K = '1' then
      qtemp <= '0';
      qbartemp <= '1';
    end if;
    if J = '1' and K = '1' then
    qtemp <= qbartemp;
    qbartemp <= not qtemp;
    end if;
  end process output;        

  q <= qtemp;
  qbar <= qbartemp;    
end structural;  


