----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 08:53:09 AM
-- Design Name: 
-- Module Name: cacheMemory - Behavioral
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

entity cacheMemory is
 port ( 
    clk : in std_logic;
    rst : in std_logic;
    r_w : in std_logic;
    CPU_A : in std_logic_vector(5 downto 0);
    CPU_D : inout std_logic_vector(5 downto 0);
    Mem_D : in std_logic_vector(7 downto 0)
 );
end cacheMemory;

architecture structural of cacheMemory is
    component decoder 

    port (
    Enable: in std_logic;
    A0 : in std_logic;
    A1 : in std_logic;
    Y0 : out std_logic;
    Y1 : out std_logic;
    Y2 : out std_logic;
    Y3 : out std_logic
);
end component;

component cacheBlock 
port (
    clk : in std_logic;
    rst : in std_logic;
    sBlock : in std_logic;
    sByte1 : in std_logic;
    sByte2 : in std_logic;
    sByte3 : in std_logic;
    sByte4 : in std_logic;
    r_w : in std_logic;
    wrD : in std_logic_vector(7 downto 0);
    rdD : out std_logic_vector(7 downto 0)
);
end component;

component and2 is

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;
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

component and3

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3: in std_logic;
    output   : out std_logic);
end component;

-- signals for decoder output --
signal decoderO1 : std_logic;
signal decoderO2 : std_logic;
signal decoderO3 : std_logic;
signal decoderO4 : std_logic;
signal decoderO5 : std_logic;
signal decoderO6 : std_logic;
signal decoderO7 : std_logic;
signal decoderO8 : std_logic;
-- constant voltage signal --
signal sigConst : std_logic;
-- Cache Memory Blocks --
signal block00 : std_logic;
signal block01 : std_logic;
signal block02 : std_logic;
signal block03 : std_logic;
signal block10 : std_logic;
signal block11 : std_logic;
signal block12 : std_logic;
signal block13 : std_logic;
signal block20 : std_logic;
signal block21 : std_logic;
signal block22 : std_logic;
signal block23 : std_logic;
signal block30 : std_logic;
signal block31 : std_logic;
signal block32 : std_logic;
signal block33 : std_logic;
-- signal for write; r_w invert --
signal w : std_logic;
-- signal for write enable and read enable 1-16 --
signal rE1, rE2, rE3, rE4, rE5, rE6, rE7, rE8, rE9, rE10, rE11, rE12, rE13, rE14, rE15, rE16 : std_logic;
signal wE1, wE2, wE3, wE4, wE5, wE6, wE7, wE8, wE9, wE10, wE11, wE12, wE13, wE14, wE15, wE16 : std_logic;

-- signal 

