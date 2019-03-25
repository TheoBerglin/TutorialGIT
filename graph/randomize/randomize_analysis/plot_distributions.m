function figname = plot_distributions( dist1, dist2 )
%PLOT_DISTRIBUTIONS Plots the histograms and the corresponding fit of two
%distributions. Returns the filename of the saved figure.
f = figure('visible','off');
hold on;

h1 = histfit(dist1, floor(length(dist1)/5));
h1(1).FaceColor = 'blue';
h1(1).FaceAlpha = 0.1;
h1(2).Color = 'blue';

h2 = histfit(dist2, floor(length(dist2)/5));
h2(1).FaceColor = 'red';
h2(1).FaceAlpha = 0.1;
h2(2).Color = 'red';

xlabel('Value of global measure')
ylabel('Occurences')

figname = 'temp_name.fig';
savefig(f,figname);

end

