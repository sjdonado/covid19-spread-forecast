function [Confirmed, Deaths, Recovered, Time] = get_data_COVID(T)
% The function [Confirmed, Deaths, Recovered, Time] = get_data_COVID(table)
% Collect the updated data from the COVID-19 epidemy in Colombia from the
% reported_cases.csv
%
% Authors: sjdonado & brianr482
%
T.Properties.VariableNames = {'id_case', 'notification_date', 'code', ...
    'city', 'department', 'current_status', 'age', 'sex', 'type', ...
    'status', 'country_origin', 'fis', 'death_date', 'diagnosis_date', ...
    'recover_date', 'web_report_date'};

% Lowercase the current_status column. Some labels have capital letter
T.current_status = lower(T.current_status);

T.current_status(strcmp(T.current_status, 'recuperado')) = {'recovered'};
T.current_status(strcmp(T.current_status, 'recuperado (hospital)')) = {'recovered'};
T.current_status(strcmp(T.current_status, 'Recuperado')) = {'recovered'};

T.current_status(strcmp(T.current_status, 'casa')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'Casa')) = {'confirmed'};

T.current_status(strcmp(T.current_status, 'hospital')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'hospital uci')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'Hospital')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'Hospital uci')) = {'confirmed'};

T.current_status(strcmp(T.current_status, 'fallecido')) = {'dead'};
T.current_status(strcmp(T.current_status, 'Fallecido')) = {'dead'};

T = convertvars(T, {'current_status'}, 'categorical');

% Split data into arrays which represent all the possible statuses
DATE_FORMAT = 'yyyy-MM-dd''T''HH:mm:ss.SSS';
diagnosis_dates = datetime(T.diagnosis_date, 'InputFormat', DATE_FORMAT);
death_dates = datetime(T.death_date, 'InputFormat', DATE_FORMAT);
recover_dates = datetime(T.recover_date, 'InputFormat', DATE_FORMAT);

% Get minimum and maximun date in order to build the time range
first_date = datetime(T(1, :).diagnosis_date, 'InputFormat', DATE_FORMAT);
last_date = max([diagnosis_dates ; death_dates ; recover_dates]);

% Preallocating - This is to optimize the filling up process of the 
% arrays returned by the function
total_days = days(last_date - first_date);
Recovered = zeros(total_days, 1);
Confirmed = zeros(total_days, 1);
Deaths = zeros(total_days, 1);

% Create the time range
Time = first_date:last_date;

% Loop through the  defined time range
i = 1;
for date = Time
    Recovered(i) = sum(date == recover_dates);
    Confirmed(i) = sum(date == diagnosis_dates);
    Deaths(i) = sum(date == death_dates);
    i = i + 1;
end