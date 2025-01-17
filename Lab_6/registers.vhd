--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;


begin
	

	storage0: bitstorage port map(datain(0), enout, writein, dataout(0));
	storage1: bitstorage port map(datain(1), enout, writein, dataout(1));
	storage2: bitstorage port map(datain(2), enout, writein, dataout(2));
	storage3: bitstorage port map(datain(3), enout, writein, dataout(3));
	storage4: bitstorage port map(datain(4), enout, writein, dataout(4));
	storage5: bitstorage port map(datain(5), enout, writein, dataout(5));
	storage6: bitstorage port map(datain(6), enout, writein, dataout(6));
	storage7: bitstorage port map(datain(7), enout, writein, dataout(7));
	

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     	enout:  in std_logic;
	     	writein: in std_logic;
	     	dataout: out std_logic_vector(7 downto 0));
	end component;
		
	signal enable: std_logic_vector(2 downto 0);
	signal writing: std_logic_vector(2 downto 0);
	signal en: std_logic_vector(3 downto 0);
	signal wr: std_logic_vector(3 downto 0);
	

begin
	enable <= enout32 & enout16 & enout8;
	writing <= writein32 & writein16 & writein8;

	with enable select
	en <= "0000" when "011",
	      "1100" when "101",
	      "1110" when "110",
	      "1111" when others;
	with writing select
	wr <= "0001" when "001",
	      "0011" when "010",
	      "1111" when "100",
	      "0000" when others;
	
	storage0: register8 port map(datain(7 downto 0),en(0),wr(0), dataout(7 downto 0));
	storage1: register8 port map(datain(15 downto 8), en(1), wr(1), dataout(15 downto 8));
	storage2: register8 port map(datain(23 downto 16), en(2), wr(2), dataout(23 downto 16));
	storage3: register8 port map(datain(31 downto 24), en(3), wr(3), dataout(31 downto 24));


end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is

component fulladder
	port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end component fulladder;


signal c: std_logic_vector(31 downto 0);
signal inverse: std_logic_vector(31 downto 0);

begin
	with add_sub select
		inverse <= (not datain_b) when '1',
				datain_b when others;
	
	addsub0: fulladder port map(datain_a(0), inverse(0), add_sub, dataout(0), c(0));
	GEN_ADD: for i in 31 downto 1 generate
		addSub: fulladder port map (datain_a(i), inverse(i), c(i - 1), dataout(i), c(i));
		
	end generate GEN_ADD;
	
	co <= c(31);


end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	with dir & shamt (3 downto 0) select
	dataout <= datain(30 downto 0) & '0' when "00001",
		   datain(29 downto 0) & "00" when "00010",
		   datain(28 downto 0) & "000" when "00011",
		   "0" & datain(31 downto 1) when "10001",
		   "00" & datain(31 downto 2) when "10010",
		   "000" & datain(31 downto 3) when "10011",
		   datain when others;
	


end architecture shifter;



