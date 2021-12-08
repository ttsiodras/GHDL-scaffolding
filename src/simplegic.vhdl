library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity GIC is
    port (
        CLK : in std_logic;
        RST : in std_logic;

        ACK : in std_logic;
        EN  : in std_logic;

        IRQ : out std_logic
    );
end GIC;

architecture arch of GIC is

    type state_type is (
    	waiting_for_period,
        activate_one_cycle,
        one_cycle_over
    );
    signal state : state_type;

    signal ready_for_next : std_logic;
    signal debug_state : integer;
begin

    debug_state <= state_type'pos(state);

    process (RST, CLK)
    begin
        if (RST='1') then
            state <= waiting_for_period;
            ready_for_next <= '1';
        elsif rising_edge(CLK) then
            IRQ <= '0';
            case state is
                when waiting_for_period =>
                    if EN = '1' and ready_for_next = '1' then
                        state <= activate_one_cycle;
                    else
                        if ACK = '1' then
                            ready_for_next <= '1';
                        end if;
                        state <= waiting_for_period;
                    end if;

                when activate_one_cycle =>
                   IRQ <= '1';
                   state <= one_cycle_over;

                when one_cycle_over =>
                   IRQ <= '0';
                   ready_for_next <= '0';
                   state <= waiting_for_period;

            end case; -- case state is ...

        end if; -- if rising_edge(CLK) ...
    end process;

end arch;
