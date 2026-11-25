library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv32i_pkg.all;
use work.program_pkg.all;

-- Unit test of the instruction ROM (compared with program_pkg.PROGRAM) and the data RAM.
entity tb_memories is
end entity tb_memories;

architecture sim of tb_memories is
  signal clk, we : std_logic := '0';
  signal fin : boolean := false;
  signal iaddr, instr, daddr, wdata, rdata : std_logic_vector(31 downto 0) := (others => '0');
begin
  u_rom : entity work.instruction_memory port map (addr => iaddr, instr => instr);
  u_ram : entity work.data_memory port map (clk => clk, we => we, addr => daddr, wdata => wdata, rdata => rdata);

  clk <= not clk after 5 ns when not fin else '0';

  process
    variable errors, checks : natural := 0;
    procedure check(got, expected : std_logic_vector(31 downto 0); msg : string) is
    begin
      checks := checks + 1;
      if got /= expected then errors := errors + 1;
        report msg & ": got " & to_hstring(got) & " expected " & to_hstring(expected) severity error; end if;
    end procedure;
    function byte_addr(w : natural) return std_logic_vector is
    begin
      return std_logic_vector(to_unsigned(4 * w, 32));
    end function;
    procedure write_word(w : natural; d : std_logic_vector(31 downto 0)) is
    begin
      daddr <= byte_addr(w); wdata <= d; we <= '1';
      wait until rising_edge(clk); wait for 1 ns; we <= '0';
    end procedure;
  begin
    for i in 0 to 255 loop                                    -- ROM = program_pkg.PROGRAM (all 256 words)
      iaddr <= byte_addr(i); wait for 1 ns;
      check(instr, PROGRAM(i), "ROM word " & integer'image(i) & " differs from program_pkg");
    end loop;
    iaddr <= std_logic_vector(unsigned(byte_addr(3)) + 3); wait for 1 ns;
    check(instr, PROGRAM(3), "ROM ignores address bits [1:0]");
    check(PROGRAM(100), NOP_INSTR, "words after the program are NOPs");

    for i in 0 to 255 loop                                    -- RAM is 0 at start-up
      daddr <= byte_addr(i); wait for 1 ns; check(rdata, x"00000000", "RAM word " & integer'image(i) & " at start-up");
    end loop;
    for i in 0 to 255 loop write_word(i, std_logic_vector(to_unsigned(i * 7919 + 1, 32))); end loop;
    for i in 0 to 255 loop
      daddr <= byte_addr(i); wait for 1 ns;
      check(rdata, std_logic_vector(to_unsigned(i * 7919 + 1, 32)), "RAM word " & integer'image(i));
    end loop;
    daddr <= byte_addr(10); wdata <= x"FFFFFFFF"; we <= '0';  -- we = 0: no write
    wait until rising_edge(clk); wait for 1 ns;
    check(rdata, std_logic_vector(to_unsigned(10 * 7919 + 1, 32)), "write with we = 0");
    wait until falling_edge(clk);                             -- asynchronous read, write at the edge
    daddr <= byte_addr(20); wdata <= x"A5A5A5A5"; we <= '1'; wait for 1 ns;
    check(rdata, std_logic_vector(to_unsigned(20 * 7919 + 1, 32)), "old value before the edge");
    wait until rising_edge(clk); wait for 1 ns; we <= '0';
    check(rdata, x"A5A5A5A5", "new value after the edge");
    daddr <= std_logic_vector(unsigned(byte_addr(20)) + 2); wait for 1 ns;
    check(rdata, x"A5A5A5A5", "RAM ignores address bits [1:0]");
    if errors = 0 then report "tb_memories: PASSED (" & integer'image(checks) & " checks)" severity note;
    else report "tb_memories: FAILED (" & integer'image(errors) & " errors)" severity failure; end if;
    fin <= true;
    wait;
  end process;
end architecture sim;
