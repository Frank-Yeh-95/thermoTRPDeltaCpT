%% Method Description
run Clapham_Miller.m
%%
%First Order T Dependence
R= 1.987; %cal/molK
T= zeros(500,1);

startT=0;

for i= startT:500+startT
    T(i-startT+1,1)=i;
end

dS= -9; %cal/molK
T0= 298; %K
dC_slope= 3000/298; %cal/molK
dC_con=0;

[lnK_CpT, K_CpT, Po_CpT]= C_M_linearCpT(T, T0, dS, dC_slope, dC_con, 1);

Po_difference= Po_dC3-Po_CpT;

fig=figure('Units','inches','Position',[0 0 7 12], 'DefaultAxesFontSize',12);
set(fig,'defaultAxesColorOrder',[[0 0 0]; [0 0 0]]);
subplot(2,1,2);
yyaxis left;
hold on;
plot(T, Po_CpT,'linewidth',2,'color',[0 0 1], 'linestyle','--');
plot(T, Po_dC3,'linewidth',2,'color',[0 0 1],'linestyle','-');
ylabel("P_o");
hold off;
yyaxis right;
plot(T, Po_difference,'linewidth',2);
ylabel("\DeltaP_o");
ylim([-0.25 0.25]);
yticks(-0.25:0.1:0.25);
xlabel("Temperature [K]");
%legend({"Slope Only \DeltaC_p", "Intercept Only \DeltaC_p","P_o Difference"},...
%    'FontSize',12,'Location','NE');
xlim([220,380]);
title("B. Slope-Only \DeltaC_p approximates Intercept-Only \DeltaC_p");


% axes('Position',[0.18 0.6 0.17 0.25]);
% hold on;
% yyaxis left;
% hold on;
% plot(T, Po_CpT,'linewidth',2,'color',[0 0 1], 'linestyle','--');
% plot(T, Po_dC3,'linewidth',2,'color',[0 0 1],'linestyle','-');
% ylim([0.15 0.85]);
% hold off;
% yyaxis right;
% plot(T, Po_difference,'linewidth',2);
% ylim([-0.35 0.35]);
% xlim([260,290]);
% [\Delta C_p at 3000cal/molK; \Delta S^o_o at -9cal/molK; T_o=250K]


dC_array=[0:50:5000];
dC_firstorder= zeros(101, 501);

for i= 1:101
    dC_slope= dC_array(i)/T0;
    dC_firstorder(i,:)= dC_slope.*T;
end

subplot(2,1,1);
hold on;
for i= 21:40:101
    y= zeros(501,1);
    y= y+dC_array(i);
    if i<34
        plot(T, dC_firstorder(i,:)./1000,'color',[0 0 .5],'linewidth',2, 'linestyle','--');
        plot(T, y./1000, 'color', [0 0 0.5],'linewidth',2);
    elseif i<66
        plot(T, dC_firstorder(i,:)./1000,'color',[0 0 1],'linewidth',2, 'linestyle','--');
        plot(T, y./1000, 'color', [0 0 1],'linewidth',2);
    else
        plot(T, dC_firstorder(i,:)./1000,'color',[0 1 1],'linewidth',2, 'linestyle','--');
        plot(T, y./1000, 'color', [0 1 1],'linewidth',2);
    end
end
ylim([0 8]);
x= zeros(8000,1);
x= x+298;
y= zeros(8000,1);
for i=1:8000
    y(i)=i./1000;
end
plot(x, y, 'linestyle',':','color','black','linewidth',1.5);
xlabel("Temperature [K]");
ylabel("\DeltaC_p [kcal/molK]");
%text(T0, 6,"T_o",'Fontsize',14);
title("A. Slope-Only and Intercept-Only \DeltaC_p comparison");
%legend({"Slope-Only \DeltaC_p", "Intercept-Only \DeltaC_p"},'Location','NW','Fontsize',12);
hold off;


%% 9FigurePlot
%Change in T0 effects onfirst order
dS= -9; %cal/molK
T0= 298; %K
T0_array=[101:2.5:351];
T50_T0_array_dCp_first=zeros(2,101);
T=[0:500];
dC_slope= 3000/T0;

%NOTE: dC to dC_slope when applicable

dC_slope_T0_array= dC./T0_array;

T50_T0_array(1,:)= -T0_array./ lambertw( 0, -exp( -1+ dS./dC));
T50_T0_array(2,:)= -T0_array./ lambertw( -1, -exp( -1+ dS./dC));
T50_T0_array_dCp_first(1,:)= -T0_array.*(dS/dC -1) + sqrt((T0_array.*(dS/dC -1)).^2 -T0_array.^2);
T50_T0_array_dCp_first(2,:)= -T0_array.*(dS/dC -1) - sqrt((T0_array.*(dS/dC -1)).^2 -T0_array.^2);

