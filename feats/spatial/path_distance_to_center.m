function [distance] = path_distance_to_center(pts,center_x,center_y,arena_r)
%PATH_DISTANCE_TO_CENTER computes the the distance of every point to the 
%centre of the arena.

    k = 0;
    if size(pts,1) == 2 %no time
        k = 1;
    end
    
    distance = sqrt( power(pts(:, 2-k) - center_x, 2) + power(pts(:, 3-k) - center_y, 2) ) / arena_r;   
end

