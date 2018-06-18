function [ distance_average, distance_median, distance_iqr ] = path_distance_to_center(pts,center_x,center_y,arena_radius,varargin)
%PATH_DISTANCE_TO_CENTER computes the average, mean and IQR distance to the centre of the arena.
%Average, Median and IQR are computed.

    k = 0;
    if size(pts,1) == 2 %no time
        k = 1;
    end
    
    distance = sqrt( power(pts(:, 2-k) - center_x, 2) + power(pts(:, 3-k) - center_y, 2) ) / arena_radius;   
    
    distance_average = mean(distance);
    distance_median = median(distance);
    distance_iqr = iqr(distance);
end

