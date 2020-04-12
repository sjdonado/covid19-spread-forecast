function [Confirmed, Deaths, Recovered, Time] = get_data_COVID(T)
% The function [Confirmed, Deaths, Recovered, Time] = get_data_COVID(table)
% Collect the updated data from the COVID-19 epidemy in Colombia from the
% reported_cases.csv
%
% Author: sjdonado
%
T.Properties.VariableNames = {'id_case', 'diagnosis_date','city', ...
    'department', 'current_status', 'age', 'sex', 'type', ...
    'country_of_origin'};

T.diagnosis_date.Format = 'dd/MM/uu';

% Lowercase the current_status column. Some labels have capital letter
T.current_status = lower(T.current_status);

% Represent the current_state attribute with a nominal value
% Recovered = -1, Confirmed = 0, Dead: 1
T.current_status(strcmp(T.current_status, 'recuperado')) = {'recovered'};
T.current_status(strcmp(T.current_status, 'recuperado (hospital)')) = {'recovered'};

T.current_status(strcmp(T.current_status, 'casa')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'hospital')) = {'confirmed'};
T.current_status(strcmp(T.current_status, 'hospital uci')) = {'confirmed'};

T.current_status(strcmp(T.current_status, 'fallecido')) = {'dead'};

T = convertvars(T, {'city', 'department', 'current_status', 'sex', 'type', 'country_of_origin'}, 'categorical');

Confirmed = [];
Deaths = [];
Recovered = [];
Time = datetime(zeros(1,1), 0, 0);

last_date = datetime(0, 0, 0);
for i = 1:size(T, 1)
    row = T(i, :);
    if row.diagnosis_date ~= last_date
        Recovered(end + 1) = 0;
        Confirmed(end + 1) = 0;
        Deaths(end + 1) = 0;
        if last_date == datetime(0, 0, 0)
            Time(end) = row.diagnosis_date;
        else
            Time(end + 1) = row.diagnosis_date;
        end
        last_date = row.diagnosis_date;
    end

    if row.current_status == "recovered"
        Recovered(end) = Recovered(end) + 1;
    end
    if row.current_status == "confirmed"
        Confirmed(end) = Confirmed(end) + 1;
    end
    if row.current_status == "dead"
        Deaths(end) = Deaths(end) + 1;
    end
end
end