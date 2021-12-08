--  A testbench has no ports.
library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity simplegic_tb is
end simplegic_tb;

architecture behav of simplegic_tb is

  --  Declaration of the component that will be instantiated.
  component GIC
    port (
        CLK : in std_logic;
        RST : in std_logic;

        ACK : in std_logic;
        EN  : in std_logic;

        IRQ : out std_logic
    );
  end component;

  -- for mandel_0: MandelBrot use entity work.MandelBrot;


  -- 50 MHz clock
  constant half_period : time  := 3.33333333333 ns;
  constant cycle_period : time  := 6.66666666666 ns;

  signal clk : std_logic := '0'; -- make sure you initialise!
  signal rst : std_logic := '1'; -- make sure you initialise!

  signal ACK : std_logic := '0';
  signal EN  : std_logic := '0';
  signal IRQ : std_logic := '0';

begin
  clk <= not clk after half_period;

  --  Component instantiation.
  gic_0: GIC port map (
    clk => clk,
    rst => rst,
    ACK => ACK,
    EN => EN,
    IRQ => IRQ
  );

  --  This process does the real job.
  process
  begin
    -- Reset for 100 cycles
    rst <= '1';
    wait for 2*cycle_period;
    rst <= '0';
    wait for 5*cycle_period;

    --  Set the inputs.
    ACK <= '0';
    EN <= '0';
    wait for 16*cycle_period;

    EN <= '1';
    wait for 16*cycle_period;

    ACK <= '1';
    wait for cycle_period;
    ACK <= '0';
    wait for 16*cycle_period;

    ACK <= '1';
    wait for cycle_period;
    ACK <= '0';
    wait for 16*cycle_period;

    assert false report "end of test" severity error;
    wait;
  end process;

end behav;
