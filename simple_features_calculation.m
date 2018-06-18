function simple_features_calculation(G,S,T,ST,AF,PF,coords,varargin)
% FLAGS (0 or 1):
% - G: geometric
% - S: spatial
% - T: temporal
% - ST: spatiotemporal
% SPECIAL FLAGS
% - AF: arena, off=0, round=1, square=2
% - PF: platform, off=0, round=1, square=2

% Coordinates:
% - cell array where each cell contains coordinates of a path
% - if isdouble(pts) then we have only one path (or ~iscell(pts))


%% CHECKING %%
arena_x = NaN;
arena_y = NaN;
arena_r = NaN;
% Check coordinates: if [time,x,y] or [x,y]
if iscell(coords)
    a = size(coords{1},2);
else
    a = size(coords,2);
end
if a ~= 3
    if T > 0 || ST > 0
        warning('Coordinates: no time axis found, temporal and spatiotemporal features will be skipped.');
    end
    T = 0;
    ST = 0;
end
% Check arena: if exists then properties should be given in varargin
for i = 1:length(varargin)
    if isequal(varargin{i},'ARENA')
        arena_x = varargin{i+1}(1);
        arena_y = varargin{i+1}(2);
        arena_r = varargin{i+1}(3);
    end
end
if AF == 0 || isnan(arena_x) || isnan(arena_y) || isnan(arena_r) 
    if S == 1
        warning('Arena: spatial features will be skipped');
    end
    S = 0;
end

feats = [];
coord_values = {};

%% COMPUTE FEATURES %%
for i = 1:length(coords)
    if iscell(coords)
        pts = coords{i};
    else
        pts = coords;
        i = length(coords);
    end

    %% GEOMETRIC FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if G
        
        % Minimum enclosing ellipse
        [x, y, a, b, R] = path_boundaries(pts);
        tmp = find(isnan([x,y,a,b,reshape(R,1,[])]));
        if ~isempty(tmp)
            warning('Minimum enclosing ellipse: NaN detected');
        end

        % Path angle
        %'DEGREES',1 for degrees
        [rel_ang_average,rel_ang_median,rel_ang_iqr,rel_ang,ang_average,ang_median,ang_iqr,abs_ang] = path_angle(pts,'DEGREES',0);
        tmp = find(isnan([rel_ang_average,rel_ang_median,rel_ang_iqr,rel_ang',ang_average,ang_median,ang_iqr,abs_ang']));
        if ~isempty(tmp)
            warning('Path angle: NaN detected');
        end
        if length(rel_ang)==1 || length(abs_ang)==1
            warning('Path angle: returned scalar instead of vector');
        elseif isempty(rel_ang) || isempty(abs_ang)
            warning('Path angle: returned empty');
        end
        
        % Path curvarture
        %MAX_VALUE = 0; %max value when curvature is NaN or Inf
        %KILL_MAX_VALUE = 1; %keep/discard indexes with MAX_VALUE
        [total_curv1,median_curv1,iqr_curv1,avg_curv1,curv1] = path_curvature(pts,'MAX_VALUE',0,'KILL_MAX_VALUE',1);
        tmp = find(isnan([total_curv1,median_curv1,iqr_curv1,avg_curv1',curv1']));
        if ~isempty(tmp)
            warning('Path curvarture: NaN detected');
        end
        if length(avg_curv1)==1 || length(curv1)==1
            warning('Path curvarture: returned scalar instead of vector');
        elseif isempty(avg_curv1) || isempty(curv1)
            warning('Path curvarture: returned empty');
        end     

        % Path density
        dense = path_density(pts);
        if isnan(dense)
            warning('Path density: NaN detected');
        end

        % Path eccentricity
        eccentricity = path_eccentricity(pts);
        if isnan(eccentricity)
            warning('Path eccentricity: NaN detected');
        end        

        % Path focus
        focus = path_focus(pts,'PATH_LENGTH_TOLERANCE',0);
        if isnan(focus)
            warning('Path focus: NaN detected');
        end         

        % Path inner radius variation
        [ CVri,distance_average,distance_median,distance_iqr ] = path_inner_radius_variation(pts);
        tmp = find(isnan([CVri,distance_average,distance_median,distance_iqr]));
        if ~isempty(tmp)
            warning('Path inner radius variation: NaN detected');
        end

        % Path length
        %'SIMPLE_LENGTH',1: compute the length between final and start points
        %'PATH_LENGTH_TOLERANCE',0: compute only if length between points is more than this value
        total_length = path_length(pts,'SIMPLE_LENGTH',0,'PATH_LENGTH_TOLERANCE',0);
        total_length2 = path_length(pts,'SIMPLE_LENGTH',1,'PATH_LENGTH_TOLERANCE',0);
        tmp = find(isnan([total_length,total_length2]));
        if ~isempty(tmp)
            warning('Path length: NaN detected');
        elseif total_length==0 || total_length2==0
            warning('Path length: length equal to zero detected');
        end        

        % Path longetst loop
        % 'EXTENSION',40: for first and last segments: would self-cross the trajectory if extended further; see how far
        max_loop = path_longest_loop(pts,'EXTENSION',40);
        if isnan(max_loop)
            warning('Path longetst loop: NaN detected');
        end

        % Path sinuosity
        % SINUOSITY_MODEL: 'Batschelet' or 'Benhamou' or 'Benhamou-balanced'
        sinu_simple = path_sinuosity(pts,'SINUOSITY_MODEL','Batschelet');
        sinu = path_sinuosity(pts,'SINUOSITY_MODEL','Benhamou');
        sinu2 = path_sinuosity(pts,'SINUOSITY_MODEL','Benhamou-balanced');
        tmp = find(isnan([sinu_simple,sinu,sinu2]));
        if ~isempty(tmp)
            warning('Path sinuosity: NaN detected');
        end          
    end
    
