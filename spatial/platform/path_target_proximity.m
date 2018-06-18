function [ val ] = path_target_proximity( pts, platform_x, platform_y, platform_r, varargin )
%PATH_TARGET_PROXIMITY measures the percentage of the path lying within a 
%circle centred at the platform and with a radius of r times the platform 
%radius (default r=6).

    r = 6;
    for i = 1:length(varargin)
        if isequal(varargin{i},'RADIUS_PROXIMITY')
            r = varargin{i+1};
        end
    end
    
    r = r*platform_r;
    
    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
    x0 = platform_x;
    y0 = platform_y;

    ltot = 0;
    lins = 0;
    for i = 2:size(pts, 1)
       % direction vector of trajectory segment
       d = pts(i, 2-k:3-k) - pts(i - 1, 2-k:3-k);
       % vector from centre of platform to segment start
       f = pts(i - 1, 2-k:3-k) - [x0, y0];
       
       a = d*d';
       b = 2*(f*d');
       c = f*f' - r^2;
       disc = b^2 - 4*a*c;
       
       lseg = norm(pts(i, 2-k:3-k) - pts(i - 1, 2-k:3-k));
       ltot = ltot + lseg;
       if disc >= 0           
           % there is an intersection with the platform
           disc = sqrt(disc);
           t1 = (-b - disc) / (2*a);
           t2 = (-b + disc) / (2*a);
           % check cases
           if t1 >= 0 && t1 <= 1
               % beginning of segment crossed the circle
               if t2 >= 0 && t2 <= 1
                    % segment crosses and overshoots the circle
                   lins = lins + (t2 - t1)*lseg;
               else
                   % entered the circle area
                   lins = lins + (1 - t1)*lseg;                   
               end
           elseif t2 >= 0 && t2 <= 1
               % left the circle area
               lins = lins + t2*lseg;
           elseif norm(pts(i - 1, 2-k:3-k) - [x0, y0]) <= r ...
               && norm(pts(i, 2-k:3-k) - [x0, y0]) <= r
               % segment fully contained in the circle
               lins = lins + lseg;
           end
       end              
    end   
    
    val = lins / ltot;
end

