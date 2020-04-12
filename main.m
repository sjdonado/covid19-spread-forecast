% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
T = readtable('data/reported_cases.csv');
[Confirmed, Deaths, Recovered, Time] = get_data_COVID(T);

figure;
hold on;
semilogy(Time, Confirmed, 'r', Time, Recovered, 'b', Time, Deaths, 'k');

ylabel('Number of cases');
xlabel('Time (days)')
leg = {'Active (reported)', 'Recovered (reported)', 'Deceased (reported)'};

legend(leg{:}, 'location', 'best')

set(gcf, 'color', 'w')
grid on
axis tight
set(gca, 'yscale', 'lin')