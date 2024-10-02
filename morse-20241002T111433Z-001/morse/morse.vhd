library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Contador is
	port(
		carac : in std_logic_vector(11 downto 0);
		estado_led: inout std_logic := '1';
		Clk : in std_logic;
		Clear : in std_logic
	);
end Contador;

architecture Conta of Contador is
shared variable num : integer range -1 to 25000000 := 0;
shared variable indixe : integer range 0 to 11;
begin	
	process(Clk)
	begin
		if(rising_edge(Clk)) then			
			if(num=0) then
				estado_led <= carac(indixe);
			elsif(num=25000000) then
				num := -1;
				indixe := (indixe + 1) mod 12;
			end if;
			
			num := num + 1;
		end if;
	end process;
end Conta;

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity pega_letra is
	port(
		letra : out std_logic_vector(11 downto 0);
		ler : in std_logic;
		Clear : in std_logic;
		l0, l1, l2 : in std_logic
	);
end pega_letra;

architecture pegar of pega_letra is
shared variable inp : std_logic_vector(2 downto 0);
begin
	process(ler, Clear)
	begin
		if(Clear='1') then
			letra <= "000000000000";
		elsif(falling_edge(ler)) then
			inp(0) := l0;
			inp(1) := l1;
			inp(2) := l2;
			
			if(inp="000") then
				letra <= "000000011101";
			elsif(inp="001") then
				letra <="000101010111";
			elsif(inp="010") then
				letra <="010111010111";
			elsif(inp="011") then
				letra <="000001010111";
			elsif(inp="100") then
				letra <="000000000001";
			elsif(inp="101") then
				letra <="000101110101";
			elsif(inp="110") then
				letra <="000101110111";
			elsif(inp="111") then
				letra <="000001010101";
			end if;
		end if;
	end process;
end pegar;

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity morse is
	port(
		l0, l1, l2 : in std_logic;
		led : inout std_logic;
		Clk : in std_logic;
		Reset : in std_logic;
		Ler : in std_logic
	);
end morse;

architecture mor of morse is
signal letra : std_logic_vector(11 downto 0);
signal reseto, lero : std_logic;
begin
	reseto <= not Reset;
	lero <= not Ler;
	pega : entity work.pega_letra(pegar) port map(l0 => l0, l1 => l1, l2 => l2, ler => lero, Clear => reseto, letra => letra);
	cont : entity work.Contador(Conta) port map (carac => letra, Clk => Clk, Clear => reseto, estado_led => led);
end mor;