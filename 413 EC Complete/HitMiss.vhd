--
-- Entity: AOI
-- Architecture : structural
-- Author: cpatel2
-- Created On: 11/11/2003
--
library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity HitMiss is

    port (
        clk : in std_logic;
        CacheTag : in std_logic_vector(1 downto 0);
        TagInp   : in std_logic_vector(1 downto 0);
        valid    : in std_logic;
        Hit     : out std_logic);
end HitMiss;

architecture structural of HitMiss is

component xor2
  port (
    input1    : in std_logic;
    input2    : in std_logic;
    output    : out  std_logic
    );
end component;

component or2
  port (
    input1    : in std_logic;
    input2    : in std_logic;
    output    : out  std_logic
    );
end component;

component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
end component;

component and3
  port (
    input1    : in std_logic;
    input2    : in std_logic;
    input3    : in std_logic;
    output    : out  std_logic
    );
end component;

component and2
  port (
    input1    : in std_logic;
    input2    : in std_logic;
    output    : out  std_logic
    );
end component;

--for xor2_1, xor2_2 : xor2 use entity work.xor2(structural);
--for and3_1 : and3 use entity work.and3(structural);
--for or2_1 : or2 use entity work.or2(structural);
signal temp1, temp2, otemp : std_logic;
-- inverter temp values --
signal notTemp1, notTemp2 : std_logic;
-- hit/ miss signal --
signal notHitMiss : std_logic;
signal notRW : std_logic;

begin
    -- comparator generation --
    hitmissOp0 : xor2 port map(CacheTag(0), TagInp(0), temp1);
    hitmissOp1 : xor2 port map(CacheTag(1), TagInp(1), temp2);
    getNotTemp1 : inverter port map(temp1, notTemp1);
    getNotTemp2 : inverter port map(temp2, notTemp2);
    getMatchingTags : and2 port map(notTemp2, notTemp1, otemp);
    
    -- hit/ miss generation --
    generateHitMiss : and2 port map(otemp, valid, Hit);

end structural;