y= zeros(101,1);
figure('Units','inches','Position',[0 0 18 16],'DefaultAxesFontSize', 16);
subplot('Position',[0.1 0.36 0.25 0.27]);
hold on;
plot(T0_array, T50_T0_array_dCp_first(1,:)-T0_array,'black','linewidth',2, 'LineStyle','--');
plot(T0_array, -(T50_T0_array_dCp_first(2,:)-T0_array),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(T0_array, T50_T0_array(1,:)-T0_array,'black','linewidth',1.5);
plot(T0_array, -(T50_T0_array(2,:)-T0_array),'color',[0.47 0.47 0.47],'linewidth',1.5);
for j= 1:2
    for i= 21:40:101
         if i<34
            scatter(T0_array(i),  abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'sizedata',100);
            scatter(T0_array(i),  abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(T0_array(i), abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'sizedata',100);
            scatter(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(T0_array(i), abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'sizedata',100);
            scatter(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
%plot(T0_array, y, 'Color','black',);
ylabel("|T-T_o| [K]");
%legend({"(+) Slope-Only","(-) Slope-Only",...
%    "(+) Inter.-Only","(-) Inter.-Only"},'Location','NW','FontSize', 14);
ylim([0 100]);
xlim([100 351]);
xticklabels({});
box off;
hold off;

axes('Position',[0.22 0.475 0.125 0.126]);
hold on;
plot(T0_array, T50_T0_array_dCp_first(1,:)-T0_array,'black','linewidth',2, 'LineStyle','--');
plot(T0_array, -(T50_T0_array_dCp_first(2,:)-T0_array),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(T0_array, T50_T0_array(1,:)-T0_array,'black','linewidth',1.75);
plot(T0_array, -(T50_T0_array(2,:)-T0_array),'color',[0.47 0.47 0.47],'linewidth',1.75);
%plot(T0_array, y, 'Color','black',);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(T0_array(i),  abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'sizedata',100);
            scatter(T0_array(i),  abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(T0_array(i), abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'sizedata',100);
            scatter(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(T0_array(i), abs(T50_T0_array_dCp_first(j,i)-T0_array(i)),'Marker','^','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'sizedata',100);
            scatter(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
xlim([130 170]);
xticks([130 150 170]);
box off;
hold off;

dPo_T0_array= zeros(2,101);
dPo_T0_array_dCp_first= zeros(2,101);

dPo_T0_array= dC.* exp((dC + dS - (dC .* T0_array./T50_T0_array) + dC .* log(T0_array./T50_T0_array))./R) .* ...
    (T50_T0_array-T0_array)...
    ./ ((exp(dS./R) + exp(dC./R .* (1 - T0_array./T50_T0_array + log(T0_array./T50_T0_array)))).^(2) ...
    .* R .* T50_T0_array.^(2));

% dPo_T0_array_dC_first=(1/2).*dC_slope_T0_array.*exp(1).^(R.^(-1).*(dS+(1/2).*dC_slope_T0_array.*(T50_T0_array+(-2).*T0_array+2.*T50_T0_array.^(-1).* ...
%   T0_array.^2))).*(1+exp(1).^(R.^(-1).*(dS+(1/2).*dC_slope_T0_array.*(T50_T0_array+(-2).*T0_array+2.*T50_T0_array.^( ...
%   -1).*T0_array.^2)))).^(-2).*R.^(-1).*T50_T0_array.^(-2).*(T50_T0_array.^2+(-2).*T0_array.^2);

dPo_T0_array_dC_first= (1/2).*dC.*exp(1).^((1/2).*R.^(-1).*(2.*dS+dC.*((-2)+T50_T0_array.*T0_array.^(-1)+ ...
  T50_T0_array.^(-1).*T0_array))).*(1+exp(1).^((1/2).*R.^(-1).*(2.*dS+dC.*((-2)+T50_T0_array.* ...
  T0_array.^(-1)+T50_T0_array.^(-1).*T0_array)))).^(-2).*R.^(-1).*T50_T0_array.^(-2).*T0_array.^(-1).*(T50_T0_array.^2+ ...
  (-1).*T0_array.^2);

y= zeros(101,1);
subplot('Position',[0.1 0.075 0.25 0.26]);
plot(T0_array, dPo_T0_array(1,:),'Color','black','linewidth',1.5);
hold on;
plot(T0_array, -dPo_T0_array(2,:),'Color',[0.47 0.47 0.47],'linewidth',1.5);
plot(T0_array, dPo_T0_array_dC_first(1,:),'Color',[0 0 0],'linewidth',2, 'LineStyle','--');
plot(T0_array, -dPo_T0_array_dC_first(2,:),'Color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
%plot(T0_array, y, 'Color','black',);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(T0_array(i), abs(dPo_T0_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'sizedata',100);
            scatter(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(T0_array(i), abs(dPo_T0_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'sizedata',100);
            scatter(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(T0_array(i), abs(dPo_T0_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'sizedata',100);
            scatter(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
ylabel("Maximal Slope");
A_xlabel=xlabel("T_o [K]");
A_xlabel.Units='normalized';
A_xlabel.Extent
A_xlabel.Position(2)=-0.125;
xlim([100 351]);
ylim([0 0.25]);
box off;
hold off;

% dLnK_T0_array_dCp_first=zeros(2,101);
% 
% dLnK_T0_array_dCp_first(1,:)= dC./(2.*T0_array.*R).*(1-T0_array.^2 ./(T50_T0_array_dCp_first(1,:).^2));
% dLnK_T0_array_dCp_first(2,:)= dC./(2.*T0_array.*R).*(1-T0_array.^2 ./(T50_T0_array_dCp_first(2,:).^2));
% dLnK_T0_array(1,:)= dC.*(1./T50_T0_array(1,:) - T0_array./(T50_T0_array(1,:).*T50_T0_array(1,:)))./R;
% dLnK_T0_array(2,:)= dC.*(1./T50_T0_array(2,:) - T0_array./(T50_T0_array(2,:).*T50_T0_array(2,:)))./R;
% 
% y= zeros(101,1);
% subplot('Position',[0.1 0.06 0.25 0.25]);
% hold on;
% plot(T0_array, dLnK_T0_array_dCp_first(1,:),'black','linewidth',2);
% plot(T0_array, -dLnK_T0_array_dCp_first(2,:),'color',[0.47 0.47 0.47],'linewidth',2);
% plot(T0_array, dLnK_T0_array(1,:),'black', 'linewidth',2);
% plot(T0_array, -dLnK_T0_array(2,:),'color',[0.47 0.47 0.47],'linewidth',2);
% for j= 1:2
%     for i= 21:40:101
%         if i<34
%             plot(T0_array(i), abs(dLnK_T0_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[128/255 0 0], ...
%                 'MarkerEdgeColor',[128/255 0 0],'MarkerSize',10);
%         elseif i<66
%             plot(T0_array(i), abs(dLnK_T0_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[1 0 0], ...
%                 'MarkerEdgeColor',[1 0 0],'MarkerSize',10);
%         else
%             plot(T0_array(i), abs(dLnK_T0_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[250/255 128/255 114/255], ...
%                 'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerSize',10);
%         end
%     end
% end
% ylabel("Maximal Slope [Arbit. Units]");
% xlabel("T_o [K]");
% ylim([0 1]);
% box off;
% hold off;

lnK_T0_array= zeros(101,501);
K_T0_array= zeros(101,501);
Po_CpT_T0_array= zeros(101, 501);
for i= 1:101
    [lnK_T0_array(i,:), K_T0_array(i,:), Po_CpT_T0_array(i,:)]= C_M_linearCpT(T, T0_array(i), dS, dC./(T0_array(i)), dC_con,1);
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.1 0.7 0.25 0.27]);
title("A. Change in T_o effects");
hold on;
for i= 21:40:101
    if i<34
        plot(T-T0_array(i), Po_CpT_T0_array(i,:),'linewidth',2,'Color',[128/255 0 0], 'LineStyle','--');
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',1.25,'Color',[128/255 0 0]);
    elseif i<66
        plot(T-T0_array(i), Po_CpT_T0_array(i,:),'linewidth',2,'Color',[1 0 0], 'LineStyle','--');
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',1.25,'Color',[1 0 0]);
    else
        plot(T-T0_array(i), Po_CpT_T0_array(i,:),'linewidth',2,'Color',[250/255 128/255 114/255], 'LineStyle','--');
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',1.25,'Color',[250/255 128/255 114/255]);
    end
end
plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlim([-66 66]);
xlabel("Temperature (T-T_o) [K]");
ylabel("P_o");
A_title=title("A. Change in T_o effects");
A_title.Position(2)= 0.97;
%legend({"Slope-Only", "Inter.-Only"},'Location','NW','Fontsize',14);
box off;
hold off;

% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:100
%     if i<25
%         plot(T-T0_array(i), lnK_T0_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0_array(i), lnK_T0_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0_array(i), lnK_T0_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0_array(i), lnK_T0_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% plot(T-T0,y, 'Color','black',);
% ylim([-2 2]);
% xlim([-100, 150]);
% title("Ln(K_e_q) v. T over many T_o after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;

%Change in dS over Po and T50

dS_array=[-22.5:0.225:0];
dS_array= reshape(dS_array,[101,1]);
dS_array_kb= dS_array./(4.186798*6.022*10^23)./1.380649*10^23;
T50_dS_array_dCp_first=zeros(2,101);

T50_dS_array_dCp_first(1,:)= -T0.*(dS_array/dC -1) + sqrt((T0.*(dS_array/dC -1)).^2 -T0.^2);
T50_dS_array_dCp_first(2,:)= -T0.*(dS_array/dC -1) - sqrt((T0.*(dS_array/dC -1)).^2 -T0.^2);
T50_dS_array(:,1)= reshape(-T0./ lambertw( 0, -exp( -1+ dS_array./dC)), [101,1]);
T50_dS_array(:,2)= reshape(-T0./ lambertw( -1, -exp( -1+ dS_array./dC)), [101,1]);

y= zeros(101,1);
subplot('Position',[0.4 0.36 0.25 0.27]);
hold on;
plot(dS_array, T50_dS_array_dCp_first(1,:)-T0,'black','linewidth',2, 'LineStyle','--');
plot(dS_array, -(T50_dS_array_dCp_first(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dS_array, T50_dS_array(:,1)-T0,'black','linewidth',1.5);
plot(dS_array, -(T50_dS_array(:,2)-T0),'color',[0.47 0.47 0.47],'linewidth',1.5);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'sizedata',100);
            scatter(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'sizedata',100);
            scatter(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'sizedata',100);
            scatter(dS_array(i),abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
ylim([0 100]);
xlim([-22.5 0]);
%plot(dS_array, y, 'Color','black',);
xticklabels({});
box off;
hold off;

axes('Position',[0.51 0.475 0.125 0.126]);
hold on;
plot(dS_array, T50_dS_array_dCp_first(1,:)-T0,'black','linewidth',2, 'LineStyle','--');
plot(dS_array, -(T50_dS_array_dCp_first(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dS_array, T50_dS_array(:,1)-T0,'black','linewidth',1.75);
plot(dS_array, -(T50_dS_array(:,2)-T0),'color',[0.47 0.47 0.47],'linewidth',1.75);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'sizedata',100);
            scatter(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'sizedata',100);
            scatter(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dS_array(i), abs(T50_dS_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'sizedata',100);
            scatter(dS_array(i),abs(T50_dS_array(i,j)-T0),'Marker','o','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
xlim([-10 -8]);
%plot(dS_array, y, 'Color','black',);
box off;
hold off;


dPo_dS_array= zeros(101,2);
dPo_dS_array_dC_first= zeros(101,2);

dPo_dS_array= dC.* exp((dC + dS_array - (dC .* T0./T50_dS_array) + dC .* log(T0./T50_dS_array))./R) .* ...
    (T50_dS_array-T0)...
    ./ ((exp(dS_array./R) + exp(dC./R .* (1 - T0./T50_dS_array + log(T0./T50_dS_array)))).^2 ...
    .* R .* T50_dS_array.^2);

dPo_dS_array_dC_first=(1/2).*dC.*exp(1).^((1/2).*R.^(-1).*(2.*dS_array+dC.*((-2)+T50_dS_array.*T0.^(-1)+ ...
  T50_dS_array.^(-1).*T0))).*(1+exp(1).^((1/2).*R.^(-1).*(2.*dS_array+dC.*((-2)+T50_dS_array.* ...
  T0.^(-1)+T50_dS_array.^(-1).*T0)))).^(-2).*R.^(-1).*T50_dS_array.^(-2).*T0.^(-1).*(T50_dS_array.^2+ ...
  (-1).*T0.^2);
% dPo_dS_array_dC_first= ((dC./2) .* exp((2 .* dS_array + dC .* (T50_dS_array_dCp_first./T0 + T0./T50_dS_array_dCp_first -2))./(2.*R)).*...
%     (T50_dS_array_dCp_first.^2 - T0.^2))...
%     ./((1 +exp((2 .* dS_array + dC .* (T50_dS_array_dCp_first./T0 + T0./T50_dS_array_dCp_first -2))./(2.*R))).^2 ...
%     .* R.*T50_dS_array_dCp_first.^(2).* T0);


y= zeros(101,1);
subplot('Position',[0.4 0.075 0.25 0.26]);
hold on;
plot(dS_array, dPo_dS_array_dC_first(:,1),'Color','black','linewidth',2, 'LineStyle','--');
plot(dS_array, abs(dPo_dS_array_dC_first(:,2)),'Color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dS_array, dPo_dS_array(:,1),'Color','black','linewidth',1.5);
plot(dS_array, abs(dPo_dS_array(:,2)),'Color',[0.47 0.47 0.47],'linewidth',1.5);
for j= 1:2
   for i= 21:40:101
       if i<34
            scatter(dS_array(i), abs(dPo_dS_array_dC_first(i,j)),'Marker','^','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'sizedata',100);
            scatter(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dS_array(i), abs(dPo_dS_array_dC_first(i,j)),'Marker','^','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'sizedata',100);
            scatter(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dS_array(i), abs(dPo_dS_array_dC_first(i,j)),'Marker','^','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'sizedata',100);
            scatter(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
       end
    end
end
%plot(dS_array, y, 'Color','black',);
B_xlabel=xlabel("\DeltaS_o^o [cal/molK]");
B_xlabel.Units='normalized';
B_xlabel.Extent
B_xlabel.Position(2)=-0.11;
ylim([0 0.25]);
xlim([-22.5 0]);
box off;
hold off;


% dLnK_dS_array_dCp_first=zeros(2,101);
% 
% dLnK_dS_array_dCp_first(1,:)= dC./(2.*T0.*R).*(1-T0.^2 ./(T50_dS_array_dCp_first(1,:).^2));
% dLnK_dS_array_dCp_first(2,:)= dC./(2.*T0.*R).*(1-T0.^2 ./(T50_dS_array_dCp_first(2,:).^2));
% dLnK_dS_array(:,1)= dC .*(1./T50_dS_array(:,1) - T0./(T50_dS_array(:,1) .* T50_dS_array(:,1)))./R;
% dLnK_dS_array(:,2)= dC .*(1./T50_dS_array(:,2) - T0./(T50_dS_array(:,2) .* T50_dS_array(:,2)))./R;
% 
% y= zeros(101,1);
% subplot('Position',[0.4 0.06 0.25 0.25]);
% hold on;
% plot(dS_array, dLnK_dS_array_dCp_first(1,:),'black','linewidth',2);
% plot(dS_array, -dLnK_dS_array_dCp_first(2,:),'black','linewidth',2);
% plot(dS_array, dLnK_dS_array(:,1),'color',[0.47 0.47 0.47],'linewidth',2);
% plot(dS_array, -dLnK_dS_array(:,2),'color',[0.47 0.47 0.47],'linewidth',2);
% for j= 1:2
%     for i= 21:40:101
%         if i<34
%             plot(dS_array(i), abs(dLnK_dS_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[184/255 134/255 11/255], ...
%                 'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerSize',10);
%         elseif i<66
%             plot(dS_array(i), abs(dLnK_dS_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[1 165/255 0], ...
%                 'MarkerEdgeColor',[1 165/255 0],'MarkerSize',10);
%         else
%             plot(dS_array(i), abs(dLnK_dS_array_dCp_first(j,i)),'Marker','^','linestyle','none','MarkerFaceColor',[189/255 183/255 107/255], ...
%                 'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerSize',10);
%         end
%     end
% end
% %plot(dS_array, y, 'Color','black',);
% xlabel("\Delta S_o^o [cal/molK]");
% ylim([0 1]);
% box off;
% hold off;

lnK_CpT_dS_array= zeros(101,501);
K_CpT_dS_array= zeros(101,501);
Po_CpT_dS_array= zeros(101, 501);
for i= 1:101
    [lnK_CpT_dS_array(i,:), K_CpT_dS_array(i,:), Po_CpT_dS_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC/T0, dC_con,1);
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.4 0.7 0.25 0.27]);
hold on;
title("B. Change in \DeltaS_o^o effects");
for i= 21:40:101
    if i<34
        plot(T-T0, Po_CpT_dS_array(i,:),'Color',[184/255 134/255 11/255],'linewidth',2, 'LineStyle','--');
        plot(T-T0, Po_dS_array(i,:),'linewidth',1.25,'Color',[184/255 134/255 11/255]);
    elseif i<66
        plot(T-T0, Po_CpT_dS_array(i,:),'Color',[1 165/255 0],'linewidth',2, 'LineStyle','--');
        plot(T-T0, Po_dS_array(i,:),'linewidth',1.25,'Color',[1 165/255 0]);
    else
        plot(T-T0, Po_CpT_dS_array(i,:),'Color',[189/255 183/255 107/255],'linewidth',2, 'LineStyle','--');
        plot(T-T0, Po_dS_array(i,:),'linewidth',1.25,'Color',[189/255 183/255 107/255]);
    end
end
plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature (T-T_o) [K]");
B_title=title("B. Change in \DeltaS_o^o effects");
B_title.Position(2)= 0.97;
xlim([-66 66]);
box off;
hold off;

% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:100
%     if i<25
%         plot(T-T0, lnK_CpT_dS_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dS_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dS_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, lnK_CpT_dS_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% plot(T-T0,y, 'Color','black',);
% ylim([-2 2]);
% title("Ln(K_e_q) v. T over many \DeltaS_o^o after T_o subtraction (C_p T dependence)");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;

%Change in dCp over Po and T50
dC_array=[0:50:5000];
dC_array_slope=dC_array./T0;
dC_array_kb= dC_array_slope./(4.186798*6.022*10^23)./1.380649*10^23;
T50_dC_array_dCp_first=zeros(2,101);

T50_dC_array_dCp_first(1,:)= -T0.*(dS./dC_array -1) + sqrt((T0.*(dS./dC_array -1)).^2 -T0.^2);
T50_dC_array_dCp_first(2,:)= -T0.*(dS./dC_array -1) - sqrt((T0.*(dS./dC_array -1)).^2 -T0.^2);
T50_dC_array(1,:)= -T0./ lambertw( 0, -exp( -1+ dS./dC_array));
T50_dC_array(2,:)= -T0./ lambertw( -1, -exp( -1+ dS./dC_array));

y= zeros(101,1);
subplot('Position',[0.7 0.36 0.25 0.27]);
hold on;
plot(dC_array./1000, T50_dC_array_dCp_first(1,:)-T0,'black','linewidth',2, 'LineStyle','--');
plot(dC_array./1000, -(T50_dC_array_dCp_first(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dC_array./1000, T50_dC_array(1,:)-T0,'black','linewidth',1.5);
plot(dC_array./1000, -(T50_dC_array(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',1.5);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
ylim([0 100]);
xticklabels({});
box off;
hold off;
%plot(T0_array, y, 'Color','black',);

axes('Position',[0.82 0.475 0.125 0.126]);
hold on;
plot(dC_array./1000, T50_dC_array_dCp_first(1,:)-T0,'black','linewidth',2, 'LineStyle','--');
plot(dC_array./1000, -(T50_dC_array_dCp_first(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dC_array./1000, T50_dC_array(1,:)-T0,'black','linewidth',1.75);
plot(dC_array./1000, -(T50_dC_array(2,:)-T0),'color',[0.47 0.47 0.47],'linewidth',1.75);
for j= 1:2
    for i= 21:40:101
        if i<34
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dC_array(i)./1000, abs(T50_dC_array_dCp_first(j,i)-T0),'Marker','^','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        end
    end
end
ylim([20 27]);
xlim([2 4]);
box off;
hold off;


dPo_dC_array= zeros(2,101);
dPo_dC_array_dC_first= zeros(2,101);

dPo_dC_array= dC_array.* exp((dC_array + dS - (dC_array .* T0./T50_dC_array) + dC_array .* log(T0./T50_dC_array))./R) .* ...
    (T50_dC_array-T0)...
    ./ ((exp(dS./R) + exp(dC_array./R .* (1 - T0./T50_dC_array + log(T0./T50_dC_array)))).^2 ...
    .* R .* T50_dC_array.^2);

dPo_dC_array_dC_first= (1/2).*dC_array.*exp(1).^((1/2).*R.^(-1).*(2.*dS+dC_array.*((-2)+T50_dC_array.*T0.^(-1)+ ...
  T50_dC_array.^(-1).*T0))).*(1+exp(1).^((1/2).*R.^(-1).*(2.*dS+dC_array.*((-2)+T50_dC_array.* ...
  T0.^(-1)+T50_dC_array.^(-1).*T0)))).^(-2).*R.^(-1).*T50_dC_array.^(-2).*T0.^(-1).*(T50_dC_array.^2+ ...
  (-1).*T0.^2);


y= zeros(101,1);
subplot('Position',[0.7 0.075 0.25 0.26]);
hold on;
plot(dC_array./1000, dPo_dC_array_dC_first(1,:),'Color','black','linewidth',2, 'LineStyle','--');
plot(dC_array./1000, abs(dPo_dC_array_dC_first(2,:)),'Color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dC_array./1000, dPo_dC_array(1,:),'Color','black','linewidth',1.5);
plot(dC_array./1000, abs(dPo_dC_array(2,:)),'Color',[0.47 0.47 0.47],'linewidth',1.5);
for j= 1:2
   for i= 21:40:101
       if i<34
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
       end
    end
end
%plot(dS_array, y, 'Color','black',);
C_xlabel=xlabel("\DeltaC_p [kcal/molK]");
C_xlabel.Units='normalized';
C_xlabel.Extent
C_xlabel.Position(2)=-0.125;
ylim([0 0.25]);
box off;
hold off;

axes('Position',[0.74 0.22 0.1 0.1]);
hold on;
plot(dC_array./1000, dPo_dC_array_dC_first(1,:),'Color','black','linewidth',2, 'LineStyle','--');
plot(dC_array./1000, abs(dPo_dC_array_dC_first(2,:)),'Color',[0.47 0.47 0.47],'linewidth',2, 'LineStyle','--');
plot(dC_array./1000, dPo_dC_array(1,:),'Color','black','linewidth',1.75);
plot(dC_array./1000, abs(dPo_dC_array(2,:)),'Color',[0.47 0.47 0.47],'linewidth',1.75);
for j= 1:2
   for i= 21:40:101
        if i<34
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 0 0.5], ...
                'MarkerEdgeColor',[0 0 0.5],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        elseif i<66
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
        else
            scatter(dC_array(i)./1000, abs(dPo_dC_array_dC_first(j,i)),'Marker','^','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'sizedata',100);
            scatter(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerEdgeAlpha',0.5,'MarkerfaceAlpha',0.5,'sizedata',100);
       end
    end
end
%plot(dS_array, y, 'Color','black',);
xlim([2 4]);
box off;
hold off;


% dLnK_dC_array_dCp_first=zeros(2,101);
% 
% dLnK_dC_array_dCp_first(1,:)= dC_array./(2.*T0.*R).*(1-T0.^2 ./(T50_dC_array_dCp_first(1,:).^2));
% dLnK_dC_array_dCp_first(2,:)= dC_array./(2.*T0.*R).*(1-T0.^2 ./(T50_dC_array_dCp_first(2,:).^2));
% dLnK_dC_array(1,:)= dC_array.*(1./T50_dC_array(1,:) - T0./(T50_dC_array(1,:) .* T50_dC_array(1,:)))./R;
% dLnK_dC_array(2,:)= dC_array.*(1./T50_dC_array(2,:) - T0./(T50_dC_array(2,:) .* T50_dC_array(2,:)))./R;
% 
% y= zeros(101,1);
% subplot('Position',[0.7 0.06 0.25 0.25]);
% hold on;
% plot(dC_array./1000, dLnK_dC_array_dCp_first(1,:),'black','linewidth',2);
% plot(dC_array./1000, -dLnK_dC_array_dCp_first(2,:),'black','linewidth',2);
% plot(dC_array./1000, dLnK_dC_array(1,:),'color',[0.47 0.47 0.47],'linewidth',2);
% plot(dC_array./1000, -dLnK_dC_array(2,:),'color',[0.47 0.47 0.47],'linewidth',2,);
% for j= 1:2
%     for i= 21:40:101
%         if i<34
%             plot(dC_array(i)./1000, abs(dLnK_dC_array_dCp_first(j,i)),'Marker','s','linestyle','none','MarkerFaceColor',[0 0 .5], ...
%                 'MarkerEdgeColor',[0 0 .5],'MarkerSize',10);
%         elseif i<66
%             plot(dC_array(i)./1000, abs(dLnK_dC_array_dCp_first(j,i)),'Marker','s','linestyle','none','MarkerFaceColor',[0 0 1], ...
%                 'MarkerEdgeColor',[0 0 1],'MarkerSize',10);
%         else
%             plot(dC_array(i)./1000, abs(dLnK_dC_array_dCp_first(j,i)),'Marker','s','linestyle','none','MarkerFaceColor',[0 1 1], ...
%                 'MarkerEdgeColor',[0 1 1],'MarkerSize',10);
%         end
%     end
% end
% %plot(dC_array, y, 'Color','black',);
% xlabel("\DeltaC_p at T_o [kcal/molK]");
% ylim([0 1]);
% % legend("Positive","Negative");
% box off;
% hold off;


lnK_CpT_dC_array= zeros(101,501);
K_CpT_dC_array= zeros(101,501);
Po_CpT_dC_array= zeros(101, 501);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array(i)./T0,dC_con,1);
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.7 0.7 0.25 0.27]);
C_title=title("C. Change \DeltaC_p effects");
C_title.Position(2)= 0.97;
hold on;
for i= 21:40:101
    if i<34
        semilogy(T-T0, Po_CpT_dC_array(i,:),'linewidth',2,'Color',[0 0 0.5], 'LineStyle','--');
        semilogy(T-T0, Po_dC_array(i,:),'linewidth',1.25,'Color',[0 0 0.5]);
    elseif i<66
        semilogy(T-T0, Po_CpT_dC_array(i,:),'linewidth',2,'Color',[0 0 1], 'LineStyle','--');
        semilogy(T-T0, Po_dC_array(i,:),'linewidth',1.25,'Color',[0 0 1]);
    else
        semilogy(T-T0, Po_CpT_dC_array(i,:),'linewidth',2,'Color',[0 1 1], 'LineStyle','--');
        semilogy(T-T0, Po_dC_array(i,:),'linewidth',1.25,'Color',[0 1 1]);
    end
end
semilogy(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature (T-T_o) [K]");
xlim([-66 66]);
hold off;

% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:100
%     if i<25
%         plot(T-T0, lnK_dC_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, lnK_dC_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, lnK_dC_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, lnK_dC_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% plot(T-T0,y, 'Color','black',);
% ylim([-2 2]);
% title("Ln(K_e_q) v. T over many \DeltaC_p after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;



% %%
% %dCp T-independent
% dC_slope=12;
% 
% dC_array_Constant=[-10000:200:10000];
% 
% lnK_CpT_dC_con_array= zeros(101,501);
% K_CpT_dC_con_array= zeros(101,501);
% Po_CpT_dC_con_array= zeros(101, 501);
% for i= 1:101
%     [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
% end
% 
% figure();
% subplot(1,3,1);
% y=zeros(501,1);
% y= y+0.5;
% hold on;
% for i= 1:5:100
%     if i<25
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1],);
%     elseif i<50
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100],);
%     elseif i<75
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0],);
%     else
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0],);
%     end
% end
% plot(T-T0,y, 'Color','black',);
% title("Po v. T over many \DeltaC_p(constant) after T_o subtraction (C_p T dependence)");
% xlabel("T - T_o (K)");
% xlim([-100 100]);
% ylabel("Open Probability [1-0]");
% hold off;
% 
% subplot(1,3,2);
% y=zeros(501,1);
% y= y+0.5;
% hold on;
% for i= 1:5:100
%     if i<25
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1],);
%     elseif i<50
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100],);
%     elseif i<75
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0],);
%     else
%         plot(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%         plot(T-T0, Po_dC_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0],);
%     end
% end
% plot(T-T0,y, 'Color','black',);
% title("Po v. T over many \DeltaC_p(constant) after T_o subtraction (C_p T dependence)");
% xlabel("T - T_o (K)");
% ylabel("Open Probability [1-0]");
% hold off;


%% Tstatb and Po at Tstatb

run ice_map.m
run fire_map.m

T=[-100:500];
T0=200;
dC_constant= 1600;
dC_slope= 8;
dC_array_constant= [-2000,-1600,-1200,-756];
dC_array_slope= [-16.5,-12,-8,-6];

dS=-11;

[lnKT0, KT0, PoT0]= C_M_linearCpT(T0, T0, dS, 1,1,0);

Tstatb_constant=-(2.*dC_array_constant./dC_slope +T0);
Tstatb_slope=-(2.*dC_constant./dC_array_slope +T0);

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
    [lnK_CpT_dC_slope_array(i,:), K_CpT_dC_slope_array(i,:), Po_CpT_dC_slope_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array_slope(i),dC_constant,0);
    [lnK_Tstatb_dC_slope_array(i,:), K_Tstatb_dC_slope_array(i,:), Po_Tstatb_dC_slope_array(i,:)]= C_M_linearCpT(Tstatb_slope(i), T0, dS, dC_array_slope(i),dC_constant,0);
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope,dC_array_constant(i),0);
    [lnK_Tstatb_dC_con_array(i,:), K_Tstatb_dC_con_array(i,:), Po_Tstatb_dC_con_array(i,:)]= C_M_linearCpT(Tstatb_constant(i), T0, dS, dC_array_slope(i),dC_constant,0);
end

y=zeros(501,1);
y= y+0.5;
x= zeros(101,1);
t0y= [0:1/100:1];
figure('Units','inches','Position',[0 0 10 8.2]);
annotation('textbox',[0.001 0.775 0.1 0.1],'String','$\bf{T_{stat. \beta} \leq 0K}$','Interpreter','latex','EdgeColor','none','fontsize',13,'fontweight','bold');
annotation('textbox',[0.001 0.558 0.1 0.1],'String','$\bf{T_{stat. \beta} < T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);
annotation('textbox',[0.001 0.342 0.1 0.1],'String','$\bf{T_{stat. \beta} = T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);
annotation('textbox',[0.001 0.125 0.1 0.1],'String','$\bf{T_{stat. \beta} > T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);

annotation('textbox',[0.16 0.9 0.1 0.1],'String','Local Min.','EdgeColor','none','fontsize',14,'fontweight','bold');
annotation('textbox',[0.34 0.9 0.1 0.1],'String','Falling Inflection','EdgeColor','none','fontsize',14,'fontweight','bold');
annotation('textbox',[0.54 0.9 0.1 0.1],'String','Rising Inflection','EdgeColor','none','fontsize',14,'fontweight','bold');
annotation('textbox',[0.775 0.9 0.1 0.1],'String','Local Max.','EdgeColor','none','fontsize',14,'fontweight','bold');

annotation('line',[0.05 0.95],[0.3 0.3],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.515 0.515],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.73 0.73],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.95 0.95],'color',[0.5 0.5 0.5]);
annotation('line',[0.115 0.115],[0.05 0.975],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.05 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.225 0.4],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.975 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.52 0.52],[0.05 0.975],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.05 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.225 0.4],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.45 0.625],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.675 0.85],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.9 0.975],'color',[0.5 0.5 0.5]);

annotation('textbox',[0.175 0.8 0.1 0.1],'String','No Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.615 0.8 0.1 0.1],'String','Dual Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.165 0.575 0.1 0.1],'String','Cold Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.605 0.575 0.1 0.1],'String','Triple Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.225 0.35 0.1 0.1],'String','Cold Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.627 0.35 0.1 0.1],'String','Hot Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.27 0.125 0.1 0.1],'String','Hot Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.605 0.125 0.1 0.1],'String','Triple Sensitivity','EdgeColor','none','fontsize',14);


subplot(4,4,1);
semilogy(T,Po_CpT_dC_slope_array(1,:),'linewidth',2,'color','k');
yticks({});
xticks({});
hold on;
semilogy([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
semilogy(Tstatb_slope(1,1), 10^-40,'marker','d','markerfacecolor','k','markeredgecolor','k');
semilogy(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([-100 401]);
set(gca,'color','none');
axis off;
subplot(4,4,4);
semilogy(T, Po_CpT_dC_con_array(4,:),'linewidth',2,'color','k');
hold on;
yticks({});
xticks({});
plot([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
plot(Tstatb_constant(1,4), 10^-40,'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([-100 401]);
set(gca,'color','none');
axis off;

subplot(4,4,5);
semilogy(T, Po_CpT_dC_slope_array(2,:),'linewidth',2,'color','b');
hold on;
yticks({});
xticks({});
%plot(x,t0y,'linestyle','--','linewidth',1.5,'color','red');
semilogy(Tstatb_slope(1,2), Po_Tstatb_dC_slope_array(2,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
semilogy(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,8);
semilogy(T, Po_CpT_dC_con_array(3,:),'linewidth',2,'Color',fire(190, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,3), Po_Tstatb_dC_con_array(3,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,10);
semilogy(T, Po_CpT_dC_slope_array(3,:),'linewidth',2,'color','b');
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,3), Po_Tstatb_dC_slope_array(3,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k','markersize',10);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,11);
semilogy(T, Po_CpT_dC_con_array(2,:),'linewidth',2,'color','r');
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,2), Po_Tstatb_dC_con_array(2,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k','markersize',10);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,13);
semilogy(T, Po_CpT_dC_con_array(1,:),'linewidth',2,'color','r');
hold on;
yticks({});
xticks({});
semilogy(Tstatb_constant(1,1), Po_CpT_dC_con_array(1,Tstatb_constant(1,1)+100),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,16);
semilogy(T, Po_CpT_dC_slope_array(4,:),'linewidth',2,'Color',ice(190, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,4), Po_Tstatb_dC_slope_array(4,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

%legend({num2str(dC_array(1))+units,num2str(dC_array(26))+units,num2str(dC_array(51))+units,num2str(dC_array(76))+units,num2str(dC_array(101))+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
%xlabel("Temperature (T) [K]");

%% Tstatb and Po at Tstatb - linear plots
%CHANGE PARAMETERS INTO BIOLOGICALLY RELEVANT RANGES

run ice_map.m
run fire_map.m

T=[-100:500];
T0=250;
dC_constant= 2000;
dC_slope= 8;
dC_array_constant= [-2200,-2000,-1600,-800];
dC_array_slope= [-17,-9,-8,-6];

dS=-7;

[lnKT0, KT0, PoT0]= C_M_linearCpT(T0, T0, dS, 1,1,0);

Tstatb_constant=-(2.*dC_array_constant./dC_slope +T0);
Tstatb_slope=-(2.*dC_constant./dC_array_slope +T0);

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
    [lnK_CpT_dC_slope_array(i,:), K_CpT_dC_slope_array(i,:), Po_CpT_dC_slope_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array_slope(i),dC_constant,0);
    [lnK_Tstatb_dC_slope_array(i,:), K_Tstatb_dC_slope_array(i,:), Po_Tstatb_dC_slope_array(i,:)]= C_M_linearCpT(Tstatb_slope(i), T0, dS, dC_array_slope(i),dC_constant,0);
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope,dC_array_constant(i),0);
    [lnK_Tstatb_dC_con_array(i,:), K_Tstatb_dC_con_array(i,:), Po_Tstatb_dC_con_array(i,:)]= C_M_linearCpT(Tstatb_constant(i), T0, dS, dC_array_slope(i),dC_constant,0);
end

y=zeros(501,1);
y= y+0.5;
x= zeros(101,1);
t0y= [0:1/100:1];
figure('Units','inches','Position',[0 0 10 8.2]);

annotation('textbox',[0.001 0.87 0.1 0.1],'String','$\bf{T_{stat. \beta} \downarrow}$','Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold');
%annotation('textbox',[0.001 0.9 0.1 0.1],'String','$\bf{P_o(T_{o}) \rightarrow}$','Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold');
annotation('textbox',[0.001 0.9 0.1 0.1],'String','$\bf{sgn(P^\prime_X(T_o))\rightarrow}$','Interpreter','latex','EdgeColor','none','fontsize',11,'fontweight','bold');

annotation('textbox',[0.001 0.775 0.1 0.1],'String',{'$\bf{T_{stat. \beta}}$','$\bf{not \; possible}$'},'Interpreter','latex','EdgeColor','none','fontsize',13,'fontweight','bold');
annotation('textbox',[0.001 0.558 0.1 0.1],'String','$\bf{T_{stat. \beta} < T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);
annotation('textbox',[0.001 0.342 0.1 0.1],'String','$\bf{T_{stat. \beta} = T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);
annotation('textbox',[0.001 0.125 0.1 0.1],'String','$\bf{T_{stat. \beta} > T_o}$','Interpreter','latex','EdgeColor','none','fontsize',13);

annotation('textbox',[0.19 0.9 0.1 0.1],'String','$\bf{(-)}$','Interpreter','latex','EdgeColor','none','fontsize',14,'fontweight','bold');
annotation('textbox',[0.375 0.9 0.1 0.1],'String',{'$\bf{0}$','$\bf{sgn(P^{\prime\prime}_X(T_o))=(-)}$'},'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
    'HorizontalAlignment','center');
annotation('textbox',[0.575 0.9 0.1 0.1],'String',{'$\bf{0}$','$\bf{sgn(P^{\prime\prime}_X(T_o))=(+)}$'},'Interpreter','latex','EdgeColor','none','fontsize',12,'fontweight','bold',...
    'HorizontalAlignment','center');
annotation('textbox',[0.805 0.9 0.1 0.1],'String','$\bf{(+)}$','Interpreter','latex','EdgeColor','none','fontsize',14,'fontweight','bold');

annotation('line',[0.05 0.95],[0.3 0.3],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.515 0.515],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.73 0.73],'color',[0.5 0.5 0.5]);
annotation('line',[0.05 0.95],[0.935 0.935],'color',[0.5 0.5 0.5]);
annotation('line',[0.125 0.125],[0.05 0.975],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.05 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.225 0.4],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.625 0.45],'color',[0.5 0.5 0.5]);
annotation('line',[0.32 0.32],[0.975 0.675],'color',[0.5 0.5 0.5]);
annotation('line',[0.52 0.52],[0.05 0.975],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.05 0.175],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.225 0.4],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.45 0.625],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.675 0.85],'color',[0.5 0.5 0.5]);
annotation('line',[0.73 0.73],[0.9 0.975],'color',[0.5 0.5 0.5]);

annotation('textbox',[0.175 0.8 0.1 0.1],'String','No Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.615 0.8 0.1 0.1],'String','Dual Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.175 0.575 0.1 0.1],'String','Observerable Cold Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.605 0.575 0.1 0.1],'String','Triple Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.225 0.35 0.1 0.1],'String','Cold Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.6725 0.35 0.1 0.1],'String','Hot Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.25 0.125 0.1 0.1],'String','Observerable Hot Sensitivity','EdgeColor','none','fontsize',14);
annotation('textbox',[0.605 0.125 0.1 0.1],'String','Triple Sensitivity','EdgeColor','none','fontsize',14);


subplot(4,4,1);
plot(T,Po_CpT_dC_slope_array(1,:),'linewidth',2,'color','k');
yticks({});
xticks({});
hold on;
%plot([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
plot(Tstatb_slope(1,1), 10^-40,'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,4);
plot(T, Po_CpT_dC_con_array(4,:),'linewidth',2,'color','k');
hold on;
yticks({});
xticks({});
%plot([0 0],[10^-40 1],'linestyle','--','linewidth',2.5,'color','k');
plot(Tstatb_constant(1,4), 10^-40,'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,5);
plot(T, Po_CpT_dC_slope_array(2,:),'linewidth',2,'color','b');
hold on;
yticks({});
xticks({});
%plot(x,t0y,'linestyle','--','linewidth',1.5,'color','red');
plot(Tstatb_slope(1,2), Po_Tstatb_dC_slope_array(2,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,8);
plot(T, Po_CpT_dC_con_array(3,:),'linewidth',2,'Color',fire(190, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,3), Po_Tstatb_dC_con_array(3,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,10);
plot(T, Po_CpT_dC_slope_array(3,:),'linewidth',2,'color','b');
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,3), Po_Tstatb_dC_slope_array(3,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k','markersize',10);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,11);
plot(T, Po_CpT_dC_con_array(2,:),'linewidth',2,'color','r');
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,2), Po_Tstatb_dC_con_array(2,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k','markersize',10);
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

subplot(4,4,13);
plot(T, Po_CpT_dC_con_array(1,:),'linewidth',2,'color','r');
hold on;
yticks({});
xticks({});
plot(Tstatb_constant(1,1), Po_CpT_dC_con_array(1,Tstatb_constant(1,1)+100),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;
subplot(4,4,16);
plot(T, Po_CpT_dC_slope_array(4,:),'linewidth',2,'Color',ice(190, :));
hold on;
yticks({});
xticks({});
plot(Tstatb_slope(1,4), Po_Tstatb_dC_slope_array(4,1),'marker','d','markerfacecolor','k','markeredgecolor','k');
plot(T0, PoT0, 'marker','o','markeredgecolor','k');
ylim([10^-40 1]);
xlim([0 501]);
set(gca,'color','none');
axis off;

%legend({num2str(dC_array(1))+units,num2str(dC_array(26))+units,num2str(dC_array(51))+units,num2str(dC_array(76))+units,num2str(dC_array(101))+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
%xlabel("Temperature (T) [K]");

%% dCp Description and MultiWing Visulatization
R=1.987; %cal/molK;
T=[0:600];

T0= 300; %K
dC_con= 6000;
dC_slope= 20; %cal/molK
dC_array_Constant=[-6000:30:-3000];
dC_slope_array= [-20:0.04:-16];

dC_slope_total_array= zeros(4,601);
dC_con_total_array= zeros(4,601);

for i=1:4
    dC_slope_total_array(i,:)= dC_con+dC_slope_array(i*33-32).*T;
    dC_con_total_array(i,:)= dC_array_Constant(i*33-32)+dC_slope*T;
end

dC_max= max(max(max(dC_slope_total_array)),max(max(dC_con_total_array)));
dC_min= min(min(min(dC_slope_total_array)),min(min(dC_con_total_array)));
x=zeros(1,2);
y=[dC_min dC_max];

figure('units','inches','position',[0 0 10 10],'DefaultAxesFontSize',16);
position3= [0.15 0.76 0.8 0.2];
position4= [0.15 0.28 0.8 0.2];
fig1=subplot('Position', position3);
fig2=subplot('Position', position4);

run ice_map.m
run fire_map.m

for i=1:4
    subplot(fig1);
    hold on;
    colormap(ice);
    plot(T, dC_slope_total_array(i,:)./1000,'color',ice(i*40+48,:),'linewidth',2);
    subplot(fig2);
    hold on;
    plot(T, dC_con_total_array(i,:)./1000,'color',fire(i*40+48,:),'linewidth',2);
end

subplot(fig1);
plot([T0 T0], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([0 300+T0]);
xticklabels({});
title("A. \DeltaC_p(T) and P_o v. T over many B values");
units= " $\frac{cal}{mol \cdot K^2}$";
% legend({num2str(dC_slope_array(1))+units,num2str(dC_slope_array(34)),num2str(dC_slope_array(67)),num2str(dC_slope_array(101))},...
%     'Interpreter','latex','Fontsize',16,'Location','best');


subplot(fig2);
plot([T0 T0], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([0 300+T0]);
title("B. \DeltaC_p(T) and Po v. T over many A values");
units= " $\frac{cal}{mol \cdot K}$";
xticklabels({});
% legend({num2str(dC_array_Constant(1))+units,num2str(dC_array_Constant(34)),num2str(dC_array_Constant(67)),...
%     num2str(dC_array_Constant(101))},...
%     'Interpreter','latex','Fontsize',16,'Location','best');



dC_array= dC_slope_array;
dS= 0; %cal/molK
lnK_CpT_dC_array= zeros(101,601);
K_CpT_dC_array= zeros(101,601);
Po_CpT_dC_array= zeros(101,601);
CpT_dCSlope_Contribution= zeros(101,601);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array(i),dC_con,0);
    CpT_dCSlope_Contribution(i,:)= ((dC_array(i)).*(T0^2./(2.*T) + T./2 - T0))./R +dS/R;
end

y=zeros(601,1);
y= y+0.5;
x= zeros(6201,1);
t0y= [0:1/6200:1];
position2= [0.15 0.55 0.8 0.2];
subplot('Position', position2);
hold on;
for i= 1:4
    plot(T, Po_CpT_dC_array((i-1)*33+1,:),'linewidth',2,'Color',ice(i*40+48,:));
end
plot(T,y, 'Color','black', 'LineStyle','--');
plot([T0 T0],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{cal}{mol \cdot K^2}$";
%legend({num2str(dC_array(1))+units,num2str(dC_array(26))+units,num2str(dC_array(51))+units,num2str(dC_array(76))+units,num2str(dC_array(101))+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
xlim([0 T0+300]);
xticklabels({});
ylim([-0.005 1]);
ylabel("P_o");
%xlabel("Temperature (T) [K]");
hold off;

CpT_dCInter_Contribution= (dC_con.*(T0./T + log(T./T0)-1))./R;

% 
% position4= [0.52 0.05 0.45 0.4];
% subplot('Position', position4);
% hold on;
% lowest=ones(501,1)*dS/R;
% for i= 1:25:101
%     if i<25
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.2 0 0.2]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.4 0 0.4]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.6 0 0.6]);
%     elseif i<101
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.8 0 0.8]);
%     else
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[1 0 1]);
%     end
% end
% plot(T-T0,lowest, 'Color','black',);
% title("ln(K_{eq}) v. T over many \DeltaC_p slope after T_o subtraction");
% text(-200, dS/R+1, "$\frac{\Delta S^o_o}{R} \downarrow$", 'Interpreter', 'latex','FontSize',16);
% xlim([-202 202]);
% ylim([-15 5]);
% xlabel("Temperature (T-T_o) [K]");
% hold off;
% 
% dC_at_T_array=zeros(501,101);
% for i=1:101
%     dC_at_T_array(:,i)=dC_con+dC_array(i).*T;
% end
% subplot(3,2,6);
% hold on;
% for i= 1:20:100
%     if i<25
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% y=zeros(501,1);
% ylim([-1000 1000]);
% plot(T-T0,y, 'Color','black',);
% ylabel("\Delta C_p cal/molK");
% xlabel("T - T_o (K)");
% hold off;


lnK_CpT_dC_con_array= zeros(101,601);
K_CpT_dC_con_array= zeros(101,601);
Po_CpT_dC_con_array= zeros(101,601);
CpT_dCInter_Contribution1= zeros(101,601);
for i= 1:101
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
    CpT_dCInter_Contribution1(i,:)= (dC_array_Constant(i).*(T0./T + log(T./T0)-1))./R;
end

position1= [0.15 0.07 0.8 0.2];
subplot('Position', position1);
y=zeros(601,1);
y= y+0.5;
hold on;
for i= 1:4
    plot(T, Po_CpT_dC_con_array((i-1)*33+1,:),'linewidth',2,'Color',fire(i*40+48,:));
end
plot(T,y, 'Color','black', 'LineStyle','--');
plot([T0 T0],[0 1],'color','k','linestyle',':','linewidth',1.5);
ylabel("P_o");
units= " $\frac{kcal}{mol \cdot K}$";
%legend({num2str(dC_array_Constant(1)/1000)+units,num2str(dC_array_Constant(26)/1000)+units,num2str(dC_array_Constant(51)/1000)+units,...
%    num2str(dC_array_Constant(76)/1000)+units,num2str(dC_array_Constant(101)/1000)+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
xlim([0 T0+300]);
ylim([-0.005 1]);
xlabel("Temperature (T) [K]");
hold off;

CpT_dCSlope_Contribution1= ones(501,1).*((dC_slope).*(T0^2./(2.*T) + T./2 - T0))./R;

% position3= [0.035 0.05 0.45 0.4];
% subplot('Position', position3);
% hold on;
% for i= 1:25:101
%     if i<25
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0 0.4]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0 0.8]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0.2 1]);
%     elseif i<101
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0.6 1]);
%     else
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 1 1]);
%     end
% end
% plot(T-T0,lowest, 'Color','black',);
% title("ln(K_{eq}) v. T over many \DeltaC_p T intercept after T_o subtraction");
% ylim([-15 5]);
% xlim([-298 202]);
% text(160, dS/R+1, "$\frac{\Delta S^o_o}{R} \downarrow$", 'Interpreter', 'latex','FontSize',16);
% xlabel("Temperature (T-T_o) [K]");
% ylabel("ln(K_{eq}) [Arbit. Units]");
% hold off;
% 
% % 
% subplot(3,2,5);
% hold on;
% for i= 1:20:100
%     plot(T-T0, CpT_dCSlope_Contribution1,'color','black');
%     if i<25
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[1-4*i/100 0 1]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% y=zeros(501,1);
% ylim([-15 15]);
% plot(T-T0,y, 'Color','black',);
% ylabel("\Delta C_p cal/molK");
% xlabel("T - T_o (K)");
% hold off;

%% dCp conference visualization

T=[0:500];
T0= 3000/15; %K
dC_con=1600;
dC_slope= 8; %cal/molK
dC_array_Constant=[-1600:8:-800];
dC_slope_array= [-8:0.025:-5.5];

dC_slope_total_array= zeros(4,501);
dC_con_total_array= zeros(4,501);

for i=1:4
    dC_slope_total_array(i,:)= dC_con+dC_slope_array(i*33-32).*T;
    dC_con_total_array(i,:)= dC_array_Constant(i*33-32)+dC_slope*T;
end

dC_max= max(max(max(dC_slope_total_array)),max(max(dC_con_total_array)));
dC_min= min(min(min(dC_slope_total_array)),min(min(dC_con_total_array)));
x=zeros(1,2);
y=[dC_min dC_max];

figure('units','normalized','outerposition',[0 0 1 1]);
position3= [0.52 0.55 0.45 0.4];
position4= [0.035 0.55 0.45 0.4];
fig1=subplot('Position', position3);
fig2=subplot('Position', position4);

run ice_map.m
run fire_map.m

subplot(fig1);
hold on;
colormap(ice);
plot(T, dC_slope_total_array(1,:)./1000,'color',ice(1*40+48,:),'linewidth',2);
plot(T, dC_slope_total_array(2,:)./1000,'color',ice(2*40+48,:),'linewidth',2);
plot(T, dC_slope_total_array(3,:)./1000,'color',ice(3*40+48,:),'linewidth',2);
plot(T, dC_slope_total_array(4,:)./1000,'color',ice(4*40+48,:),'linewidth',2);
subplot(fig2);
hold on;
plot(T, dC_con_total_array(1,:)./1000,'color',fire(1*40+48,:),'linewidth',2);
plot(T, dC_con_total_array(2,:)./1000,'color',fire(2*40+48,:),'linewidth',2);
plot(T, dC_con_total_array(3,:)./1000,'color',fire(3*40+48,:),'linewidth',2);
plot(T, dC_con_total_array(4,:)./1000,'color',fire(4*40+48,:),'linewidth',2);
% 
% for i=1:4
%     subplot(fig1);
%     hold on;
%     colormap(ice);
%     plot(T, dC_slope_total_array(i,:)./1000,'color',ice(i*40+48,:),'linewidth',2);
%     subplot(fig2);
%     hold on;
%     plot(T, dC_con_total_array(i,:)./1000,'color',fire(i*40+48,:),'linewidth',2);
% end

subplot(fig1);
ylim([dC_min./1000 dC_max./1000]);
xlim([0 300+T0]);
title("B. \DeltaC_p(T) and Po v. T over many B",'fontsize',20);
units= " $\frac{cal}{mol \cdot K^2}$";
legend({num2str(dC_slope_array(1))+units,num2str(dC_slope_array(34)),num2str(dC_slope_array(67)),num2str(dC_slope_array(101))},...
    'Interpreter','latex','Fontsize',20,'Location','best');


subplot(fig2);
ylabel("\DeltaC_p [kcal/molK]",'fontsize',14);
ylim([dC_min./1000 dC_max./1000]);
xlim([0 300+T0]);
title("A. \DeltaC_p(T) and Po v. T over many A",'fontsize',20);
units= " $\frac{cal}{mol \cdot K}$";
legend({num2str(dC_array_Constant(1))+units,num2str(dC_array_Constant(34)),num2str(dC_array_Constant(67)),...
    num2str(dC_array_Constant(101))},...
    'Interpreter','latex','Fontsize',20,'Location','best');



T=[0:500];
dC_array= dC_slope_array;
dS= 0; %cal/molK
T0= 3000/15; %K
dC_slope= 8; %cal/molK
lnK_CpT_dC_array= zeros(101,501);
K_CpT_dC_array= zeros(101,501);
Po_CpT_dC_array= zeros(101, 501);
CpT_dCSlope_Contribution= zeros(101,501);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_array(i),dC_con,0);
    CpT_dCSlope_Contribution(i,:)= ((dC_array(i)).*(T0^2./(2.*T) + T./2 - T0))./R +dS/R;
end

y=zeros(501,1);
y= y+0.5;
x= zeros(6201,1);
t0y= [0:1/6200:1];
position2= [0.52 0.1 0.45 0.4];
subplot('Position', position2);
hold on;
plot(T, Po_CpT_dC_array(1,:),'linewidth',2,'Color',ice(1*40+48,:));
plot(T, Po_CpT_dC_array(34,:),'linewidth',2,'Color',ice(2*40+48,:));
plot(T, Po_CpT_dC_array(67,:),'linewidth',2,'Color',ice(3*40+48,:));
plot(T, Po_CpT_dC_array(101,:),'linewidth',2,'Color',ice(4*40+48,:));
% for i= 1:4
%     plot(T, Po_CpT_dC_array(i*33-32,:),'linewidth',2,'Color',ice(i*40+48,:));
% end
units= " $\frac{cal}{mol \cdot K^2}$";
%legend({num2str(dC_array(1))+units,num2str(dC_array(26))+units,num2str(dC_array(51))+units,num2str(dC_array(76))+units,num2str(dC_array(101))+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
xlim([0 T0+300]);
ylim([-0.005 1]);
xlabel("Temperature (T) [K]",'fontsize',20);
hold off;

CpT_dCInter_Contribution= (dC_con.*(T0./T + log(T./T0)-1))./R;

% 
% position4= [0.52 0.05 0.45 0.4];
% subplot('Position', position4);
% hold on;
% lowest=ones(501,1)*dS/R;
% for i= 1:25:101
%     if i<25
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.2 0 0.2]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.4 0 0.4]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.6 0 0.6]);
%     elseif i<101
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.8 0 0.8]);
%     else
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[1 0 1]);
%     end
% end
% plot(T-T0,lowest, 'Color','black',);
% title("ln(K_{eq}) v. T over many \DeltaC_p slope after T_o subtraction");
% text(-200, dS/R+1, "$\frac{\Delta S^o_o}{R} \downarrow$", 'Interpreter', 'latex','FontSize',16);
% xlim([-202 202]);
% ylim([-15 5]);
% xlabel("Temperature (T-T_o) [K]");
% hold off;
% 
% dC_at_T_array=zeros(501,101);
% for i=1:101
%     dC_at_T_array(:,i)=dC_con+dC_array(i).*T;
% end
% subplot(3,2,6);
% hold on;
% for i= 1:20:100
%     if i<25
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% y=zeros(501,1);
% ylim([-1000 1000]);
% plot(T-T0,y, 'Color','black',);
% ylabel("\Delta C_p cal/molK");
% xlabel("T - T_o (K)");
% hold off;


dC_array_Constant=[-1600:8:-800];

lnK_CpT_dC_con_array= zeros(101,501);
K_CpT_dC_con_array= zeros(101,501);
Po_CpT_dC_con_array= zeros(101, 501);
CpT_dCInter_Contribution1= zeros(101, 501);
for i= 1:101
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
    CpT_dCInter_Contribution1(i,:)= (dC_array_Constant(i).*(T0./T + log(T./T0)-1))./R;
end

position1= [0.035 0.1 0.45 0.4];
subplot('Position', position1);
y=zeros(501,1);
y= y+0.5;
hold on;
plot(T, Po_CpT_dC_con_array(1,:),'linewidth',2,'Color',fire(1*40+48,:));
plot(T, Po_CpT_dC_con_array(34,:),'linewidth',2,'Color',fire(2*40+48,:));
plot(T, Po_CpT_dC_con_array(67,:),'linewidth',2,'Color',fire(3*40+48,:));
plot(T, Po_CpT_dC_con_array(101,:),'linewidth',2,'Color',fire(4*40+48,:));
% for i= 1:4
%     plot(T, Po_CpT_dC_con_array(i*33-32,:),'linewidth',2,'Color',fire(i*40+48,:));
% end
ylabel("P_o",'fontsize',16);
units= " $\frac{kcal}{mol \cdot K}$";
%legend({num2str(dC_array_Constant(1)/1000)+units,num2str(dC_array_Constant(26)/1000)+units,num2str(dC_array_Constant(51)/1000)+units,...
%    num2str(dC_array_Constant(76)/1000)+units,num2str(dC_array_Constant(101)/1000)+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
xlim([0 T0+300]);
ylim([-0.005 1]);
xlabel("Temperature (T) [K]",'fontsize',20);
hold off;

CpT_dCSlope_Contribution1= ones(501,1).*((dC_slope).*(T0^2./(2.*T) + T./2 - T0))./R;

%% dCp Description and sinlge Visulatization
T=[0:600];
T0= 300; %K
dC_con= 6000;
dC_slope= 20; %cal/molK
dC_array_Constant=[-9000:30:-6000];
dC_slope_array= [-28:0.08:-20];
Tc=[0 T0+20];
Th=[T0-20 1000];

dC_slope_total_array= zeros(5,2);
dC_con_total_array= zeros(5,2);

for i=1:5
    dC_slope_total_array(i,:)= dC_con+dC_slope_array((i-1)*25+1).*Tc;
    dC_con_total_array(i,:)= dC_array_Constant((i-1)*25+1)+dC_slope*Th;
end

dC_max= max(max(max(dC_slope_total_array)),max(max(dC_con_total_array)));
dC_min= min(min(min(dC_slope_total_array)),min(min(dC_con_total_array)));
x=zeros(1,2);
y=[dC_min dC_max];

figure('units','inches','Position',[0 0 15 7.78],'DefaultAxesFontSize',16);
position3= [0.575 0.55 0.4 0.4];
position4= [0.1 0.55 0.4 0.4];
fig1=subplot('Position', position4);
fig2=subplot('Position', position3);

run ice_map.m
ice=ice(88:(188-88)/5:188,:);
run fire_map.m
fire=fire(88:(188-88)/5:188,:);

for i=1:4
    subplot(fig1);
    hold on;
    colormap(ice);
    plot(Tc, dC_slope_total_array(i,:)./1000,'color',ice(i,:),'linewidth',2);
    subplot(fig2);
    hold on;
    plot(Th, dC_con_total_array(i,:)./1000,'color',fire(i,:),'linewidth',2);
end

subplot(fig1);
plot([T0 T0], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([min(min(dC_slope_total_array))./1000 max(max(dC_slope_total_array))./1000]);
xlim([0 320]);
title("A. \DeltaC_p(T) and P_o v. T over many B");
units= " $\frac{cal}{mol \cdot K^2}$";
% legend({num2str(dC_slope_array(1))+units,num2str(dC_slope_array(34)),num2str(dC_slope_array(67)),num2str(dC_slope_array(101))},...
%     'Interpreter','latex','Fontsize',16,'Location','SW');


subplot(fig2);
plot([T0 T0], y./1000, 'linestyle',':','color','black','linewidth',1.5);
ylabel("\DeltaC_p [kcal/molK]");
ylim([dC_min./1000 dC_max./1000]);
xlim([T0-20 1000]);
title("B. \DeltaC_p(T) and P_o v. T over many A");
units= " $\frac{cal}{mol \cdot K}$";
% legend({num2str(dC_array_Constant(1))+units,num2str(dC_array_Constant(34)),num2str(dC_array_Constant(67)),...
%     num2str(dC_array_Constant(101))},...
%     'Interpreter','latex','Fontsize',16,'Location','SE');



T=[1:(T0+20)/1000:T0+21];
dC_array= dC_slope_array;
dS= -11; %cal/molK
lnK_CpT_dC_array= zeros(101,1001);
K_CpT_dC_array= zeros(101,1001);
Po_CpT_dC_array= zeros(101, 1001);
CpT_dCSlope_Contribution= zeros(101,1001);
for i= 1:101
    [lnK_CpT_dC_array(i,:), K_CpT_dC_array(i,:), Po_CpT_dC_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope_array(i),dC_con,0);
    CpT_dCSlope_Contribution(i,:)= ((dC_slope_array(i)).*(T0^2./(2.*T) + T./2 - T0))./R +dS/R;
end

y=zeros(501,1);
y= y+0.5;
x= zeros(6201,1);
t0y= [0:1/6200:1];
position1= [0.1 0.1 0.4 0.4];
subplot('Position', position1);
hold on;
ylabel("P_o");
for i= 1:4
    plot(T, Po_CpT_dC_array((i-1)*33+1,:),'linewidth',2,'Color',ice(i,:));
end
plot([0 T0+20],[0.5 0.5], 'Color','black', 'LineStyle','--');
plot([T0 T0],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{cal}{mol \cdot K^2}$";
%legend({num2str(dC_array(1))+units,num2str(dC_array(26))+units,num2str(dC_array(51))+units,num2str(dC_array(76))+units,num2str(dC_array(101))+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
ylim([-0.005 1]);
xlim([0 320]);
xlabel("Temperature (T) [K]");
hold off;

CpT_dCInter_Contribution= (dC_con.*(T0./T + log(T./T0)-1))./R;

% 
% position4= [0.52 0.05 0.45 0.4];
% subplot('Position', position4);
% hold on;
% lowest=ones(501,1)*dS/R;
% for i= 1:25:101
%     if i<25
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.2 0 0.2]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.4 0 0.4]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.6 0 0.6]);
%     elseif i<101
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[0.8 0 0.8]);
%     else
%         plot(T-T0, lnK_CpT_dC_array(i,:),'linewidth',2,'Color',[1 0 1]);
%     end
% end
% plot(T-T0,lowest, 'Color','black',);
% title("ln(K_{eq}) v. T over many \DeltaC_p slope after T_o subtraction");
% text(-200, dS/R+1, "$\frac{\Delta S^o_o}{R} \downarrow$", 'Interpreter', 'latex','FontSize',16);
% xlim([-202 202]);
% ylim([-15 5]);
% xlabel("Temperature (T-T_o) [K]");
% hold off;
% 
% dC_at_T_array=zeros(501,101);
% for i=1:101
%     dC_at_T_array(:,i)=dC_con+dC_array(i).*T;
% end
% subplot(3,2,6);
% hold on;
% for i= 1:20:100
%     if i<25
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, dC_at_T_array(:,i),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% y=zeros(501,1);
% ylim([-1000 1000]);
% plot(T-T0,y, 'Color','black',);
% ylabel("\Delta C_p cal/molK");
% xlabel("T - T_o (K)");
% hold off;

T=[T0-20:(1000-T0+20)/500:1000];

lnK_CpT_dC_con_array= zeros(101,501);
K_CpT_dC_con_array= zeros(101,501);
Po_CpT_dC_con_array= zeros(101, 501);
CpT_dCInter_Contribution1= zeros(101, 501);
for i= 1:101
    [lnK_CpT_dC_con_array(i,:), K_CpT_dC_con_array(i,:), Po_CpT_dC_con_array(i,:)]= C_M_linearCpT(T, T0, dS, dC_slope, dC_array_Constant(i),0);
    CpT_dCInter_Contribution1(i,:)= (dC_array_Constant(i).*(T0./T + log(T./T0)-1))./R;
end

position2= [0.575 0.1 0.4 0.4];
subplot('Position', position2);
y=zeros(501,1);
y= y+0.5;
hold on
for i= 1:4
    plot(T, Po_CpT_dC_con_array((i-1)*33+1,:),'linewidth',2,'Color',fire(i,:));
end
plot(T,y, 'Color','black', 'LineStyle','--');
plot([T0 T0],[0 1],'color','k','linestyle',':','linewidth',1.5);
units= " $\frac{kcal}{mol \cdot K}$";
%legend({num2str(dC_array_Constant(1)/1000)+units,num2str(dC_array_Constant(26)/1000)+units,num2str(dC_array_Constant(51)/1000)+units,...
%    num2str(dC_array_Constant(76)/1000)+units,num2str(dC_array_Constant(101)/1000)+units},...
%    'Interpreter','latex','Fontsize',14,'Location','best');
ylim([-0.005 1]);
xlim([280 1000]);
xlabel("Temperature (T) [K]");
hold off;

CpT_dCSlope_Contribution1= ones(501,1).*((dC_slope).*(T0^2./(2.*T) + T./2 - T0))./R;

% position3= [0.035 0.05 0.45 0.4];
% subplot('Position', position3);
% hold on;
% for i= 1:25:101
%     if i<25
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0 0.4]);
%     elseif i<50
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0 0.8]);
%     elseif i<75
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0.2 1]);
%     elseif i<101
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 0.6 1]);
%     else
%         plot(T-T0, lnK_CpT_dC_con_array(i,:),'linewidth',2,'Color',[0 1 1]);
%     end
% end
% plot(T-T0,lowest, 'Color','black',);
% title("ln(K_{eq}) v. T over many \DeltaC_p T intercept after T_o subtraction");
% ylim([-15 5]);
% xlim([-298 202]);
% text(160, dS/R+1, "$\frac{\Delta S^o_o}{R} \downarrow$", 'Interpreter', 'latex','FontSize',16);
% xlabel("Temperature (T-T_o) [K]");
% ylabel("ln(K_{eq}) [Arbit. Units]");
% hold off;
% 
% % 
% subplot(3,2,5);
% hold on;
% for i= 1:20:100
%     plot(T-T0, CpT_dCSlope_Contribution1,'color','black');
%     if i<25
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[1-4*i/100 0 1]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[1-4*i/100 0 1]);
%     elseif i<50
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         plot(T-T0, -CpT_dCInter_Contribution1(i,:), 'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%         plot(T-T0, CpT_dCInter_Contribution1(i,:)+reshape(CpT_dCSlope_Contribution1, [1 501]), 'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% y=zeros(501,1);
% ylim([-15 15]);
% plot(T-T0,y, 'Color','black',);
% ylabel("\Delta C_p cal/molK");
% xlabel("T - T_o (K)");
% hold off;



%% DPo Visualization
%CHANGE UP PARAMETERS
run custommap_script.m

T=[0:500];
T0= 200; %K
dS=-11;
dC_con=1600;
dC_slope= 8; %cal/molK
dC_array_Constant=[-1600:8:-800];
dC_Slope_array= [-8:0.03:-5];

dC_con_array=[-3500:7:3500];
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
            WingNum_T(i,j)= -2;
        elseif ((dPo_0_T(i,j)<=0 || dPo_0_T(i,j)==Inf) && (j>=501))
            WingNum_T(i,j)= 2;
        elseif i<501 && T0>dPo_0_T(i,j)>0
            %triple wing heat sen
            WingNum_T(i,j)=0;
        elseif i<501 && dPo_0_T(i,j)>=T0
            %single wing heat
            WingNum_T(i,j)=1;
        elseif i>501 && dPo_0_T(i,j)>T0
            %tiple wing cold sen
            WingNum_T(i,j)=0;
        elseif i>501 && T0>=dPo_0_T(i,j)>0
            %single wing cold
            WingNum_T(i,j)=-1;
        end
            
    end
end

% for i=1:2001
%     for j=1:2001
%         T_dPo_0= -(2*dC_con_array(i)/dC_slope_array(j) +T0);
%         if T_dPo_0<= 0 || T_dPo_0==Inf || isnan(T_dPo_0)
%             dPo_0_T(i,j)= NaN;
%         else
%             dPo_0_T(i,j)= T_dPo_0;
%         end
%     end
% end

figure('Units','inches','Position',[0 0 15 10],'DefaultAxesFontSize',16);
%heatmap(dC_con_array,dC_slope_array,dPo_0_T,'GridVisible','off','colormap',jet);
imagesc(dC_slope_array,dC_con_array,WingNum_T, 'Alphadata', 0.33);
colormap(custommap);
set(gca,'YDir','normal');
xticks([-12:4:12]);
yticks([-3000 -2000 -1000 0 1000 2000 3000]);
yticklabels({'-3', '-2', '-1', '0', '1', '2', '3'});
%title("Effect of Slope and Intercept on Number of Wings");
xlabel("Slope (B) [cal/molK^2]");
ylabel("Intercept (A) [kcal/molK]");

n=0;

% axes('Position',[0.19 0.85 0.05 0.05]);
% plot(T-T0, Po_CpT_dC_con_array(1,:),'linewidth',1,'Color','k');
% set(gca,'color','none');
% axis off;

dC_con_temp_array=[-8:2:8];
dC_slope_temp_array=[-16:2:16];


dC_con_valid_line= -dC_slope_array*T0./2;
dC_con_1to3_line= -dC_slope_array*T0;
sizes= size(dC_slope_array);
dC_slope_3to2_line= zeros(sizes(2));
dC_con_zeros= zeros(sizes(2));
hold on;
plot(dC_slope_array, dC_con_valid_line,'color',[0.375 0.375 0.375],'linewidth',2);
% plot(dC_slope_array(1:20:200), dC_con_valid_line(1:20:200),'color',[0.375 0.375 0.375],'linewidth',1);
% plot(dC_slope_array(300:20:sizes(2)), dC_con_valid_line(300:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',1);
plot(dC_slope_array, dC_con_1to3_line,'color',[0.375 0.375 0.375],'linewidth',2);
% plot(dC_slope_array(1:20:75), dC_con_1to3_line(1:20:75),'color',[0.375 0.375 0.375],'linewidth',1);
% plot(dC_slope_array(120:20:sizes(2)), dC_con_1to3_line(120:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',1);
plot(dC_slope_3to2_line(1:20:sizes(2)), dC_con_array(1:20:sizes(2)),'color',[0.5 0.5 0.5],'linewidth',2);
plot(dC_slope_array(1:20:sizes(2)), dC_con_zeros(1:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',2,'linestyle','--');
plot(dC_con_zeros(1:20:sizes(2)), dC_con_array(1:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',2);
% for i=-12:4:12
%     for j=-3:3
%         if i*j<0 || i*j==16
%             plot(i,j,'linestyle','none','marker','*','markerfacecolor','k','markeredgecolor','k','markersize',3);
%         end
%     end
% end

%single wing visulatitions from previous graph
run ice_map.m
ice=ice(88:(188-88)/5:188,:);
run fire_map.m
fire=fire(88:(188-88)/5:188,:);

dC_con_single=[-3000:14:-1586];
dC_slope_single= [-15:0.07:-7.93];

for i=1:3
    plot([8], dC_con_single(33*i-32), 'marker','d', 'linestyle','none', 'markerfacecolor',fire(i,:),'markeredgecolor',[0.5 0.5 0.5],'markersize',11, 'linewidth', 1);
end
plot([8], dC_con_single(101), 'marker','d', 'linestyle','none','markerfacecolor',fire(i,:),  'markeredgecolor',[0.5 0.5 0.5],'markersize',11, 'linewidth', 1);

for i=1:3
    plot(dC_slope_single(33*i-32), [1600], 'marker','d', 'linestyle','none','markerfacecolor',ice(i,:), 'markeredgecolor',[0.5 0.5 0.5],'markersize',11, 'linewidth', 1);
end
plot(dC_slope_single(101), [1600], 'marker','d', 'linestyle','none','markerfacecolor',ice(i,:), 'markeredgecolor',[0.5 0.5 0.5],'markersize',11, 'linewidth', 1);

%plot([8 -8],[-1600 1600],'marker','o','markerfacecolor',[0.375 0.375 0.375],'markeredgecolor',[0.375 0.375 0.375],'color','none','markersize',9);

run fire_map.m
run ice_map.m

%multiwing visualizations from previous graph
for i=2:4
    plot([8], dC_array_Constant(33*i-32), 'marker','o', 'linestyle','none', 'markerfacecolor',fire(i*40+48,:),'markeredgecolor',[0.5 0.5 0.5],'markersize',9);
end
 plot([8], dC_array_Constant(1), 'marker','o', 'linestyle','none', 'markerfacecolor',fire(1*40+48,:),'markeredgecolor','none','markersize',7);

for i=2:4
    plot(dC_Slope_array(33*i-32), [1600], 'marker','o', 'linestyle','none', 'markerfacecolor',ice(i*40+48,:),'markeredgecolor',[0.5 0.5 0.5],'markersize',9);
end
 plot(dC_Slope_array(1), [1600], 'marker','o', 'linestyle','none', 'markerfacecolor',ice(1*40+48,:),'markeredgecolor','none','markersize',7);

hold off;

text(0.1, 2000, '\bf\Leftarrow\rmInter.-Only or \DeltaC_p constant','color', [0.25 0.25 0.25],'FontSize',14);
text(7, 110, '\bf\Downarrow\rmSlope-Only','color', [0.25 0.25 0.25],'horizontalalignment','center','FontSize',14);
text(dC_slope_array(200), dC_con_valid_line(300), "$A = -\frac{B}{2}(T_o)$",'Interpreter','latex',...
    'horizontalalignment','center','fontsize',18,'fontweight','bold','verticalalignment','middle');
text(dC_slope_array(200), dC_con_1to3_line(125), "$A = -B(T_o)$",'Interpreter','latex',...
    'horizontalalignment','center','fontsize',16,'fontweight','bold','verticalalignment','middle');

annotation('textbox',[0.825 0.85 0.05 0.05],'string','I','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.25 0.85 0.05 0.05],'string','IIa','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.825 0.25 0.05 0.05],'string','IVa','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.75 0.15 0.05 0.05],'string','IVb','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.15 0.7 0.05 0.05],'string','IIb','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);
annotation('textbox',[0.175 0.15 0.05 0.05],'string','III','edgecolor','none','horizontalalignment','center','Fontname','Cambria','fontsize',20,'color',[0.25 0.25 0.25]);

% annotation('textarrow',[0.375 0.375], [0.5 0.6],'string','Cold-Sensitive Single Wing Area','headwidth',5,'headlength',5);
% annotation('textarrow',[0.55 0.5], [0.83 0.78],'string','Cold-Sensitive Triple Wing Area','headwidth',5,'headlength',5);
% annotation('textarrow',[0.25 0.25], [0.4 0.35],'string','No P_o Curve Area','headwidth',5,'headlength',5);
% annotation('textarrow',[0.45 0.55], [0.175 0.25], 'string','Heat-Sensitive Single Wing Area','headwidth',5,'headlength',5);
% annotation('textarrow',[0.66 0.66], [0.49 0.425],'string','Heat-Sensitive Triple Wing Area','headwidth',5,'headlength',5);
% annotation('textarrow',[0.8 0.8], [0.65 0.7],'string','Double P_o Curve Area','headwidth',5,'headlength',5);
% 

%example traces
for n = 1:size(dC_slope_temp_array,2)
    for m = 1:size(dC_con_temp_array,2)
        dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
        if dC_slope_temp_array(n)==-12 && dC_con_temp_array(m)==2
            %single cold
            T=[0:dPo_T*1.5];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.25 0.65 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color','b');
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==-6 && dC_con_temp_array(m)==2
            %triple cold
            T=[0:2.75*dPo_T-T0];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.4 0.8 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',ice(190, :));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==6 && dC_con_temp_array(m)==-2
            %single heat
            T=[dPo_T:2.5*dPo_T-T0];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.6 0.25 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color','r');
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==14 && dC_con_temp_array(m)==-2
            %triple heat
            T=[0:T0*2];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            axes('Position',[0.78 0.27 0.075 0.075]);
            plot(T, temp_po,'linewidth',1.5,'Color',fire(190, :));
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==8 && dC_con_temp_array(m)==8
            axes('Position',[0.75 0.75 0.075 0.075]);
            dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
            T=[T0/2:T0*3/2];
            [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
            plot(T, temp_po,'linewidth',1.5,'Color','k');
            set(gca,'color','none');
            ylim([0 1]);
            axis off;
        elseif dC_slope_temp_array(n)==-8 && dC_con_temp_array(m)==-8
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
% %%
% figure();
% subplot(2,1,1);
% y=zeros(501,1);
% y= y+0.5;
% for i= 1:20:100
%     if i<25
%         semilogy(T-T0, Po_CpT_dC_array(i,:),'Color',[1-4*i/100 0 1]);
%         hold on;
%     elseif i<50
%         semilogy(T-T0, Po_CpT_dC_array(i,:),'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         semilogy(T-T0, Po_CpT_dC_array(i,:),'Color',[4*(i-50)/100 1 0]);
%     else
%         semilogy(T-T0, Po_CpT_dC_array(i,:),'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% %semilogy(T-T0,y, 'Color','black',);
% units= " $\frac{cal}{mol \cdot K^2}$";
% legend({num2str(dC_array(1))+units,num2str(dC_array(21))+units,num2str(dC_array(41))+units,num2str(dC_array(61))+units, num2str(dC_array(81))+units},'Interpreter','latex','Fontsize',14);
% title("Po v. T over many \DeltaC_p after T_o subtraction (C_p T-slope) at "+num2str(dC_con/1000)+"kcal/molK C_p Intercept");
% ylabel("Open Probability [1-0]");
% ylim([10^-10 1]);
% hold off;
% 
% subplot(2,1,2);
% for i= 1:20:100
%     if i<25
%         semilogy(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1-4*i/100 0 1]);
%         hold on;
%     elseif i<50
%         semilogy(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[0 4*(i-25)/100 1-4*(i-25)/100]);
%     elseif i<75
%         semilogy(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[4*(i-50)/100 1 0]);
%     else
%         semilogy(T-T0, Po_CpT_dC_con_array(i,:),'linewidth',1,'Color',[1 1-(4*(i-75))/100 0]);
%     end
% end
% %plot(T-T0,y, 'Color','black',);
% title("Po v. T over many \DeltaC_p after T_o subtraction (C_p T intercept) at "+num2str(dC_slope)+"cal/molK^2 C_p Slope");
% ylabel("Open Probability [1-0]");
% units= " $\frac{kcal}{mol \cdot K}$";
% legend({num2str(dC_array_Constant(1)/1000)+units,num2str(dC_array_Constant(21)/1000)+units,num2str(dC_array_Constant(41)/1000)+units,num2str(dC_array_Constant(61)/1000)+units, num2str(dC_array_Constant(81)/1000)+units},'Interpreter','latex','Fontsize',14);
% ylim([10^-10 1]);
% hold off;


%% del Seffect on full linear

run ice_map.m;
run fire_map.m;
%Change in T0 effects onfirst order
dS= -9; %cal/molK
T0= 300; %K
dC_con=-6000;
dC_slope=-20; %cal/molK
T=[0:500];

T0_array=[201:2:401];
dS_array=[-9:0.09:0];

%NOTE: dC to dC_slope when applicable

% lnK_T0_negcon_array= zeros(101,501);
% K_T0_negcon_array= zeros(101,501);
% Po_T0_CpT_negcon_array= zeros(101, 501);
% lnK_T0_poscon_array= zeros(101,501);
% K_T0_poscon_array= zeros(101,501);
% Po_T0_CpT_poscon_array= zeros(101, 501);
% for i= 1:101
%     [lnK_T0_negcon_array(i,:), K_T0_negcon_array(i,:), Po_T0_CpT_negcon_array(i,:)]= C_M_linearCpT(T, T0_array(i), dS, -dC_slope, dC_con ,0);
%     [lnK_T0_poscon_array(i,:), K_T0_poscon_array(i,:), Po_T0_CpT_poscon_array(i,:)]= C_M_linearCpT(T, T0_array(i), dS, dC_slope, -dC_con ,0);
% end
% 
% y=zeros(501,1);
% y= y+0.5;
% subplot(2,2,1);
% title("A. Change in T_o effects");
% hold on;
% for i= 1:25:101
%         plot(T-T0_array(i), Po_T0_CpT_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
% end
% plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
% plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
% xlabel("Temperature (T-T_o) [K]");
% xlim([-66 66]);
% ylabel("P_o");
% A_title=title("A. Change in T_o effects");
% A_title.Position(2)= 0.97;
% %legend({"Slope-Only", "Inter.-Only"},'Location','NW','Fontsize',14);
% box off;
% hold off;
% 
% subplot(2,2,3);
% hold on;
% for i= 1:25:101
%         plot(T-T0_array(i), Po_T0_CpT_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
% end
% plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
% plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
% xlabel("Temperature (T-T_o) [K]");
% xlim([-66 66]);
% ylabel("P_o");
% A_title.Position(2)= 0.97;
% %legend({"Slope-Only", "Inter.-Only"},'Location','NW','Fontsize',14);
% box off;
% hold off;



lnK_dS_negcon_array= zeros(101,501);
K_dS_negcon_array= zeros(101,501);
Po_dS_CpT_negcon_array= zeros(101, 501);
lnK_dS_poscon_array= zeros(101,501);
K_dS_poscon_array= zeros(101,501);
Po_dS_CpT_poscon_array= zeros(101, 501);
Po_dS_CpT_double_array= zeros(101,501);
Po_dS_CpT_none_array= zeros(101,501);
Po_dS_CpT_single_negcon_array= zeros(101,501);
Po_dS_CpT_single_poscon_array= zeros(101,501);
Po_dS_CpT_triple_negcon_array= zeros(101,501);
Po_dS_CpT_triple_poscon_array= zeros(101,501);
for i= 1:101
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope, dC_con ,0);
    [lnK_dS_poscon_array(i,:), K_dS_poscon_array(i,:), Po_dS_CpT_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_double_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_none_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_single_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope-2, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_single_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope-2, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_triple_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope+2, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_triple_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope+2, -dC_con ,0);
end


y=zeros(501,1);
y= y+0.5;
figure();

subplot(2,4,1);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_double_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
ylabel("P_o");
title(['I. B=',num2str(-dC_slope),' A=',num2str(-dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,5);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_none_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
ylabel("P_o");
title(['III. B=',num2str(dC_slope),' A=',num2str(dC_con)]);
xlim([T0-66 T0+66]);
ylim([0 1]);
box off;
hold off;

subplot(2,4,2);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['B=',num2str(-dC_slope),' A=',num2str(dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,6);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['B=',num2str(dC_slope),' A=',num2str(-dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,3);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_single_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['IVb. B=',num2str(-dC_slope-2),' A=',num2str(dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,7);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_single_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['IIb. B=',num2str(dC_slope-2),' A=',num2str(-dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,4);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_triple_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['IVa. B=',num2str(-dC_slope+2),' A=',num2str(dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,8);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_triple_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['IIa. B=',num2str(dC_slope+2),' A=',num2str(-dC_con)]);
xlim([T0-66 T0+66]);
box off;
hold off;

%% del Seffect on full linear

run ice_map.m;
run fire_map.m;
%Change in T0 effects onfirst order
dS= -9; %cal/molK
T0= 300; %K
dC_con=-6000;
dC_slope=-20; %cal/molK
T=[0:500];

T0_array=[201:2:401];
dS_array=[-9:0.09:0];

%NOTE: dC to dC_slope when applicable

% lnK_T0_negcon_array= zeros(101,501);
% K_T0_negcon_array= zeros(101,501);
% Po_T0_CpT_negcon_array= zeros(101, 501);
% lnK_T0_poscon_array= zeros(101,501);
% K_T0_poscon_array= zeros(101,501);
% Po_T0_CpT_poscon_array= zeros(101, 501);
% for i= 1:101
%     [lnK_T0_negcon_array(i,:), K_T0_negcon_array(i,:), Po_T0_CpT_negcon_array(i,:)]= C_M_linearCpT(T, T0_array(i), dS, -dC_slope, dC_con ,0);
%     [lnK_T0_poscon_array(i,:), K_T0_poscon_array(i,:), Po_T0_CpT_poscon_array(i,:)]= C_M_linearCpT(T, T0_array(i), dS, dC_slope, -dC_con ,0);
% end
% 
% y=zeros(501,1);
% y= y+0.5;
% subplot(2,2,1);
% title("A. Change in T_o effects");
% hold on;
% for i= 1:25:101
%         plot(T-T0_array(i), Po_T0_CpT_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
% end
% plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
% plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
% xlabel("Temperature (T-T_o) [K]");
% xlim([-66 66]);
% ylabel("P_o");
% A_title=title("A. Change in T_o effects");
% A_title.Position(2)= 0.97;
% %legend({"Slope-Only", "Inter.-Only"},'Location','NW','Fontsize',14);
% box off;
% hold off;
% 
% subplot(2,2,3);
% hold on;
% for i= 1:25:101
%         plot(T-T0_array(i), Po_T0_CpT_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
% end
% plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
% plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
% xlabel("Temperature (T-T_o) [K]");
% xlim([-66 66]);
% ylabel("P_o");
% A_title.Position(2)= 0.97;
% %legend({"Slope-Only", "Inter.-Only"},'Location','NW','Fontsize',14);
% box off;
% hold off;



lnK_dS_negcon_array= zeros(101,501);
K_dS_negcon_array= zeros(101,501);
Po_dS_CpT_negcon_array= zeros(101, 501);
lnK_dS_poscon_array= zeros(101,501);
K_dS_poscon_array= zeros(101,501);
Po_dS_CpT_poscon_array= zeros(101, 501);
Po_dS_CpT_double_array= zeros(101,501);
Po_dS_CpT_none_array= zeros(101,501);
Po_dS_CpT_single_negcon_array= zeros(101,501);
Po_dS_CpT_single_poscon_array= zeros(101,501);
Po_dS_CpT_triple_negcon_array= zeros(101,501);
Po_dS_CpT_triple_poscon_array= zeros(101,501);
for i= 1:101
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope, dC_con ,0);
    [lnK_dS_poscon_array(i,:), K_dS_poscon_array(i,:), Po_dS_CpT_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_double_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_none_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_single_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope-2, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_single_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope-2, -dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_triple_negcon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), -dC_slope+2, dC_con ,0);
    [lnK_dS_negcon_array(i,:), K_dS_negcon_array(i,:), Po_dS_CpT_triple_poscon_array(i,:)]= C_M_linearCpT(T, T0, dS_array(i), dC_slope+2, -dC_con ,0);
end


y=zeros(501,1);
y= y+0.5;
figure();

subplot(2,4,1);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_double_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
ylabel("P_o");
title(['I. B=',num2str(-dC_slope),' A=',num2str(-dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,5);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_none_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
ylabel("P_o");
title(['III. B=',num2str(dC_slope),' A=',num2str(dC_con)]);
%xlim([T0-66 T0+66]);
ylim([0 1]);
box off;
hold off;

subplot(2,4,2);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0,[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['B=',num2str(-dC_slope),' A=',num2str(dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,6);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['B=',num2str(dC_slope),' A=',num2str(-dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,3);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_single_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['IVb. B=',num2str(-dC_slope-2),' A=',num2str(dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,7);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_single_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['IIb. B=',num2str(dC_slope-2),' A=',num2str(-dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,4);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_triple_negcon_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['IVa. B=',num2str(-dC_slope+2),' A=',num2str(dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

subplot(2,4,8);
hold on;
for i= 1:25:101
        plot(T, Po_dS_CpT_triple_poscon_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [K]");
title(['IIa. B=',num2str(dC_slope+2),' A=',num2str(-dC_con)]);
%xlim([T0-66 T0+66]);
box off;
hold off;

%% del Seffect on full linear celsius

run ice_map.m;
run fire_map.m;
%Change in T0 effects onfirst order
dS= -9; %cal/molK
T0_cold= 340; %K
dC_con_cold=6800;
dC_slope_cold=-20; %cal/molK
dS_array=[-10:0.1:0];

T0_hot= 280;
dC_con_hot= -5600;
dC_slope_hot= 20;
T=[0:500];

lnK_negcon_array= zeros(101,501);
K_negcon_array= zeros(101,501);
Po_CpT_negcon_array= zeros(101, 501);
lnK_poscon_array= zeros(101,501);
K_poscon_array= zeros(101,501);
Po_CpT_double_array= zeros(101,501);
Po_CpT_none_array= zeros(101,501);
Po_CpT_single_hot_array= zeros(101,501);
Po_CpT_single_cold_array= zeros(101,501);
Po_CpT_single_hot_true_array= zeros(101,501);
Po_CpT_single_cold_true_array= zeros(101,501);
Po_CpT_triple_hot_array= zeros(101,501);
Po_CpT_triple_cold_array= zeros(101,501);
for i= 1:101
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_CpT_single_hot_true_array(i,:)]= C_M_linearCpT(T, T0_hot, dS_array(i), dC_slope_hot, dC_con_hot,0);
    [lnK_poscon_array(i,:), K_poscon_array(i,:), Po_CpT_single_cold_true_array(i,:)]= C_M_linearCpT(T, T0_cold, dS_array(i), dC_slope_cold, dC_con_cold,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_dS_CpT_double_array(i,:)]= C_M_linearCpT(T, T0_hot, dS_array(i), dC_slope_hot, dC_con_hot+2800 ,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_dS_CpT_none_array(i,:)]= C_M_linearCpT(T, T0_cold, dS_array(i), dC_slope_cold-20, dC_con_cold ,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_CpT_single_hot_array(i,:)]= C_M_linearCpT(T, T0_hot, dS_array(i), dC_slope_hot, dC_con_hot-250 ,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_CpT_single_cold_array(i,:)]= C_M_linearCpT(T, T0_cold, dS_array(i), dC_slope_cold-1, dC_con_cold ,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_CpT_triple_hot_array(i,:)]= C_M_linearCpT(T, T0_hot, dS_array(i), dC_slope_hot, dC_con_hot+500 ,0);
    [lnK_negcon_array(i,:), K_negcon_array(i,:), Po_CpT_triple_cold_array(i,:)]= C_M_linearCpT(T, T0_cold, dS_array(i), dC_slope_cold+1, dC_con_cold ,0);
end


y=zeros(501,1);
y= y+0.5;
figure('Units','centimeters','Position',[0 0 35.6 22.5]);

subplot(2,4,1);
hold on;
for i= 1:25:101
        plot(T-273, Po_dS_CpT_double_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0_hot-273,[0 1], 'Color','black','LineStyle',':','linewidth',1);
ylabel("P_o",'fontsize',15);
title(['A.'],'Position',[T0_hot-66-273 1.05],'fontsize',20);
xlim([T0_hot-66-273 T0_hot+66-273]);
box off;
hold off;

subplot(2,4,5);
hold on;
for i= 1:25:101
        plot(T-273, Po_dS_CpT_none_array(i,:),'linewidth',2,'color',[1-i/101 1-i/101 1-i/101]);
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0_cold-273,[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [^oC]",'fontsize',15);
ylabel("P_o",'fontsize',15);
title(['E.'],'Position',[T0_cold-66-273 1.05],'fontsize',20);
xlim([T0_cold-66-273 T0_cold+66-273]);
ylim([0 1]);
box off;
hold off;

subplot(2,4,2);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_single_hot_true_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2)+T0_hot-273,[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['B.'],'Position',[T0_hot-66-273 1.05],'fontsize',20);
xlim([T0_hot-66-273 T0_hot+66-273]);
box off;
hold off;

subplot(2,4,6);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_single_cold_true_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0_cold+zeros(1,2)-273,[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [^oC]",'fontsize',15);
title(['F.'],'Position',[T0_cold-66-273 1.05],'fontsize',20);
xlim([T0_cold-66-273 T0_cold+66-273]);
box off;
hold off;

subplot(2,4,3);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_single_hot_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0_hot-273+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['C.'],'Position',[T0_hot-66-273 1.05],'fontsize',20);
xlim([T0_hot-66-273 T0_hot+66-273]);
box off;
hold off;

subplot(2,4,7);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_single_cold_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0_cold-273+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [^oC]",'fontsize',15);
title(['G.'],'Position',[T0_cold-66-273 1.05],'fontsize',20);
xlim([T0_cold-66-273 T0_cold+66-273]);
box off;
hold off;

subplot(2,4,4);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_triple_hot_array(i,:),'linewidth',2,'color',fire(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0_hot-273+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
title(['D.'],'Position',[T0_hot-66-273 1.05],'fontsize',20);
xlim([T0_hot-66-273 T0_hot+66-273]);
box off;
hold off;

subplot(2,4,8);
hold on;
for i= 1:25:101
        plot(T-273, Po_CpT_triple_cold_array(i,:),'linewidth',2,'color',ice(i*2,:));
end
plot(T-273,y, 'Color','black','LineStyle',':','linewidth',2);
plot(T0_cold-273+zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlabel("Temperature [^oC]",'fontsize',15);
title(['H.'],'Position',[T0_cold-66-273 1.05],'fontsize',20);
xlim([T0_cold-66-273 T0_cold+66-273]);
box off;
hold off;

%% visualizition
run fire_map.m
run ice_map.m

run custommap_script.m

T0= 3000/15;
dC_Constant_array=[-1600:8:-800];
dC_Slope_array= [-8:0.025:-5.5];

dC_con_array=[-3500:7:3500];
dC_slope_array= [-15:0.03:15];

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
            WingNum_T(i,j)= -2;
        elseif ((dPo_0_T(i,j)<=0 || dPo_0_T(i,j)==Inf) && (j>=501))
            WingNum_T(i,j)= 2;
        elseif i<501 && T0>dPo_0_T(i,j)>0
            %triple wing heat sen
            WingNum_T(i,j)=0;
        elseif i<501 && dPo_0_T(i,j)>=T0
            %single wing heat
            WingNum_T(i,j)=1;
        elseif i>501 && dPo_0_T(i,j)>T0
            %tiple wing cold sen
            WingNum_T(i,j)=0;
        elseif i>501 && T0>=dPo_0_T(i,j)>0
            %single wing cold
            WingNum_T(i,j)=-1;
        end
            
    end
end


figure('Units','inches','Position',[0 0 11 8]);
%heatmap(dC_con_array,dC_slope_array,dPo_0_T,'GridVisible','off','colormap',jet);
plot(dC_slope_array, dC_con_array, 'color', [1 1 1]);
%imagesc(dC_slope_array,dC_con_array,WingNum_T, 'Alphadata', 0.33);
xlim([min(dC_slope_array) max(dC_slope_array)]);
ylim([min(dC_con_array) max(dC_con_array)]);
colormap(custommap);
set(gca,'YDir','normal');
xticks([-12:4:12]);
title("Effect of Slope and Intercept on Number of Wings");
xlabel("B [cal/molK^2]");
ylabel("A [cal/molK]");
hold on; 

%heat sensitive
% 
% dC_con_temp_array=[-3:0.5:3];
% dC_slope_temp_array=[-12:2:12];
% 
% dC_con_valid_line= -dC_slope_array*T0./2;
% dC_con_1to3_line= -dC_slope_array*T0;
% sizes= size(dC_slope_array);
% dC_slope_3to2_line= zeros(sizes(2));
% dC_con_zeros= zeros(sizes(2));
% hold on;
% plot(dC_slope_array, dC_con_valid_line,'color',[0.375 0.375 0.375],'linewidth',1);
% plot(dC_slope_array, dC_con_1to3_line,'color',[0.375 0.375 0.375],'linewidth',1);
% plot([0 0], [min(dC_con_array) max(dC_con_array)],'color',[0.5 0.5 0.5],'linewidth',1);
% plot(dC_slope_array(1:20:sizes(2)), dC_con_zeros(1:20:sizes(2)),'color',[0.375 0.375 0.375],'linewidth',1);
% 
for i=1:4
    plot([8], dC_Constant_array(33*i-32), 'marker','o', 'linestyle','none', 'markerfacecolor',fire(i*40+48,:),'markeredgecolor',fire(i*40+48,:));
end

for i=1:4
    plot(dC_Slope_array(33*i-32), [1600], 'marker','o', 'linestyle','none', 'markerfacecolor',ice(i*40+48,:),'markeredgecolor',ice(i*40+48,:));
end
% 
% 
% n=0;
% 
% for i=0.185:(0.8-0.185)/12:0.8
%     n=n+1;
%     m=0;
%     for j=0.16:(0.825-0.16)/12:0.825
%         m=m+1;
%         dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
%         if dC_slope_temp_array(n)==-12 && dC_con_temp_array(m)==2
%             T=[0:dPo_T*1.5];
%             [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
%             axes('Position',[i+(0.8-0.185)/12 j-(0.825-0.16)/12 0.05 0.05]);
%             plot(T, temp_po,'linewidth',1,'Color','k');
%             set(gca,'color','none');
%             ylim([0 1]);
%             axis off;
%         elseif dC_slope_temp_array(n)==-6 && dC_con_temp_array(m)==2
%             T=[0:2.75*dPo_T-T0];
%             [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
%             axes('Position',[i+(0.8-0.185)/12 j+(0.825-0.16)/12 0.05 0.05]);
%             plot(T, temp_po,'linewidth',1,'Color','k');
%             set(gca,'color','none');
%             ylim([0 1]);
%             axis off;
%         elseif dC_slope_temp_array(n)==6 && dC_con_temp_array(m)==-2
%             T=[dPo_T:2.5*dPo_T-T0];
%             [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
%             axes('Position',[i-(0.8-0.185)/15 j-(0.825-0.16)/15 0.05 0.05]);
%             plot(T, temp_po,'linewidth',1,'Color','k');
%             set(gca,'color','none');
%             ylim([0 1]);
%             axis off;
%         elseif dC_slope_temp_array(n)==10 && dC_con_temp_array(m)==-1.5
%             T=[0:T0*2];
%             [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
%             axes('Position',[i j 0.05 0.05]);
%             plot(T, temp_po,'linewidth',1,'Color','k');
%             set(gca,'color','none');
%             ylim([0 1]);
%             axis off;
%         elseif (dC_slope_temp_array(n)*dC_con_temp_array(m)== 16) 
%             axes('Position',[i j 0.05 0.05]);
%             dPo_T= -(2*dC_con_temp_array(m)*1000/dC_slope_temp_array(n) +T0);
%             T=[T0/2:T0*3/2];
%             [temp_lnk, temp_keq, temp_po]=C_M_linearCpT( T, T0, dS, dC_slope_temp_array(n), dC_con_temp_array(m)*1000, 0);
%             plot(T, temp_po,'linewidth',1,'Color','k');
%             set(gca,'color','none');
%             ylim([0 1]);
%             axis off;
%         end
%     end
% end
