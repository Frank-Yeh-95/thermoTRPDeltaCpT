# thermoTRPDeltaCpT
thermoTRP DeltaCp(T) Model

1-13-2023 - FY Edits

C_M.m is the function that will take in [PARAMETERS] to model the Clapham and Miller \Delta C_{p, constant} 
C_M_linearCpT.m is the function that will take in [PARAMETERS] to model a \Delta C_{p, linear} framework for thermoTRP gating

Clapham_Miller.m is a set of functions that will generate some graphs that explain in detail the \Delta C_{p, constant} framework
  Parameter changes section will demonstrate the differences in P_o(T) behaviors between different parameters
  Finding maximal slope section will demonstrate the equations necessary needed to reveal the temperature of maximal slope
    The equations necessary require the use of a Lambert's W which is a converse relationship of we^w=z, where the goal is to reveal the value of w
    The equations reveal that the two temperature sensitivities observed in the Clapham and Miller framework are not identical, as they vary on slope and temperature location
  Parameter changes on T_50 and maximal slope section will demonstrate that the parameters T_0, \Delta S^o_o, and \Delta C_{p, constant} variably change the slope and temperature location of P_o=0.5

Paper_Figs.m is a set of functions that were used to generate the graphs found in the research article: [HYPERLINK]
  dH_0th_order section generates the temperature sensitivity curves with the associated maximal slope (T_{50})
  delCp Constant section generates the temperature sensitivity curves and the effect of varying the thermodynamic parameters as described by Clapham and Miller, 2011.
  Explanatory Figures section generates the 
