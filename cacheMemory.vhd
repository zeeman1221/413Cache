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
    CPU_D : out std_logic_vector(7 downto 0);
    Mem_D : in std_logic_vector(7 downto 0);
    HM : out std_logic;
    clk8 : in std_logic;
    clk9 : in std_logic;
    clk10 : in std_logic;
    clk12 : in std_logic;
    clk14 : in std_logic;
    clk16 : in std_logic;
    busy : in std_logic;
    WriteD : in std_logic_vector(7 downto 0);
    clk1 : in std_logic
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
  Hit : in std_logic;
  sBlock : in std_logic;
  sByte1 : in std_logic;
  sByte2 : in std_logic;
  sByte3 : in std_logic;
  sByte4 : in std_logic;
  r_w : in std_logic;
  rdD : inout std_logic_vector(7 downto 0);
  clk8 : in std_logic;
  clk10 : in std_logic;
  clk12 : in std_logic;
  clk14 : in std_logic;
  MEM_D : in std_logic_vector(7 downto 0);
  clk16 : in std_logic;
  WriteD : in std_logic_vector(7 downto 0);
  clk1 : in std_logic
);
end component;

component and2

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
  rdOut : out std_logic;
  override : in std_logic
  );
end component;

component or4

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3: in std_logic;
    input4: in std_logic;
    output   : out std_logic);
end component;

component HitMiss
    port (
        clk : in std_logic;
        CacheTag : in std_logic_vector(1 downto 0);
        TagInp   : in std_logic_vector(1 downto 0);
        valid    : in std_logic;
        Hit     : out std_logic);
end component;

