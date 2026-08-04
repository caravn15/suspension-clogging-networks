function PlotFig3Resistance(sol,R24_v)

% plot
hold on;
% colororder('default')
plot(R24_v,sol{1}.PinClog./abs(sol{1}.QClog(1,:)),'-','Color',[0 0.4470 0.7410 1], 'LineWidth', 2.5);
plot(R24_v,sol{2}.PinClog./abs(sol{2}.QClog(1,:)),'-','Color',[0.8500 0.3250 0.0980 1], 'LineWidth', 2.5);
plot(R24_v,sol{1}.PinNewt./abs(sol{1}.QNewt(1,:)),'--','Color',[0 0.4470 0.7410 1],'LineWidth', 2.5);
plot(R24_v,sol{2}.PinNewt./abs(sol{2}.QNewt(1,:)),'--','Color',[0.8500 0.3250 0.0980 1],'LineWidth', 2.5);
ax           = gca;
ax.LineWidth = 1.5;
set(gca,'FontSize',20);
box on;

% axis options
xlim([0,1])
set(gca,'XTick',[0,0.5,1])
ylim([20,100])
yticks([20,60,100])

end