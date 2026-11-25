----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2026 01:49:19 AM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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
use ieee.std_logic_unsigned.all;
use work.rv32i_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
  port (
    clk   : in  std_logic;
    we    : in  std_logic;
    addr  : in  std_logic_vector(31 downto 0);
    wdata : in  std_logic_vector(31 downto 0);
    rdata : out std_logic_vector(31 downto 0)
  );
end entity data_memory;

architecture behavioural of data_memory is
  type tRAM is array (0 to 255) of std_logic_vector(31 downto 0);
  signal RAM : tRAM := (others => (others => '0'));
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        RAM(conv_integer(addr(9 downto 2))) <= wdata;
      end if;
    end if;
  end process;

  rdata <= RAM(conv_integer(addr(9 downto 2)));

end behavioural;