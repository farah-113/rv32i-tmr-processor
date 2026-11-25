library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Unit test of the register file (ports: clk, we, wa, wd, ra1, ra2, rd1, rd2).
entity tb_register_file is
end entity tb_register_file;

architecture sim of tb_register_file is
  signal clk, we : std_logic := '0';
  signal wa, ra1, ra2 : std_logic_vector(4 downto 0) := (others => '0');
  signal wd, rd1, rd2 : std_logic_vector(31 downto 0) := (others => '0');
  signal done : boolean := false;
begin
  dut : entity work.register_file
    port map (clk => clk, we => we, wa => wa, wd => wd, ra1 => ra1, ra2 => ra2, rd1 => rd1, rd2 => rd2);

  clk <= not clk after 5 ns when not done else '0';

  process
    variable errors, checks : natural := 0;
    procedure check(got, expected : std_logic_vector(31 downto 0); msg : string) is
    begin
      checks := checks + 1;
      if got /= expected then
        errors := errors + 1;
        report msg & ": got " & to_hstring(got) & " expected " & to_hstring(expected) severity error;
      end if;
    end procedure;
    function pattern(i : natural) return std_logic_vector is
    begin
      return std_logic_vector(to_unsigned(i * 16#01010101# + 16#3C5A0F1E#, 32));
    end function;
    procedure write_reg(r : natural; d : std_logic_vector(31 downto 0)) is
    begin
      wa <= std_logic_vector(to_unsigned(r, 5)); wd <= d; we <= '1';
      wait until rising_edge(clk); wait for 1 ns; we <= '0';
    end procedure;
  begin
    wait for 1 ns;
    for i in 0 to 31 loop                                   -- all registers are 0 at start-up
      ra1 <= std_logic_vector(to_unsigned(i, 5)); wait for 1 ns;
      check(rd1, x"00000000", "start-up value of x" & integer'image(i));
    end loop;
    for i in 1 to 31 loop write_reg(i, pattern(i)); end loop;
    for i in 0 to 31 loop                                   -- both read ports at once
      ra1 <= std_logic_vector(to_unsigned(i, 5)); ra2 <= std_logic_vector(to_unsigned(31 - i, 5)); wait for 1 ns;
      if i = 0 then check(rd1, x"00000000", "x0 on port 1"); else check(rd1, pattern(i), "port 1 x" & integer'image(i)); end if;
      if 31 - i = 0 then check(rd2, x"00000000", "x0 on port 2"); else check(rd2, pattern(31 - i), "port 2 x" & integer'image(31 - i)); end if;
    end loop;
    write_reg(0, x"FFFFFFFF");                              -- x0 ignores writes
    ra1 <= "00000"; wait for 1 ns; check(rd1, x"00000000", "x0 after a write");
    wa <= "00101"; wd <= x"DEADBEEF"; we <= '0';            -- we = 0: no write
    wait until rising_edge(clk); wait for 1 ns;
    ra1 <= "00101"; wait for 1 ns; check(rd1, pattern(5), "write with we = 0");
    wait until falling_edge(clk);                           -- the write happens at the clock edge
    wa <= "00101"; wd <= x"CAFEF00D"; we <= '1'; ra1 <= "00101"; wait for 1 ns;
    check(rd1, pattern(5), "old value before the edge");
    wait until rising_edge(clk); wait for 1 ns; we <= '0';
    check(rd1, x"CAFEF00D", "new value after the edge");
    if errors = 0 then report "tb_register_file: PASSED (" & integer'image(checks) & " checks)" severity note;
    else report "tb_register_file: FAILED (" & integer'image(errors) & " errors)" severity failure; end if;
    done <= true;
    wait;
  end process;
end architecture sim;
