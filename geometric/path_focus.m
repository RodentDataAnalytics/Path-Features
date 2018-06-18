function [ f ] = path_focus( pts, varargin )
%PATH_FOCUS measure how focused the path is inside a certain area

	PATH_LENGTH_TOLERANCE = 0;
    for i = 1:length(varargin)
        if isequal(varargin{i},'PATH_LENGTH_TOLERANCE')
			PATH_LENGTH_TOLERANCE = varargin{i+1};
        end
    end
	
    [~, ~, major, minor] = path_boundaries(pts);
    total_length = path_length(pts,'PATH_LENGTH_TOLERANCE',PATH_LENGTH_TOLERANCE);
    f = 1 - major*minor/(total_length^2 / (4*pi)); 
end

