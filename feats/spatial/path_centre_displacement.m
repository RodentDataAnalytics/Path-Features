function [ val ] = path_centre_displacement( pts, arena_x, arena_y, arena_r )
%PATH_CENTRE_DISPLACEMENT computes the distance between the center of the 
%minimum enclosing ellipsoid and the centre of the arena.
    
    [x0, y0] = path_boundaries(pts);
    
    val = sqrt( (x0 - arena_x)^2 + (y0 - arena_y)^2 ) / arena_r;    
end

