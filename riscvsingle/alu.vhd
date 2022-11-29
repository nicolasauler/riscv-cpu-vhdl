library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity alu is 
    port(
        a, b:       in                  std_logic_vector(31 downto 0);
        alucontrol: in                  std_logic_vector(2  downto 0);
        alures:  buffer              std_logic_vector(31 downto 0);
        zero:       out                 std_logic
        -- overflow: out   std_logic;
    );
end entity alu;

architecture synth of alu is

    signal soma, bout:     std_logic_vector(31 downto 0);
	 signal s_test:			std_logic_vector(0 downto 0);

begin

s_test <= (others => alucontrol(2));

bout <= (not b) when (alucontrol(2) = '1') 
                else b;
soma <= std_logic_vector(unsigned(a) + unsigned(bout) + unsigned(s_test));

-- alu function
process(a, soma, bout, alucontrol)
begin

    case alucontrol(1 downto 0) is
        when "00" => alures <= a and bout;
        when "01" => alures <= a or bout;
        when "10" => alures <= soma;
        when "11" => alures <= ("0000000000000000000000000000000" & soma(31));
        when others => alures <= X"00000000";
    end case;

end process;

zero <= '1' when (alures = X"00000000") else '0';

-- overflow circuit
--process(all) begin
--
--    case alucontrol(2 downto 1) is
--        when "01" => Overflow <= 
--            (A(31) and B(31) and (not (soma(31)))) or
--            ((not A(31)) and (not B(31)) and soma(31));
--        when "11" => Overflow <= 
--            ((not A(31)) and B(31) and soma(31)) or
--            (A(31) and (not B(31)) and (not soma(31)));
--        when others => Overflow <= '0';
--    end case;
--end process;

end architecture synth;
