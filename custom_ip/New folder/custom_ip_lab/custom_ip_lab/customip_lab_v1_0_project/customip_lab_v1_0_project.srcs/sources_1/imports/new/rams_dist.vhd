-- Asymmetric port RAM
-- Write Wider than Read
-- asym_ram_sdp_write_wider.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.data_types.all;
use ieee.numeric_std.all;

entity weight_RAM is
	port(
		clkA  : in  std_logic;
		clkB  : in  std_logic;
		enA   : in  std_logic;
		enB   : in  std_logic;
		weB   : in  std_logic;
		addrA : in  w_addr_array;
		addrB : in  integer;
		diB   : in  std_logic_vector(WIDTHB - 1 downto 0);
		doA   : out data_array
	);

end weight_RAM;

architecture behavioral of weight_RAM is
	function max(L, R : INTEGER) return INTEGER is
	begin
		if L > R then
			return L;
		else
			return R;
		end if;
	end;

	function min(L, R : INTEGER) return INTEGER is
	begin
		if L < R then
			return L;
		else
			return R;
		end if;
	end;

	function log2(val : INTEGER) return natural is
		variable res : natural;
	begin
		for i in 0 to 31 loop
			if (val <= (2 ** i)) then
				res := i;
				exit;
			end if;
		end loop;
		return res;
	end function Log2;

	constant minWIDTH : integer := min(WIDTHA, WIDTHB);
	constant maxWIDTH : integer := max(WIDTHA, WIDTHB);
	constant maxSIZE  : integer := max(SIZEA, SIZEB);
	constant RATIO    : integer := maxWIDTH / minWIDTH;

	-- An asymmetric RAM is modeled in a similar way as a symmetric RAM, with an
	-- array of array object. Its aspect ratio corresponds to the port with the
	-- lower data width (larger depth)
	type ramType is array (maxSIZE - 1 downto 0) of std_logic_vector(minWIDTH - 1 downto 0);

	signal my_ram : ramType := (others => (others => '0'));

	signal readA : data_array;
	signal readB : std_logic_vector(WIDTHB - 1 downto 0) := (others => '0');
	signal regA  : data_array;
	signal regB  : std_logic_vector(WIDTHB - 1 downto 0) := (others => '0');

begin

	-- read process
	process(clkA)
	begin
		if rising_edge(clkA) then
			if enA = '1' then
			    for i in 0 to num_units-1 loop
    				readA(i) <= my_ram(conv_integer(addrA(i)));
			    end loop;
			end if;
			regA <= readA;
		end if;
	end process;

	-- Write process
	process(clkB)
	begin
		if rising_edge(clkB) then
			for i in 0 to RATIO - 1 loop
				if enB = '1' then
					if weB = '1' then
						my_ram(conv_integer(std_logic_vector(to_unsigned(addrB, ADDRWIDTHB)) & conv_std_logic_vector(i, log2(RATIO)))) <= diB((i + 1) * minWIDTH - 1 downto i * minWIDTH);
					end if;
				end if;
			end loop;
			regB <= readB;
		end if;
	end process;

	doA <= regA;

end behavioral;
