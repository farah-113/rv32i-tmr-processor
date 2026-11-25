----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2026 01:37:05 AM
-- Design Name: 
-- Module Name: instruction_memory - Behavioral
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

entity instruction_memory is
  port (
    addr  : in  std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0)
  );
end entity instruction_memory;

architecture behavioural of instruction_memory is

  type tROM is array (0 to 255) of std_logic_vector(31 downto 0);
  constant ROM : tROM := (
    0      => x"00500093",   --  0x00: addi x1, x0, 5
    1      => x"00700113",   --  0x04: addi x2, x0, 7
    2      => x"002081B3",   --  0x08: add  x3, x1, x2
    3      => x"00302023",   --  0x0C: sw   x3, 0(x0)
    4      => x"00002203",   --  0x10: lw   x4, 0(x0)
    5      => x"00418463",   --  0x14: beq  x3, x4, +8    
    6      => x"06300293",   --  0x18: addi x5, x0, 99  
    7      => x"40120333",   --  0x1C: sub  x6, x4, x1
    8      => x"0000006F",   --  0x20: jal  x0, 0           --loop
    others => NOP_INSTR 
  );

begin

  instr <= ROM(conv_integer(addr(9 downto 2)));

end behavioural;