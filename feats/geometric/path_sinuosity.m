function sinu = path_sinuosity(pts,varargin)
%PATH_SINUOSITY calculates the sinuosity of a path.

% Sinuosity formulas:
% (a) Batschelet:
%  "Batschelet, E., 1981. Circular Statistics in Biology. Academic Press,
%  London."
%  Based on this formula the sinuosity is simply defined as the distance 
%  between the first and the last point of the path divided by the total
%  length of the path.
% (b) (i) Benhamou and (ii) Benhamou-balanced:
%  "Benhamou, S., 2004. How to reliably estimate the tortuosity of an
%   animal's path: straightness, sinuosity, or fractal dimension?"
%  Benhamou defines two formulas, one generic when the turning angles are
%  unbalanced and one more spedific when the turning angles are balanced.
%   (i) sinu = 2*sqrt( p * ( ((1-c^2-s^2) / ((1-c^2)+s^2)) + b^2 ) ),
%   where p and b are the expectation and coefficient of variation of the
%   step length, s is the mean sine of the turning angles and c the mean
%   cosine of the turning angles. In this implementation p is equal to the
%   average of the lengths between each two points of the path and b is the
%   standard deviation divided my the mean of the lengths between each two 
%   points of the path.
%   (ii) sinu = 2*sqrt( p * ( ((1+c^2) / (1-c^2)) + b^2 ) ),
%   where it is assumed that the distribution of the turning angles has
%   zero mean and is symmetrical about it (Gaussian).

    SINUOSITY_MODEL = 'Batschelet';
    
    for i = 1:length(varargin)
        if isequal(varargin{i},'SINUOSITY_MODEL')
			SINUOSITY_MODEL = varargin{i+1};
        end
    end
    
    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
    switch SINUOSITY_MODEL
        case 'Batschelet'
            % Total length of the path
            total_length = 0;
            for i = 2:size(pts,1)
                d = sqrt( (pts(i,2-k)-pts(i-1,2-k))^2 + (pts(i,3-k)-pts(i-1,3-k))^2 );
                total_length = total_length + d;
            end
            % Distance between the first and the last point divided by total length of the path
            if total_length == 0
                sinu = 0;
            else
                sinu = (sqrt( (pts(end,2-k)-pts(1,2-k))^2 + (pts(end,3-k)-pts(1,3-k))^2 )) / total_length;
            end
        case {'Benhamou' , 'Benhamou-balanced'}
            % Get the absolute angles
            [~,abs_ang] = path_angle(pts);
            % Compute mean sine and cosine
            s = mean(sin(abs_ang));
            c = mean(cos(abs_ang));
            % Expected step-length
            ls = zeros(size(pts,1)-1,1);
            for i = 2:size(pts,1)
                ls(i-1) = sqrt( (pts(i,2-k)-pts(i-1,2-k))^2 + (pts(i,3-k)-pts(i-1,3-k))^2 );
            end
            p = mean(ls); %take the average of the lengths
            % Coefficient of variation of step length
            b = std(ls)/mean(ls);
            % Benhamou equations
            switch SINUOSITY_MODEL
                case 'Benhamou'
                    % Sinuosity (unbalanced angles)
                    sinu = 2*sqrt( p * ( ((1-c^2-s^2) / ((1-c^2)+s^2)) + b^2 ) );
                case 'Benhamou-balanced'
                    % Sinuosity (balanced angles)
                    sinu = 2*sqrt( p * ( ((1+c^2) / (1-c^2)) + b^2 ) );
            end
    end
end

