%% dH_0th_order
T=[0:500];
R=1.987; %cal/molK;
T_cel= T-273;

%Numbers from Feng Qin 2003 Single Channel TRPV1
dH_hot=150000;
dS_hot=470;
lnK_hot= -(dH_hot-T.*dS_hot)./(R.*T);
Po_hot= exp(lnK_hot)./(1+exp(lnK_hot));
dPo_hot= (dH_hot.*exp((dH_hot+T.*dS_hot)./(R.*T)))./(R.*(T.^2).*(exp(dH_hot./(R.*T))+exp(dS_hot./R)).^2);

%Numbers from Brauchi Latorre 2004 TRPM8
dH_cold=-112000;
dS_cold=-384;
lnK_cold= -(dH_cold-T.*dS_cold)./(R.*T);
Po_cold= exp(lnK_cold)./(1+exp(lnK_cold));
dPo_cold= (dH_cold.*exp((dH_cold+T.*dS_cold)./(R.*T)))./(R.*(T.^2).*(exp(dH_cold./(R.*T))+exp(dS_cold./R)).^2);

figure('Units','inches','Position',[0 0 7 10]);

%Po Graph
Po_graph=subplot(2,1,1);
hold on;
Po_graph.FontSize= 16;
plot(T_cel, Po_cold,'linewidth',2,'color','blue');
plot(T_cel, Po_hot,'linewidth',2,'color','red');
line([19 19],[0 1],'linewidth',2,'linestyle','--','color','blue');
line([46 46],[0 1],'linewidth',2,'linestyle','--','color','red');
ylim([0 1]);
xlim([-25 75]);
ylabel('P_o','fontsize',18);
text(0.9*75,0.9,'A','fontsize',24);
hold off;

% figure();
% semilogy(T_cel, Po_cold);
% hold on;
% semilogy(T_cel, Po_hot);
% hold off;

%dPo Graph
dPo_graph=subplot(2,1,2);
hold on;
dPo_graph.FontSize= 16;
plot(T_cel, dPo_cold,'linewidth',2,'color','blue');
plot(T_cel, dPo_hot,'linewidth',2,'color','red');
line([19 19],[-0.2 0.2],'linewidth',2,'linestyle','--','color','blue');
line([46 46],[-0.2 0.2],'linewidth',2,'linestyle','--','color','red');
% ylim([0 1]);
xlim([-25 75]);
ylabel('$\bf{\frac{dP_o}{dT}}$','fontsize',22,'Interpreter','latex');
xlabel('Temperature (^oC)','fontsize',16);
text(0.9*75,0.9*0.4-0.2,'B','fontsize',24);
hold off;

%% delCp Constant

number_of_pts=23;
T0_298_line_x=ones(1,number_of_pts);
T0_298_line_x=T0_298_line_x.*25;
T0_298_line_y=[0:1/(number_of_pts-1):1];

%Change in dCp
dS= -9; %cal/molK
T0_hot= 298; %K
dC3= 3000; %cal/molK

dS= -9; %cal/molK
T0_hot= 298; %K
dC5= 5000; %cal/molK

[lnK_dC3, K_dC3, Po_dC3]= C_M(T, T0_hot, dS, dC3);
[lnK_dC5, K_dC5, Po_dC5]= C_M(T, T0_hot, dS, dC5);

figure('Units','inches','Position',[0 0 18 6], 'DefaultAxesFontSize', 16);
subplot(1,3,3);
plot(T_cel, Po_dC3, 'linewidth',2,'color',[0.5 0.5 0.5]);
hold on;

line([25 25],[0 1],'linewidth',2,'color',[0.5 0.5 0.5],'linestyle','--');
plot(T0_298_line_x,T0_298_line_y,'linestyle','none','marker','.','markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'markersize',15);
plot(T_cel, Po_dC5, 'linewidth',2,'color',[0 0 1]);
xlabel("Temperature (^oC)");
xlim([-25 75]);
text(58,0.9,'C','fontsize',24);


%Change in dS
dS20= -20; %cal/molK
T0_hot= 298; %K
dC= 3000; %cal/molK

dS9= -9; %cal/molK
T0_hot= 298; %K
dC= 3000; %cal/molK

[lnK_dS20, K_dS20, Po_dS20]= C_M(T, T0_hot, dS20, dC);
[lnK_dS9, K_dS9, Po_dS9]= C_M(T, T0_hot, dS9, dC);

subplot(1,3,2);
plot(T_cel, Po_dS20, 'linewidth',2,'color',[1 165/255 0]);
hold on;
line([25 25],[0 1],'linewidth',2,'color',[0.5 0.5 0.5],'linestyle','--');
plot(T0_298_line_x,T0_298_line_y,'linestyle','none','marker','.','markerfacecolor',[1 165/255 0],'markeredgecolor',[1 165/255 0],'markersize',15);
plot(T_cel, Po_dS9, 'linewidth',2,'color',[0.5 0.5 0.5]);
xlabel("Temperature (^oC)");
xlim([-25 75]);
text(58,0.9,'B','fontsize',24);


%Change in T0
dS= -9; %cal/molK
T0298= 298; %K
dC= 3000; %cal/molK

dS= -9; %cal/molK
T0308= 308; %K
dC= 3000; %cal/molK

[lnK_T0298, K_T0298, Po_T0298]= C_M(T, T0298, dS, dC);
[lnK_T0308, K_T0308, Po_T0308]= C_M(T, T0308, dS, dC);

subplot(1,3,1);
plot(T_cel, Po_T0298, 'linewidth',2,'color',[0.5 0.5 0.5]);
hold on;
line([298-273 298-273],[0 1],'linewidth',2,'color',[0.5 0.5 0.5],'linestyle','--');
plot(T_cel, Po_T0308, 'linewidth',2,'color',[1 0 0]);
line([308-273 308-273],[0 1],'linewidth',2,'color',[1 0 0],'linestyle','--');
ylabel("P_o",'fontsize',18);
xlabel("Temperature (^oC)");
xlim([-25 75]);
text(58,0.9,'A','fontsize',24);

%% Explanatory Figures

run ice_map.m
run fire_map.m

T=[-100:500];
T0_hot=250;
dC_constant= 2000;
dC_slope= 8;
dC_array_constant= [-2400,-2000,-1600,-800];
dC_array_slope= [-18,-9.5,-8,-6.5];

dS=0;

[lnKT0, KT0, PoT0]= C_M_linearCpT(T0_hot, T0_hot, dS, 1,1,0);

Tstatb_constant=-(2.*dC_array_constant./dC_slope +T0_hot);
Tstatb_slope=-(2.*dC_constant./dC_array_slope +T0_hot);

lnK_CpT_dC_slope_array= zeros(4,601);
K_CpT_dC_slope_array= zeros(4,601);
Po_CpT_dC_slope_array= zeros(4, 601);
lnK_CpT_dC_con_array= zeros(4,601);
K_CpT_dC_con_array= zeros(4,601);
Po_CpT_dC_con_array= zeros(4, 601);

lnK_Tstatb_dC_slope_array= zeros(4,1);
K_Tstatb_dC_slope_array= zeros(4,1);
Po_Tstatb_dC_slope_array= zeros(4,1);
lnK_Tstatb_dC_con_array= zeros(4,1);
K_Tstatb_dC_con_array= zeros(4,1);
Po_Tstatb_dC_con_array= zeros(4,1);
for i= 1:4
    [lnK_CpT_dC_slope_array(i,:), K_CpT_dC_slope_array(i,:), Po_CpT_dC_slope_array(i,:)]= C_M_linearCpT(T, T0_hot, dS, dC_array_slope(i),dC_constant,0);
    [lnK_Tstatb_dC_slope_array(i,:), K_Tstatb_dC_slope_array(i,:), Po_Tstatb_dC_slope_array(i,:)]= C_M_linearCpT(Tstatb_slope(i), T0_hot, dS, dC_array_slope(i),dC_constant,0);
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0_hot, dS, dC_slope,dC_array_constant(i),0);
    [lnK_Tstatb_dC_con_array(i,:), K_Tstatb_dC_con_array(i,:), Po_Tstatb_dC_con_array(i,:)]= C_M_linearCpT(Tstatb_constant(i), T0_hot, dS, dC_array_slope(i),dC_constant,0);
