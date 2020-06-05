function S = SIR(X,t)
% SIR model.
%
% Input
%   X(1): beta: scalar [1x1]: Infection rate
%   X(2): gamma: scalar [1x1]: Recover rate
%   X(3): scalar [1x1]: Initial number of susceptible cases
%   X(4): scalar [1x1]: Initial number of infectious cases
%   X(5): scalar [1x1]: Initial number of recovered cases
%   X(5): scalar [1x1]: Initial number of recovered cases
%   t: scalar [1x1]: Days numbers
%
% Output
%   X: vector [3xN] of the target time-histories of the
%      [susceptible, infectious, recovered] cases


x0 = X(3:5);
% function dx = dx(~, x)
%     dx(1) = -X(1) * x(1) * x(2);
%     dx(2) =  X(1) * x(1) * x(2) - X(2) * x(2);
%     dx(3) =  X(2) * x(2);
%     dx = [dx(1),dx(2),dx(3)]';
% end
function dx = dx(~, x)
    dx = zeros(3,1);
    dx(1) = -X(1) .* x(1) .* x(2);
    dx(2) =  X(1) .* x(1) .* x(2) - X(2) .* x(2);
    dx(3) =  X(2) .* x(2);
end

[~, S] = ode15s(@dx, t, x0);
end
