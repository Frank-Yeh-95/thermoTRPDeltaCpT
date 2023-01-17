T= zeros(500,1);
R= 1.987; %cal/molK
startT=0;

for i= startT:500+startT;
    T(i-startT+1,1)=i;
end

dS= -5;
dC= 3000;
T0= 298;

%% Parameter Changes
%Change in dCp
dS= -9; %cal/molK
T0= 298; %K
dC3= 3000; %cal/molK

dS= -9; %cal/molK
T0= 298; %K
dC5= 5000; %cal/molK

[lnK_dC3, K_dC3, Po_dC3]= C_M(T, T0, dS, dC3);
[lnK_dC5, K_dC5, Po_dC5]= C_M(T, T0, dS, dC5);

figure('Units','inches','Position',[0 0 18 6], 'DefaultAxesFontSize', 18);
subplot(1,3,3);
plot(T, Po_dC3, 'linewidth',2,'color',[0 0 1]);
hold on;
plot(T, Po_dC5, 'linewidth',2,'color',[0 1 1]);
xlabel("Temperature (K)");
%legend("\DeltaC_p at 3kcal/molK", "\DeltaC_p at 5kcal/molK");
xlim([248,348]);
title("C.",'Position',[255 1.01]);
% 
%  figure();
%  plot(T, lnK_dC3);
%  hold on;
%  plot(T, lnK_dC5);
%  ylim([-5,5]);
%  ylabel("Ln(K_e_q)");
% xlabel("Temperature (K)");
%  legend("\DeltaCp at 3kcal/molK", "\DeltaCp at 5kcal/molK");
%  title("Changes in \DeltaC_p seems to steepen Ln(K_e_q) curves");

%Change in dS
dS20= -20; %cal/molK
T0= 298; %K
dC= 3000; %cal/molK

dS9= -9; %cal/molK
T0= 298; %K
dC= 3000; %cal/molK

[lnK_dS20, K_dS20, Po_dS20]= C_M(T, T0, dS20, dC);
[lnK_dS9, K_dS9, Po_dS9]= C_M(T, T0, dS9, dC);


subplot(1,3,2);
plot(T, Po_dS20, 'linewidth',2,'color',[184/255 134/255 11/255]);
hold on;
plot(T, Po_dS9, 'linewidth',2,'color',[1 165/255 0]);
xlabel("Temperature (K)");
%legend("\DeltaS_o^o at -20cal/molK", "\DeltaS_o^o at -9cal/molK");
xlim([248,348]);
title("B.",'Position',[255 1.01]);
% 
%  figure();
%  plot(T, lnK_dS20);
%  hold on;
%  plot(T, lnK_dS9);
%  ylim([-5,5]);
%  ylabel("Ln(K_e_q)");
% xlabel("Temperature (K)");
% legend("\DeltaS_o at -20cal/molK", "\DeltaS_o at -5cal/molK");
% title("Changes in \DeltaS_o seems to vertically shift Ln(K_e_q) curves");


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
plot(T, Po_T0298, 'linewidth',2,'color',[1 0 0]);
hold on;
plot(T, Po_T0308, 'linewidth',2,'color',[250/255 128/255 114/255]);
ylabel("P_o");
xlabel("Temperature (K)");
%legend("T_o at 298K", "T_o at 308K");
xlim([248,348]);
title("A.",'position',[255 1.01]);

%  figure();
%  plot(T, lnK_T0298);
%  hold on;
%  plot(T, lnK_T0308);
%  ylim([-5,5]);
%  ylabel("Ln(K_e_q)");
% xlabel("Temperature (K)");
% legend("T_o at 298K", "T_o at 308K");
% title("Changes in T_o seems to horizontally shift Ln(K_e_q) curves");

%%Finding maximal slope

%Temperature at Po=0.5 is T= -T0/ LambertW( -exp( -1+ delS/delCp))

greaterT50= -T0/ lambertw( 0, -exp( -1+ dS/dC));
lesserT50= -T0/ lambertw( -1, -exp( -1+ dS/dC));

