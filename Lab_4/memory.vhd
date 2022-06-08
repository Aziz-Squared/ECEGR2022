
--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
    	if WE = '1' and to_integer(unsigned(Address)) <= 127 then
		--DataOut <= i_ram(to_integer(unsigned(Address)));
		i_ram(to_integer(unsigned(Address(7 downto 0)))) <= DataIn;
	end if;

	
    end if;

	-- Rest of the RAM implementation

	if OE = '0' and to_integer(unsigned(Address)) <= 127 then
		--i_ram(to_integer(unsigned(Address))) <= DataIn;
		DataOut <= i_ram(to_integer(unsigned(Address(7 downto 0))));
	end if;

	if to_integer(unsigned(Address)) > 128 then
		DataOut <= X"00000000";
	end if;
  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;


signal writeSel: std_logic_vector(7 downto 0);
signal a0Out: std_logic_vector(31 downto 0);
signal a1Out: std_logic_vector(31 downto 0);
signal a2Out: std_logic_vector(31 downto 0);
signal a3Out: std_logic_vector(31 downto 0);
signal a4Out: std_logic_vector(31 downto 0);
signal a5Out: std_logic_vector(31 downto 0);
signal a6Out: std_logic_vector(31 downto 0);
signal a7Out: std_logic_vector(31 downto 0);
begin
    -- Add your code here for the Register Bank implementation
	with WriteReg select
		writeSel <= "00000001" when "01010", -- a0
		 	    "00000010" when "01011", -- a1
			    "00000100" when "01100", -- a2
			    "00001000" when "01101", -- a3
			    "00010000" when "01110", -- a4
			    "00100000" when "01111", -- a5
			    "01000000" when "10000", -- a6
			    "10000000" when "10001", -- a7
			    "00000000" when others;


	regA0: register32 port map(WriteData,'0','1','1',writeSel(0),'0','0',a0Out);
	regA1: register32 port map(WriteData,'0','1','1',writeSel(1),'0','0',a1Out);
	regA2: register32 port map(WriteData,'0','1','1',writeSel(2),'0','0',a2Out);
	regA3: register32 port map(WriteData,'0','1','1',writeSel(3),'0','0',a3Out);
	regA4: register32 port map(WriteData,'0','1','1',writeSel(4),'0','0',a4Out);
	regA5: register32 port map(WriteData,'0','1','1',writeSel(5),'0','0',a5Out);
	regA6: register32 port map(WriteData,'0','1','1',writeSel(6),'0','0',a6Out);
	regA7: register32 port map(WriteData,'0','1','1',writeSel(7),'0','0',a7Out);


	with ReadReg1 select
		ReadData1 <= a0Out when "01010",
			     a1Out when "01011",
			     a2Out when "01100",
			     a3Out when "01101",
			     a4Out when "01110",
			     a5Out when "01111",
			     a6Out when "10000",
			     a7Out when "10001",
			     X"00000000" when others;

	with ReadReg2 select
		ReadData2 <= a0Out when "01010",
			     a1Out when "01011",
			     a2Out when "01100",
			     a3Out when "01101",
			     a4Out when "01110",
			     a5Out when "01111",
			     a6Out when "10000",
			     a7Out when "10001",
			     X"00000000" when others;
		
	


end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------