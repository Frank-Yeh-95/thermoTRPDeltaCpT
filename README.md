# thermoTRPDeltaCpT
thermoTRP DeltaCp(T) Model

1-13-2023 - FY Edits: Import code from offline folders
5-22-2023 - FY Edits: Improved ReadMe description and reuploaded the relevant code files

# Fitting Functions
C_M.m is the function that will take in T0, \Delta S^o_o and \Delta C_p Parameters with a T temperature variable to model the Clapham and Miller \Delta C_{p, constant} 

C_M_linearCpT.m is the function that will take in T0, \Delta S^o_o, \Delta C_p slope and \Delta C_p intercept Parameters with a T temperature variable  to model a \Delta C_{p, linear} framework for thermoTRP gating. Additional simplification is added if there is only a slope but no intercept parameters.

# Figure Functions
Clapham_Miller.m is a set of functions that will generate some graphs that explain in detail the \Delta C_{p, constant} framework. Symbolic Math Tools addon is required for lambertw to function.
1.  Parameter changes section will demonstrate the differences in P_o(T) behaviors between different parameters
2.  Finding maximal slope section will demonstrate the equations necessary needed to reveal the temperature of maximal slope    
A.  The equations necessary require the use of a Lambert's W which is a converse relationship of we^w=z, where the goal is to reveal the value of w    
B.  The equations reveal that the two temperature sensitivities observed in the Clapham and Miller framework are not identical, as they vary on slope and temperature location
3.  Parameter changes on T_50 and maximal slope section will demonstrate that the parameters T_0, \Delta S^o_o, and \Delta C_{p, constant} variably change the slope and temperature location of P_o=0.5

Paper_Figs.m is a set of functions that were used to generate the graphs found in the research article: [HYPERLINK]
1.  dH_0th_order section generates the temperature sensitivity curves with the associated maximal slope (T_{50})
2.  delCp Constant section generates the temperature sensitivity curves and the effect of varying the thermodynamic parameters as described by Clapham and Miller, 2011
3.  Explanatory Figures section generates the representative figures for each condition that are described in detail in the paper. \Delta S^o_o = 0.
4.  delCp Linear Examples section generates a number of different curves to exemplify the different temperature-sensitivities. [A] is changes in slope, [B] is changes in intercept.
5.  delCp Linear Examples lnkeq section generates a number of different ln(Keq) curves to exemplify the different temperature-sensitivities. [A] is changes in slope, [B] is changes in intercept.
6.  Parameter Space section generates a specific parameter space diagram at T=250K, this shows the different temperature sensitivities described in the Explanatory Figures section. The parameters graphed are the intercept and slope parameters of the \Delta C_{p, linear} model. The experimental data is also shown in symbols.
7.  Po change in delS section keeps all the thermodynamic parameters of \Delta C_{p, linear} and T_o constant but changes \Delta S^o_o. On a linear P_o scale, the observed P_o(T) behaviors might be different than those observed when \Delta S^o_o = 0.
8.  Po change in delS (log) section is the same Po change in delS figure, but on a log(P_o) scale. Here, the P_o(T) behavior observed is maintained as in the Explanatory Figures.
  

#Auxiliary Function and Data Repositories
Experimental Data.mat is a file with the intercept and slopes from experimental data ()

custommap_script.m is a function that will 