end

y=zeros(501,1);
y= y+0.5;
x= zeros(101,1);
t0y= [0:1/100:1];
figure('Units','centimeters','Position',[0 0 17.8 22]);

annotation('textbox',[0 0.84 0.1 0.1],'String',{'$\bf{-\frac{A}{B}} \; ? \; T_o  \downarrow$'},...
    'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold');
% annotation('textbox',[0.001 0.9 0.1 0.1],'String','$\bf{P_o(T_{o}) \rightarrow}$', ...
%     'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold');
annotation('textbox',[0. 0.88 0.1 0.1],'String','$\bf{\Delta C_p(T_o) \; ? \; 0\rightarrow}$', ...
   'Interpreter','latex','EdgeColor','none','fontsize',11,'fontweight','bold');

annotation('textbox',[0 0.75 0.1 0.1],'String','$\bf{-2\frac{A}{B} \leq T_o}$', ...
    'Interpreter','latex','EdgeColor','none','fontsize',13,'fontweight','bold','VerticalAlignment','middle' );
annotation('textbox',[0 0.525 0.1 0.1],'String',{'$\bf{-2\frac{A}{B}  > T_o}$','','$\bf{-\frac{A}{B} < T_o}$'}, ...
    'Interpreter','latex', 'EdgeColor','none','fontsize',13,'VerticalAlignment','middle');
annotation('textbox',[0 0.3 0.1 0.1],'String','$\bf{-\frac{A}{B} = T_o}$','Interpreter','latex', ...
    'EdgeColor','none','fontsize',13,'VerticalAlignment','middle' );
annotation('textbox',[0 0.05 0.1 0.1],'String',['$\bf{-\frac{A}{B} > T_o}$'],'Interpreter','latex', ...
    'EdgeColor','none','fontsize',13,'VerticalAlignment','middle' );

% annotation('textbox',[0.175 0.88 0.1 0.1],'String','\bf{Local Max.}', ...
%     'EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');
% annotation('textbox',[0.375 0.88 0.1 0.1],'String','\bf{Falling Inflection}', ...
%     'EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');
% annotation('textbox',[0.575 0.88 0.1 0.1],'String','\bf{Rising Inflection}', ...
%     'EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');
% annotation('textbox',[0.775 0.88 0.1 0.1],'String','\bf{Local Min.}', ...
%     'EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');

annotation('textbox',[0.205 0.84 0.1 0.1],'String',['$\bf{\Delta C_p(T_o)<0}$'],'Interpreter','latex','EdgeColor','none', ...
    'fontsize',14,'fontweight','bold',...
    'HorizontalAlignment','center');
% annotation('textbox',[0.375 0.88 0.1 0.1],'String',{'$\bf{0}$'}, ...
%     'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');
annotation('textbox',[0.42 0.85 0.1 0.1],'String',{'$\bf{\Delta C_p(T_o)=0}$','$\bf{B<0}$'}, ...
    'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
    'HorizontalAlignment','center');
% annotation('textbox',[0.575 0.88 0.1 0.1],'String',{'$\bf{0}$'}, ...
%     'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
%     'HorizontalAlignment','center');
annotation('textbox',[0.635 0.85 0.1 0.1],'String',{'$\bf{\Delta C_p(T_o)=0}$','$\bf{B>0}$'}, ...
    'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
    'HorizontalAlignment','center');
annotation('textbox',[0.84 0.84 0.1 0.1],'String','$\bf{\Delta C_p(T_o)>0}$','Interpreter','latex','EdgeColor','none','fontsize',14, ...
    'fontweight','bold',...
    'HorizontalAlignment','center');

