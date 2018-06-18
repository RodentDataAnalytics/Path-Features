function [ total_length ] = path_length( pts, varargin )
%PATH_LENGTH Computes the length of the trajectory
%tolerance: compute only if length between points is more than this value

    SIMPLE_LENGTH = 0;
	PATH_LENGTH_TOLERANCE = 0;
	
    for i = 1:length(varargin)
        if isequal(varargin{i},'SIMPLE_LENGTH')
            SIMPLE_LENGTH = varargin{i+1};
        elseif isequal(varargin{i},'PATH_LENGTH_TOLERANCE')
			PATH_LENGTH_TOLERANCE = varargin{i+1};
        end
    end

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
    total_length = 0;
    
    if SIMPLE_LENGTH
        %compute the length between final and start points
        total_length = sqrt( (pts(end,2-k)-pts(1,2-k))^2 + (pts(end,3-k)-pts(1,3-k))^2 );
    else
        for i = 2:size(pts,1)
            d = sqrt( (pts(i,2-k)-pts(i-1,2-k))^2 + (pts(i,3-k)-pts(i-1,3-k))^2 );
            if d > PATH_LENGTH_TOLERANCE
                total_length = total_length + d;
            end
        end
    end
    
    %Alternative Way: results almost the same (difference = -9.0949e-13)
    % for i = 2:size(pts, 1)
    %     % compute the length in cm and seconds
    %     total_length = total_length + norm( pts(i, 2:3) - pts(i-1, 2:3) );        
    % end 
end

