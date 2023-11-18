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
    clk1     : out std_logic;
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
    clk19    : out std_logic;
    clk8long : out std_logic);
end cCount;


architecture structural of cCount is
component and5 is
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    input4   : in  std_logic;
    input5   : in std_logic;
    output   : out std_logic);
end component;

component inverter is
  port (
    input   : in  std_logic;
    output   : out std_logic);
end component;

component or2 is
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

signal t0,t1,t2,t3,t4 : std_logic:='0';
signal t0bar, t1bar, t2bar, t3bar, t4bar : std_logic;

  begin
    sett0bar : inverter port map (t0, t0bar);
    sett1bar : inverter port map (t1, t1bar);
    sett2bar : inverter port map (t2, t2bar);
    sett3bar : inverter port map (t3, t3bar);
    sett4bar : inverter port map (t4, t4bar);
  
    setclk1 : and5 port map (t0, t1bar, t2bar, t3bar, t4bar, clk1);
    setclk2 : and5 port map (t0bar, t1, t2bar, t3bar, t4bar, clk2);
    setclk3 : and5 port map (t0, t1, t2bar, t3bar, t4bar, clk3);
    setclk4 : and5 port map (t0bar, t1bar, t2, t3bar, t4bar, clk4);
    setclk5 : and5 port map (t0, t1bar, t2, t3bar, t4bar, clk5);
    setclk6 : and5 port map (t0bar, t1, t2, t3bar, t4bar, clk6);
    setclk7 : and5 port map (t0, t1, t2, t3bar, t4bar, clk7);
    setclk8 : and5 port map (t0bar, t1bar, t2bar, t3, t4bar, clk8);
    setclk9 : and5 port map (t0, t1bar, t2bar, t3, t4bar, clk9);
    setclk10 : and5 port map (t0bar, t1, t2bar, t3, t4bar, clk10);
    setclk11 : and5 port map (t0, t1, t2bar, t3, t4bar, clk11);
    setclk12 : and5 port map (t0bar, t1bar, t2, t3, t4bar, clk12);
    setclk13 : and5 port map (t0, t1bar, t2, t3, t4bar, clk13);
    setclk14 : and5 port map (t0bar, t1, t2, t3, t4bar, clk14);
    setclk15 : and5 port map (t0, t1, t2, t3, t4bar, clk15);
    setclk16 : and5 port map (t0bar, t1bar, t2bar, t3bar, t4, clk16);
    setclk17 : and5 port map (t0, t1bar, t2bar, t3bar, t4, clk17);
    setclk18 : and5 port map (t0bar, t1, t2bar, t3bar, t4, clk18);
    setclk19 : and5 port map (t0, t1, t2bar, t3bar, t4, clk19);
    setclk8long : or2 port map (t3, t4, clk8long);
    
    
    
    output: process (busy,clk)
     begin       
    if busy = '1' then
        if (falling_edge(clk)) then
            t0 <= not t0;
        end if;
        if (falling_edge(clk) and t0 = '1') then
            t1 <= not t1;
        end if;
        if (falling_edge(clk) and t1 = '1' and t0 = '1') then
            t2 <= not t2;
        end if;
        if (falling_edge(clk) and t1 = '1' and t0 = '1' and t2 = '1') then
            t3 <= not t3;
        end if;
        if (falling_edge(clk) and t1 = '1' and t0 = '1' and t2 = '1' and t3 = '1') then
            t4 <= not t4;
        end if;
    end if;
    if busy = '0' then
        t0 <= '0';
        t1 <= '0';
        t2 <= '0';
        t3 <= '0';
        t4 <= '0';
    end if;
end process output;
end structural;