library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generateReadMiss is
port (
    CPU_A : in std_logic_vector(5 downto 0);
    CPU_DO : out std_logic_vector(7 downto 0);
    CPU_DI : in std_logic_vector(7 downto 0);
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
    clk7     : out std_logic;
    clk8     : out std_logic;
    clk10    : out std_logic;
    clk12    : out std_logic;
    clk14    : out std_logic;
    clk16    : out std_logic;
    clk8long : out std_logic);
end component;

component cacheMemory
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
    WriteD : in std_logic_vector (7 downto 0);
    clk1 : in std_logic
 );
end component;
-- all 19 clock signals for Dff --
signal clk1 : std_logic:='0';
signal clk2 : std_logic:='0';
signal clk7 : std_logic:='0';
signal clk8 : std_logic:='0';
signal clk10 : std_logic:='0';
signal clk12 : std_logic:='0';
signal clk14 : std_logic:='0';
signal clk16 : std_logic:='0';
signal clk8long : std_logic:='0';
-- useless signal for qbars -- 
signal stud : std_logic;

-- other signals --
signal resetbar, HitMissIn, CPU2, CPU3, CPU4, CPU5: std_logic;
signal busyQ, busyQQ : std_logic:='0';
signal r_wQ, wrDon, wrDonf : std_logic;
signal clk8bar,clkbar, clk8longbar: std_logic;
signal RDone, WDone, rst_busy, r_wbar: std_logic:='0';
signal RHDone : std_logic:='0';
signal GND : std_logic:='0';
signal CPU_DQ, WriteD: std_logic_vector(7 downto 0);
begin
    
    -- comb. neg. edge clk dffs --
    clkbarset : inverter port map (clk, clkbar);
    clkbar8longset : inverter port map (clk8long, clk8longbar);
    getClk : cCount port map(clk, busyQ, rst, clk1, clk2, clk7, clk8, clk10, clk12, clk14, clk16, clk8long);
--    setProp : inverter port map(clk3,stopProp);
    override : and2 port map(r_w, clk8longbar, r_wQ);
    
    c8bar: inverter port map(clk8, clk8bar);
    write: inverter port map(r_wQ,r_wbar);

    --update HIT with signal for a hit success
    setRMDone : and3 port map(clk,HitMissIn, r_wQ, RHDone);
    writept1 : dff port map(busyQ, clkbar,wrDon, stud);

    --both writes have the same conditions to complete
    setWHDone : and3 port map(wrDon,r_wbar, clk8longbar, WDone);
    RActionDone: or2 port map(clk16, RHDone, RDone);
    setRST_Busy: or3 port map(RDone, WDone, rst, rst_busy);

    setBusyQ: sr port map(clkbar,start, rst_busy, busyQ, stud);
        
    setMEM_AQ2: dff port map(CPU_A(2),clk8bar,CPU2,stud);
    setMEM_AQ3: dff port map(CPU_A(3),clk8bar,CPU3,stud);
    setMEM_AQ4: dff port map(CPU_A(4),clk8bar,CPU4,stud);
    setMEM_AQ5: dff port map(CPU_A(5),clk8bar,CPU5,stud);
    
    extracycle: or2 port map(start, busyQ, busyQQ);
    cache: cacheMemory port map(clk, rst, r_wQ, CPU_A, CPU_DQ, MEM_D, HitMissIn, clk8long, clk8, clk10, clk12, clk14,clk16,busyQQ, WriteD,clk1);

    MEM_A(0) <='0';
    MEM_A(1) <='0';
    MEMA2 : and2 port map(CPU2,clk8long,MEM_A(2));
    MEMA3 : and2 port map(CPU3,clk8long,MEM_A(3));
    MEMA4 : and2 port map(CPU4,clk8long,MEM_A(4));
    MEMA5 : and2 port map(CPU5,clk8long,MEM_A(5));
    
    enable <= clk7;
    busy <= busyQ;
    
    LatchWrite1 : dff port map(CPU_DI(0),start,WriteD(0),stud);
    LatchWrite2 : dff port map(CPU_DI(1),start,WriteD(1),stud);
    LatchWrite3 : dff port map(CPU_DI(2),start,WriteD(2),stud);
    LatchWrite4 : dff port map(CPU_DI(3),start,WriteD(3),stud);
    LatchWrite5 : dff port map(CPU_DI(4),start,WriteD(4),stud);
    LatchWrite6 : dff port map(CPU_DI(5),start,WriteD(5),stud);
    LatchWrite7 : dff port map(CPU_DI(6),start,WriteD(6),stud);
    LatchWrite8 : dff port map(CPU_DI(7),start,WriteD(7),stud);
    
    
    
    CPUD0 : and2 port map(CPU_DQ(0),HitMissIn,CPU_DO(0));
    CPUD1 : and2 port map(CPU_DQ(1),HitMissIn,CPU_DO(1));
    CPUD2 : and2 port map(CPU_DQ(2),HitMissIn,CPU_DO(2));
    CPUD3 : and2 port map(CPU_DQ(3),HitMissIn,CPU_DO(3));
    CPUD4 : and2 port map(CPU_DQ(4),HitMissIn,CPU_DO(4));
    CPUD5 : and2 port map(CPU_DQ(5),HitMissIn,CPU_DO(5));
    CPUD6 : and2 port map(CPU_DQ(6),HitMissIn,CPU_DO(6));
    CPUD7 : and2 port map(CPU_DQ(7),HitMissIn,CPU_DO(7));
    
    --debug <= HitMissIn;
  end structural;
