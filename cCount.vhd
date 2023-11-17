--
-- Entity: or3
-- Architecture : structural
-- Author: cpatel2
-- Created On: 11/11/2003
--
library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity cCount is

  port (
    clk	     : in  std_logic;
    busy     : in  std_logic;
    rst      : in  std_logic;
    clk2     : out std_logic;
    clk3     : out std_logic;
    clk4     : out std_logic;
    clk5     : out std_logic;
    clk6     : out std_logic;
    clk7     : out std_logic;
    clk8     : out std_logic;
    clk9     : out std_logic;    
    clk10    : out std_logic;
    clk11     : out std_logic;
    clk12    : out std_logic;
    clk13     : out std_logic;
    clk14    : out std_logic;
    clk15     : out std_logic;
    clk16    : out std_logic;
    clk17     : out std_logic;
    clk18     : out std_logic;
    clk19    : out std_logic);
end cCount;


architecture structural of cCount is

signal t0,t1,t2,t3,t4 : std_logic:='0';


  begin
    output: process (busy,clk)
     begin       
    if busy = '1' then
        if (rising_edge(clk)) then
            t0 <= not t0;
        end if;
        if (rising_edge(clk) and t0 = '1') then
            t1 <= not t1;
        end if;
        if (rising_edge(clk) and t1 = '1' and t0 = '1') then
            t2 <= not t2;
        end if;
        if (rising_edge(clk) and t1 = '1' and t0 = '1' and t2 = '1') then
            t3 <= not t3;
        end if;
        if (rising_edge(clk) and t1 = '1' and t0 = '1' and t2 = '1' and t3 = '1') then
            t4 <= not t4;
        end if;
    else
        t0 <= '0';
        t1 <= '0';
        t2 <= '0';
        t3 <= '0';
        t4 <= '0';
    end if;

clk2 <= not t0 and t1 and not t2 and not t3 and not t4;
clk3 <= t0 and t1 and not t2 and not t3 and not t4;
clk4 <= not t0 and not t1 and t2 and not t3 and not t4;
clk5 <= t0 and not t1 and t2 and not t3 and not t4;
clk6 <= not t0 and t1 and t2 and not t3 and not t4;
clk7 <= t0 and t1 and t2 and not t3 and not t4;
clk8 <= t3 or t4;
clk9 <= t0 and not t1 and not t2 and t3 and not t4;
clk10 <= not t0 and t1 and not t2 and t3 and not t4;
clk11 <= t0 and t1 and not t2 and t3 and not t4;
clk12 <= not t0  and not t1 and t2 and t3 and not t4;
clk13 <= t0  and not t1 and t2 and t3 and not t4;
clk14 <= not t0 and t1 and t2 and t3 and not t4;
clk15 <= t0 and t1 and t2 and t3 and not t4;
clk16 <= not t0 and not t1 and not t2 and not t3 and t4;
clk17 <= t0 and not t1 and not t2 and not t3 and t4;
clk18 <= not t0 and t1 and not t2 and not t3 and t4;
clk19 <= t0 and t1 and not t2 and not t3 and t4;
end process output;
end structural;