annotation('line',[0.0 1],[0.225 0.225],'color',[0.5 0.5 0.5]);
annotation('line',[0.0 1],[0.45 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.0 1],[0.675 0.675],'color',[0.5 0.5 0.5]);
annotation('line',[0.0 1],[0.9 0.9],'color',[0.5 0.5 0.5]);
annotation('line',[0.15 0.15],[0.0 0.95],'color',[0.5 0.5 0.5]);
annotation('line',[0.3625 0.3625],[0.0 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.3625 0.3625],[0.275 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.3625 0.3625],[0.625 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.3625 0.3625],[0.975 0.675],'color',[0.5 0.5 0.5]);
annotation('line',[0.575 0.575],[0.0 0.975],'color',[0.5 0.5 0.5]);
annotation('line',[0.7875 0.7875],[0.0 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.7875 0.7875],[0.275 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.7875 0.7875],[0.45 0.625],'color',[0.5 0.5 0.5]);
annotation('line',[0.7875 0.7875],[0.675 0.975],'color',[0.5 0.5 0.5]);
%annotation('line',[0.73 0.73],[0.9 0.975],'color',[0.5 0.5 0.5]);

annotation('textbox',[0.205 0.8 0.1 0.1],'String',{'Double Sensitivity',"(III)"},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.84 0.67 0.1 0.1],'String',{'Double Sensitivity','(I)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.275 0.565 0.1 0.1],'String',{'Triple Sensitivity','(IIa)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.7 0.565 0.1 0.1],'String',{'Triple Sensitivity','(IVc)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.275 0.18 0.1 0.1],'String',{'Single Cold Sensitivity','(IIb)'},'EdgeColor', ...
    'none','fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.75 0.18 0.1 0.1],'String',{'Single Hot Sensitivity','(IVb)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.375 0.115 0.1 0.1],'String',{'Triple Sensitivity','(IVa)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');
annotation('textbox',[0.675 0.115 0.1 0.1],'String',{'Triple Sensitivity','(IIc)'},'EdgeColor','none', ...
    'fontsize',12,'HorizontalAlignment','center');


