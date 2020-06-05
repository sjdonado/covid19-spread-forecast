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
beta = 1.2;

% Recovered rate
gamma = sum(Recovered) / sum(Confirmed);

total_days = days(max(Time) - min(Time));

initial_total_victims = Confirmed(1,1) + Recovered(1,1) + Deaths(1,1);
S0 = 49.65e6; % Colombia population

t = (1:total_days);
% Subtract to S0 the first infected
x = SIR([beta, gamma, S0 - 1, 1, 0], t);

% Optimize beta and gamma estimation fitting the given confirmed cases
% Init sir params
I = cumsum(Confirmed);
R = cumsum(Deaths + Recovered);
S = ones(size(t, 1), 1) * S0 - (I + R);
data = [S(:) I(:) R(:)];

% Initialize beta and gamma randomly
init = [rand(2,1)*1E-2;  data(1,:)'];

% Ask about why opt_params(4) is negative
% Ask about what means optimize the initial condition
% Ask about this function, is it the best approach? (due internally uses
% least-squares)
[opt_params, ResNorm] = lsqcurvefit(@SIR, init, t(:), data(2:end, :));

% Tem fix: to future sent only opt_params
xo = SIR([opt_params(1), opt_params(2), S0 - 1, 1, 0], t);

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
title('Optimized params');
plot(t, xo(:,1),'B-o')% Susceptible cases
plot(t, xo(:,2),'R-o')% Infectious cases
plot(t, xo(:,3),'G-o')% Recovered cases

legend('Susceptible', 'Infectious', 'Recovered', 'location', 'best');

ylabel('Number of people');
xlabel('Time (days)');
