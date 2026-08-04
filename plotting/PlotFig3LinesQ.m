function PlotFig3LinesQ(vessel_ind,sol,R24_v,plotX,plotY,phm)

% plott
hold on;
plot(R24_v, abs(sol{1}.QClog(vessel_ind,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R24_v, abs(sol{2}.QClog(vessel_ind,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
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
        ylim([0.5,1.02])
        set(gca,'YTick',[0.5,0.75,1.02])
    elseif vessel_ind == 2
        ylim([0.5,1.02])
        set(gca,'YTick',[0.5,0.75,1.02])
    elseif vessel_ind == 3
        ylim([0,1.02])
        set(gca,'YTick',[0,0.5,1.02])
    end
elseif phm == 0.65
    if vessel_ind == 1
        ylim([0.5,1.02])
        set(gca,'YTick',[0.5,0.75,1.02])
    elseif vessel_ind == 2
        ylim([0.5,1.02])
        set(gca,'YTick',[0.5,0.75,1.02])
    elseif vessel_ind == 3
        ylim([0,1.02])
        set(gca,'YTick',[0,0.5,1.02])
    end
end

% plot tick labels if required
if plotX == 0
    set(gca,'xticklabels',[])
end
if plotY == 0
    set(gca,'yticklabels',[])
end

ylabel('$Q$','Interpreter','latex');

end