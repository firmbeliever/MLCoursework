function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

expt = ones(m,1);
expt = X * theta;
diff = ones(m,1);
diff = expt - y;
diff = diff.^2;
addDiffs = sum(diff);
J = addDiffs / (2*m);

thetaCopy = theta;
thetaCopy(1) = 0;
regParam = lambda / (2*m) * sum(thetaCopy.^2);
J = J + regParam;

% =========================================================================

diff = expt - y;
grad = (X' * diff) / m;
gradRegParam = (lambda / m) * thetaCopy;
grad = grad + gradRegParam;

grad = grad(:);

end
