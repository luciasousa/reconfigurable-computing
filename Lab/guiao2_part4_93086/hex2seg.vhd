library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex2seg is
    Port ( hex : in STD_LOGIC_VECTOR (3 downto 0);
           en_L : in STD_LOGIC;
           --an_L : out STD_LOGIC_VECTOR(7 downto 0);
           seg_L : out STD_LOGIC_VECTOR (6 downto 0));
end hex2seg;

architecture Behavioral of hex2seg is

begin
    --an_L <= "11111110";
    seg_L <= "1111001" when (hex = "0001") else  --1                 
            "0100100" when (hex = "0010") else  --2         
            "0110000" when (hex = "0011") else  --3                 
            "0011001" when (hex = "0100") else  --4                 
            "0010010" when (hex = "0101") else  --5                 
            "0000010" when (hex = "0110") else  --6                 
            "1111000" when (hex = "0111") else  --7                 
            "0000000" when (hex = "1000") else  --8                 
            "0010000" when (hex = "1001") else  --9                 
            "0001000" when (hex = "1010") else  --A                 
            "0000011" when (hex = "1011") else  --b                 
            "1000110" when (hex = "1100") else  --C                 
            "0100001" when (hex = "1101") else  --D                 
            "0000110" when (hex = "1110") else  --E                 
            "0001110" when (hex = "1111") else  --F                 
            "1000000"; 

end Behavioral;