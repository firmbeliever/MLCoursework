function [J grad] = nnCostTest(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

% Add ones to the X data matrix
X = [ones(m, 1) X];
sums = 0;

for i=1:m
  %for k=1:num_labels
    
    a2s = zeros(1, hidden_layer_size);
    a3s = zeros(num_labels, 1);
    expected = zeros(num_labels, 1);
    for hidUnitID = 1:hidden_layer_size
      a2s(hidUnitID) = sigmoid(X(i, :) * Theta1(hidUnitID, :)');
    end
    a2s = [1 a2s];
    for outUnitID = 1:num_labels
      a3s(outUnitID) = sigmoid(a2s * Theta2(outUnitID, :)');
      expected(outUnitID) = (y(i) == outUnitID);
    end
    costs = (-expected .* log(a3s))  -  ((1-expected) .* log(1 - a3s));
    sums = sums + sum(costs(:));
 
end

J = sums / m;


%y_matrix = eye(num_labels)(y,:);
%z2 = X * Theta1';
%a2 = sigmoid(z2);
%a2 = [ones(m, 1) a2];
%z3 = a2 * Theta2';
%a3 = sigmoid(z3);
%c = (-y_matrix .* log(a3)) - ((1 - y_matrix) .* log(1 - a3));
%J = sum(c(:)) / m;

%regularize
%t1 = Theta1;
%t1(:,1) = 0;
%t2 = Theta2;
%t2(:,1) = 0;
%t1 = t1.^2;
%t2 = t2.^2;
%d = sum(t1(:)) + sum(t2(:));
%e = d * lambda / (2 * m);
%J = J + e;
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


%d3 = a3 - y_matrix;
%T2noBias = Theta2(:,2:end);
%d2 = (d3 * T2noBias) .* sigmoidGradient(z2);
%Delta1 = d2' * X;
%Delta2 = d3' * a2;
%Theta1_grad = Delta1 / m;
%Theta2_grad = Delta2 / m;


%regularize
%Theta1(:,1) = 0;
%Theta2(:,1) = 0;
%reg1 = (lambda / m) * Theta1;
%reg2 = (lambda / m) * Theta2;
%Theta1_grad = Theta1_grad + reg1;
%Theta2_grad = Theta2_grad + reg2;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
