library ieee;
use ieee.std_logic_1164.all;

entity immgen is
    port(
        instr:      in          std_logic_vector(31 downto 7); -- parts of instructions with immediate fields
        immsrc:     in          std_logic_vector(1 downto 0); -- r-type dont have immediates, so doesnt have immsrc
        immext:     out         std_logic_vector(31 downto 0)
    );
end entity immgen;

architecture behavioural of immgen is 

begin

    process(instr, immsrc) begin
        case immsrc is
            when "00" => -- I-type load
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 20); 
            when "01" => -- S-type store
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            when "10" => -- B-type beq
                immext <= (31 downto 12 => instr(31)) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
            when others =>
                immext <= (31 downto 0 => '-');
        end case;
    end process;

end architecture behavioural;
