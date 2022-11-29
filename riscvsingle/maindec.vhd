library ieee;
use ieee.std_logic_1164.all;

entity maindec is
    port(
        opcode:     in  std_logic_vector(6 downto 0); 
        
        memtoreg:   out std_logic;
        aluop:      out std_logic_vector(1 downto 0);
        we:         out std_logic;
        alusrc:     out std_logic; 
        branch:     out std_logic;
        regwrite:   out std_logic;
        immsrc:     out std_logic_vector(1 downto 0) -- tell type of instr
    );
end entity maindec;

architecture behavioural of maindec is

    signal controls: std_logic_vector(8 downto 0);

begin

    process(opcode)
    begin
        case opcode is
            when "0110011"  => controls <= "0010010--"; -- r-format (add, sub, or, and)
            when "0000011"  => controls <= "111000000"; -- lw
            when "0100011"  => controls <= "100100001"; -- sw
            when "1100011"  => controls <= "000010110"; -- beq
            when others     => controls <= "---------"; -- not valid
        end case;
    end process;

    (alusrc, memtoreg, regwrite, we, branch, aluop(1), aluop(0), immsrc(1), immsrc(0)) <= controls;

end architecture behavioural;
