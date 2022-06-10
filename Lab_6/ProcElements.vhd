--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here
	with selector select
		Result <= In0 when '0',
			  In1 when others;
	


end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is

signal route: std_logic_vector(4 downto 0);

begin
-- Add your code here
	
	route <= "00000" when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else -- Add
		 "00001" when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else -- Sub
		 "00010" when opcode = "0010011" and funct3 = "000" else	 		-- Addi
		 "01001" when opcode = "0110011" and funct3 = "111" and funct7 = "0000000" else -- And
		 "00111" when opcode = "0110011" and funct3 = "110" and funct7 = "0000000" else -- Or
		 "00011" when opcode = "0110011" and funct3 = "001" and funct7 = "0000000" else -- Sll
		 "00101" when opcode = "0110011" and funct3 = "101" and funct7 = "0000000" else -- Srl
		 "00000" when opcode = "0000011" and funct3 = "010" else			-- Lw
		 "00000" when opcode = "0100011" and funct3 = "010" else			-- Sw
		 "00001" when opcode = "1100011" and funct3 = "000" else			-- BEQ
		 "00001" when opcode = "1100011" and funct3 = "001" else			-- BNE
		 "01010" when opcode = "0010011" and funct3 = "111" else			-- ANDI
		 "01000" when opcode = "0010011" and funct3 = "110" else			-- ORI
		 "00100" when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- Slli
		 "00110" when opcode = "0010011" and funct3 = "101" and funct7 = "0000000";	-- Srlli

	ALUCtrl <= route;
		 

	Branch <= "01" when opcode = "1100011" and funct3 = "000" else -- BEQ
		  "10" when opcode = "1100011" and funct3 = "001";     -- BNE

	MemRead <= '0' when opcode = "0000011" else
		   '1';

	MemWrite <= '1' when opcode = "0100011" else
		    '0';
		 

	ALUSrc <= '0' when opcode = "0110011" or opcode = "1100011" or opcode = "XXXXXXX" else '1';

	RegWrite <= '1' when (opcode = "0110111" or opcode = "0000011" or opcode = "0010011" or opcode = "0110011") and clk = '0' else '0';


	ImmGen <= "00" when opcode = "0010011" or opcode = "0000011" else -- I-Type
		  "01" when opcode = "0100011" else			  -- S-Type
		  "10" when opcode = "1100011" else			  -- B-Type
		  "11";




end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here

PCProc: process(Reset, Clock) is
begin
	if Reset = '1' then
		PCout <= X"00400000";
	end if;
	if Clock = '1' then
		PCout <= PCin;
	end if;
end process PCProc;
end executive;
--------------------------------------------------------------------------------
