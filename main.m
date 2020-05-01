% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
table = readtable('data/Casos_positivos_de_COVID-19_en_Colombia.csv');
[Confirmed, Deaths, Recovered, Time] = get_data_COVID(table);

sum(Confirmed) + sum(Deaths) + sum(Recovered) % Expected value: 6211

%beta = 1;
% beta = 0.214;

% Infection rate
beta = 1.2;

%gamma = 1/5;
% gamma = 1 / 28;

% Recovered rate
gamma = 0.116;

tmax = days(max(Time) - min(Time));

initial_total_victims = Confirmed(1,1) + Recovered(1,1) + Deaths(1,1);
S0 = 49.65e6 - 1; % Colombia population minus total victims

[t,x] = SIR(S0,1,0,beta,gamma,tmax);

figure;
hold all;
plot(t,x(:,1),'B-o')% Susceptible cases
plot(t,x(:,2),'R-o')% Infectious cases
plot(t,x(:,3),'G-o')% Recovered cases

legend('Susceptible', 'Infectious', 'Recovered', 'location', 'best');

ylabel('Number of people');
xlabel('Time (days)');