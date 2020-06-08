% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
table = readtable('data/Casos_positivos_de_COVID-19_en_Colombia.csv');

% Susceptible = Colombia population
% Incfectious = Confirmed
% Recovered
[Confirmed, Deaths, Recovered, Time] = get_data_COVID(table);

sum(Confirmed) % Expected value: 6211

% Infection rate
beta = 1.5;

% Recovered rate
gamma = 2.2

total_days = days(max(Time) - min(Time))

initial_total_victims = Confirmed(1,1) + Recovered(1,1) + Deaths(1,1)
% S0 = 49.65e4; % Colombia population according to DANE
S0 = 48258494 % Colombia population according to DANE
%S0 = 9e5;
t = (1:total_days);
% Subtract to S0 the first 48258494infected
x = SIR([beta, gamma, S0 - initial_total_victims, Confirmed(1,1), ...
    Recovered(1,1)], t);

% Optimize beta and gamma estimation fitting the given confirmed cases
% Init sir params
I = cumsum(Confirmed);
R = cumsum(Deaths + Recovered);
S = ones(size(t, 1), 1) * S0 - (I + R);
data = [S(:) I(:) R(:)];
t_data = 1:size(data, 1);

figure;
hold all;
grid on;
title('Colombia COVID-19 dataset');
plot(t_data, I, 'B-', 'linewidth', 2)% Infectious cases
plot(t_data, R, 'R-', 'linewidth', 2)% Recovered cases

legend('Infectious', 'Recovered + Deaths', 'location', 'best');

ylabel('Number of people');
xlabel('Time (days)');

% Initialize beta and gamma randomly
init = [rand(2,1)*1e-2;  data(1,:)'];

% Ask about why opt_params(4) is negative
% Ask about what means optimize the initial condition
% Ask about this function, is it a good approach? (due internally uses
% least-squares)
[opt_params, ResNorm] = lsqcurvefit(@SIR, init', t(:), data(2:end, :));

% Tem fix: to future sent only opt_params
xo = SIR([opt_params(1), opt_params(2), S0 - initial_total_victims, ...
    Confirmed(1,1), Recovered(1,1)], t);

figure;
hold all;
plot(t, x(:,1),'B-o')% Susceptible cases
plot(t, x(:,2),'R-o')% Infectious cases
plot(t, x(:,3),'G-o')% Recovered cases

legend('Susceptible', 'Infectious', 'Recovered', 'location', 'best');

ylabel('Number of people');
xlabel('Time (days)');

figure;
hold all;
title('Fit model');
plot(t, xo(:,2),'B-o')% Infectious cases
plot(t, xo(:,3),'R-o')% Recovered cases

legend('Infectious', 'Recovered + Deaths', 'location', 'best');

ylabel('Number of people');
xlabel('Time (days)');
