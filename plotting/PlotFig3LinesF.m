function PlotFig3LinesF(vessel_ind,sol,R24_v,plotX,plotY,phm)

% plott
hold on;
if vessel_ind == 1
    plot(R24_v,sol{1}.FMaxClog(vessel_ind,:),'-','Color',[0 0.4470 0.7410 0.7],'LineWidth',3.5);
else
    plot(R24_v,sol{1}.FMaxClog(vessel_ind,:),':','Color',[0 0.4470 0.7410 0.7],'LineWidth',3.5);
end
plot(R24_v, sol{1}.FClog(vessel_ind,:),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R24_v, sol{2}.FMaxClog(vessel_ind,:),':','Color',[0.8500 0.3250 0.0980 0.7],'LineWidth',3.5);
plot(R24_v, sol{2}.FClog(vessel_ind,:),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
ax           = gca;
ax.LineWidth = 1.5;
set(gca,'FontSize',20);
axis square;
box on;

% axis options
xlim([0,1])
set(gca,'XTick',[0,0.5,1])
if phm == 0.85
    if vessel_ind == 1
        ylim([0.56,0.6])
        set(gca,'YTick',[0.56,0.58,0.6])
    elseif vessel_ind == 2
        ylim([0.28,0.6])
        set(gca,'YTick',[0.28,0.44,0.6])
    elseif vessel_ind == 3
        ylim([0,0.3])
        set(gca,'YTick',[0,0.15,0.3])
    end
elseif phm == 0.65
    if vessel_ind == 1
        ylim([0.43,0.47])
        set(gca,'YTick',[0.43,0.45,0.47])
    elseif vessel_ind == 2
        ylim([0.21,0.47])
        set(gca,'YTick',[0.21,0.34,0.47])
    elseif vessel_ind == 3
        ylim([0,0.24])
        set(gca,'YTick',[0,0.12,0.24])
    end
end

% plot tick labels if required
if plotX == 0
    set(gca,'xticklabels',[])
end
if plotY == 0
    set(gca,'yticklabels',[])
end

ylabel('$F$','Interpreter','latex');

end