greaterdPo= dC.* exp((dC + dS - (dC .* T0./greaterT50) + dC .* log(T0./greaterT50))./R) .* ...
    (greaterT50-T0)...
    ./ ((exp(dS./R) + exp(dC./R .* (1 - T0./greaterT50 + log(T0./greaterT50)))).^(2) ...
    .* R .* greaterT50.^(2));
lesserdPo= dC.* exp((dC + dS - (dC .* T0./lesserT50) + dC .* log(T0./lesserT50))./R) .* ...
    (lesserT50-T0)...
    ./ ((exp(dS./R) + exp(dC./R .* (1 - T0./lesserT50 + log(T0./lesserT50)))).^(2) ...
    .* R .* lesserT50.^(2));

[lnK_dC, K_dC, Po_dC]= C_M(T, T0, dS, dC);

negapprox= zeros(500,1);
posapprox= zeros(500,1);

posapprox= T.*greaterdPo+(0.5-greaterdPo*greaterT50);
negapprox= T.*lesserdPo+(0.5-lesserdPo*lesserT50);

figure('Units','inches','Position',[0 0 16.5 6],'DefaultAxesFontSize',14);
annotation('textbox', [0.21625 0.000 0.2 0.1], 'string', 'Temperature (T-T_o) K','Edgecolor','none','fontsize',15,'horizontalalignment','center','verticalalignment','bottom');
annotation('textbox', [0.04 0.9 0.01 0.1],'string','A.','Edgecolor','none','fontsize',20,'horizontalalignment','center','verticalalignment','bottom');
annotation('textbox', [0.65 0.9 0.01 0.1],'string','B.','Edgecolor','none','fontsize',20,'horizontalalignment','center','verticalalignment','bottom');

subplot('Position',[0.078125 0.125 0.25 0.8]);
hold on;
plot(T-T0, Po_dC,'color',[0 0 1],'linewidth',2);
plot(T-T0, negapprox,'color',[0.47 0.47 0.47],'linewidth',3);
plot([lesserT50-T0 lesserT50-T0], [0 0.5], 'color',[0.47 0.47 0.47],'linewidth',1.5, 'linestyle', '--');
plot([-35 lesserT50-T0], [0.5 0.5], 'color',[0.47 0.47 0.47],'linewidth',1.5, 'linestyle', '--');
%plot(T-T0, y,'color', [0 0 0], 'linestyle','--');
ylabel("P_o");
%title("Negative Wing");
%legend({"T-independent \DeltaC_p","Negative Wing"},'fontsize',16);
%text(lesserT50-T0+0.5, 0.5, "T_{50} with Maximal Slope",'fontsize',16);
ylim([0 1]);
xlim([-35 -10]);
hold off;

subplot('Position',[0.354375 0.125 0.25 0.8]);
hold on;
plot(T-T0, Po_dC,'color',[0 0 1],'linewidth',2);
plot(T-T0, posapprox,'color',[0 0 0],'linewidth',3);
plot([greaterT50-T0 greaterT50-T0], [0 0.5], 'color',[0 0 0],'linewidth',1.5, 'linestyle', '--');
plot([greaterT50-T0 10], [0.5 0.5], 'color',[0 0 0],'linewidth',1.5, 'linestyle', '--');
%plot(T-T0, y,'color', [0 0 0], 'linestyle','--');
%title("Positive Wing");
%legend({"T-independent \DeltaC_p","Positive Wing"},'fontsize',16,'location','NW');
%text(greaterT50-T0+0.5, 0.5, "T_{50} with Maximal Slope",'fontsize',16);
ylim([0 1]);
xlim([10 35]);
hold off;

rescaledT= T-T0;
rescaledT(T0:size(T))

