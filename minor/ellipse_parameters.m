function [ a, b, R] = ellipse_parameters( A )
%ELLIPSE_PARAMETERS returns major/minor axis and the rotation matrix 
    [~, d, v] = svd(A);
    a = 1/sqrt(d(1, 1));
    b = 1/sqrt(d(2, 2));
    %theta = acos(v(1, 1));
    R = v;
    
    % a should always be the major-axis and b the minor-axis
    if b > a
        tmp = a;
        a = b;
        b = tmp;
    end
end

