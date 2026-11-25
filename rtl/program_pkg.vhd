----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 04:17:33 PM
-- Design Name: 
-- Module Name: program_pkg - Behavioral
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
use work.rv32i_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package program_pkg is

  constant PROGRAM : mem_array_t := (
    0      => x"00500093",   --  0x00: addi x1, x0, 5
    1      => x"00700113",   --  0x04: addi x2, x0, 7
    2      => x"002081B3",   --  0x08: add  x3, x1, x2
    3      => x"00302023",   --  0x0C: sw   x3, 0(x0)
    4      => x"00002203",   --  0x10: lw   x4, 0(x0)
    5      => x"00418463",   --  0x14: beq  x3, x4, +8      (taken -> 0x1C)
    6      => x"06300293",   --  0x18: addi x5, x0, 99      (skipped)
    7      => x"40120333",   --  0x1C: sub  x6, x4, x1
    8      => x"0000006F",   --  0x20: jal  x0, 0           (loop forever)
    others => NOP_INSTR      --  Fills words 9 to 255 with NOP (0x00000013)
  );

end package program_pkg;
