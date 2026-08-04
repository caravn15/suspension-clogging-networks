function PlotFig3LinesPhi(vessel_ind,sol,R24_v,plotX,plotY,YLim,YTick)

% plot
hold on;
plot(R24_v,sol{1}.PhClog(vessel_ind,:),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R24_v,sol{2}.PhClog(vessel_ind,:),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
plot(R24_v,sol{2}.PhMaxClog(vessel_ind,:),':','Color',[0 0 0 1],'LineWidth',3.5);
ax           = gca;
ax.LineWidth = 1.5;
set(gca,'FontSize',20);
axis square;
box on;

% axis options
xlim([0,1])
set(gca,'XTick',[0,0.5,1])
ylim(YLim)
set(gca,'YTick',YTick)

% plot tick labels if required
if plotX == 0
    set(gca,'xticklabels',[])
end
if plotY == 0
    set(gca,'yticklabels',[])
end

ylabel('$\overline{\phi}$','Interpreter','latex');

end