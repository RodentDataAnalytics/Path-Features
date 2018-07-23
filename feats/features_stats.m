function [all,common,robust,header] = features_stats(features)
%FEATURES_STATS computes various statistics for the features

% List of statistics:
% Common:
% - Mean
% - Standard deviation (std)
% - Coefficient of variation (std/mean)
% - Mean absolute deviation (mean(|x-mean|))
% Robust:
% - Median
% - Inter-quartile range (iqr)
% - Coefficient of variation (iqr/median)
% - Median absolute deviation (median(|x-median|))

    header = {'Mean','STD','CV','MAD','Median','IQR','CVr','MADr'};

    common = {};
    robust = {};

    if ~iscell(features) || isempty(features)
        error('features_stats: input must be a non empty cell array');
    end
    
    if ~isnumeric(features{1,1})
        k = 2; %we have a header skip it
    else
        k = 1;
    end

    % Make 0 all the empty, NaN, Inf and non-real values
    features2 = features(k:end,:);
    empty = cellfun('isempty',features);
    features2(empty) = {0};
    [n,m] = size(features2);
    for i = 1:n
        for j = 1:m
            c = arrayfun(@(x) any(isnan(x)|isinf(x)|imag(x)), features2{i,j});
            features2{i,j}(c) = 0;
        end
    end
    
    % Common stats
    Mean = cell2mat(cellfun(@mean,features2,'UniformOutput',0));
    Std = cell2mat(cellfun(@std,features2,'UniformOutput',0));
    cv1 = Std./Mean;
    mad1 = cell2mat(cellfun(@(x) (mean(abs(x-mean(x)))),features2,'UniformOutput',0));
    Mean(isnan(Mean)|isinf(Mean)|imag(Mean)) = 0;
    Std(isnan(Std)|isinf(Std)|imag(Std)) = 0;
    cv1(isnan(cv1)|isinf(cv1)|imag(cv1)) = 0;
    mad1(isnan(mad1)|isinf(mad1)|imag(mad1)) = 0;
    common = {Mean,Std,cv1,mad1};
    
    % Robust stats
    Median = cell2mat(cellfun(@median,features2,'UniformOutput',0));
    IQR = cell2mat(cellfun(@iqr,features2,'UniformOutput',0));
    cv2 = IQR./Median;
    mad2 = cell2mat(cellfun(@(x) (median(abs(x-median(x)))),features2,'UniformOutput',0));
    Median(isnan(Median)|isinf(Median)|imag(Median)) = 0;
    IQR(isnan(IQR)|isinf(IQR)|imag(IQR)) = 0;
    cv2(isnan(cv2)|isinf(cv2)|imag(cv2)) = 0;
    mad2(isnan(mad2)|isinf(mad2)|imag(mad2)) = 0;    
    robust = {Median,IQR,cv2,mad2};
    
    % All
    all = [common,robust];
end

