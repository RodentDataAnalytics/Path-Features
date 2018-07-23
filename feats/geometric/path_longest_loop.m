function max_loop = path_longest_loop( pts, varargin )
%PATH_LONGEST_LOOP measures the length of the longest loop, or 
%self-intersecting sub-segment of the path.
%To compute this value all pairs of lines defined by two consecutive 
%trajectory points were tested for intersection. If no intersection was 
%present a value of zero was assigned to the feature.
%https://www.nature.com/articles/srep14562

    ext = 40;
    
    for i = 1:length(varargin)
        if isequal(varargin{i},'EXTENSION')
            ext = varargin{i+1};
        end
    end
    
    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end

    d = zeros(size(pts, 1) - 1, 2);
    % compute direction vectors for each pair of points
    for i = 2:size(pts, 1)
        d(i - 1, :) = pts(i, 2-k:3-k) - pts(i - 1, 2-k:3-k);
    end

    max_loop = 0;
    % for each pair of line segments
    i = 1;
    while i < length(d)
        for j = (i + 2):length(d)
            rs = cross(d(i, :), d(j, :));
            if rs ~= 0  % check if they intersect               
                % vector from starting points of the 2 segments            
                pq = pts(j, 2-k:3-k) - pts(i, 2-k:3-k);
                t = cross(pq, d(j, :)) / rs;
                u = cross(pq, d(i, :)) / rs;
                
                intersect = 0;
                if t >= 0 && t <= 1 && u >= 0 && u <= 1
                    % they intersect, compute length of loop
                    intersect = 1;                    
                elseif (i == 1 && u >= 0 && u<= 1)
                   % first segment would self-cross the trajectory if
                   % extended further; see how far                   
                   e = norm(d(i, :))*abs(t) + norm(d(j, :))*u;
                   if t < 0 && e <= ext
                       intersect = 1;
                   end                    
                elseif (j == size(d, 1) && t >=0 && t<= 1)
                   % last segment, do the same check if we project it
                   % further                   
                   e = norm(d(i, :))*(1 - t) + norm(d(j, :))*abs(u);
                   if u > 0 && e < ext 
                       intersect = 1;
                   end
                end
                
                if intersect
                    l = sum(sqrt( d( (i + 1):(j - 1), 1).^2 + d( (i + 1):(j - 1), 2).^2 ));                    
                    l = l + norm(d(i, :))*(1 - t) + norm(d(j, :))*u;
                    max_loop = max(l, max_loop);       
                    i = j;
                    break;
                end
            end            
        end
        i = i + 1;
    end
    
    
    function v = cross(x, y)
        v = x(1)*y(2) - x(2)*y(1);
    end        

end

