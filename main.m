% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
T = readtable('data/reported_cases.csv');
[Confirmed, Deaths, Recovered, Time] = get_data_COVID(T);

tic
% If the number of confirmed Confirmed cases is small, it is difficult to know whether
% the quarantine has been rigorously applied or not. In addition, this
% suggests that the number of infectious is much larger than the number of
% confirmed cases
minNum= max(5,round(0.025*max(Confirmed)));
Recovered(Confirmed<=minNum)=[];
Deaths(Confirmed<=minNum)=[];
Time(Confirmed<=minNum)= [];
Confirmed(Confirmed<=minNum)=[];

Npop = 49.65e6; % Colombia population

% Definition of the first estimates for the parameters
alpha_guess = 0.06; % protection rate
beta_guess = 0.9; % Infection rate
LT_guess = 5; % latent time in days
Q_guess = 0.5; % rate at which infectious people enter in quarantine
lambda_guess = [0.1,0.05]; % recovery rate
kappa_guess = [0.1,0.05]; % death rate

guess = [alpha_guess,...
    beta_guess,...
    1/LT_guess,...
    Q_guess,...
    lambda_guess,...
    kappa_guess];

% Initial conditions
E0 = Confirmed(1); % Initial number of exposed cases. Unknown but unlikely to be zero.
I0 = Confirmed(1); % Initial number of infectious cases. Unknown but unlikely to be zero.
Q0 = Confirmed(1);
R0 = Recovered(1);
D0 = Deaths(1);

Active = Confirmed-Recovered-Deaths;
Active(Active<0) = 0; % No negative number possible
[alpha1,beta1,gamma1,delta1,Lambda1,Kappa1] = ...
    fit_SEIQRDP(Active,Recovered,Deaths,Npop,E0,I0,Time,guess,'Display','off');


dt = 0.1; % time step
time1 = Time(1):dt:Time(end);
N = numel(time1);
t = [0:N-1].*dt;


% Call of the function SEIQRDP.m with the fitted parameters
[S,E,I,Q,R,D,P] = SEIQRDP(alpha1,beta1,gamma1,delta1,Lambda1,Kappa1,Npop,E0,I0,Q0,R0,D0,t);

clf;close all;
figure

semilogy(time1,Q,'r',time1,R,'b',time1,D,'k', 'linewidth', 2);
hold on
semilogy(Time,Active,'m',Time,Recovered,'g',Time,Deaths,'c', 'linewidth', 2);
% ylim([0,1.1*Npop])
ylabel('Number of cases')
xlabel('Time (days)')
leg = {'Confirmed (fitted)',...
'Recovered (fitted)','Deceased (fitted)',...
'Confirmed (reported)','Recovered (reported)','Deceased  (reported)'};

legend(leg{:},'location','best');
set(gcf,'color','w')

grid on
axis tight
set(gca,'yscale','lin')

toc