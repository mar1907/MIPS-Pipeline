--Instruction Decode

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstrDecode is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           clk: in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           en: in std_logic;
           OpCode : out STD_LOGIC_VECTOR (2 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           SA : out STD_LOGIC;
           Func : out STD_LOGIC_VECTOR (2 downto 0));
end InstrDecode;

architecture Behavioral of InstrDecode is
component RegisterFile is
    Port ( clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0));
end component;
signal S1,S2,S3,S4: std_logic_vector(2 downto 0);
begin
    U1:RegisterFile port map(clk,RegWr,instr(12 downto 10), instr(9 downto 7), S4, RD1, RD2, WD);
    
    S1<=instr(9 downto 7) when RegDst='0' else instr(6 downto 4);
    
    ExtImm<="000000000"&instr(6 downto 0) when ExtOp='0' or instr(6)='0' else "111111111"&instr(6 downto 0);
    
    Func<=instr(2 downto 0);
    SA<=instr(3);

    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                S2<=S1;
            end if;
        end if;
    end process;
    
     process(clk)
       begin
           if rising_edge(clk) then
               if en='1' then
                   S3<=S2;
               end if;
           end if;
       end process;
       
      process(clk)
          begin
              if rising_edge(clk) then
                  if en='1' then
                      S4<=S3;
                  end if;
              end if;
          end process;

end Behavioral;
