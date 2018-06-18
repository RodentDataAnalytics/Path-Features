function [ CVri,distance_average,distance_median,distance_iqr ] = path_inner_radius_variation( pts,varargin )
%PATH_INNER_RADIOUS_VARIATION returns various metrics regarding the minimum 
%enclosing ellipsoid
%Formula: CVri = IQR(ri) / Median(ri), where:
% CVri: inner radius variation
% IQR(ri): the IQR value of the distance between each point of the path to
%          the center of the minimum enclosing ellipsoid.
% Median(ri): same as above for the median

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
    % need first the centre of the minimum enclosing ellipsoid and the
    % minor axis
    [x0, y0] = path_boundaries(pts);
    
    %original was /arena_radius
    %distance = sqrt( power(pts(:, 2-k) - x0, 2) + power(pts(:, 3-k) - y0, 2) ) / rm;   
    distance = sqrt( power(pts(:, 2-k) - x0, 2) + power(pts(:, 3-k) - y0, 2) );   
    
    distance_average = mean(distance);
    distance_median = median(distance);
    distance_iqr = iqr(distance);
    
    CVri = distance_iqr / distance_median;  
end

