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
    MEM_A : out std_logic_vector(5 downto 0);
    debug : out std_logic
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
         q   : out std_logic);
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
    clk8long : out std_logic;
    clk102beat:out std_logic;
    clk122beat:out std_logic;
    clk142beat:out std_logic);
    
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
    clk1 : in std_logic;
    debug : out std_logic
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
signal clk102beat : std_logic:='0';
signal clk122beat : std_logic:='0';
signal clk142beat : std_logic:='0';
-- useless signal for qbars -- 
signal stud : std_logic;

-- other signals --
signal resetbar, HitMissIn, CPU2, CPU3, CPU4, CPU5: std_logic;
signal busyQ, busyQQ : std_logic:='0';
signal r_wQ, wrDon, wrDonf,r_wlatch : std_logic;
signal clk8bar,clkbar, clk8longbar, startbar: std_logic;
signal RDone, WDone, rst_busy, r_wbar: std_logic:='0';
signal RHDone : std_logic:='0';
signal GND : std_logic:='0';
signal CPU_DQ, WriteD: std_logic_vector(7 downto 0);
signal Add : std_logic_vector(5 downto 0);
begin
    
    -- comb. neg. edge clk dffs --
    clkbarset : inverter port map (clk, clkbar);
    startbarset : inverter port map (start, startbar);
    clkbar8longset : inverter port map (clk8long, clk8longbar);
    getClk : cCount port map(clk, busyQ, rst, clk1, clk2, clk7, clk8, clk10, clk12, clk14, clk16, clk8long, clk102beat, clk122beat, clk142beat);
--    setProp : inverter port map(clk3,stopProp);
    LatchRW1 : dff port map(r_w,startbar,r_wlatch,stud);
    override : and2 port map(r_wlatch, clk8longbar, r_wQ);
    
    c8bar: inverter port map(clk8, clk8bar);
    write: inverter port map(r_wQ,r_wbar);

    --update HIT with signal for a hit success
    setRMDone : and3 port map(clk,HitMissIn, r_wQ, RHDone);
    writept1 : dff port map(clk1, clkbar, wrDon, stud);

    --both writes have the same conditions to complete
    setWHDone : and3 port map(wrDon,r_wbar, clk8longbar, WDone);
    RActionDone: or2 port map(clk16, RHDone, RDone);
    setRST_Busy: or3 port map(RDone, WDone, rst, rst_busy);

    setBusyQ: sr port map(clkbar,start, rst_busy, busyQ);
        
    setMEM_AQ2: dff port map(Add(2),clk8bar,CPU2,stud);
    setMEM_AQ3: dff port map(Add(3),clk8bar,CPU3,stud);
    setMEM_AQ4: dff port map(Add(4),clk8bar,CPU4,stud);
    setMEM_AQ5: dff port map(Add(5),clk8bar,CPU5,stud);
    
    --extracycle: or2 port map(start, busyQ, busyQQ);
    cache: cacheMemory port map(clk, rst, r_wQ, Add, CPU_DO, MEM_D, HitMissIn, clk8long, clk8, clk10, clk12, clk14,clk16,busyQ, WriteD,clk1,debug);

    MEMA0 : or2 port map(clk102beat,clk142beat,MEM_A(0));
    MEMA1 : or2 port map(clk122beat, clk142beat,MEM_A(1));
    MEMA2 : and2 port map(CPU2,clk8long,MEM_A(2));
    MEMA3 : and2 port map(CPU3,clk8long,MEM_A(3));
    MEMA4 : and2 port map(CPU4,clk8long,MEM_A(4));
    MEMA5 : and2 port map(CPU5,clk8long,MEM_A(5));
    
    enable <= clk7;
    busy <= busyQ;
    
    LatchWrite1 : dff port map(CPU_DI(0),r_w,WriteD(0),stud);
    LatchWrite2 : dff port map(CPU_DI(1),r_w,WriteD(1),stud);
    LatchWrite3 : dff port map(CPU_DI(2),r_w,WriteD(2),stud);
    LatchWrite4 : dff port map(CPU_DI(3),r_w,WriteD(3),stud);
    LatchWrite5 : dff port map(CPU_DI(4),r_w,WriteD(4),stud);
    LatchWrite6 : dff port map(CPU_DI(5),r_w,WriteD(5),stud);
    LatchWrite7 : dff port map(CPU_DI(6),r_w,WriteD(6),stud);
    LatchWrite8 : dff port map(CPU_DI(7),r_w,WriteD(7),stud);


    LatchAdd1 : dff port map(CPU_A(0),startbar,Add(0),stud);
    LatchAdd2 : dff port map(CPU_A(1),startbar,Add(1),stud);
    LatchAdd3 : dff port map(CPU_A(2),startbar,Add(2),stud);
    LatchAdd4 : dff port map(CPU_A(3),startbar,Add(3),stud);
    LatchAdd5 : dff port map(CPU_A(4),startbar,Add(4),stud);
    LatchAdd6 : dff port map(CPU_A(5),startbar,Add(5),stud);

    
    --debug <= RDone;
  end structural;