%     header = {'rel_ang_average','rel_ang_median','rel_ang_iqr','abs_ang_average','abs_ang_median','abs_ang_iqr',...
%         'total_curv1','median_curv1','iqr_curv1',...
%         'path_density','path_eccentricity','focus',...
%         'inner_rad_var','distance_average','distance_median','distance_iqr',...
%         'total_length','total_length_simple',...
%         'max_loop','sinu_simple','sinu','sinu2'};    
%     header_c = {'rel_ang','abs_ang','avg_curv1','curv1'};
    tmp_feats_elem = [rel_ang_average,rel_ang_median,rel_ang_iqr,ang_average,ang_median,ang_iqr,...
        total_curv1,median_curv1,iqr_curv1,...
        dense,eccentricity,focus,...
        CVri,distance_average,distance_median,distance_iqr,...
        total_length,total_length2,max_loop,sinu_simple,sinu,sinu2];
    tmp_coord_values = {rel_ang,abs_ang,avg_curv1,curv1};
    coord_values = [coord_values;tmp_coord_values];
    feats = [feats;tmp_feats_elem];
    save('feats.mat','feats','coord_values');

    %% SPATIAL FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if S 

        % Path angle from the center of the arena
        [angle_average,angle_median,angle_iqr,angle] = path_angle_from_center(pts, arena_x, arena_y);
        tmp = find(isnan([angle_average,angle_median,angle_iqr,angle']));
        if ~isempty(tmp)
            warning('Path angle from center: NaN detected');
        end
        if length(angle)==1
            warning('Path angle from center: returned scalar instead of vector');
        elseif isempty(angle)
            warning('Path angle from center: returned empty');
        end

        % Path center displacement
        cent_dipl = path_centre_displacement(pts, arena_x, arena_y, arena_r);
        if isnan(cent_dipl)
            warning('Path center displacement: NaN detected');
        end

        % Path distance to center
        [distance_average, distance_median, distance_iqr] = path_distance_to_center(pts,arena_x,arena_y,arena_r);
        tmp = find(isnan([distance_average,distance_median,distance_iqr]));
        if ~isempty(tmp)
            warning('Path angle from center: NaN detected');
        end        
    end


    %% TEMPORAL FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    if T

        % Path duration
        %'SIMPLE_LENGTH',1: compute the duration between final and start points
        total_time = path_time(pts,'SIMPLE_TIME',0);
    end


    %% SPATIOTEMPORAL FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ST

        % Path angular speed
        [average_angular_speed, median_angular_speed, iqr_angular_speed, angular_speed, angle] = path_angular_speed(pts);

        % Path speed
        %'PATH_SPEED_TOLERANCE',0: compute only if length between points is more than this value
        [speed_average,speed_median,speed_iqr,speed] = path_speed(pts,'PATH_SPEED_TOLERANCE',0);
    end

end
