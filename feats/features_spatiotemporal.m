function [path_features,path_features_cell,header,header_cell] = features_spatiotemporal(paths)
%FEATURES_SPATIAL computes various features based on temporal and
%spatiotemporal aspects of the path

%INPUT:
% - paths: cell array where each cell is the coordinates (time,x,y,...) of
%          a path.
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
% - angular_speed: angular (every three points)
% - speed: speed (every two points)
% Standalone features:
% - total_time: duration of the path

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
        
        if size(pts,2) < 3
            error('features_spatial: ')
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % STANDALONE FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Path diration
        total_time = path_time(pts);
        path_features = [path_features,total_time];
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % META_STATS FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Path angular speed
        angular_speed = path_angular_speed(pts);
        path_feature_cell = [path_feature_cell,{angular_speed}];

        % Path speed
        %'PATH_SPEED_TOLERANCE',0: compute only if length between points is more than this value
        speed = path_speed(pts,'PATH_SPEED_TOLERANCE',0); 
        path_feature_cell = [path_feature_cell,{speed}];
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        path_features = [path_features;path_feature];
        path_features_cell = [path_features_cell;path_feature_cell];        
    end
    % THIS LINE NEEDS TO BE REMOVED IF MORE FEATURES ARE ADDED
    path_features = path_features';
end

