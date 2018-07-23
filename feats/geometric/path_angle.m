function [rel_ang,abs_ang] = path_angle(pts,varargin)
%PATH_ANGLE calculates the average, median, IQR absolute and relative angle
%of the path. Any undefined values will be equal to 0.

	DEGREES = 0;
	
	for i = 1:length(varargin)
		if isequal(varargin{i},'DEGREES')
			DEGREES = varargin{i+1};
		end
	end

    k = 0;
    if size(pts,2) == 2 %no time
        k = 1;
    end
    
	%% Relative Angles	
	%c^2 = a^2 + b^2 - 2*a*b*cos(theta) => theta = arccos( (a^2+b^2-c^2) / (2*a*b) )
	%where a = sqrt((x3-x2)^2 + (y3-y2)^2) and b = sqrt((x2-x1)^2 + (y2-y1)^2)
	
    rel_ang = [];
    for i = 1:size(pts,1)-2
		%vectors a,b,c
        va_x = pts(i+2,2-k) - pts(i+1,2-k);
        va_y = pts(i+2,3-k) - pts(i+1,3-k);
		a = sqrt(va_x^2 + va_y^2);
		
        vb_x = pts(i+1,2-k) - pts(i,2-k);
        vb_y = pts(i+1,3-k) - pts(i,3-k);		
		b = sqrt(vb_x^2 + vb_y^2);
		
        vc_x = pts(i+2,2-k) - pts(i,2-k);
        vc_y = pts(i+2,3-k) - pts(i,3-k);		
		c = sqrt(vc_x^2 + vc_y^2);
		
		theta = acos( (a^2 + b^2 - c^2) / (2*a*b) );
		
        if isnan(theta) || isinf(theta) || ~isreal(theta)
            theta = 0;
        end
        
        if DEGREES
			theta = theta * 180/pi; %covert radians to degrees
        end
			
        rel_ang = [rel_ang;theta];
    end	

	
	%% Absolute Angles	
	%theta = arctan( (y2-y1) / (x2-x1) )
	%where (x1,y1) is the starting point and (x2,y2) the ending point  	
	
    abs_ang = [];
    for i = 1:size(pts,1)-1
	    adj = pts(i+1,2-k) - pts(i,2-k);
        opp = pts(i+1,3-k) - pts(i,3-k);
		theta = atan(opp/adj);
		
        if isnan(theta) || isinf(theta) || ~isreal(theta)
            theta = 0;
        end
        
        if DEGREES
			theta = theta * 180/pi; %covert radians to degrees
        end
			
        abs_ang = [abs_ang;theta];
    end		    
end

