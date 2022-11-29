library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
    generic(
        width:  integer := 8
    );
    port(
        d0, d1, d2:     in          std_logic_vector(width-1 downto 0);
        s:              in          std_logic_vector(1 downto 0);
        y:              out         std_logic_vector(width-1 downto 0)
    );
end entity mux3;

architecture behavioural of mux3 is

begin

    y   <=  d2 when s="10" else
            d1 when s="01" else
            d0;

end architecture behavioural;
