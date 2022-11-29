library ieee;
use ieee.std_logic_1164.all;

entity flopr is
    generic(
        width:                  integer := 32
    );
    port(
        clk, rst:   in          std_logic;
        en:         in          std_logic;
        d:          in          std_logic_vector(width-1 downto 0);
        q:          out         std_logic_vector(width-1 downto 0)
    );
end entity flopr;

architecture asynchronous of flopr is

begin

    process(clk, rst, en)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) and (en = '1') then
            q <= d;
        end if;
    end process;

end architecture asynchronous;
