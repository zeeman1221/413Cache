-- Entity: chip_test 
-- Architecture : test 
-- Author: cpatel2
-- Created On: 11/01/05
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use STD.textio.all;
  
entity chip_test is
  
end chip_test;
  
architecture test of chip_test is

--CPU_DO and CPU_DI are two split signals from the original CPU_D inout signal
--CPU_DO is a pure output (and is read to the waveform as such
--CPU_DI is a pure input and reads in from the chip_test.txt file
--if then are combined, the CPU_D line becomes XX whenever data is pushed back through its output function
  component generateReadMiss  
    port (
    CPU_A : in std_logic_vector(6 downto 0);
    CPU_DO : out std_logic_vector(7 downto 0);
    CPU_DI : in std_logic_vector(7 downto 0);
    r_w   : in std_logic;
    start : in std_logic;
    clk   : in std_logic;
    rst   : in std_logic;
    MEM_D : in std_logic_vector(7 downto 0);
    busy  : out std_logic;
    enable : out std_logic;
    MEM_A : out std_logic_vector(6 downto 0)
    );
      
  end component;


  
  for c1 : generateReadMiss use entity work.generateReadMiss(structural);

  signal Vdd, Gnd: std_logic;
  signal cpu_datao, cpu_datai, mem_data: std_logic_vector(7 downto 0);
  signal cpu_add, mem_add: std_logic_vector(6 downto 0);
  signal cpu_rd_wrn, reset, clk, start, clock, busy, mem_en: std_logic;

  signal clk_count: integer:=0;

procedure print_output is
   variable out_line: line;

   begin
   write (out_line, string' (" Clock: "));
   write (out_line, clk_count);
   write (out_line, string'(" Start: "));
   write (out_line, start);
   write (out_line, string'(" Cpu Read/Write: "));
   write (out_line, cpu_rd_wrn);
   write (out_line, string'(" Reset: "));
   write (out_line, reset);
   writeline(output, out_line);

   write (out_line, string' (" CPU address: "));
   write (out_line, cpu_add);
   write (out_line, string'(" CPU data: "));
   write (out_line, cpu_datao);
   writeline(output, out_line);
   
   write (out_line, string'(" Memory data: "));
   write (out_line, mem_data);   
   writeline(output, out_line);
   writeline(output, out_line);
      
   write (out_line, string'(" Busy: "));
   write (out_line, busy);
   write (out_line, string'(" Memory  Enable: "));
   write (out_line, mem_en);
   writeline(output, out_line);

   write (out_line, string'(" Memory  Address: "));
   write (out_line, mem_add);
   writeline(output, out_line);   

   write (out_line, string'(" ----------------------------------------------"));
   writeline(output, out_line);

   
end print_output;



begin

  Vdd <= '1';
  Gnd <= '0';
  clk <= clock;
  
  c1 : generateReadMiss port map (cpu_add, cpu_datao, cpu_datai, cpu_rd_wrn, start, clk, reset, mem_data, busy, mem_en, mem_add);   

  clking : process
  begin
    clock<= '1', '0' after 5 ns;
    wait for 10 ns;
  end process clking;
  
  io_process: process
    --3 different memory files for testing
    -- chip_inLOWER.txt checks lower half of cache (extra bit is 0)
    -- chip_inUP.txt checks upper half of cache (extra bit is 1)
    -- chip_inALL.txt checks both halves to make sure one block in lower with same tag as higher cannot access it
    file infile  : text is in "./chip_inUP.txt";
    variable out_line: line;
    variable buf: line;
    variable value: std_logic_vector(7 downto 0);
    variable value0: std_logic_vector(6 downto 0);
    variable value1: std_logic;
    
  begin

    while not (endfile(infile)) loop
      
      wait until rising_edge(clock);
      print_output;

      readline(infile, buf);
      read(buf, value0);
      cpu_add <= value0;

      readline(infile, buf);
      read(buf, value);
      cpu_datai <= value;

      readline(infile, buf);
      read(buf, value1);
      cpu_rd_wrn <= value1;

      readline(infile, buf);
      read(buf, value1);
      start <= value1;      

      readline(infile, buf);
      read(buf, value1);
      reset <= value1;      
      
      wait until falling_edge(clock);

      readline(infile, buf);
      read(buf, value);
      mem_data <= value;
      
      clk_count <= clk_count+1;

      print_output;

    end loop;
    wait;
      
  end process io_process;


end test;