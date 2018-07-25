function [A , c] = MinVolEllipse(P, tolerance)
% [A , c] = MinVolEllipse(P, tolerance)
% Finds the minimum volume enclsing ellipsoid (MVEE) of a set of data
% points stored in matrix P. The following optimization problem is solved: 
%
% minimize       log(det(A))
% subject to     (P_i - c)' * A * (P_i - c) <= 1
%                
% in variables A and c, where P_i is the i-th column of the matrix P. 
% The solver is based on Khachiyan Algorithm, and the final solution 
% is different from the optimal value by the pre-spesified amount of 'tolerance'.
%
% inputs:
%---------
% P : (d x N) dimnesional matrix containing N points in R^d.
% tolerance : error in the solution with respect to the optimal value.
%
% outputs:
%---------
% A : (d x d) matrix of the ellipse equation in the 'center form': 
% (x-c)' * A * (x-c) = 1 
% c : 'd' dimensional vector as the center of the ellipse. 
% 
% example:
% --------
%      P = rand(5,100);
%      [A, c] = MinVolEllipse(P, .01)
%
%      To reduce the computation time, work with the boundary points only:
%      
%      K = convhulln(P');  
%      K = unique(K(:));  
%      Q = P(:,K);
%      [A, c] = MinVolEllipse(Q, .01)
%
%
% Nima Moshtagh (nima@seas.upenn.edu)
% University of Pennsylvania
%
% December 2005
% UPDATE: Jan 2009

% Extended code comments by Tiago V. Gehring

% Also see:
% Moshtagh, N., 2005. Minimum volume enclosing ellipsoid. 
% Convex Optimization, 111, p.112.

MAX_ITER = 100000; % add a break to the loop (Avgoustinos Vouros, 2018)

%%%%%%%%%%%%%%%%%%%%% Solving the Dual problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------
% data points 
% -----------------------------------
[d, N] = size(P);

% Q is a 3xN matrix
Q = zeros(d+1,N);
Q(1:d,:) = P(1:d,1:N);
Q(d+1,:) = ones(1,N);


% initializations
% -----------------------------------
count = 1;
err = 1;
% u is an Nx1 vector where each element is 1/N
u = (1/N) * ones(N,1);  % 1st iteration


% Khachiyan Algorithm
% -----------------------------------
while err > tolerance
    % Matrix multiplication
    X = Q * diag(u) * Q';       % X = \sum_i ( u_i * q_i * q_i')  is a (d+1)x(d+1) matrix
    M = diag(Q' * inv(X) * Q);  % M the diagonal vector of an NxN matrix
    
    % Find the value and location of the maximum element in the vector M
    [maximum, j] = max(M);
    
    % Calculate the step size for the ascent
    step_size = (maximum - d -1)/((d+1)*(maximum-1));
    
    % Calculate the new_u
    new_u = (1 - step_size)*u ;
    
    % Increment the jth element of new_u by step_size
    new_u(j) = new_u(j) + step_size;
    
    % Store the error by taking finding the square root of the SSD 
    % between new_u and u  
    err = norm(new_u - u);
    
    % Increment count and update u
    count = count + 1;
    u = new_u;
    if count > MAX_ITER
        break
    end
end



%%%%%%%%%%%%%%%%%%% Computing the Ellipse parameters %%%%%%%%%%%%%%%%%%%%%%
% Finds the ellipse equation in the 'center form': 
% (x-c)' * A * (x-c) = 1
% It computes a dxd matrix 'A' and a d dimensional vector 'c' as the center
% of the ellipse. 

U = diag(u);

% the A matrix for the ellipse
% --------------------------------------------
A = (1/d) * inv(P * U * P' - (P * u)*(P*u)' );


% center of the ellipse 
% --------------------------------------------
c = P * u;
