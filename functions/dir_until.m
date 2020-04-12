function [X] = dir_until(T, date)
% DIR From This function parses and returns all cases occurred between the
% time 0 and the given date
%   The parsed structure is an array with 3 indices:
%   0 -> Recovered
%   1 -> Infected
%   2 -> Dead

% Filter by the given date
T = T.current_status(T.diagnosis_date <= date);

% Get all possible classes
classes = unique(T);

% Preallocating
X = zeros(0, length(classes));

% Populate the output with the explained format
for class_index = 1:length(classes)
    class = classes(class_index);
    X(class_index) = length(find(T == class));
end

