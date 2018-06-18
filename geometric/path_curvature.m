function [total_curv1,median_curv1,iqr_curv1,avg_curv1,curv1] = path_curvature(pts,varargin)
% Idea: https://github.com/adamfranco/curvature/wiki
% Radius of the circumcircle formula:
% http://www.mathopenref.com/trianglecircumcircle.html
%%
    
    MAX_VALUE = 0; %max value when curvature is NaN or Inf
    KILL_MAX_VALUE = 1; %keep/discard indexes with MAX_VALUE
    
    for i = 1:length(varargin)
        if isequal(varargin{i},'MAX_VALUE')
            MAX_VALUE = varargin{i+1};
        elseif isequal(varargin{i},'KILL_MAX_VALUE')
            KILL_MAX_VALUE = varargin{i+1};
        end
    end

    curv1 = [];
    avg_curv1 = [];
    total_curv1 = 0;
    median_curv1 = 0;
    iqr_curv1 = 0;
    
    kk = 0;
    if size(pts,2) == 2 %no time
        kk = 1;
    end

    % 3 points are needed to compute the circumcircle
    if size(pts,1) < 3
        return;
    end
    
    for i = 3:size(pts,1)
        %point 1 (x,y)
        p1x = pts(i-2,2-kk);
        p1y = pts(i-2,3-kk);
        %point 2 (x,y)
        p2x = pts(i-1,2-kk);
        p2y = pts(i-1,3-kk);  
        %point 3 (x,y)
        p3x = pts(i,2-kk);
        p3y = pts(i,3-kk);        
        % segment p1<->p2
        a = ((p2x-p1x)^2 + (p2y-p1y)^2);
        % segment p2<->p3
        b = ((p3x-p2x)^2 + (p3y-p2y)^2);
        % triangle p1<->p3
        c = ((p3x-p1x)^2 + (p3y-p1y)^2);
        %formula
        if a > 0 && b > 0 && c >0
            num = (a * b * c);
            den = sqrt(abs((a+b+c)*(b+c-a)*(c+a-b)*(a+b-c)));
            k = num/den;
        else
            % points were very close or in line
            k = MAX_VALUE;
        end
        
        if isnan(k) || isinf(k)
            k = MAX_VALUE;
        end
        curv1 = [curv1;k];
    end    
    
    %completely ignore points with curvature = MAX_VALUE
    if KILL_MAX_VALUE
        tmp = find(curv1==0);
        curv1(tmp) = [];
    end
    
    %compute the curve radius for each segment (every two points)
    if ~isempty(curv1)
        avg_curv1 = curv1(1);
    else % all the points have been excluded
        total_curv1 = 0;
        iqr_curv1 = 0;
        median_curv1 = 0;
        return
    end
    
    for i = 2:length(curv1)
        avg_curv1 = [avg_curv1 ; (curv1(i-1)+curv1(i)/2)];
    end
    
    total_curv1 = mean(avg_curv1);
    iqr_curv1 = iqr(avg_curv1);
    median_curv1 = median(avg_curv1);
end
