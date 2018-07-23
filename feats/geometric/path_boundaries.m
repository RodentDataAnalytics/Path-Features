function [ x, y, a, b, R ] = path_boundaries( pts,varargin )
%PATH_BOUNDARIES computes ellipsoid enclosing metrics of a set of points.

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end

    x = 0; %centre of the elipse (x)
    y = 0; %centre of the elipse (y)
    a = 0; %ellipse major axis   
    b = 0; %ellipse minor axis
    R = zeros(2,2); %ellipse rotation matrix

    if size(pts, 1) > 3
        %A = area of the minimum enclosing ellipse
        [A, cntr] = MinVolEllipse(pts(:, 2-k:3-k)', 1e-2);
        x = cntr(1);
        y = cntr(2);
        if (sum(isinf(A)) + sum(isnan(A))) == 0
            [a, b, R] = ellipse_parameters(A);
        end
    end    
end