subplot("position",[0.175 0.7 0.15 0.175]);
%no sensitivity
plot(T,Po_CpT_dC_slope_array(1,:),'linewidth',2,'color','k');
yticks({});
xticks({});
hold on;
%plot([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
plot(Tstatb_slope(1,1), 10^-40,'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot("position",[0.8125 0.7 0.15 0.175]);
%double
plot(T, Po_CpT_dC_con_array(4,:),'linewidth',2,'color','k');
hold on;
yticks({});
xticks({});
%plot([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
plot(Tstatb_constant(1,4), 10^-40,'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
% 
subplot("position",[0.175 0.475 0.15 0.175]);
%triple cold
plot(T, Po_CpT_dC_slope_array(2,:),'linewidth',2,'color',ice(100,:));
hold on;
yticks({});
xticks({});
%plot(x,t0y,'linestyle','--','linewidth',1.5,'color','red');
plot(Tstatb_slope(1,2), Po_Tstatb_dC_slope_array(2,1),'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot("position",[0.8125 0.475 0.15 0.175]);
%triple hot
plot(T, Po_CpT_dC_con_array(3,:),'linewidth',2,'Color',fire(200, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,3), Po_Tstatb_dC_con_array(3,1),'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot("position",[0.3875 0.25 0.15 0.175]);
%single cold
plot(T, Po_CpT_dC_slope_array(3,:),'linewidth',2,'color',ice(150, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,3), Po_Tstatb_dC_slope_array(3,1),'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',6.5);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot("position",[0.6 0.25 0.15 0.175]);
%single heat
plot(T, Po_CpT_dC_con_array(2,:),'linewidth',2,'color',fire(150, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,2), Po_Tstatb_dC_con_array(2,1),'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',6.5);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
% 
subplot("position",[0.175 0.025 0.15 0.175]);
%bottom left (triple heat)
plot(T, Po_CpT_dC_con_array(1,:),'linewidth',2,'color',fire(100, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,1), Po_CpT_dC_con_array(1,Tstatb_constant(1,1)+100),'marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0, 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot("position",[0.8125 0.025 0.15 0.175]);
%bottom right (triple cold)
plot(T, Po_CpT_dC_slope_array(4,:),'linewidth',2,'Color',ice(200, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,4), Po_Tstatb_dC_slope_array(4,1),'marker','d','marker','o','markeredgecolor','k','markersize',10);
plot(T0_hot, PoT0,'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

%% delCp Linear Examples

T=[0:500];
T_cel=T-273;
T0= 250; %K
dC_con=2000;
dC_slope= 8; %cal/molK
dC_array_Constant=[-2000:10:-1000];
dC_slope_array= [-8:(8-6)/100:-6];

dC_slope_total_array= zeros(4,501);
dC_con_total_array= zeros(4,501);

T_min= -200;
T_max= 200;

for i=1:4
    dC_slope_total_array(i,:)= dC_con+dC_slope_array(i*33-32).*T;
    dC_con_total_array(i,:)= dC_array_Constant(i*33-32)+dC_slope*T;
end

dC_max= max(max(max(dC_slope_total_array)),max(max(dC_con_total_array)));
dC_min= min(min(min(dC_slope_total_array)),min(min(dC_con_total_array)));
x=zeros(1,2);
y=[dC_min dC_max];

figure('units','inches','position',[0.5 0.5 15 10],'DefaultAxesFontSize',16);
position3= [0.075 0.545 0.425 0.45];
position4= [0.55 0.545 0.425 0.45];
fig1=subplot('Position', position3);
fig2=subplot('Position', position4);

run ice_map.m
run fire_map.m

for i=1:4
    subplot(fig1);
    hold on;
    colormap(ice);
    plot(T_cel, dC_slope_total_array(i,:)./1000,'color',ice(i*40+48,:),'linewidth',2);
    subplot(fig2);
    hold on;
    plot(T_cel, dC_con_total_array(i,:)./1000,'color',fire(i*40+48,:),'linewidth',2);
end

subplot(fig1);
plot([T0-273 T0-273], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([T_min T_max]);
xticklabels({});
text(0.9*(T_max),0.9*(dC_max./1000-dC_min./1000)+dC_min./1000,"A",'fontsize',20);
units= " $\frac{cal}{mol \cdot K^2}$";

subplot(fig2);
plot([T0-273 T0-273], y./1000, 'linestyle',':','color','black','linewidth',1.5);
% ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([T_min T_max]);
text(0.9*(T_max),0.9*(dC_max./1000-dC_min./1000)+dC_min./1000,"B",'fontsize',20);
units= " $\frac{cal}{mol \cdot K}$";
xticklabels({});

dC_array= dC_slope_array;
dS= 0; %cal/molK
lnK_CpT_dC_array= zeros(101,501);
K_CpT_dC_array= zeros(101,501);
Po_CpT_dC_array= zeros(101,501);
CpT_dCSlope_Contribution= zeros(101,501);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array(i),dC_con,0);
    CpT_dCSlope_Contribution(i,:)= ((dC_array(i)).*(T0^2./(2.*T) + T./2 - T0))./R +dS/R;
end

y=zeros(501,1);
y= y+0.5;
x= zeros(6201,1);
t0y= [0:1/6200:1];
position2= [0.075 0.075 0.425 0.45];
subplot('Position', position2);
hold on;
for i= 1:4
    plot(T_cel, Po_CpT_dC_array((i-1)*33+1,:),'linewidth',2,'Color',ice(i*40+48,:));
end
plot(T_cel,y, 'Color','black', 'LineStyle','--');
plot([T0-273 T0-273],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{cal}{mol \cdot K^2}$";
xlim([T_min T_max]);
ylim([-0.005 1]);
xlabel("Temperature (T) [^oC]");
ylabel("P_o");
hold off;

CpT_dCInter_Contribution= (dC_con.*(T0./T + log(T./T0)-1))./R;

lnK_CpT_dC_con_array= zeros(101,501);
K_CpT_dC_con_array= zeros(101,501);
Po_CpT_dC_con_array= zeros(101,501);
CpT_dCInter_Contribution1= zeros(101,501);
for i= 1:101
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
    CpT_dCInter_Contribution1(i,:)= (dC_array_Constant(i).*(T0./T + log(T./T0)-1))./R;
end

position1= [0.55 0.075 0.425 0.45];
subplot('Position', position1);
y=zeros(501,1);
y= y+0.5;
hold on;
for i= 1:4
    plot(T_cel, Po_CpT_dC_con_array((i-1)*33+1,:),'linewidth',2,'Color',fire(i*40+48,:));
end
plot(T_cel,y, 'Color','black', 'LineStyle','--');
plot([T0-273 T0-273],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{kcal}{mol \cdot K}$";
xlim([T_min T_max]);
ylim([-0.005 1]);
xlabel("Temperature (T) [^oC]");
hold off;

CpT_dCSlope_Contribution1= ones(501,1).*((dC_slope).*(T0^2./(2.*T) + T./2 - T0))./R;


%% delCp Linear Examples lnkeq

T=[0:500];
T_cel=T-273;
T0= 250; %K
dC_con=2000;
dC_slope= 8; %cal/molK
dC_array_Constant=[-2000:10:-1000];
dC_slope_array= [-8:(8-6)/100:-6];

dC_slope_total_array= zeros(4,501);
dC_con_total_array= zeros(4,501);

T_min= -200;
T_max= 200;

for i=1:4
    dC_slope_total_array(i,:)= dC_con+dC_slope_array(i*33-32).*T;
    dC_con_total_array(i,:)= dC_array_Constant(i*33-32)+dC_slope*T;
end

dC_max= max(max(max(dC_slope_total_array)),max(max(dC_con_total_array)));
dC_min= min(min(min(dC_slope_total_array)),min(min(dC_con_total_array)));
x=zeros(1,2);
y=[dC_min dC_max];

figure('units','inches','position',[0.5 0.5 15 10],'DefaultAxesFontSize',16);
position3= [0.075 0.545 0.425 0.45];
position4= [0.55 0.545 0.425 0.45];
fig1=subplot('Position', position3);
fig2=subplot('Position', position4);

run ice_map.m
run fire_map.m

for i=1:4
    subplot(fig1);
    hold on;
    colormap(ice);
    plot(T_cel, dC_slope_total_array(i,:)./1000,'color',ice(i*40+48,:),'linewidth',2);
    subplot(fig2);
    hold on;
    plot(T_cel, dC_con_total_array(i,:)./1000,'color',fire(i*40+48,:),'linewidth',2);
end

subplot(fig1);
plot([T0-273 T0-273], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([T_min T_max]);
xticklabels({});
text(0.9*(T_max),0.9*(dC_max./1000-dC_min./1000)+dC_min./1000,"A",'fontsize',20);
units= " $\frac{cal}{mol \cdot K^2}$";

subplot(fig2);
plot([T0-273 T0-273], y./1000, 'linestyle',':','color','black','linewidth',1.5);
% ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([T_min T_max]);
text(0.9*(T_max),0.9*(dC_max./1000-dC_min./1000)+dC_min./1000,"B",'fontsize',20);
units= " $\frac{cal}{mol \cdot K}$";
xticklabels({});

dC_array= dC_slope_array;
dS= -11; %cal/molK
lnK_CpT_dC_array= zeros(101,501);
K_CpT_dC_array= zeros(101,501);
Po_CpT_dC_array= zeros(101,501);
CpT_dCSlope_Contribution= zeros(101,501);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array(i),dC_con,0);
    CpT_dCSlope_Contribution(i,:)= ((dC_array(i)).*(T0^2./(2.*T) + T./2 - T0))./R +dS/R;
end

y=zeros(501,1);
y= y+0.5;
x= zeros(6201,1);
t0y= [0:1/6200:1];
position2= [0.075 0.075 0.425 0.45];
subplot('Position', position2);
hold on;
for i= 1:4
    plot(T_cel, lnK_CpT_dC_array((i-1)*33+1,:),'linewidth',2,'Color',ice(i*40+48,:));
end
plot(T_cel,y, 'Color','black', 'LineStyle','--');
plot([T0-273 T0-273],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{cal}{mol \cdot K^2}$";
xlim([T_min T_max]);
ylim([-25 25]);
xlabel("Temperature (T) [^oC]");
ylabel("P_o");
hold off;

CpT_dCInter_Contribution= (dC_con.*(T0./T + log(T./T0)-1))./R;

lnK_CpT_dC_con_array= zeros(101,501);
K_CpT_dC_con_array= zeros(101,501);
Po_CpT_dC_con_array= zeros(101,501);
CpT_dCInter_Contribution1= zeros(101,501);
for i= 1:101
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
    CpT_dCInter_Contribution1(i,:)= (dC_array_Constant(i).*(T0./T + log(T./T0)-1))./R;
end

position1= [0.55 0.075 0.425 0.45];
subplot('Position', position1);
y=zeros(501,1);
y= y+0.5;
hold on;
for i= 1:4
    plot(T_cel, lnK_CpT_dC_con_array((i-1)*33+1,:),'linewidth',2,'Color',fire(i*40+48,:));
end
plot(T_cel,y, 'Color','black', 'LineStyle','--');
plot([T0-273 T0-273],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{kcal}{mol \cdot K}$";
xlim([T_min T_max]);
ylim([-25 25]);
xlabel("Temperature (T) [^oC]");
hold off;

CpT_dCSlope_Contribution1= ones(501,1).*((dC_slope).*(T0^2./(2.*T) + T./2 - T0))./R;



%% Parameter Space
run custommap_script.m
run fire_map.m
run ice_map.m
load 'Experimental Data.mat'

T=[0:500];
T_cel=T-273;
T0= 250; %K
dC_con=2000;
dC_slope= 8; %cal/molK
dC_array_Constant=[-2000:10:-1000];
dC_Slope_array= [-8:(8-6)/100:-6];

dS=0;

dC_con_array=[-4000:8:4000];
dC_slope_array= [-16:0.032:16];

dPo_0_T=zeros(1001,1001);

for i=1:1001
    for j=1:1001
        dPo_0_T(i,j)= -(2*dC_con_array(i)/dC_slope_array(j) +T0);
    end
end

%i is con

WingNum_T=zeros(1001,1001);

for i=1:1001
    for j=1:1001
        if ((dPo_0_T(i,j)<=0 || dPo_0_T(i,j)==Inf) && j<501)|| isnan(dPo_0_T(i,j))
            WingNum_T(i,j)= -3;
        elseif ((dPo_0_T(i,j)<=0 || dPo_0_T(i,j)==Inf) && (j>=501))
            WingNum_T(i,j)= 3;
        elseif i<501 && T0>dPo_0_T(i,j)>0 %&& mod(j,20)<10
            %triple wing heat sen
            WingNum_T(i,j)=-1;
        elseif i<501 && dPo_0_T(i,j)>=T0 %&& mod(i,30)<15
            %single wing heat
            WingNum_T(i,j)=-2;
        elseif i>501 && dPo_0_T(i,j)>T0 %&& mod(i,30)<15
            %tiple wing cold sen
            WingNum_T(i,j)=2;
        elseif i>501 && T0>=dPo_0_T(i,j)>0 %&& mod(j,25)<13
            %single wing cold
            WingNum_T(i,j)=1;
        else
            WingNum_T(i,j)=0;
        end
            
    end
end

figure('Units','centimeters','Position',[0 0 17.8 11.8666666667],'DefaultAxesFontSize',14);
imagesc(dC_slope_array,dC_con_array,WingNum_T, 'Alphadata', 0.25);
colormap(custommap);
set(gca,'YDir','normal');
xticks(-12:4:12);
yticks([-3000 -2000 -1000 0 1000 2000 3000]);
yticklabels({'-3', '-2', '-1', '0', '1', '2', '3'});
xlabel("Slope (B) [cal/molK^2]");
ylabel("Intercept (A) [kcal/molK]");

n=0;

dC_con_temp_array=-5:0.01:5;
dC_slope_temp_array=-10:0.5:10;


dC_con_valid_line= -dC_slope_array*T0./2;
dC_con_1to3_line= -dC_slope_array*T0;
sizes= size(dC_slope_array);
dC_slope_3to2_line= zeros(sizes(2));
dC_con_zeros= zeros(sizes(2));
hold on;
plot(dC_slope_array, dC_con_valid_line,'color',[0.375 0.375 0.375],'linewidth',2);
plot(dC_slope_array(1:500), dC_con_1to3_line(1:500),'color',ice(150,:),'linewidth',2);
plot(dC_slope_array(501:1001), dC_con_1to3_line(501:1001),'color',fire(150,:),'linewidth',2);
plot(dC_slope_array(1:20:sizes(2)), dC_con_zeros(1:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',2,'linestyle','--');
plot(dC_con_zeros(1:20:sizes(2)), dC_con_array(1:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',2);

run fire_map.m
run ice_map.m

%multiwing visualizations from previous graph
% for i=1:4
%     plot([dC_slope], dC_array_Constant(33*i-32), 'marker','o', 'linestyle','none', 'markerfacecolor',fire(i*40+48,:),'markeredgecolor',[0.5 0.5 0.5],'markersize',9);
%     plot(dC_Slope_array(33*i-32), [dC_con], 'marker','o', 'linestyle','none', 'markerfacecolor',ice(i*40+48,:),'markeredgecolor',[0.5 0.5 0.5],'markersize',9);
% end
% 
% hold off;

text(0.1, 2000, '\bf\Leftarrow\rmInter.-Only or \DeltaC_p constant','color', [0.25 0.25 0.25],'FontSize',12);
text(7, 250, '\bf\Downarrow\rmSlope-Only','color', [0.25 0.25 0.25],'horizontalalignment','center','FontSize',12);
text(dC_slope_array(150), dC_con_valid_line(300), "$\bf{-2\frac{A}{B} = T_o}$",'Interpreter','latex',...
    'horizontalalignment','center','fontsize',12,'fontweight','bold','verticalalignment','middle');
text(dC_slope_array(250), dC_con_1to3_line(100), ["$\bf{\Delta C_p(T_o)=0}$","$\bf\Leftarrow{-\frac{A}{B}=T_o}$"],'Interpreter','latex',...
    'horizontalalignment','center','fontsize',12,'fontweight','bold','verticalalignment','middle');

annotation('textbox',[0.825 0.85 0.05 0.05],'string','I','edgecolor','none','horizontalalignment','center','fontsize',14,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.465 0.875 0.05 0.05],'string','IIc','edgecolor','none','horizontalalignment','center','fontsize',14,'color',ice(200,:));
annotation('textbox',[0.15 0.8 0.05 0.05],'string','IIa','edgecolor','none','horizontalalignment','center','fontsize',14,'color',ice(100,:));
annotation('textbox',[0.325 0.7 0.1 0.05],'string','\bf\Downarrow\rmIIb','edgecolor','none','horizontalalignment','center','fontsize',14,'color',ice(150,:));
annotation('textbox',[0.825 0.25 0.05 0.05],'string','IVc','edgecolor','none','horizontalalignment','center','fontsize',14,'color',fire(200,:));
annotation('textbox',[0.55 0.15 0.05 0.05],'string','IVa','edgecolor','none','horizontalalignment','center','fontsize',14,'color',fire(100,:));
annotation('textbox',[0.60 0.315 0.1 0.05],'string','IVb \bf\Uparrow\rm','edgecolor','none','horizontalalignment','center','fontsize',14,'color',fire(150,:));
annotation('textbox',[0.2 0.2 0.05 0.05],'string','III','edgecolor','none','horizontalalignment','center','fontsize',14,'color',[0.25 0.25 0.25]);

%Experimental Data: Liu et al., 2008
plot(Liu_2008(:,1),Liu_2008(:,2)*1000, 'LineStyle','none','marker','square','color','black','markerfacecolor','black','markersize',5)

%Experimental Data: 
plot(Protein_Protein(:,1),Protein_Protein(:,2)*1000, 'LineStyle','none','marker','pentagram','color','black','markerfacecolor','black','markersize',5)

%Experimental Data: 
plot(Unfolding(:,1),Unfolding(:,2)*1000, 'LineStyle','none','marker','^','color','black','markerfacecolor','black','markersize',5)

%example traces
for n = 1:size(dC_slope_temp_array,2)
    for m = 1:size(dC_con_temp_array,2)
        dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
        if dC_slope_temp_array(n)==-8 && dC_con_temp_array(m)==2
            %single cold
            T=[150:dPo_T*1.5];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.39 0.675 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',ice(150,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==-6.5 && dC_con_temp_array(m)==2
            %triple cold 1
            T=[0:dPo_T*1.5];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.4 0.78 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',ice(200,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==-9.5 && dC_con_temp_array(m)==2
            %triple cold 2
            T=[0:400];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.2 0.7 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',ice(100,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==8 && dC_con_temp_array(m)==-2
            %single heat
            T=[150:375];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.55 0.3 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',fire(150,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==8 && dC_con_temp_array(m)==-2.4
            %single heat
            T=[0:2.25*dPo_T-T0];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.61 0.17 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',fire(100,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==8 && dC_con_temp_array(m)==-1.6
            %triple heat
            T=[0:T0*2];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.78 0.27 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',fire(200,:));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==8 && dC_con_temp_array(m)==2
            axes('Position',[0.75 0.75 0.075 0.075]);
            dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
            T=[T0/2:T0*3/2];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            plot(T, temp_po,'linewidth',1.5,'Color','k');
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==-8 && dC_con_temp_array(m)==-2
            axes('Position',[0.25 0.25 0.075 0.075]);
            dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
            T=[T0/2:T0*3/2];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            plot(T, temp_po,'linewidth',1.5,'Color','k');
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        end
    end
end

hold off;

%% Po change in delta S

T=[0:500];
T_cel=T-273;
To=250;
dS_array= [-9 0 9];
dC_slope= 8;
dC_con= 2000; %cal/molK

run ice_map.m
run fire_map.m

dC_slope_array= [-10 -8 -20/3];
dC_con_array= [-2400 -2000 -1600];

lnK_CpT_dC_con_array= zeros(3,4,501);
K_CpT_dC_con_array= zeros(3,4,501);
Po_CpT_dC_con_array= zeros(3,4,501);

lnK_CpT_dC_slope_array= zeros(3,4,501);
K_CpT_dC_slope_array= zeros(3,4,501);
Po_CpT_dC_slope_array= zeros(3,4,501);

lnK_CpT_double_array= zeros(3,2,501);
K_CpT_double_array= zeros(3,2,501);
Po_CpT_double_array= zeros(3,2,501);

for i= 1:3
    for j= 1:3
        [lnK_CpT_dC_slope_array(i,j,:), K_CpT_dC_slope_array(i,j,:), Po_CpT_dC_slope_array(i,j,:)]= C_M_linearCpT(T, To, dS_array(i), dC_slope_array(j),dC_con, 0);
        [lnK_CpT_dC_con_array(i,j,:), K_CpT_dC_con_array(i,j,:), Po_CpT_dC_con_array(i,j,:)]= C_M_linearCpT(T, To, dS_array(i), dC_slope, dC_con_array(j), 0);
    end
    [lnK_CpT_double_array(i,1,:), K_CpT_double_array(i,1,:), Po_CpT_double_array(i,1,:)]= C_M_linearCpT(T, To, dS_array(i), 0,dC_con, 0);
    [lnK_CpT_double_array(i,2,:), K_CpT_double_array(i,2,:), Po_CpT_double_array(i,2,:)]= C_M_linearCpT(T, To, dS_array(i), -dC_slope,0, 0);
end


figure('Units','centimeters','Position',[0 0 17.8 8.9]);
for i= 1:3
    for j=1:3
        colorcode_fire= fire(j*50+50,:)*((i+2)/4);
        colorcode_ice= ice(j*50+50,:)*((i+2)/4);
       
        for number=1:size(colorcode_ice,2)
            colorcode_ice(number)
            if colorcode_ice(number)>1
                colorcode_ice(number)=1;
            end
            if colorcode_fire(number)>1
                colorcode_fire(number)=1;
            end

        end
        
        
        top=subplot(2,4,j+1);
        hold on;
        temp_Po=reshape(Po_CpT_dC_slope_array(i,j,:),[501,1]);
        plot(T-273, temp_Po,'color',colorcode_ice,'linewidth',2);
        plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
        plot(round(-(2*dC_con/dC_slope_array(j) +To))-273,temp_Po(round(-(2*dC_con/dC_slope_array(j) +To))),'marker','o','markeredgecolor','k','markersize',10);
        ylim([0 1]);
        xlim([-200 170]);
        set(gca,'fontweight','bold');
        set(gca,'fontsize',12);
        hold off;
        
        bottom=subplot(2,4,j+5);
        hold on;
        temp_Po=reshape(Po_CpT_dC_con_array(i,j,:),[501,1]);
        plot(T-273, temp_Po,'color',colorcode_fire,'linewidth',2);
        plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
        plot(round(-(2*dC_con_array(j)/dC_slope +To))-273,temp_Po(round(-(2*dC_con_array(j)/dC_slope +To))),'marker','o','markeredgecolor','k','markersize',10);
        ylim([0 1]);
        xlim([-200 170]);
        xlabel("Temp. (^oC)",'FontSize',12,'FontWeight','bold');
        set(gca,'fontweight','bold');
        set(gca,'fontsize',12);
        hold off;
        
    end
    
    top=subplot(2,4,1);
    hold on;
    temp_Po=reshape(Po_CpT_double_array(i,1,:),[501,1]);
    plot(T-273, temp_Po,'color',[1/5*(i-1) 1/5*(i-1) 1/5*(i-1)],'linewidth',2);
    plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
    ylim([0 1]);
    xlim([-200 170]);
    ylabel("P_o");
    set(gca,'fontweight','bold');
    set(gca,'fontsize',12);
    hold off;
    
    bottom=subplot(2,4,5);
    hold on;
    temp_Po=reshape(Po_CpT_double_array(i,2,:),[501,1]);
    plot(T-273, temp_Po,'color',[1/5*(i-1) 1/5*(i-1) 1/5*(i-1)],'linewidth',2);
    plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
    ylim([0 1]);
    xlim([-200 170]);
    xlabel("Temp. (^oC)",'FontSize',10,'FontWeight','bold');
    ylabel("P_o");
    set(gca,'fontweight','bold');
    set(gca,'fontsize',12);
    hold off;
end


for j=1:4
    
    j;
    top=subplot(2,4,j);
    toppos= get(top, 'position');
    bottom=subplot(2,4,j+4);
    bottompos= get(bottom, 'position');
    
    switch mod(j,4)
    
        case 1
            toppos(1)=toppos(1)+0.015;
            annotation('textbox',toppos,'string','I','edgecolor','none','horizontalalignment','left','fontsize',12,'color',[0.25 0.25 0.25],'FontWeight','bold');
            
            bottompos(1)=toppos(1);
            annotation('textbox',bottompos,'string','III','edgecolor','none','horizontalalignment','left','fontsize',12,'color',[0.25 0.25 0.25],'FontWeight','bold');
        case 2
            toppos(1)=toppos(1)-0.0075;
            annotation('textbox',toppos,'string','IIa','edgecolor','none','horizontalalignment','right','fontsize',12,'color',ice(j*50,:),'FontWeight','bold');
            
            bottompos(1)=bottompos(1)+0.0075;
            annotation('textbox',bottompos,'string','IVa','edgecolor','none','horizontalalignment','left','fontsize',12,'color',fire(j*50,:),'FontWeight','bold');
        case 3
            toppos(1)=toppos(1);
            annotation('textbox',toppos,'string','IIb','edgecolor','none','horizontalalignment','right','fontsize',12,'color',ice(j*50,:),'FontWeight','bold');
            
            bottompos(1)=bottompos(1);
            annotation('textbox',bottompos,'string','IVb','edgecolor','none','horizontalalignment','left','fontsize',12,'color',fire(j*50,:),'FontWeight','bold');
        case 0
           toppos(1)=toppos(1)+0.0075;
           annotation('textbox',toppos,'string','IIc','edgecolor','none','horizontalalignment','left','fontsize',12,'color',ice(j*50,:),'FontWeight','bold');
           
           bottompos(1)=bottompos(1);
           annotation('textbox',bottompos,'string','IVc','edgecolor','none','horizontalalignment','right','fontsize',12,'color',fire(j*50,:),'FontWeight','bold');
    end
end


%% Po change in delta S (log)

T=[0:500];
T_cel=T-273;
To=250;
dS_array= [-9 0 9];
dC_slope= 8;
dC_con= 2000; %cal/molK

run ice_map.m
run fire_map.m

dC_slope_array= [-10 -8 -20/3];
dC_con_array= [-2400 -2000 -1600];

lnK_CpT_dC_con_array= zeros(3,4,501);
K_CpT_dC_con_array= zeros(3,4,501);
Po_CpT_dC_con_array= zeros(3,4,501);

lnK_CpT_dC_slope_array= zeros(3,4,501);
K_CpT_dC_slope_array= zeros(3,4,501);
Po_CpT_dC_slope_array= zeros(3,4,501);

lnK_CpT_double_array= zeros(3,2,501);
K_CpT_double_array= zeros(3,2,501);
Po_CpT_double_array= zeros(3,2,501);

for i= 1:3
    for j= 1:3
        [lnK_CpT_dC_slope_array(i,j,:), K_CpT_dC_slope_array(i,j,:), Po_CpT_dC_slope_array(i,j,:)]= C_M_linearCpT(T, To, dS_array(i), dC_slope_array(j),dC_con, 0);
        [lnK_CpT_dC_con_array(i,j,:), K_CpT_dC_con_array(i,j,:), Po_CpT_dC_con_array(i,j,:)]= C_M_linearCpT(T, To, dS_array(i), dC_slope, dC_con_array(j), 0);
    end
    [lnK_CpT_double_array(i,1,:), K_CpT_double_array(i,1,:), Po_CpT_double_array(i,1,:)]= C_M_linearCpT(T, To, dS_array(i), 0,dC_con, 0);
    [lnK_CpT_double_array(i,2,:), K_CpT_double_array(i,2,:), Po_CpT_double_array(i,2,:)]= C_M_linearCpT(T, To, dS_array(i), -dC_slope,0, 0);
end


figure('Units','centimeters','Position',[1 1 33 16.5]);
for i= 1:3
    for j=1:3
        colorcode_fire= fire(j*50+50,:)*((i+2)/4);
        colorcode_ice= ice(j*50+50,:)*((i+2)/4);
       
        for number=1:size(colorcode_ice,2)
            colorcode_ice(number)
            if colorcode_ice(number)>1
                colorcode_ice(number)=1;
            end
            if colorcode_fire(number)>1
                colorcode_fire(number)=1;
            end

        end
        
        
        top=subplot(2,4,j+1);
        hold on;
        set(gca,'yscale','log');
        temp_Po=reshape(Po_CpT_dC_slope_array(i,j,:),[501,1]);
        plot(T-273, temp_Po,'color',colorcode_ice,'linewidth',2);
        plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
        plot(round(-(2*dC_con/dC_slope_array(j) +To))-273,temp_Po(round(-(2*dC_con/dC_slope_array(j) +To))),'marker','o','markeredgecolor','k','markersize',10);
        ylim([10^-6 1]);
        xlim([-200 170]);
        set(gca,'fontweight','bold');
        set(gca,'fontsize',12);
        hold off;
        
        bottom=subplot(2,4,j+5);
        hold on;
        set(gca,'yscale','log');
        temp_Po=reshape(Po_CpT_dC_con_array(i,j,:),[501,1]);
        plot(T-273, temp_Po,'color',colorcode_fire,'linewidth',2);
        plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
        plot(round(-(2*dC_con_array(j)/dC_slope +To))-273,temp_Po(round(-(2*dC_con_array(j)/dC_slope +To))),'marker','o','markeredgecolor','k','markersize',10);
        ylim([10^-6 1]);
        xlim([-200 170]);
        xlabel("Temperature (^oC)",'FontSize',12,'FontWeight','bold');
        set(gca,'fontweight','bold');
        set(gca,'fontsize',12);
        hold off;
        
    end
    
    top=subplot(2,4,1);
    hold on;
    set(gca,'yscale','log');
    temp_Po=reshape(Po_CpT_double_array(i,1,:),[501,1]);
    plot(T-273, temp_Po,'color',[1/5*(i-1) 1/5*(i-1) 1/5*(i-1)],'linewidth',2);
    plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
    ylim([10^-6 1]);
    xlim([-200 170]);
    ylabel("P_o");
    set(gca,'fontweight','bold');
    set(gca,'fontsize',12);
    hold off;
    
    bottom=subplot(2,4,5);
    hold on;
    set(gca,'yscale','log');
    temp_Po=reshape(Po_CpT_double_array(i,2,:),[501,1]);
    plot(T-273, temp_Po,'color',[1/5*(i-1) 1/5*(i-1) 1/5*(i-1)],'linewidth',2);
    plot(To-273, temp_Po(To), 'marker','d','markerfacecolor','k','markeredgecolor','k','markersize',8);
    ylim([10^-6 1]);
    xlim([-200 170]);
    xlabel("Temperature (^oC)",'FontSize',12,'FontWeight','bold');
    ylabel("P_o");
    set(gca,'fontweight','bold');
    set(gca,'fontsize',12);
    hold off;
end


for j=1:4
    
    j;
    top=subplot(2,4,j);
    toppos= get(top, 'position');
    bottom=subplot(2,4,j+4);
    bottompos= get(bottom, 'position');
    
    switch mod(j,4)
    
        case 1
            toppos(1)=toppos(1)+0.015;
            annotation('textbox',toppos,'string','I','edgecolor','none','horizontalalignment','left','fontsize',20,'color',[0.25 0.25 0.25],'FontWeight','bold');
            
            bottompos(1)=toppos(1);
            annotation('textbox',bottompos,'string','III','edgecolor','none','horizontalalignment','left','fontsize',20,'color',[0.25 0.25 0.25],'FontWeight','bold');
        case 2
            toppos(1)=toppos(1)-0.0075;
            annotation('textbox',toppos,'string','IIa','edgecolor','none','horizontalalignment','right','fontsize',20,'color',ice(j*50,:),'FontWeight','bold');
            
            bottompos(1)=bottompos(1)+0.0075;
            annotation('textbox',bottompos,'string','IVa','edgecolor','none','horizontalalignment','left','fontsize',20,'color',fire(j*50,:),'FontWeight','bold');
        case 3
            toppos(1)=toppos(1)-0.0075;
            annotation('textbox',toppos,'string','IIb','edgecolor','none','horizontalalignment','right','fontsize',20,'color',ice(j*50,:),'FontWeight','bold');
            
            bottompos(1)=bottompos(1)+0.0075;
            annotation('textbox',bottompos,'string','IVb','edgecolor','none','horizontalalignment','left','fontsize',20,'color',fire(j*50,:),'FontWeight','bold');
        case 0
           toppos(1)=toppos(1)+0.0075;
           annotation('textbox',toppos,'string','IIc','edgecolor','none','horizontalalignment','left','fontsize',20,'color',ice(j*50,:),'FontWeight','bold');
           
           bottompos(1)=bottompos(1)-0.0075;
           annotation('textbox',bottompos,'string','IVc','edgecolor','none','horizontalalignment','right','fontsize',20,'color',fire(j*50,:),'FontWeight','bold');
    end
end
