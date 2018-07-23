function [ total_time ] = path_time( pts, varargin )
%PATH_TIME Computes the time spent for this trajectory
%SIMPLE_TIME: compute the duration based on the first and the last points

    SIMPLE_TIME = 0; %activates end-start time
    for i = 1:length(varargin)
        if isequal(varargin{i},'SIMPLE_TIME')
            SIMPLE_TIME = 1;
        end
    end
    
    total_time = 0;

    if size(pts,1) < 3 || size(pts,2) < 3
        return
    end
      
    if SIMPLE_TIME
        total_time = pts(end,1)-pts(1,1);
    else
        for i = 2:size(pts,1)
            total_time = total_time + (pts(i,1)-pts(i-1,1));
        end
    end
end

