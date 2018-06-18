function [ val ] = path_centre_displacement( pts, arena_x, arena_y, arena_r, varargin )
%PATH_CENTRE_DISPLACEMENT the distance of the center of the minimum
%enclosing ellipsoid to the centre of the arena.
    
    [x0, y0] = path_boundaries(pts);
    
    val = sqrt( (x0 - arena_x)^2 + (y0 - arena_y)^2 ) / arena_r;    
end

