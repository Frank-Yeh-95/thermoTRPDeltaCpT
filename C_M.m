function [lnK, K, Po]= C_M( T, T0, dS, dC)
    R= 1.987; %cal/molK
    lnK= (dS - dC.*(1- T0./T + log(T0./T)))./R;
    K= exp(lnK);
    Po= K./(1+K);
end