----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 04:59:02 PM
-- Design Name: 
-- Module Name: register_file - Behavioral
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

entity register_file is
  port (
    clk : in  std_logic;
  
    we  : in  std_logic;
    wa  : in  std_logic_vector(4 downto 0);
    wd  : in  std_logic_vector(31 downto 0);

    ra1 : in  std_logic_vector(4 downto 0);
    ra2 : in  std_logic_vector(4 downto 0);
    rd1 : out std_logic_vector(31 downto 0);
    rd2 : out std_logic_vector(31 downto 0)
  );
end entity register_file;

architecture behavioural of register_file is
  type reg_array_t is array (0 to 31) of std_logic_vector(31 downto 0);
  signal regs : reg_array_t := (others => X"00000000");
  
begin

write_proc : process (clk)
  begin
    if rising_edge(clk) then
      if we = '1' and wa /= "00000" then
        regs(conv_integer(wa)) <= wd;
      end if;
    end if;
  end process write_proc;

  rd1 <= (others => '0') when ra1 = "00000" else regs(conv_integer(ra1));
  rd2 <= (others => '0') when ra2 = "00000" else regs(conv_integer(ra2));

end behavioural;