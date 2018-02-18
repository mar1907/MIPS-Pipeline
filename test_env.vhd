--Top Environment

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           RsTx: out STD_LOGIC;
           RsRx: in STD_LOGIC);
end test_env;

architecture Behavioral of test_env is
component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;
component SSD is
    Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
component InF is
    Port ( clk : in STD_LOGIC;
           jmp : in STD_LOGIC;
           pc1 : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           en: in STD_LOGIC;
           reset: in STD_LOGIC;
           branch: in STD_LOGIC;
           branchAdd: in STD_LOGIC_VECTOR (15 downto 0));
end component;
component InstrDecode is
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
end component;
component Ex is
    Port ( ALUsrc : in STD_LOGIC;
           pc1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD1: in STD_LOGIC_VECTOR(15 downto 0);
           RD2: in STD_LOGIC_VECTOR(15 downto 0);
           ALUop: in STD_LOGIC_VECTOR(1 downto 0);
           instr: in STD_LOGIC_VECTOR(15 downto 0);
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           zero: out STD_LOGIC;
           BranchAdd: out STD_LOGIC_VECTOR(15 downto 0));
end component;
component RAMwr_first is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (15 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end component;
component TX_FSM is
    Port ( TX_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TX_EN : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk:in std_logic;
           BAUD_EN : in STD_LOGIC;
           TX : out STD_LOGIC;
           TX_RDY : out STD_LOGIC);
end component;
signal en:std_logic_vector(4 downto 0);
signal S3, pc1, instr, ALURes, RD1, RD2, BranchAdd, MemO, WD:std_logic_vector(15 downto 0);
signal instrR,instrRR,RD1R,RD2R,pc1R,ALUResR,BranchAddR,ALUResRR,MemOR,instrRRR,instrRRRR:std_logic_vector(15 downto 0);
signal jump, branch, MemWE, MemEN, AluI2, RegWr, RegWA, ExtOp, S1, zero, branch1: std_logic;
signal AluI2R,zeroR,branchR,branchRR,MemWER,MemWERR,MemENR,MemENRR,S1R,S1RR,S1RRR: std_logic;
signal RegWD, AluOp, AluOpR,RegWDR,RegWDRR,RegWDRRR: std_logic_vector(1 downto 0);
signal B_EN,enable,TX_EN,TX_RDY:std_logic;
signal count:STD_LOGIC_VECTOR(13 downto 0);
signal counter:STD_LOGIC_VECTOR(1 downto 0);
signal input,input1:STD_LOGIC_VECTOR(7 downto 0);
begin
    U10: MPG port map(clk,btn(0),en(0));
    U11: MPG port map(clk,btn(1),en(1));
    
    U2: SSD port map(S3,clk,cat,an);
    process(sw(7 downto 5),instrR,RD1,RD2,WD,PC1,instRRRR)
    begin
        case sw(7 downto 5) is
            when "000"=>S3<=instrR;
            when "001"=>S3<=instr;
            when "010"=>S3<=instrRR;
            when "011"=>S3<=instrRRR;
            when "100"=>S3<=WD;
            when "101"=>S3<=ALURes;
            when "111"=>S3<=instrRRRR;
            when others=>S3<=WD;
        end case;
    end process;
    
    process(instr(15 downto 13))
    begin
        case instr(15 downto 13) is
            when "000"=>jump<='0'; branch<='0'; MemWE<='0'; MemEN<='0'; AluI2<='0'; RegWr<='1'; RegWD<="00"; RegWA<='1'; AluOp<="00"; ExtOp<='0';
            when "001"=>jump<='0'; branch<='0'; MemWE<='0'; MemEN<='0'; AluI2<='1'; RegWr<='1'; RegWD<="00"; RegWA<='0'; AluOp<="01"; ExtOp<='0';
            when "010"=>jump<='0'; branch<='0'; MemWE<='0'; MemEN<='1'; AluI2<='1'; RegWr<='1'; RegWD<="01"; RegWA<='0'; AluOp<="01"; ExtOp<='0';
            when "011"=>jump<='0'; branch<='0'; MemWE<='1'; MemEN<='1'; AluI2<='1'; RegWr<='0'; RegWD<="00"; RegWA<='0'; AluOp<="01"; ExtOp<='0';
            when "100"=>jump<='0'; branch<='1'; MemWE<='1'; MemEN<='0'; AluI2<='0'; RegWr<='0'; RegWD<="00"; RegWA<='0'; AluOp<="10"; ExtOp<='0';
            when "101"=>jump<='0'; branch<='0'; MemWE<='0'; MemEN<='0'; AluI2<='0'; RegWr<='1'; RegWD<="10"; RegWA<='0'; AluOp<="00"; ExtOp<='0';
            when "110"=>jump<='0'; branch<='0'; MemWE<='0'; MemEN<='0'; AluI2<='1'; RegWr<='1'; RegWD<="00"; RegWA<='0'; AluOp<="10"; ExtOp<='0';
            when "111"=>jump<='1'; branch<='0'; MemWE<='0'; MemEN<='0'; AluI2<='0'; RegWr<='0'; RegWD<="00"; RegWA<='0'; AluOp<="00"; ExtOp<='0';
        end case;
    end process;
    
    --If/Id
    process(clk)
    begin
        if rising_edge(clk) then
            if en(0)='1' then
                instr<=instrR;
            end if;
        end if;
    end process;
    
    --Id/Ex
    process(clk)
    begin
        if rising_edge(clk) then
            if en(0)='1' then
                instrRR<=instr;
                RD1R<=RD1;
                RD2R<=RD2;
                pc1R<=PC1;
                AluI2R<=AluI2;
                AluOpR<=AluOp;
                branchR<=branch;
                MemWER<=MemWE;
                MemENR<=MemEN;
                RegWDR<=RegWD;
                S1R<=S1;
            end if;
        end if;
    end process;
    
    --Ex/Mem
    process(clk)
    begin
        if rising_edge(clk) then
            if en(0)='1' then
                ALUResR<=ALURes;
                BranchAddR<=BranchAdd;
                zeroR<=zero;
                branchRR<=branchR;
                MemWERR<=MemWER;
                MemENRR<=MemENR;
                instrRRR<=instrRR;
                RegWDRR<=RegWDR;
                S1RR<=S1R;
            end if;
        end if;
    end process;
    
    --Mem/Wb
    process(clk)
    begin
        if rising_edge(clk) then
            if en(0)='1' then
                AluResRR<=ALUResR;
                MemOR<=MemO;
                instrRRRR<=instrRRR;
                RegWDRRR<=RegWDRR;
                S1RRR<=S1RR;
            end if;
        end if;
    end process;
    
    branch1<=branchRR and zeroR;
    U3: InF port map(clk,jump,pc1,instrR,en(0),en(1),branch1, BranchAddR);
    
    S1<=RegWr and en(0);
    U4: InstrDecode port map(instr,RegWA,ExtOp,S1RRR,WD,clk,RD1,RD2,en(0));
    
    U5: EX port map(AluI2R, PC1R, RD1R, RD2R, AluOpR, instrRR, ALURes, zero, BranchAdd);
    
    U6: RAMWr_first port map(clk, MemWERR, MemENRR, ALUResR, RD2R, MemO);
    
    process(ALURes, MemO, instr(6 downto 0), RegWD)
    begin
        case RegWDRRR is
            when "00"=>WD<=ALUResRR;
            when "01"=>WD<=MemOR;
            when "10"=>Wd<="000000000"&instrRRRR(6 downto 0);
            when others=>WD<=MemOR;
        end case;
    end process;
    
    led(14 downto 0)<=branch1&enable&zero&jump&branch&MemWE&MemEN&AluI2&RegWr&RegWDRRR&RegWA&AluOp&ExtOp;
                      --15     14    13   12    11     10   9      8      7    6 5   4    3 2    1
    process(clk)
        begin
            if rising_edge(clk) then
                if count="10100010110000" then
                    count<="00000000000000";
                    B_EN<='1';
                else
                    count<=count+1;
                    B_EN<='0';
                end if;
            end if;
    end process;
    enable<='1' when (instr=B"001_100_100_0000000") else '0';
    U7:TX_FSM port map(input1,enable,'0',clk,B_EN,RsTx,TX_RDY);
    process(clk,enable)
    begin
        if enable='0' then
            counter<="11";
        elsif rising_edge(clk) then
            if B_EN='1' then
                if TX_RDY='1' then
                    counter<=counter+1;
                end if;
            end if;
        end if;
    end process;
    input1<="01000110" when input="00001111" else
            "00111000" when input="00001000" else
            "00110000";
    input<="0000"&RD2(3 downto 0) when counter="11" else
           "0000"&RD2(7 downto 4) when counter="10" else
           "0000"&RD2(11 downto 8) when counter="01" else
           "0000"&RD2(15 downto 12) when counter="00";
    process(clk,en(0),TX_RDY)
    begin
        if en(0)='1' then
            TX_EN<='1';
        elsif TX_RDY='1' then
            TX_EN<='0';
        elsif rising_edge(clk) then
            TX_EN<=enable;
        end if;
    end process;
end Behavioral;
