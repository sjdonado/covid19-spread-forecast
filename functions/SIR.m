function [T,X] = SIR(S0,I0,R0,beta,gamma,tmax)
% SIR model.
%
% Input
%   S0: scalar [1x1]: Initial number of susceptible cases
%   I0: scalar [1x1]: Initial number of infectious cases
%   R0: scalar [1x1]: Initial number of recovered cases
%   beta: scalar [1x1]: Infection rate
%   gamma: scalar [1x1]: Cure rate
%   tmax: scalar [1x1]: Forecast limit (by weeks)
%
% Output
%   T: vector [1xN] time indexes
%   X: vector [3xN] of the target time-histories of the
%      [susceptible, infectious, recovered] cases

function dx = epi(~,x)
    dx = zeros(3,1);
    dx(1) = (-beta*x(1)*x(2)/S0);
    dx(2) = (+beta*x(1)*x(2)/S0) - gamma*x(2);
    dx(3) = +gamma*x(2);
end

[T,X] = ode45(@epi,[0 tmax],[S0,I0,R0]);
end