component sr                      
  port (  
         clk : in std_logic;
         J   : in  std_logic;
         K : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
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
signal sigConst, sigConstBar, WriteB1Tag, WriteB2Tag, WriteB3Tag, WriteB4Tag : std_logic;

-- signal for write enable and read enable 1-16 --
signal TagB10, TagB20, TagB30, TagB40, TagB11, TagB21, TagB31, TagB41 : std_logic;
signal CValB1, CValB2, CValB3, CValB4, ValB1, ValB2, ValB3, ValB4: std_logic;
signal Hit, valid, stud, HitQ : std_logic;
signal CacheTag, CTagB1, CTagB2, CTagB3, CTagB4 : std_logic_vector(1 downto 0);
signal dataB1, dataB2, dataB3, dataB4 : std_logic_vector(7 downto 0);
-- signal 

begin -- CPU Address(5 downto 0): 5,4 for tag; 3,2 for block; 1,0 for byte
    -- constant voltage for decoder enabler --
    sigConst <= '1';
    sigConstBar <= '0';
    -- inverting r_w for write signal --
    -- decoder for block and byte --
    makeDecoderBlock : decoder port map(sigConst, CPU_A(3), CPU_A(2), decoderO1, decoderO2, decoderO3, decoderO4);
    makeDecoderByte : decoder port map(sigConst, CPU_A(4), CPU_A(5), decoderO5, decoderO6, decoderO7, decoderO8);
    
  -- setting the CacheTag and performing HitMiss
    selTagB10 : and2 port map (CTagB1(0), decoderO1, TagB10);
    selTagB11 : and2 port map (CTagB1(1), decoderO1, TagB11);
    selValB1  : and2 port map (CValB1, decoderO1, ValB1);

    selTagB20 : and2 port map (CTagB2(0), decoderO2, TagB20);
    selTagB21 : and2 port map (CTagB2(1), decoderO2, TagB21);
    selValB2  : and2 port map (CValB2, decoderO2, ValB2);
    
    selTagB30 : and2 port map (CTagB3(0), decoderO3, TagB30);
    selTagB31 : and2 port map (CTagB3(1), decoderO3, TagB31);
    selValB3  : and2 port map (CValB3, decoderO3, ValB3);
    
    selTagB40 : and2 port map (CTagB4(0), decoderO4, TagB40);
    selTagB41 : and2 port map (CTagB4(1), decoderO4, TagB41);
    selValB4  : and2 port map (CValB4, decoderO4, ValB4);
    
    setCacheTag0 : or4 port map (TagB10, TagB20, TagB30, TagB40, CacheTag(0));
    setCacheTag1 : or4 port map (TagB11, TagB21, TagB31, TagB41, CacheTag(1));
    setCacheVal  : or4 port map (ValB1, ValB2, ValB3, ValB4, valid);
    
    HitMissCalc : HitMiss port map(clk, CacheTag, CPU_A(1 downto 0), valid, Hit);
    DuringOp : and2 port map(Hit, Busy, HitQ);
    
    overwriteB1 : and2 port map(decoderO1, clk8, WriteB1Tag);
    overwriteB2 : and2 port map(decoderO2, clk8, WriteB2Tag);
    overwriteB3 : and2 port map(decoderO3, clk8, WriteB3Tag);
    overwriteB4 : and2 port map(decoderO4, clk8, WriteB4Tag);
    
    settagB10 : cachecell port map(CPU_A(0), WriteB1Tag, sigConst, CTagB1(0),sigConstBar);
    settagB11 : cachecell port map(CPU_A(1), WriteB1Tag, sigConst, CTagB1(1),sigConstBar);
    setValB1 : sr port map (clk, WriteB1Tag, rst, CValB1,stud);
    
    settagB20 : cachecell port map(CPU_A(0), WriteB2Tag, sigConst, CTagB2(0),sigConstBar);
    settagB21 : cachecell port map(CPU_A(1), WriteB2Tag, sigConst, CTagB2(1),sigConstBar);
    setValB2 : sr port map (clk, WriteB2Tag, rst, CValB2,stud);
    
    settagB30 : cachecell port map(CPU_A(0), WriteB3Tag, sigConst, CTagB3(0),sigConstBar);
    settagB31 : cachecell port map(CPU_A(1), WriteB3Tag, sigConst, CTagB3(1),sigConstBar);
    setValB3 : sr port map (clk, WriteB3Tag, rst, CValB3,stud);
    
    settagB40 : cachecell port map(CPU_A(0), WriteB4Tag, sigConst, CTagB4(0),sigConstBar);
    settagB41 : cachecell port map(CPU_A(1), WriteB4Tag, sigConst, CTagB4(1),sigConstBar);
    setValB4 : sr port map (clk, WriteB4Tag, rst, CValB4,stud);
    --accessing Cache Blocks--
    cacheBlock1 : cacheBlock port map(HitQ, decoderO1, decoderO5, decoderO6, decoderO7, decoderO8, r_w, dataB1, clk9, clk10, clk12, clk14, MEM_D, clk16, WriteD,clk1);
    cacheBlock2 : cacheBlock port map(HitQ, decoderO2, decoderO5, decoderO6, decoderO7, decoderO8, r_w, dataB2, clk9, clk10, clk12, clk14, MEM_D, clk16, WriteD,clk1);
    cacheBlock3 : cacheBlock port map(HitQ, decoderO3, decoderO5, decoderO6, decoderO7, decoderO8, r_w, dataB3, clk9, clk10, clk12, clk14, MEM_D, clk16, WriteD,clk1);
    cacheBlock4 : cacheBlock port map(HitQ, decoderO4, decoderO5, decoderO6, decoderO7, decoderO8, r_w, dataB4, clk9, clk10, clk12, clk14, MEM_D, clk16, WriteD,clk1);
  
  setCPU_D0 : or4 port map(dataB1(0), dataB2(0), dataB3(0), dataB4(0), CPU_D(0));
  setCPU_D1 : or4 port map(dataB1(1), dataB2(1), dataB3(1), dataB4(1), CPU_D(1));
  setCPU_D2 : or4 port map(dataB1(2), dataB2(2), dataB3(2), dataB4(2), CPU_D(2));
  setCPU_D3 : or4 port map(dataB1(3), dataB2(3), dataB3(3), dataB4(3), CPU_D(3));
  setCPU_D4 : or4 port map(dataB1(4), dataB2(4), dataB3(4), dataB4(4), CPU_D(4));
  setCPU_D5 : or4 port map(dataB1(5), dataB2(5), dataB3(5), dataB4(5), CPU_D(5));
  setCPU_D6 : or4 port map(dataB1(6), dataB2(6), dataB3(6), dataB4(6), CPU_D(6));
  setCPU_D7 : or4 port map(dataB1(7), dataB2(7), dataB3(7), dataB4(7), CPU_D(7));
  
  HM <= HitQ;
end structural;