subplot('Position',[0.6875 0.125 0.25 0.80]);
hold on;
plot(-rescaledT(1:T0), Po_dC(1:T0),'color',[0.47 0.47 0.47],'linewidth',3);
plot([abs(lesserT50-T0) abs(lesserT50-T0)], [0 0.5], 'color',[0.47 0.47 0.47],'linewidth',1.5, 'linestyle', '--');
plot([0 abs(lesserT50-T0)], [0.5 0.5], 'color',[0.47 0.47 0.47],'linewidth',1.5, 'linestyle', '--');
plot(rescaledT(T0:size(T)), Po_dC(T0:size(T)),'color',[0 0 0],'linewidth',3);
plot([greaterT50-T0 greaterT50-T0], [0 0.5], 'color',[0 0 0],'linewidth',1.5, 'linestyle', '--');
plot([greaterT50-T0 0], [0.5 0.5], 'color',[0 0 0],'linewidth',1.5, 'linestyle', '--');
ylim([0 1]);
xlim([0 50]);
xlabel("Temperature |T-T_o| [K]");
ylabel("P_o");
hold off;

%% Parameter changes on T_50 and maximal slope

dS=-9;

%Change in T0 effects
T0_array=[101:2.5:351];
T50_T0_array=zeros(2,101);

T50_T0_array(1,:)= -T0_array./ lambertw( 0, -exp( -1+ dS./dC));
T50_T0_array(2,:)= -T0_array./ lambertw( -1, -exp( -1+ dS./dC));

y= zeros(101,1);
figure('Units','inches','Position',[0 0 18 16],'DefaultAxesFontSize', 16);
subplot('Position',[0.1 0.36 0.25 0.27]);
plot(T0_array, T50_T0_array(1,:)-T0_array,'Color','black','linewidth',2);
hold on;
plot(T0_array, -T50_T0_array(2,:)+T0_array,'Color',[0.47 0.47 0.47],'linewidth',2);
%plot(T0_array, y, 'Color','black');
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerSize',10);
        elseif i<66
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerSize',10);
        else
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerSize',10);
        end
    end
end
ylabel("|T-T_o| [K]");
%legend({"Positive Wing","Negative Wing"},'Location','NW','FontSize',12);
xlim([100 351]);
xticklabels({});
ylim([0 100]);
box off;
hold off;

axes('Position',[0.22 0.475 0.125 0.126]);
plot(T0_array, T50_T0_array(1,:)-T0_array,'Color','black','linewidth',2);
hold on;
plot(T0_array, -T50_T0_array(2,:)+T0_array,'Color',[0.47 0.47 0.47],'linewidth',2);
%plot(T0_array, y, 'Color','black');
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerSize',10);
        elseif i<66
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerSize',10);
        else
            plot(T0_array(i), abs(T50_T0_array(j,i)-T0_array(i)),'Marker','o','linestyle','none','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerSize',10);
        end
    end
end
xlim([130 170]);
xticks([130 150 170]);
box off;
hold off;


dPo_T0_array= zeros(2,101);

dPo_T0_array= dC.* exp((dC + dS - (dC .* T0_array./T50_T0_array) + dC .* log(T0_array./T50_T0_array))./R) .* ...
    (T50_T0_array-T0_array)...
    ./ ((exp(dS./R) + exp(dC./R .* (1 - T0_array./T50_T0_array + log(T0_array./T50_T0_array)))).^(2) ...
    .* R .* T50_T0_array.^(2));
% dPo_T0_array(2,:)= exp((dS-dC)./R).*exp(dC.*T0_array./(R.*T50_T0_array(2,:))).*(T0_array./T50_T0_array(2,:)).^(-dC./R).*(dC./R)...
%     .*(1-T0_array./T50_T0_array(2,:))...
%     ./(1+exp((dS-dC)./R).*exp(dC.*T0_array./(R.*T50_T0_array(2,:))).*(T0_array./T50_T0_array(2,:)).^(-dC./R)).^2;

