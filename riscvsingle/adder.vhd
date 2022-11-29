library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity adder is
    port(
        a, b:       in  std_logic_vector(31 downto 0);
        y:          out std_logic_vector(31 downto 0)
    );
end entity adder;

architecture behavioural of adder is

begin

    y <= std_logic_vector(unsigned(a) + unsigned(b));

end architecture behavioural;
