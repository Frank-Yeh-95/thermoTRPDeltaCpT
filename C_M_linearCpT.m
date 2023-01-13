function [lnK, K, Po]= C_M_linearCpT( T, T0, dS, dC_slope, dC0, simplification)
    R= 1.987; %cal/molK
    if simplification==0
        lnK= (dS + (dC_slope).*(T0^2./(2.*T) + T./2 - T0) + (dC0.*(T0./T + log(T./T0)-1)))./R;
    else
        dC= dC_slope;
        lnK= (dS + dC*(T./2 - T0 + T0^2./(2.*T)))./R;
    end
    K= exp(lnK);
    Po= K./(1+K);
end
