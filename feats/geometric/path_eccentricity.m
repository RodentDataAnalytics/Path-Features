function [ eccentricity ] = path_eccentricity( pts,varargin )
%PATH_ECCENTRICITY measures how elongated is the path

    %major and minor axes of the enclosing ellipsoid
    [~, ~, a, b] = path_boundaries(pts);
    
    eccentricity = sqrt(1 - b^2/a^2);

    if isnan(eccentricity)
        eccentricity = 0;
    end
end

