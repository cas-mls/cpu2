----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: Decode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;

use IEEE.STD_LOGIC_1164.ALL;

use xil_defaultlib.Utilities.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
  
  Port ( 
--    clk : IN STD_LOGIC;
    inst : IN STD_LOGIC_VECTOR(31 downto 0);
    opcode : out OPCODETYPE;
    highlow : out STD_LOGIC;
    memop :  out MEMTYPE;
    regop1 : out REGTYPE;
    regop2 : out REGTYPE;
    immop : out IMMTYPE
    );
  
end DECODE_STATE;

architecture Behavioral of DECODE_STATE is

--component Registers 
--    Port ( clk : in STD_LOGIC;
--           regnum : in STD_LOGIC_VECTOR(3 downto 0);
--           we : in std_logic ;
--           regin : in STD_LOGIC_VECTOR (31 downto 0);
--           regout : out STD_LOGIC_VECTOR (31 downto 0));
--end component;

    
--    signal we1 : STD_LOGIC :='0';
--    signal regin1 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
--    signal regout1 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

--    signal we2 : STD_LOGIC :='0';
--    signal regin2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
--    signal regout2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
--    type opcode is (LOAD, STORE);
--    attribute enum_encoding : STD_LOGIC_VECTOR;
--    attribute enum_encoding of opcode : type is X"00001";

begin

    opcode <= inst(31 downto 27);
    -- Spare bit 26
    highlow <= inst(26);
    memop <= inst(25 downto 24); 
    regop1 <= inst(23 downto 20);
    regop2 <= inst(19 downto 16);
    immop <= inst(15 downto 0);
    


--    reg1 : registers
--    port map
--    (
--        clk => clk,
--        regnum => regop1,
--        we => we1,
--        regin => regin1,
--        regout => regout1    
--        );
        
--    reg2 : registers
--    port map
--    (
--        clk => clk,
--        regnum => regop2,
--        we => we2,
--        regin => regin2,
--        regout => regout2    
--        );

--    Reg_Proc: process (clk)
--    begin

--    if rising_edge (clk) then
--        case cur_opcode is
--            when LOAD =>
----                if memop = "00" then
----                    we1 <= '1';
----                    we2 <= '0';
----                    regin1 <= regout1;
----                end if;
--            when STORE =>
----                memop <= "00";
--            when others =>
----                memop <= "00";
--        end case;        
--    end if;

--    end process;



end Behavioral;
