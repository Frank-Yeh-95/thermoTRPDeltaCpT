%%
T=[0:500];
R=1.987; %cal/molK;
T_cel= T-273;

dH_hot=150000;
dS_hot=470;
lnK_hot= -(dH_hot-T.*dS_hot)./(R.*T);
Po_hot= exp(lnK_hot)./(1+exp(lnK_hot));
dPo_hot= (dH_hot.*exp((dH_hot+T.*dS_hot)./(R.*T)))./(R.*(T.^2).*(exp(dH_hot./(R.*T))+exp(dS_hot./R)).^2);

dH_cold=-112000;
dS_cold=-384;
lnK_cold= -(dH_cold-T.*dS_cold)./(R.*T);
Po_cold= exp(lnK_cold)./(1+exp(lnK_cold));
dPo_cold= (dH_cold.*exp((dH_cold+T.*dS_cold)./(R.*T)))./(R.*(T.^2).*(exp(dH_cold./(R.*T))+exp(dS_cold./R)).^2);

figure();

Po_graph=subplot(2,1,1);
hold on;
Po_graph.FontSize= 16;
plot(T_cel, Po_cold,'linewidth',2,'color','blue');
plot(T_cel, Po_hot,'linewidth',2,'color','red');
ylim([0 1]);
xlim([-25 75]);
ylabel('$\bf{P_o}$','fontsize',18,'Interpreter','latex');
hold off;

% figure();
% semilogy(T_cel, Po_cold);
% hold on;
% semilogy(T_cel, Po_hot);
% hold off;

dPo_graph=subplot(2,1,2);
hold on;
dPo_graph.FontSize= 16;
plot(T_cel, dPo_cold,'linewidth',2,'color','blue');
plot(T_cel, dPo_hot,'linewidth',2,'color','red');
% ylim([0 1]);
xlim([-25 75]);
ylabel('$\bf{\frac{dP_o}{dT}}$','fontsize',20,'Interpreter','latex');
xlabel('Temperature (^oC)','fontsize',16);
hold off;

%%