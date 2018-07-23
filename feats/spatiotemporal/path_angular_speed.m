function [ angular_speed ] = path_angular_speed( pts )
%PATH_ANGULAR_SPEED computes the angular speed

    if size(pts,1) < 3 || size(pts,2) < 3
        angular_speed = 0;
        return
    end   
    
    angle = [];
    for i = 2:length(pts)
        dot_product = (pts(i,2)*pts(i-1,2)) + (pts(i,3)*pts(i-1,3));
        magnitude1 = sqrt( (pts(i-1,2)^2) + (pts(i-1,3)^2) );
        magnitude2 = sqrt( (pts(i,2)^2) + (pts(i,3)^2) );
        theta = acos( dot_product/(magnitude1*magnitude2) );
        
        if isnan(theta) || isinf(theta)
            theta = 0;
        end
        if ~isreal(theta)
            theta = real(theta);
        end        
    
        angle = [angle;theta];
    end     
    
    angular_speed = [];
    for i = 2:length(angle) 
        dt = pts(i+1,1)-pts(i,1); % 1 point less thus pts+1
        tmp = (angle(i)-angle(i-1)) / dt;
        if dt <= 0
            tmp = 0;
        end
        angular_speed = [angular_speed ; tmp];
    end   
end

