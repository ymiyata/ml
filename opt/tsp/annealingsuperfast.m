function newx = annealingsuperfast(optimValues,problem)
%ANNEALINGFAST Generates a point using Student's t distribution
%   NEWX = ANNEALINGFAST(optimValues,problem) generates a point based on
%   the current point and the current temperature using Student's t
%   distribution. 
%
%   OPTIMVALUES is a structure containing the following information:
%              x: current point 
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration 
%             t0: start time
%              k: annealing parameter
%            tau: threshold acceptance sequence
%
%   PROBLEM is a structure containing the following information:
%      objective: function handle to the objective function
%             x0: the start point
%           nvar: number of decision variables
%             lb: lower bound on decision variables
%             ub: upper bound on decision variables
%
%   Example:
%    Create an options structure using ANNEALINGFAST as the annealing
%    function
%    options = saoptimset('AnnealingFcn' ,@annealingfast);


%   Copyright 2006-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2008/10/08 17:11:07 $

currentx = optimValues.x;
nvar = numel(currentx);
newx = currentx;
y = randn(nvar,1);
y = y./norm(y);
newx(:) = currentx(:) + (optimValues.temperature).^2.*y;

newx = sahonorbounds(newx,optimValues,problem);
end

function newx = sahonorbounds(newx,optimValues,problem)
% SAHONORBOUNDS ensures that the points that SIMULANNEAL and THRESHACCEPT
%    move forward with are always feasible.  It does so by checking to see
%    if the given point is outside of the bounds, and then if it is,
%    creating a point called which is on the bound that was being violated
%    and then generating a new point on the line between the previous point
%    and the projnewx. It is assumed that optimValues.x is within bounds.

%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2006/11/11 22:43:25 $

% Return if the problem is unbounded
if ~problem.bounded
    return
end

xin = newx; % Get the shape of input
newx = newx(:); % make a column vector
lb = problem.lb;
ub = problem.ub;
lbound = newx < lb;
ubound = newx > ub;
alpha = rand;
% Project newx to the feasible region; get a random point as a convex
% combination of proj(newx) and currentx (already feasible)
if any(lbound) || any(ubound)
    projnewx = newx;
    projnewx(lbound) = lb(lbound);
    projnewx(ubound) = ub(ubound);
    newx = alpha*projnewx + (1-alpha)*optimValues.x(:);
    % Reshape back to xin
    newx = reshapeinput(xin,newx);
else
    newx = xin;
end
end
