% Cleaning
clc;
clear all;
close all;

% Add functions subdir
addpath './functions'; 

% Extract and re-label data
T = readtable('data/reported_cases.csv');
T.Properties.VariableNames = {'id_case', 'diagnosis_date','city', ...
    'department', 'current_status', 'age', 'sex', 'type', ...
    'country_of_origin'};

T.diagnosis_date.Format = 'dd/MM/uu';

% Lowercase the current_status column. Some labels have capital letter
T.current_status = lower(T.current_status);

% Represent the current_state attribute with a nominal value
% Recovered = -1, Infected = 0, Dead: 1
T.current_status(strcmp(T.current_status, 'recuperado')) = {-1};
T.current_status(strcmp(T.current_status, 'recuperado (hospital)')) = {-1};

T.current_status(strcmp(T.current_status, 'casa')) = {0};
T.current_status(strcmp(T.current_status, 'hospital')) = {0};
T.current_status(strcmp(T.current_status, 'hospital uci')) = {0};

T.current_status(strcmp(T.current_status, 'fallecido')) = {1};

T.current_status = cell2mat(T.current_status);
% X = dir_until(T, '05/03/2020');

% disp(X);