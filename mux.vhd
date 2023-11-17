library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
    port (
        inp1 : in std_logic;
        inp2 : in std_logic;
        inp3 : in std_logic;
        inp4 : in std_logic;
        sig1 : in std_logic;
        sig2 : in std_logic;
        output : out std_logic
    );

end mux;

architecture structural of mux is
    component inverter
        port (
            input : in std_logic;
            output : out std_logic
        );
    end component;

    component and3
        port (
            input1 : in std_logic;
            input2 : in std_logic;
            input3 : in std_logic;
            output : out std_logic
        );
    end component;

    component or4
        port (
            input1 : in std_logic;
            input2 : in std_logic;
            input3 : in std_logic;
            input4 : in std_logic;
            output : out std_logic
        );
    end component;
    signal notSig1, notSig2 : std_logic;
    signal outAnd1, outAnd2, outAnd3, outAnd4 : std_logic;

    begin
        invsig1 : inverter port map(sig1, notSig1);
        invsig2 : inverter port map(sig2, notSig2);


        mAnd1 : and3 port map(inp1, notSig1, notSig2, outAnd1);
        mAnd2 : and3 port map(inp2, notSig1, sig2, outAnd2);
        mAnd3 : and3 port map(inp3, sig1, notSig2, outAnd3);
        mAnd4 : and3 port map(inp4, sig1, sig2, outAnd4);
        mOr1 : or4 port map(outAnd1, outAnd2, outAnd3, outAnd4, output);
end structural;

