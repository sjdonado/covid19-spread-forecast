function [T,X] = SEIR(S0,E0,I0,R0,beta,gamma,sigma,tmax)
% SEIR model.
%
% Input
%   S0: scalar [1x1]: Initial number of susceptible cases
%   E0: scalar [1x1]: Initial number of exposed cases
%   I0: scalar [1x1]: Initial number of infectious cases
%   R0: scalar [1x1]: Initial number of recovered cases
%   beta: scalar [1x1]: Infection rate
%   gamma: scalar [1x1]: Cure rate
%   sigma: scalar [1x1]: Incubate rate
%
% Output
%   T: vector [1xN]
%   X: vector [3xN]

function dx = epi(~,x)
    dx = zeros(4,1);
    dx(1) = (-beta*x(1)*x(2)/S0);
    dx(4) = (+beta*x(1)*x(2)/S0)-(sigma)*x(4);
    dx(2) = sigma*x(4)-(gamma)*x(2);
    dx(3) = gamma*x(2);
end

[T,X]= ode45(@epi,[0 tmax],[S0,I0,R0,E0]);
end
