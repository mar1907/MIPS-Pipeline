--Execution unit


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ex is
    Port ( ALUsrc : in STD_LOGIC;
           pc1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD1: in STD_LOGIC_VECTOR(15 downto 0);
           RD2: in STD_LOGIC_VECTOR(15 downto 0);
           ALUop: in STD_LOGIC_VECTOR(1 downto 0);
           instr: in STD_LOGIC_VECTOR(15 downto 0);
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           zero: out STD_LOGIC;
           BranchAdd: out STD_LOGIC_VECTOR(15 downto 0));
end Ex;

architecture Behavioral of Ex is
signal ctrl: std_logic_vector(2 downto 0);
signal alu2: std_logic_vector(15 downto 0);
signal aluRes1: std_logic_vector(15 downto 0);
begin
    BranchAdd<=pc1+("000000000"&instr(6 downto 0));
    
    process(ALUop, instr)
    begin
        case ALUop is
            when "00"=>
                case instr(2 downto 0) is
                    when "000"=>ctrl<="000";
                    when "001"=>ctrl<="001";
                    when "010"=>ctrl<="010";
                    when "011"=>ctrl<="011";
                    when "100"=>ctrl<="100";
                    when "101"=>ctrl<="101";
                    when "110"=>ctrl<="110";
                    when "111"=>ctrl<="111";
                    when others=>ctrl<="111";
                end case;
            when "01"=>ctrl<="000";
            when "10"=>ctrl<="001";
            when others=>ctrl<="001";
        end case;
    end process;
    
    alu2<=RD2 when ALUsrc='0' else "000000000"&instr(6 downto 0);
    
    process(RD1, alu2, instr(3), ctrl)
    begin
        case ctrl is
            when "000"=>aluRes1<=RD1+alu2;
            when "001"=>aluRes1<=RD1-alu2;
            when "010"=>aluRes1<=RD1(14 downto 0)&'0';
            when "011"=>
                if instr(3)='0' then
                    aluRes1<='0'&RD1(15 downto 1);
                else
                    aluRes1<=RD1(15)&RD1(15 downto 1);
                end if;
            when "100"=>aluRes1<=RD1 and alu2;
            when "101"=>aluRes1<=RD1 or alu2;
            when "110"=>aluRes1<=RD1 xor alu2;
            when "111"=>aluRes1<=not RD1;
        end case;
    end process;
    
    zero<='1' when aluRes1="0000000000000000" else '0';

    ALURes<=aluRes1;

end Behavioral;
