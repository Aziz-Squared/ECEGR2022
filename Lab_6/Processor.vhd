--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	-- Register info
	signal readData1: std_logic_vector(31 downto 0);
	signal readData2: std_logic_vector(31 downto 0);
	signal writeData: std_logic_vector(31 downto 0);
	signal writingCommand: std_logic;

	-- ALU info
	signal Zed: std_logic;
	signal result: std_logic_vector(31 downto 0);
	signal immGen: std_logic_vector(31 downto 0);
	signal muxResult: std_logic_vector(31 downto 0);

	-- Program Counter info
	signal PC: std_logic_vector(31 downto 0);
	signal newInstruction: std_logic_vector(31 downto 0);
	signal PCAdd: std_logic_vector(31 downto 0);
	signal carry1: std_logic;
	signal carry3: std_logic;
	signal adding: std_logic_vector(31 downto 0);

	-- Add/Sub info
	signal carry2: std_logic;
	signal offSetAddress: std_logic_vector(31 downto 0);

	-- Control info
	signal branch: std_logic_vector(1 downto 0);
	signal memoryRead: std_logic;
	signal mem2Reg: std_logic;
	signal memWrite: std_logic;
	signal aluControl: std_logic_vector(4 downto 0);
	signal aluSrc: std_logic;
	signal regWrite: std_logic;
	signal imm: std_logic_vector(1 downto 0);

	signal instruct: std_logic_vector(31 downto 0);

	
	-- Branch Mux Info
	signal branchSelect: std_logic;
	
	-- Data Memory Info
	signal ramResult: std_logic_vector(31 downto 0);

	signal instruction: std_logic_vector(31 downto 0);

begin
	-- Add your code here

	progCounter: ProgramCounter port map(reset, clock, newInstruction, PC);
	programCounterAdder: adder_subtracter port map(PC, X"00000001", '0', PCAdd, carry1);
	instructMem: InstructionRAM port map(reset, clock, PC(31 downto 2), instruction);
	registerFile: Registers port map(instruction(19 downto 15), instruction(24 downto 20), Instruction(11 downto 7), writeData, regWrite, readData1, readData2);
	controller: Control port map(clock, instruction(6 downto 0), instruction(14 downto 12), instruction(31 downto 25), branch, memoryRead, mem2Reg, aluControl, memWrite, aluSrc, regWrite, imm);
	aMux: BusMux2to1 port map(aluSrc, readData2, immGen, muxResult);
	aluUnit: ALU port map(readData1, muxResult, aluControl, Zed, result);
	offset: adder_subtracter port map(result, x"10000000", '1', offSetAddress, carry2);
	pcImmGenAdder: adder_subtracter port map(PC, immGen, '0', adding, carry3);
	branchMux: BusMux2to1 port map(branchSelect, PCAdd, adding, newInstruction);
	dMem: RAM port map(reset, clock, memoryRead, memWrite, offSetAddress(31 downto 2), readData2, ramResult);
	dMemMux: BusMux2to1 port map(mem2Reg, result, ramResult, writeData);

	immGen(31 downto 12) <= (Others=>instruction(31)) when imm = "00" else
				(Others=>instruction(31)) when imm = "01" else
				(Others=>instruction(31)) when imm = "10" else
				Instruction(31 downto 12);

	immGen(11 downto 0) <= instruction(31 downto 20) when imm = "00" else
				instruction(31 downto 25) & Instruction (11 downto 7) when imm = "01" else
				instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when imm = "10" else
				(Others=>'0');

	branchSelect <= '1' when (branch = "10" and Zed = '1') or (branch = "10" and Zed = '0') else
				'0';


end holistic;

