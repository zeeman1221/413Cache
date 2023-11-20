----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 09:31:27 PM
-- Design Name: 
-- Module Name: cachecell - Behavioral
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

entity cachecell is
  port ( 
  wrD : in std_logic;
  wrEn : in std_logic;
  rdEn : in std_logic;
  rdOut : out std_logic ;
  override:in std_logic
  );
end cachecell;

architecture structural of cachecell is

component Dlatch                      
  port ( d   : in  std_logic;
         clk : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
end component; 

component or2
  port (
    input1    : in  std_logic;
    input2   : in std_logic;
    output   : out std_logic);
end component;

component and2
  port (
    input1    : in  std_logic;
    input2   : in std_logic;
    output   : out std_logic);
end component;

-- signals --
signal outPort : std_logic;
signal notOutPort,outputEn : std_logic;

begin
    makeDlatch : Dlatch port map(wrD, wrEn, outPort, notOutPort);
    startOutput: or2 port map(override,rdEn,outputEn);
    output: and2 port map(outputEn, outPort, rdOut);
end structural;
