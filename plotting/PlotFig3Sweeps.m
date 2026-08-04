function PlotFig3Sweeps(phinLim,sol,phin_M,R24_M,plotX,plotY,plotLines)

% plot
h1 = surf(R24_M,phin_M,reshape(sol,[length(R24_M),length(R24_M)]));
set(h1, 'EdgeColor', 'flat');
view([0,0,1]);
ax           = gca;
ax.LineWidth = 3;
set(gca,'FontSize',20);
axis square;
box on;
grid off;

% axis options
xlim([0,1])
ylim([min(phin_M(:)),max(phin_M(:))])
set(gca,'XTick',[0,0.5,1])
set(gca,'YTick',[phinLim(1),round(phinLim(1)+diff(phinLim)/2,2),phinLim(2)])

% colorbar
A = parula(3);
colormap(A)
clim([0 3]);

% plot tick labels if required
if plotX == 0
    set(gca,'xticklabels',[])
end
if plotY == 0
    set(gca,'yticklabels',[])
end

% plot lines for phin if required
if ~isempty(plotLines)
    line([0,1],[plotLines(1),plotLines(1)],[100,100],'Color',[0 0.4470 0.7410 1],'LineStyle','--','LineWidth',2.5)
    line([0,1],[plotLines(2),plotLines(2)],[100,100],'Color', [0.8500 0.3250 0.0980 1],'LineStyle','--','LineWidth',2.5)
end


end