begin -- CPU Address(5 downto 0): 5,4 for tag; 3,2 for block; 1,0 for byte
    -- constant voltage for decoder enabler --
    sigConst <= '1';
    -- inverting r_w for write signal --
    getWrite : inverter port map(r_w, w);
    -- decoder for block and byte --
    makeDecoderBlock : decoder port map(sigConst, CPU_A(3), CPU_A(2), decoderO1, decoderO2, decoderO3, decoderO4);
    makeDecoderByte : decoder port map(sigConst, CPU_A(4), CPU_A(5), decoderO5, decoderO6, decoderO7, decoderO8);
    
    --makeCacheBlock1 : cacheBlock port map(clk, rst, decoderO1, decoderO5, decoderO6, decoderO7, decoderO8, r_w,
    --makeCacheBlock2 : cacheBlock port map(clk, rst, decoderO2, decoderO5, decoderO6, decoderO7, decoderO8, r_w,
    --makeCacheBlock3 : cacheBlock port map(clk, rst, decoderO3, decoderO5, decoderO6, decoderO7, decoderO8, r_w,
    --makeCacheBlock4 : cacheBlock port map(clk, rst, decoderO4, decoderO5, decoderO6, decoderO7, decoderO8, r_w,
    -- Creating 16 Cache memory with outputs of decoder using and2 + clk signal --
    --makeBlock00 : and3 port map(clk, decoderO1, decoderO5, block00);
    --block00RE : and2 port map(block00, r_w, rE1);
    --block00WE : and2 port map(block00, w, wE1);
    --makeBlock01 : and3 port map(clk, decoderO1, decoderO6, block01);
    --block01RE : and2 port map(block01, r_w, rE2);
    --block01WE : and2 port map(block01, w, wE2);
    --makeBlock02 : and3 port map(clk, decoderO1, decoderO7, block02);
    --block02RE : and2 port map(block02, r_w, rE3);
    --block02WE : and2 port map(block02, w, wE3);
    --makeBlock03 : and3 port map(clk, decoderO1, decoderO8, block03);
    --block03RE : and2 port map(block03, r_w, rE4);
    --block03WE : and2 port map(block03, w, wE4);
    --makeBlock10 : and3 port map(clk, decoderO2, decoderO5, block10);
    --block10RE : and2 port map(block10, r_w, rE5);
    --block10WE : and2 port map(block10, w, wE5);
    --makeBlock11 : and3 port map(clk, decoderO2, decoderO6, block11);
    --block11RE : and2 port map(block11, r_w, rE6);
    --block11WE : and2 port map(block11, w, wE6);
    --makeBlock12 : and3 port map(clk, decoderO2, decoderO7, block12);
    --block12RE : and2 port map(block12, r_w, rE7);
    --block12WE : and2 port map(block12, w, wE7);
    --makeBlock13 : and3 port map(clk, decoderO2, decoderO8, block13);
    --block13RE : and2 port map(block13, r_w, rE8);
    --block13WE : and2 port map(block13, w, wE8);
    --makeBlock20 : and3 port map(clk, decoderO3, decoderO5, block20);
    --block20RE : and2 port map(block20, r_w, rE9);
    --block20WE : and2 port map(block20, w, wE9);
    --makeBlock21 : and3 port map(clk, decoderO3, decoderO6, block21);
    --block21RE : and2 port map(block21, r_w, rE10);
    --block21WE : and2 port map(block21, w, wE10);
    --makeBlock22 : and3 port map(clk, decoderO3, decoderO7, block22);
    --block22RE : and2 port map(block22, r_w, rE11);
    --block22WE : and2 port map(block22, w, wE11);
    --makeBlock23 : and3 port map(clk, decoderO3, decoderO8, block23);
    --block23RE : and2 port map(block23, r_w, rE12);
    --block23WE : and2 port map(block23, w, wE12);
    --makeBlock30 : and3 port map(clk, decoderO4, decoderO5, block30);
    --block30RE : and2 port map(block30, r_w, rE13);
    --block30WE : and2 port map(block30, w, wE13);
    --makeBlock31 : and3 port map(clk, decoderO4, decoderO6, block31);
    --block31RE : and2 port map(block31, r_w, rE14);
    --block31WE : and2 port map(block31, w, wE14);
    --makeBlock32 : and3 port map(clk, decoderO4, decoderO7, block32);
    --block32RE : and2 port map(block32, r_w, rE15);
    --block32WE : and2 port map(block32, w, wE15);
    --makeBlock33 : and3 port map(clk, decoderO4, decoderO8, block33);
    --block33RE : and2 port map(block33, r_w, rE16);
    --block33WE : and2 port map(block33, w, wE16);
    
    -- ENTIRE CACHE --
    cacheBlock1 : cacheBlock port map(clk, rst, decoderO1, decoderO5, decoderO6, decoderO7, decoderO8, r_w, CPU_D, CPU_D);
    cacheBlock2 : cacheBlock port map(clk, rst, decoderO2, decoderO5, decoderO6, decoderO7, decoderO8, r_w, CPU_D, CPU_D);
    cacheBlock3 : cacheBlock port map(clk, rst, decoderO3, decoderO5, decoderO6, decoderO7, decoderO8, r_w, CPU_D, CPU_D);
    cacheBlock4 : cacheBlock port map(clk, rst, decoderO4, decoderO5, decoderO6, decoderO7, decoderO8, r_w, CPU_D, CPU_D);
    tag0 : cachecell port map(CPU_A(0), sigConst, sigConst, sigConst, CPU_D(0));
    tag1 : cachecell port map(CPU_A(1), sigConst, sigConst, sigConst, CPU_D(1));
    

end structural;
