----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:10:50 PM
-- Design Name: 
-- Module Name: pc_register - Behavioral
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

entity pc_register is
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    pc_next : in  std_logic_vector(31 downto 0);
    pc      : out std_logic_vector(31 downto 0)
  );
end entity pc_register;

architecture behavioural of pc_register is
  signal pc_q : std_logic_vector(31 downto 0) := (others => '0');
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        pc_q <= (others => '0');
      else
        pc_q <= pc_next;
      end if;
    end if;
  end process;

  pc <= pc_q;

end behavioural;