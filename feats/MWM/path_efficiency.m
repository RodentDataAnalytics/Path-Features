function [ eff ] = path_efficiency( pts,platform_x,platform_y)
%PATH_EFFICIENCY computes the ratio between the minimum distance from the
%starting location to the platform and the total distance

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
    %minimum distance to platform centre from the start position
    min_path = norm( pts(1, 2-k) - platform_x, pts(1, 3-k) - platform_y );
    %trajectory total length
    total_length = path_length(pts,'PATH_LENGTH_TOLERANCE',0);
    
    if total_length ~= 0
        eff = min_path / total_length;
    else
        eff = 0;
    end       
end

