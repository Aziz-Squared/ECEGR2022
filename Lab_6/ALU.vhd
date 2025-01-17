--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

signal dOutAdd: std_logic_vector(31 downto 0);
signal dOutSub: std_logic_vector(31 downto 0);
signal dOutAddi: std_logic_vector(31 downto 0);
signal dOutSll: std_logic_vector(31 downto 0);
signal dOutSlli: std_logic_vector(31 downto 0);
signal dOutSrl: std_logic_vector(31 downto 0);
signal dOutSrli: std_logic_vector(31 downto 0);
signal dOutOR: std_logic_vector(31 downto 0);
signal dOutORI: std_logic_vector(31 downto 0);
signal dOutAnd: std_logic_vector(31 downto 0);
signal dOutAndi: std_logic_vector(31 downto 0);

signal result: std_logic_vector(31 downto 0);

begin
	add: adder_subtracter port map(DataIn1, DataIn2, '0', dOutAdd, zero);
	sub: adder_subtracter port map(DataIn1, DataIn2, '1', dOutSub, zero);
	addi: adder_subtracter port map(DataIn1, DataIn2, '0', dOutAddi, zero);
	shiftL: shift_register port map(DataIn1, '0', DataIn2(4 downto 0), dOutSll);
	shiftLi: shift_register port map(DataIn1, '0', DataIn2(4 downto 0), dOutSlli);
	shiftR: shift_register port map(DataIn1, '1', DataIn2(4 downto 0), dOutSrl);
	shiftRi: shift_register port map(DataIn1, '1', DataIn2(4 downto 0), dOutSrli);

	dOutOR <= DataIn1 or DataIn2;
	dOutORI <= DataIn1 or DataIn2;
	dOutAnd <= DataIn1 and DataIn2;
	dOutAndi <= DataIn1 and DataIn2;
	

	
	with ALUCtrl select
		result <= dOutAdd when "00000",
			     dOutSub when "00001",
			     dOutAddi when "00010",
			     dOutSll when "00011",
			     dOutSlli when "00100",
			     dOutSrl when "00101",
			     dOutSrli when "00110",
			     dOutOR when "00111",
			     dOutORI when "01000",
			     dOutAnd when "01001",
			     dOutAndi when "01010",
			     X"00000000" when others;
			     	
	ALUResult <= result;


	Zero <= '1' when result = x"00000000" else
		'0';


end architecture ALU_Arch;
