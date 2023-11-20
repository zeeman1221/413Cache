----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 10:38:33 PM
-- Design Name: 
-- Module Name: selector - Behavioral
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

entity selector is
port (
    chipEnable : in std_logic;
    r_w : in std_logic;
    rdEn : out std_logic;
    wrEn : out std_logic;
    Hit : in std_logic
 );
end selector;

architecture structural of selector is
component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
end component;

component and3

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    output   : out std_logic);
end component;

-- signals --
signal notR_W : std_logic;
signal rdEnQ, wrEnQ : std_logic;

begin
makeInverter : inverter port map(r_w, notR_W);
makeAndReadEn : and3 port map(r_w, chipEnable, Hit, rdEn);
makeAndWriteEn : and3 port map(notR_W, chipEnable, Hit, wrEn);
end structural;
