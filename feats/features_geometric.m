function [path_features,path_features_cell,header,header_cell] = features_geometric(paths)
% FEATURES_GEOMTERIC computes various features based on geometric aspects
% of the path

%INPUT:
% - paths: cell array where each cell is the coordinates (time,x,y,...) or
%          (x,y,...) of a path.

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
% - rel_ang: relative angle (every three points)
% - abs_ang: absolute angle (every two points)
% - avg_curv1: curvature (~ every two points)
% - distanceMEE: distance of every point from the center of the minimum enclosing ellipse of the path
% Standalone features:
% - dense
% - focus
% - eccentricity
% - total_length: total length of the path
% - total_length2: length of the first and last points of the path
% - max_loop
% - sinu_simple: sinuosity based on Batschelet
% - sinu: sinuosity based on Benhamou
% - sinu2: sinuosity based on Benhamou (balanced)
% - x, y, a, b: minimum enclosing ellipsoid center (x,y), major (a) and minor (b) axes 

    header = {'Density','Focus','Eccentricity','Length','Distance','Loop',...
        'SinuositySimple','Sinuosity','SinuosityBalanced',...
        'EllipsoidX','EllipsoidY','EllipsoidA','EllipsoidB'};
    header_cell = {'AngleRelative','AngleAbsolute','Curvature','DistanceMEE'};

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

        % Path density
        dense = path_density(pts);
        path_feature = [path_feature,dense];

        % Path focus
        focus = path_focus(pts,'PATH_LENGTH_TOLERANCE',0);
        path_feature = [path_feature,focus];

        % Path eccentricity
        eccentricity = path_eccentricity(pts);
        path_feature = [path_feature,eccentricity];

        % Path length
        %'SIMPLE_LENGTH',1: compute the length between final and start points
        %'PATH_LENGTH_TOLERANCE',0: compute only if length between points is more than this value
        total_length = path_length(pts,'SIMPLE_LENGTH',0,'PATH_LENGTH_TOLERANCE',0);
        total_length2 = path_length(pts,'SIMPLE_LENGTH',1,'PATH_LENGTH_TOLERANCE',0);
        path_feature = [path_feature,total_length,total_length2];

        % Path longetst loop
        % 'EXTENSION',40: for first and last segments: would self-cross the trajectory if extended further; see how far
        max_loop = path_longest_loop(pts,'EXTENSION',40);
        path_feature = [path_feature,max_loop];

        % Path sinuosity
        % SINUOSITY_MODEL: 'Batschelet' or 'Benhamou' or 'Benhamou-balanced'
        sinu_simple = path_sinuosity(pts,'SINUOSITY_MODEL','Batschelet');
        sinu = path_sinuosity(pts,'SINUOSITY_MODEL','Benhamou');
        sinu2 = path_sinuosity(pts,'SINUOSITY_MODEL','Benhamou-balanced');
        path_feature = [path_feature,sinu_simple,sinu,sinu2];

        % Minimum enclosing ellipse
        [x, y, a, b, ~] = path_boundaries(pts);
        path_feature = [path_feature,x, y, a, b];
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % META_STATS FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Path angles
        %'DEGREES',1 for degrees
        [rel_ang,abs_ang] = path_angle(pts,'DEGREES',0);
        path_feature_cell = [path_feature_cell,{rel_ang},{abs_ang}];

        % Path curvarture
        %MAX_VALUE = 0; %max value when curvature is NaN or Inf
        %KILL_MAX_VALUE = 1; %keep/discard indexes with MAX_VALUE
        [avg_curv1,~] = path_curvature(pts,'MAX_VALUE',0,'KILL_MAX_VALUE',1);
        path_feature_cell = [path_feature_cell,{avg_curv1}];

        % Path inner radius variation
        [~,~,~,~,distance] = path_inner_radius_variation(pts);
        path_feature_cell = [path_feature_cell,{distance}];
        
        %...
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        path_features = [path_features;path_feature];
        path_features_cell = [path_features_cell;path_feature_cell];
    end
end
