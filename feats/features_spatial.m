function [path_features,path_features_cell,header,header_cell] = features_spatial(paths, arena_x, arena_y, arena_r)
%FEATURES_SPATIAL computes various features based on spatial aspects
% of the path

%INPUT:
% - paths: cell array where each cell is the coordinates (time,x,y,...) or
%          (x,y,...) of a path.
% - arena_x, arena_y: center of the arena
% - arena_r: radius of the arena; for squared arenas it can be half the diagonal

%OUTPUT:
% - path_features:      standalone features
% - path_features_cell: features for meta-analysis (e.g. average)
% - header:             standalone features header
% - header_cell:        features for meta-analysis header

% Update the file with more features:
% - Update either path_features or path_features_cell section
% - Update either header or header_cell variable

%% List of features:
% Features for meta-statistics:
% - angle: angle of every point from the center of the arena
% - distance: distance of every point from the center of the arena
% Standalone features:
% - cent_dipl: center displacement


    header = {'CenterDisplacement'};
    header_cell = {'AngleCenter','DistanceCenter'};

    path_features = [];
    path_features_cell = {};

    for i = 1:length(paths)
        
        path_feature = []; %meta-statistics features
        path_feature_cell = {}; %standalone featues
        
        if iscell(paths) 
            % We may have multiple paths
            pts = paths{i};
        else 
            % We have only 1 path
            pts = paths;
            i = length(paths);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % STANDALONE FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
        % Path center displacement
        cent_dipl = path_centre_displacement(pts, arena_x, arena_y, arena_r);
        path_features = [path_features,cent_dipl];  
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % META_STATS FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Path angle from the center of the arena
        angle = path_angle_from_center( pts, arena_x, arena_y);
        path_feature_cell = [path_feature_cell,{angle}];
        
        % Path distance from the center of the arena
        distance = path_distance_to_center(pts, arena_x, arena_y, arena_r);
        path_feature_cell = [path_feature_cell,{distance}];
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        path_features = [path_features;path_feature];
        path_features_cell = [path_features_cell;path_feature_cell];        
    end
    % THIS LINE NEEDS TO BE REMOVED IF MORE FEATURES ARE ADDED
    path_features = path_features';
end

