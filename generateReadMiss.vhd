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
    clk   : in std_logic;
    rst   : in std_logic;
    r_w   : in std_logic;
    start : in std_logic;
    CPU_A : in std_logic_vector(5 downto 0);
    MEM_D : in std_logic_vector(7 downto 0);
    HitMiss : in std_logic;
    busy  : out std_logic;
    CPU_D : out std_logic_vector(7 downto 0);
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


-- all 19 clock signals for Dff --
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
signal resetbar : std_logic;
signal busyQ : std_logic:='0';
signal validQ : std_logic:='0';
signal confirmWrite : std_logic;
signal Validclk : std_logic;
signal busySet: std_logic;
signal clk11bar, clk12bar : std_logic;
signal RDone, WDone, rst_busy, r_wbar, HitMiss: std_logic;
signal WHDone, WMDone, RHDone : std_logic:='0';
begin
    -- comb. neg. edge clk dffs --
    getClk : cCount port map(clk, busyQ, rst, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, clk10, clk11, clk12, clk13, clk14, clk15, clk16, clk17, clk18, clk19);
--    setProp : inverter port map(clk3,stopProp);

    RSTBAR: inverter port map(rst, resetbar);
    c11bar: inverter port map(clk11, clk11bar);
    c12bar: inverter port map(clk12, clk12bar);
    write: inverter port map(r_w,r_wbar);
    Vlidclk: or2 port map(rst,clk11,Validclk);
    setValidRM: dff port map(busyQ,Validclk,validQ,stud);
    
    --update HIT with signal for a hit success
    setRMDone : and3 port map(clk2,HitMiss, r_w, RHDone);
    --both writes have the same conditions to complete
    setWHDone : and3 port map(clk3,r_wbar, WDone);
    --clk19 means RMDone
    RActionDone: or2 port map(clk19, RHDone, RDone);
    setRST_Busy: or3 port map(RDone, WDone, rst, rst_busy);

    setBusyQ: sr port map(clk,start, rst_busy, busyQ, stud);
    
    setMEM_AQ0: dff port map(CPU_A(0),clk4,MEM_A(0),stud);
    setMEM_AQ1: dff port map(CPU_A(1),clk4,MEM_A(1),stud);
    setMEM_AQ2: dff port map(CPU_A(2),clk4,MEM_A(2),stud);
    setMEM_AQ3: dff port map(CPU_A(3),clk4,MEM_A(3),stud);
    setMEM_AQ4: dff port map(CPU_A(4),clk4,MEM_A(4),stud);
    setMEM_AQ5: dff port map(CPU_A(5),clk4,MEM_A(5),stud);
       
    
    setcWrite: dff port map(busyQ,clk12bar,confirmWrite,stud);

    -- begin state machine for ReadMiss --
   
    --chose clk11 and clk11bar because we want two signals that are 0 and 1 respectively during confirmWrite = 1 (which occurs at clk12)
    setWriteHigh : cachecell port map(MEM_D(0), confirmWrite, clk11, clk11bar, CPU_D(0));
    busy <= busyQ;
    valid <= validQ;

  end structural;
