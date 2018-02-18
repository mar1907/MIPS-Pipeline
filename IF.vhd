--Instruction fetch

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InF is
    Port ( clk : in STD_LOGIC;
           jmp : in STD_LOGIC;
           pc1 : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           en: in STD_LOGIC;
           reset: in STD_LOGIC;
           branch: in STD_LOGIC;
           branchAdd: in STD_LOGIC_VECTOR (15 downto 0));
end InF;

architecture Behavioral of InF is
type mem is array(0 to 63) of std_logic_vector(15 downto 0);
signal ROMmem: mem:=(
    B"101_000_101_0000000",     --lli $5,0              0       A280
    B"101_000_110_0001010",     --lli $6,10             1       A30A
    B"101_000_100_0000000",     --lli $4,0              2       A200
    B"101_000_010_0000001",     --lli $2,1              3       A101
    B"101_000_001_0000000",     --lli $1,0              4       A080
    B"100_101_110_0001000",     --beq $5,$6,8           5       9708
    B"001_101_101_0000001",     --addi $5,$5,1          6       3641
    B"000_001_010_011_0_000",   --add $1,$2,$3          7       0530
    B"0000000000000000",        --nop                   8       0000
    B"000_100_010_100_0_000",   --add $4,$2,$4          9       1140
    B"001_010_001_0000000",     --addi $1,$2,0          A       2880
    B"001_011_010_0000000",     --addi $2,$3,0          B       2D00
    B"111_0000000000101",       --j 5                   C       E005
    B"0000000000000000",        --nop                   D       0000
    B"001_100_100_0000000",     --addi $4,$4,0          E       3200
    others=>"0000000000000000"          
);
signal SoPC, SinPC, SoPC1, S3:std_logic_vector(5 downto 0);
signal SoPC1R:std_logic_vector(5 downto 0);
signal instr1, instr1R: std_logic_vector (15 downto 0);
begin
    instr1<=ROMmem(conv_integer(SoPC));
    process(clk,reset)
    begin
        if reset='1' then
            SoPC<="000000";
        else
            if rising_edge(clk) then
                if en='1' then
                    SoPC<=SinPC;
                end if;
            end if;
        end if;
        
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                SoPC1R<=SoPC1;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                instr1R<=instr1;
            end if;
        end if;
    end process;
    
    SoPC1<=SoPC+1;
    pc1<="0000000000"&SoPC1R;
    
    S3<=SoPC1 when branch='0' else branchAdd(5 downto 0);
    SinPC<=S3 when jmp='0' else instr1R(5 downto 0);
    
    instr<=instr1;
end Behavioral;
