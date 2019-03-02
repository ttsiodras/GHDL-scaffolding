--  A testbench has no ports.
library std;
use std.textio.all;

entity adder_tb is
end adder_tb;

architecture behav of adder_tb is
  --  Declaration of the component that will be instantiated.
  component adder
    port (i0, i1 : in bit; ci : in bit; s : out bit; co : out bit);
  end component;

  --  Specifies which entity is bound with the component.
  -- Not necessary, IMHO (ttsiod)
  -- for adder_0: adder use entity work.adder;
  signal i0, i1, ci, s, co : bit;
begin
  --  Component instantiation.
  adder_0: adder port map (i0 => i0, i1 => i1, ci => ci,
                           s => s, co => co);

  --  This process does the real job.
  process
    type pattern_type is record
      --  The inputs of the adder.
      f_i0, f_i1, f_ci : bit;
      --  The expected outputs of the adder.
      f_s, f_co : bit;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0', '0'),
       ('0', '0', '1', '1', '0'),
       ('0', '1', '0', '1', '0'),
       ('0', '1', '1', '0', '1'),
       ('1', '0', '0', '1', '0'),
       ('1', '0', '1', '0', '1'),
       ('1', '1', '0', '0', '1'),
       ('1', '1', '1', '1', '1'));
  begin
    --  Check each pattern.
    for i in patterns'range loop
      --  Set the inputs.
      i0 <= patterns(i).f_i0;
      i1 <= patterns(i).f_i1;
      ci <= patterns(i).f_ci;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert s = patterns(i).f_s
        report "bad sum value" severity error;
      assert co = patterns(i).f_co
        report "bad carry out value, co=" & bit'Image(co) severity failure;
        -- report "bad carry out value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
