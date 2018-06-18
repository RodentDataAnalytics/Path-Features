function dense = path_density(pts)
%PATH_DENSITY measures how dense is the path based on the minimum enclosing
%ellipsoid of its points.

% Based on the minimum enclosing ellipsoid, the less the difference between
% the major and the minor axis the more circular the shape of the
% ellipsoid. More circular ellipsoids may be linked to less exploration
% thus more dense path on a specific area.

    [~, ~, a, b] = path_boundaries(pts);
    
    % the total length of the path is added to the equation because
    % some paths may be more/less lengthy than others.
    total_length = path_length(pts);
    
    dense = (a - b) / total_length;
    
    if isnan(dense)
        dense = 0;
    end
end

