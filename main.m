% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
table = readtable('data/Casos_positivos_de_COVID-19_en_Colombia.csv');
[Confirmed, Deaths, Recovered, Time] = get_data_COVID(table);

sum(Confirmed)+sum(Deaths)+sum(Recovered) % Expected value: 6211

%beta = 1;
beta = 0.214;
%gamma = 1/5;
gamma = 1 / 28;
tmax = size(Time, 2) / 7;

S0 = 49.65e6; % Colombia population

[t,x] = SIR(S0,Confirmed(1,1),Recovered(1,1),beta,gamma,tmax);

figure;
hold all;
plot(t,x(:,1),'B-o')% Susceptible cases
plot(t,x(:,2),'R-o')% Infectious cases
plot(t,x(:,3),'G-o')% Recovered cases

legend('Susceptible', 'Infectious', 'Recovered', 'location', 'best');

ylabel('Number of people');
xlabel('Time');