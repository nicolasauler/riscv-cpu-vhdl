library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity datamem is
    port(
        clk, we:        in  std_logic;
        a, wd:          in  std_logic_vector(31 downto 0);
        rd:             out std_logic_vector(31 downto 0)
    );
end entity datamem;

architecture behavioural of datamem is

	type ramtype is array(63 downto 0) of std_logic_vector(31 downto 0);
	signal mem: ramtype := (others => (others => '0'));

begin
	--mem(0) := "00000000000000000000000000000111"; -- 7
	-- read or write memory
	process(clk)
	begin
		if rising_edge(clk) then
			if(we='1') then 
				mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
			end if;
		end if;
	end process;

	rd <= mem(to_integer(unsigned(a(7 downto 2))));

end architecture behavioural;
