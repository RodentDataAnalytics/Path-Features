function [angle_average,angle_median,angle_iqr,angle] = path_angle_from_center( pts, arena_x, arena_y, varargin )
%PATH_ANGLE_FROM_CENTER computes the angle of each trajectory point from
%the center of the arena.

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end

    angle = [];
    
    for i = 1:size(pts,1)
        %find the distance of the point from the x-axis
        dy = abs(pts(i,3-k)-arena_y);
        %find the distance of the point from the y-axis
        dx = abs(pts(i,2-k)-arena_x);
        %angle
        theta = atan(dy/dx);

        if isnan(theta) || isinf(theta) || ~isreal(theta)
            theta = 0;
        end
        
        angle = [angle ; theta];
    end
    
    angle_average = mean(angle);
    angle_median = median(angle);
    angle_iqr = iqr(angle);  
end