y= zeros(101,1);
subplot('Position',[0.1 0.075 0.25 0.26]);
plot(T0_array, dPo_T0_array(1,:),'Color','black','linewidth',2);
hold on;
plot(T0_array, -dPo_T0_array(2,:),'Color',[0.47 0.47 0.47],'linewidth',2);
%plot(T0_array, y, 'Color','black');
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[128/255 0 0], ...
                'MarkerEdgeColor',[128/255 0 0],'MarkerSize',10);
        elseif i<66
            plot(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[1 0 0], ...
                'MarkerEdgeColor',[1 0 0],'MarkerSize',10);
        else
            plot(T0_array(i), abs(dPo_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[250/255 128/255 114/255], ...
                'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerSize',10);
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


% dLnK_T0_array=zeros(2,101);
% 
% dLnK_T0_array(1,:)= dC.*(1./T50_T0_array(1,:) - T0_array./(T50_T0_array(1,:).*T50_T0_array(1,:)))./R;
% dLnK_T0_array(2,:)= dC.*(1./T50_T0_array(2,:) - T0_array./(T50_T0_array(2,:).*T50_T0_array(2,:)))./R;

% y= zeros(101,1);
% subplot('Position',[0.1 0.06 0.25 0.25]);
% plot(T0_array, dLnK_T0_array(1,:),'Color','black','linewidth',2);
% hold on;
% plot(T0_array, -dLnK_T0_array(2,:),'Color',[0.47 0.47 0.47],'linewidth',2);
% %plot(T0_array, y, 'Color','black');
% for j= 1:2
%     for i= 21:40:101
%         if i<34
%             plot(T0_array(i), abs(dLnK_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[128/255 0 0], ...
%                 'MarkerEdgeColor',[128/255 0 0],'MarkerSize',10);
%         elseif i<66
%             plot(T0_array(i), abs(dLnK_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[1 0 0], ...
%                 'MarkerEdgeColor',[1 0 0],'MarkerSize',10);
%         else
%             plot(T0_array(i), abs(dLnK_T0_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[250/255 128/255 114/255], ...
%                 'MarkerEdgeColor',[250/255 128/255 114/255],'MarkerSize',10);
%         end
%     end
% end
% ylabel("Maximal Slope [Arbit. Units]");
% xlabel("T_o [K]");
% ylim([0 5]);
% box off;
% hold off;


lnK_T0_array= zeros(101,501);
K_T0_array= zeros(101,501);
Po_T0_array= zeros(101, 501);
for i= 1:101
    [lnK_T0_array(i,:), K_T0_array(i,:), Po_T0_array(i,:)]= C_M(T, T0_array(i), dS, dC);
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.1 0.7 0.25 0.27]);
hold on;
for i= 21:40:101
    if i<34
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',2,'Color',[128/255 0 0]);
    elseif i<66
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',2,'Color',[1 0 0]);
    else
        plot(T-T0_array(i), Po_T0_array(i,:),'linewidth',2,'Color',[250/255 128/255 114/255]);
    end
end
plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlim([-66 66]);
xlabel("Temperature (T-T_o) [K]");
ylabel("P_o");
A_title=title("A. Change in T_o effects");
A_title.Position(2)= 0.97;
box off;
hold off;

% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:101;
%     plot(T-T0_array(i), lnK_T0_array(i,:));
% end
% plot(T-T0,y, 'Color','black');
% xlim([-40 40]);
% ylim([-5 5]);
% title("Ln(K_e_q) v. T over many T_o after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;

%Change in dS over Po and T50

dS_array=[-22.5:0.225:0];
dS_array= reshape(dS_array,[101,1]);
T50_dS_array=zeros(101,2);

T50_dS_array(:,1)= reshape(-T0./ lambertw( 0, -exp( -1+ dS_array./dC)), [101,1]);
T50_dS_array(:,2)= reshape(-T0./ lambertw( -1, -exp( -1+ dS_array./dC)), [101,1]);
%T50_dS_array= T50_dS_array-T0;
%T50_dS_array(:,2)=-T50_dS_array(:,2);

y= zeros(101,1);
subplot('Position',[0.4 0.36 0.25 0.27]);
plot(dS_array, T50_dS_array(:,1)-T0,'Color','black','linewidth',2);
hold on;
plot(dS_array, -(T50_dS_array(:,2)-T0),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerSize',10);
        elseif i<66
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerSize',10);
        else
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerSize',10);
        end
    end
end
%plot(dS_array, y, 'Color','black');
ylim([0 100]);
xlim([-22.5 0]);
xticklabels({});
box off;
hold off;


axes('Position',[0.51 0.475 0.125 0.126]);
plot(dS_array, T50_dS_array(:,1)-T0,'Color','black','linewidth',2);
hold on;
plot(dS_array, -(T50_dS_array(:,2)-T0),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerSize',10);
        elseif i<66
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerSize',10);
        else
            plot(dS_array(i), abs(T50_dS_array(i,j)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerSize',10);
        end
    end
end
%plot(dS_array, y, 'Color','black');
xlim([-10 -8]);
box off;
hold off;

dPo_dS_array= zeros(101,2);

dPo_dS_array= dC.* exp((dC + dS_array - (dC .* T0./T50_dS_array) + dC .* log(T0./T50_dS_array))./R) .* ...
    (T50_dS_array-T0)...
    ./ ((exp(dS_array./R) + exp(dC./R .* (1 - T0./T50_dS_array + log(T0./T50_dS_array)))).^2 ...
    .* R .* T50_dS_array.^2);


y= zeros(101,1);
subplot('Position',[0.4 0.075 0.25 0.26]);
plot(dS_array, dPo_dS_array(:,1),'Color','black','linewidth',2);
hold on;
plot(dS_array, abs(dPo_dS_array(:,2)),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[184/255 134/255 11/255], ...
                'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerSize',10);
        elseif i<66
            plot(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[1 165/255 0], ...
                'MarkerEdgeColor',[1 165/255 0],'MarkerSize',10);
        else
            plot(dS_array(i), abs(dPo_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[189/255 183/255 107/255], ...
                'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerSize',10);
        end
    end
end
%plot(dS_array, y, 'Color','black');
B_xlabel=xlabel("\DeltaS_o^o [cal/molK]");
B_xlabel.Units='normalized';
B_xlabel.Extent
B_xlabel.Position(2)=-0.11;
ylim([0 0.25]);
xlim([-22.5 0]);
box off;
hold off;

% % dLnK_dS_array=zeros(101,2);
% % dLnK_dS_array(:,1)= dC .*(1./T50_dS_array(:,1) - T0./(T50_dS_array(:,1) .* T50_dS_array(:,1)))./R;
% % dLnK_dS_array(:,2)= dC .*(1./T50_dS_array(:,2) - T0./(T50_dS_array(:,2) .* T50_dS_array(:,2)))./R;
% % 
% y= zeros(101,1);
% subplot('Position',[0.4 0.06 0.25 0.25]);
% plot(dS_array, dLnK_dS_array(:,1),'Color','black','linewidth',2);
% hold on;
% plot(dS_array, -dLnK_dS_array(:,2),'Color',[0.47 0.47 0.47],'linewidth',2);
% for j= 1:2
%     for i= 21:40:101
%         if i<34
%             plot(dS_array(i), abs(dLnK_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[184/255 134/255 11/255], ...
%                 'MarkerEdgeColor',[184/255 134/255 11/255],'MarkerSize',10);
%         elseif i<66
%             plot(dS_array(i), abs(dLnK_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[1 165/255 0], ...
%                 'MarkerEdgeColor',[1 165/255 0],'MarkerSize',10);
%         else
%             plot(dS_array(i), abs(dLnK_dS_array(i,j)),'Marker','o','linestyle','none','MarkerFaceColor',[189/255 183/255 107/255], ...
%                 'MarkerEdgeColor',[189/255 183/255 107/255],'MarkerSize',10);
%         end
%     end
% end
% %plot(dS_array, y, 'Color','black');
% xlabel("\Delta S_o^o [cal/molK]");
% box off;
% hold off;


lnK_dS_array= zeros(101,501);
K_dS_array= zeros(101,501);
Po_dS_array= zeros(101, 501);
for i= 1:101;
    [lnK_dS_array(i,:), K_dS_array(i,:), Po_dS_array(i,:)]= C_M(T, T0, dS_array(i), dC);
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.4 0.7 0.25 0.27]);
hold on;
for i= 21:40:101
    if i<34
        plot(T-T0, Po_dS_array(i,:),'linewidth',2,'Color',[184/255 134/255 11/255]);
    elseif i<66
        plot(T-T0, Po_dS_array(i,:),'linewidth',2,'Color',[1 165/255 0]);
    else
        plot(T-T0, Po_dS_array(i,:),'linewidth',2,'Color',[189/255 183/255 107/255]);
    end
end
plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlim([-66 66]);
xlabel("Temperature (T-T_o) [K]");
B_title=title("B. Change in \DeltaS_o^o effects");
B_title.Position(2)= 0.97;
box off;
hold off;

% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:101;
%     plot(T-T0, lnK_dS_array(i,:));
% end
% plot(T-T0,y, 'Color','black');
% xlim([-100 100]);
% title("Ln(K_e_q) v. T over many \DeltaS_o^o after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;

%Change in dCp over Po and T50
dC_array=[0:50:5000];

T50_dC_array=zeros(2,101);

T50_dC_array(1,:)= -T0./ lambertw( 0, -exp( -1+ dS./dC_array));
T50_dC_array(2,:)= -T0./ lambertw( -1, -exp( -1+ dS./dC_array));

y= zeros(101,1);
subplot('Position',[0.7 0.36 0.25 0.27]);
plot(dC_array./1000, abs(T50_dC_array(1,:)-T0),'Color','black','linewidth',2);
hold on;
plot(dC_array./1000, abs(-T50_dC_array(2,:)+T0),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 .5], ...
                'MarkerEdgeColor',[0 0 .5],'MarkerSize',10);
        elseif i<66
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerSize',10);
        else
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerSize',10);
        end
    end
end
%plot(dC_array, y, 'Color','black');
% legend("Positive","Negative");
ylim([0 100]);
xticklabels({});
box off;
hold off;

axes('Position',[0.82 0.475 0.125 0.126]);
plot(dC_array./1000, abs(T50_dC_array(1,:)-T0),'Color','black','linewidth',2);
hold on;
plot(dC_array./1000, abs(-T50_dC_array(2,:)+T0),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
    for i= 21:40:101
        if i<34
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 .5], ...
                'MarkerEdgeColor',[0 0 .5],'MarkerSize',10);
        elseif i<66
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerSize',10);
        else
            plot(dC_array(i)./1000, abs(T50_dC_array(j,i)-T0),'Marker','o','linestyle','none','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1],'MarkerSize',10);
        end
    end
end
%plot(dC_array, y, 'Color','black');
% legend("Positive","Negative");
xlim([2 4]);
box off;
hold off;


dPo_dC_array= zeros(2,101);

dPo_dC_array= dC_array.* exp((dC_array + dS - (dC_array .* T0./T50_dC_array) + dC_array .* log(T0./T50_dC_array))./R) .* ...
    (T50_dC_array-T0)...
    ./ ((exp(dS./R) + exp(dC_array./R .* (1 - T0./T50_dC_array + log(T0./T50_dC_array)))).^2 ...
    .* R .* T50_dC_array.^2);


y= zeros(101,1);
subplot('Position',[0.7 0.075 0.25 0.26]);
plot(dC_array./1000, dPo_dC_array(1,:),'Color','black','linewidth',2);
hold on;
plot(dC_array./1000, abs(dPo_dC_array(2,:)),'Color',[0.47 0.47 0.47],'linewidth',2);
for j= 1:2
   for i= 21:40:101
        if i<34
            plot(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 .5], ...
                'MarkerEdgeColor',[0 0 0.5],'MarkerSize',10);
        elseif i<66
            plot(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 1], ...
                'MarkerEdgeColor',[0 0 1],'MarkerSize',10);
        else
            plot(dC_array(i)./1000, abs(dPo_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 1 1], ...
                'MarkerEdgeColor',[0 1 1], 'MarkerSize',10);
        end
    end
end
%plot(dS_array, y, 'Color','black');
C_xlabel=xlabel("\DeltaC_p [kcal/molK]");
C_xlabel.Units='normalized';
C_xlabel.Extent
C_xlabel.Position(2)=-0.125;
ylim([0 0.25]);
box off;
hold off;

% dLnK_dC_array=zeros(2,101);
% dLnK_dC_array(1,:)= dC_array.*(1./T50_dC_array(1,:) - T0./(T50_dC_array(1,:) .* T50_dC_array(1,:)))./R;
% dLnK_dC_array(2,:)= dC_array.*(1./T50_dC_array(2,:) - T0./(T50_dC_array(2,:) .* T50_dC_array(2,:)))./R;
% 
% y= zeros(101,1);
% subplot('Position',[0.7 0.06 0.25 0.25]);
% hold on;
% plot(dC_array./1000, dLnK_dC_array(1,:),'Color','black','linewidth',2);
% plot(dC_array./1000, -dLnK_dC_array(2,:),'Color',[0.47 0.47 0.47],'linewidth',3);
% for j= 1:2
%     for i= 1:40:101
%         if i<34
%             plot(dC_array(i)./1000, abs(dLnK_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 .5], ...
%                 'MarkerEdgeColor',[0 0 .5],'MarkerSize',10);
%         elseif i<66
%             plot(dC_array(i)./1000, abs(dLnK_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 0 1], ...
%                 'MarkerEdgeColor',[0 0 1],'MarkerSize',10);
%         else
%             plot(dC_array(i)./1000, abs(dLnK_dC_array(j,i)),'Marker','o','linestyle','none','MarkerFaceColor',[0 1 1], ...
%                 'MarkerEdgeColor',[0 1 1],'MarkerSize',10);
%         end
%     end
% end
% %plot(dC_array, y, 'Color','black');
% xlabel("\Delta C_p [kcal/molK]");
% % legend("Positive","Negative");
% box off;
% hold off;


lnK_dC_array= zeros(101,501);
K_dC_array= zeros(101,501);
Po_dC_array= zeros(101, 501);
for i= 1:101
    [lnK_dC_array(i,:), K_dC_array(i,:), Po_dC_array(i,:)]= C_M(T, T0, dS, dC_array(i));
end

y=zeros(501,1);
y= y+0.5;
subplot('Position',[0.7 0.7 0.25 0.27]);
C_title=title("C. Change \DeltaC_p effects");
C_title.Position(2)= 0.97;
hold on;
for i= 21:40:101
    if i<34
        plot(T-T0, Po_dC_array(i,:),'linewidth',2,'Color',[0 0 0.5]);
    elseif i<66
        plot(T-T0, Po_dC_array(i,:),'linewidth',2,'Color',[0 0 1]);
    else
        plot(T-T0, Po_dC_array(i,:),'linewidth',2,'Color',[0 1 1])
    end
end
plot(T-T0,y, 'Color','black','LineStyle',':','linewidth',2);
plot(zeros(1,2),[0 1], 'Color','black','LineStyle',':','linewidth',1);
xlim([-66 66]);
xlabel("Temperature (T-T_o) [K]");
box off;
hold off;


% y=zeros(501,1);
% y= y+0.5;
% figure();
% hold on;
% for i= 1:5:101;
%     plot(T-T0, Po_dC_array(i,:));
% end
% plot(T-T0,y, 'Color','black');
% xlim([-100 100]);
% title("Po v. T over many \DeltaC_p after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Open Probability [1-0]");
% ay=gca;
% ay.YAxis.Scale = 'log';
% ylim([10^-5 1]);
% hold off;
% 
% y=zeros(501,1);
% figure();
% hold on;
% for i= 1:5:101;
%     plot(T-T0, lnK_dC_array(i,:));
% end
% plot(T-T0,y, 'Color','black');
% xlim([-100 100]);
% ylim([-10 10]);
% title("Ln(K_e_q) v. T over many \DeltaC_p after T_o subtraction");
% xlabel("Temperature (K)");
% ylabel("Ln(K_e_q)");
% hold off;
