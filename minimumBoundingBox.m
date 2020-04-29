function [ planeEqs, U, xMean ] = minimumBoundingBox( X )
%minimumBoundingBox - Computes the minimum bounding box planes of
% a set of datapoints
%   Input:
%       X - M*N matrix with N data samples and M dimentions/features
%   Outputs:
%       planeEqs - Cell array with bounding plane parameters
%       U        - Matrix with principal directions in the columns
%       xMean    - Dataset mean / central point

[M, N] = size(X);

% Remove the mean so that the SVD can find the principal directions without
% this constant offset
xMean = mean(X,2);
xCentered = X - xMean*ones(1,N);

% Compute the SVD
[U,S,~] = svd(xCentered);

% U has principal directions of the data in the columns
% S has the magnitudes of the directions

% The principal directions of the data are also the normal vectors of the
% planes that constitute the minimum bounding box
% All it takes to find the plane equations is to find a point that lies in
% the boundary

% Alocate an empty cell array to store intermediate variables and finally
% the plane equations
planeEqs = cell(M,2);

% For each principal direction
for i = 1:M
    pd = U(:,i);
    
    % Each principal direction is the normal of two bounding planes.
    % One plane bounds the data from below and the other from above
    % To find the extremes along the principal direction we project the
    % points onto it (with the dot product)

    pointsAlongPD = pd'*xCentered;
    
    % Save indices of extremum points
    [ ~, planeEqs{i,1} ] = min(pointsAlongPD);
    [ ~, planeEqs{i,2} ] = max(pointsAlongPD);

    % Calculate plane equations
    % In the point-normal form we have the normal to the plane a point that
    % belongs to the plane. All it takes is to find the the scalar
    % variable.
    % Plane equation reference: https://en.wikipedia.org/wiki/Plane_(geometry)#Point-normal_form_and_general_form_of_the_equation_of_a_plane
    
    % Each cell contains the scalar
    planeEqs{i,1} = -pd'*X(:, planeEqs{i,1});
    planeEqs{i,2} = -pd'*X(:, planeEqs{i,2});
    
    % Each cell contains the full vector that characterizes the plane
    % The first column stores planes that bound the data from below and the
    % second column stores planes bound the data from above
    planeEqs{i,1} = [pd; planeEqs{i,1}];
    planeEqs{i,2} = [pd; planeEqs{i,2}];
end

end

