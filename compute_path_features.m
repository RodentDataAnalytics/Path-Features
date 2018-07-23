
% Properties
arena_x = 0; %center of the arena (x coordinate)
arena_y = 0; %center of the arena (y coordinate)
arena_r = 127; %radius of the arena (R)

% Load the paths
load('test_paths.mat');

%% Geometric features
[path_features,path_features_cell,header_,header_cell] = features_geometric(paths);
%Stats for the non-standalone features
[all,~,~,header2] = features_stats(path_features_cell);
%Combine
tmp = repmat(header_cell,1,length(header2)); 
header = [header_,tmp];
tmp = repelem(header2,1,length(header_cell));
subheader = [header_,tmp];
tmp = cell2mat(all);
tmp = [path_features,tmp];
tmp(isnan(tmp)|isinf(tmp)|imag(tmp)) = 0; %do a check for any weird values 
feats_geo = num2cell(tmp);
feats_geo = [header;subheader;feats_geo];

%% Spatial features
[path_features,path_features_cell,header_,header_cell] = features_spatial(paths, arena_x, arena_y, arena_r);
%Stats for the non-standalone features
[all,~,~,header2] = features_stats(path_features_cell);
%Combine
tmp = repmat(header_cell,1,length(header2)); 
header = [header_,tmp];
tmp = repelem(header2,1,length(header_cell));
subheader = [header_,tmp];
tmp = cell2mat(all);
tmp = [path_features,tmp];
tmp(isnan(tmp)|isinf(tmp)|imag(tmp)) = 0; %do a check for any weird values 
feats_spac = num2cell(tmp);
feats_spac = [header;subheader;feats_spac];

%% Spatiotemporal features
[path_features,path_features_cell,header_,header_cell] = features_spatiotemporal(paths);
%Stats for the non-standalone features
[all,~,~,header2] = features_stats(path_features_cell);
%Combine
tmp = repmat(header_cell,1,length(header2)); 
header = [header_,tmp];
tmp = repelem(header2,1,length(header_cell));
subheader = [header_,tmp];
tmp = cell2mat(all);
tmp = [path_features,tmp];
tmp(isnan(tmp)|isinf(tmp)|imag(tmp)) = 0; %do a check for any weird values 
feats_spacTemp = num2cell(tmp);
feats_spacTemp = [header;subheader;feats_spacTemp];


%% Export to csv files
writetable(cell2table(feats_geo), fullfile(pwd,'results','feats_geometric.csv'), 'WriteVariableNames',0);
writetable(cell2table(feats_spac), fullfile(pwd,'results','feats_spacial.csv'),  'WriteVariableNames',0);
writetable(cell2table(feats_spacTemp), fullfile(pwd,'results','feats_spaciotemporal.csv'), 'WriteVariableNames',0);




