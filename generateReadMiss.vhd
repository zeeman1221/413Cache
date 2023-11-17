----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2023 10:34:31 PM
-- Design Name: 
-- Module Name: generateReadMiss - Behavioral
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

entity generateReadMiss is
port (
    CPU_A : in std_logic_vector(5 downto 0);
    CPU_D : out std_logic_vector(7 downto 0);
    r_w   : in std_logic;
    start : in std_logic;
    clk   : in std_logic;
    rst   : in std_logic;
    MEM_D : in std_logic_vector(7 downto 0);
    busy  : out std_logic;
    enable : out std_logic;
    MEM_A : out std_logic_vector(5 downto 0)
);
end generateReadMiss;

architecture structural of generateReadMiss is
component cachecell
  port ( 
  wrD : in std_logic;
  wrEn : in std_logic;
  rdEn : in std_logic;
  rdEnBar : in std_logic;
  rdOut : out std_logic 
  );
end component;

component dff                
  port ( d   : in  std_logic;
         clk : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
end component;      

component inverter                
  port ( input   : in  std_logic;
         output: out std_logic); 
end component; 

component or2                
  port ( input1   : in  std_logic;
         input2   : in  std_logic;
         output: out std_logic); 
end component;

component or3                
  port ( input1   : in  std_logic;
         input2   : in  std_logic;
         input3   : in  std_logic;
         output: out std_logic); 
end component;

component and3                
  port ( input1   : in  std_logic;
         input2   : in  std_logic;
         input3   : in  std_logic;
         output: out std_logic); 
end component;

component and2                
  port ( input1   : in  std_logic;
         input2   : in  std_logic;
         output: out std_logic); 
end component;

component sr                      
  port (  
         clk : in std_logic;
         J   : in  std_logic;
         K : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
end component;  

component HitMiss
  port (
    clk : in std_logic;
    CacheTag : in std_logic_vector(1 downto 0);
    TagInp   : in std_logic_vector(1 downto 0);
    valid    : in std_logic;
    clk8     : in std_logic;
    output   : out std_logic);
end component;

component cCount
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
    clk19    : out std_logic);
end component;

component cacheMemory is
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
    clk14 : in std_logic
 );
end component;


-- all 19 clock signals for Dff --
signal clk1 : std_logic:='0';
signal clk2 : std_logic:='0';
signal clk3 : std_logic:='0';
signal clk4 : std_logic:='0';
signal clk5 : std_logic:='0';
signal clk6 : std_logic:='0';
signal clk7 : std_logic:='0';
signal clk8 : std_logic:='0';
signal clk9 : std_logic:='0';
signal clk10 : std_logic:='0';
signal clk11 : std_logic:='0';
signal clk12 : std_logic:='0';
signal clk13 : std_logic:='0';
signal clk14 : std_logic:='0';
signal clk15 : std_logic:='0';
signal clk16 : std_logic:='0';
signal clk17 : std_logic:='0';
signal clk18 : std_logic:='0';
signal clk19 : std_logic:='0';
-- useless signal for qbars -- 
signal stud : std_logic;

-- other signals --
signal resetbar, HitMissIn : std_logic;
signal busyQ : std_logic:='0';
signal r_wQ: std_logic;
signal clk8bar : std_logic;
signal RDone, WDone, rst_busy, r_wbar: std_logic:='0';
signal RHDone : std_logic:='0';
begin
    -- comb. neg. edge clk dffs --
    getClk : cCount port map(clk, busyQ, rst, clk1, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, clk10, clk11, clk12, clk13, clk14, clk15, clk16, clk17, clk18, clk19);
--    setProp : inverter port map(clk3,stopProp);
    override : and2 port map(r_w, clk8bar, r_wQ);
    
    RSTBAR: inverter port map(rst, resetbar);
    c8bar: inverter port map(clk8, clk8bar);
    write: inverter port map(r_w,r_wbar);

    
    --update HIT with signal for a hit success
    setRMDone : and3 port map(clk1,HitMissIn, r_w, RHDone);
    --both writes have the same conditions to complete
    setWHDone : and2 port map(clk2,r_wbar, WDone);
    --clk19 means RMDone
    RActionDone: or2 port map(clk17, RHDone, RDone);
    setRST_Busy: or3 port map(RDone, WDone, rst, rst_busy);

    setBusyQ: sr port map(clk,start, rst_busy, busyQ, stud);
    
    setMEM_AQ0: dff port map(start,clk8bar,MEM_A(0),stud);
    setMEM_AQ1: dff port map(start,clk8bar,MEM_A(1),stud);
    setMEM_AQ2: dff port map(CPU_A(2),clk8bar,MEM_A(2),stud);
    setMEM_AQ3: dff port map(CPU_A(3),clk8bar,MEM_A(3),stud);
    setMEM_AQ4: dff port map(CPU_A(4),clk8bar,MEM_A(4),stud);
    setMEM_AQ5: dff port map(CPU_A(5),clk8bar,MEM_A(5),stud);
       
    cache: cacheMemory port map(clk, rst, r_wQ, CPU_A, CPU_D, MEM_D, HitMissIn, clk8, clk9, clk10, clk12, clk14);


    enable <= clk7;
    busy <= busyQ;

  end structural;
