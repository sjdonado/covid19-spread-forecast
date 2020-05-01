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

Confirmed = [];
Deaths = [];
Recovered = [];
Time = datetime(zeros(1,1), 0, 0);

last_date = datetime(0, 0, 0);
for i = 1:size(T, 1)
    row = T(i, :);
    date = split(row.diagnosis_date, 'T');
    date = split(string(date(1,1)), '-');
    diagnosis_date = datetime(str2num(date(1)),str2num(date(2)),str2num(date(3)));
    if diagnosis_date ~= last_date
        Recovered(end + 1) = 0;
        Confirmed(end + 1) = 0;
        Deaths(end + 1) = 0;
        if last_date == datetime(0, 0, 0)
            Time(end) = diagnosis_date;
        else
            Time(end + 1) = diagnosis_date;
        end
        last_date = diagnosis_date;
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