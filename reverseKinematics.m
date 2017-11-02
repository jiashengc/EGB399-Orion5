function [theta2, theta3, theta4] = reverseKinematics(claw, x, y, z, gripper)

    %% Use predefined inputs if they are not supplied
    if ~exist('x','var')
        x = 402; 
    end

    if ~exist('y','var')
        y = 55; 
    end
    
    if ~exist('z','var')
        z = 80; 
    end
    
    if ~exist('gripper','var')
        gripper = 50; 
    end


    c = 40.0;
    height = 53.0;
    %r = 30.309;
    r = 36.5;
    
    l2 = 170.384;
    l3 = 136.307;
    l4 = 86.0 + c;
    
    x = x - 100;
    y = y - 290;
    w = sqrt(power(x,2) + power(y,2)) - r;
    base = (rad2deg(atan2(x,y))*-1) - 37;
    %% 
    
    h1 = sqrt(w^2 + (l4+z)^2);
    angle_a1 = rad2deg( acos(((l4+z)^2+h1^2-w^2) / (2*(l4+z)*h1)) );
    angle_b1 = rad2deg( acos((h1^2+w^2-(l4+z)^2) / (2*h1*w)) );

    angle_b2 = 90 - angle_b1;
    h2 = sqrt(h1^2+height^2 - (2*h1*height*cos(deg2rad(angle_b2))));
    % h2 = min(h2, 306.68);
    angle_a2 = rad2deg( acos((h1^2+h2^2-height^2) / (2*h1*h2)) );
    angle_c2 = rad2deg( acos((h2^2 + height^2 - h1^2) / (2*h2*height)) );

    angle_a3 = rad2deg( acos((l3^2 + h2^2 - l2^2) / (2*l3*h2)) );
    angle_b3 = rad2deg( acos((l2^2 + h2^2 - l3^2) / (2*l2*h2)) );
    angle_c3 = rad2deg( acos((l2^2 + l3^2 - h2^2) / (2*l2*l3)) );

    theta2 = (angle_b3+angle_c2) - 90;
    theta3 = angle_c3;
    theta4 = angle_a1 + angle_a2 +  angle_a3;
    
    claw.setAllJointsPosition([base (theta2*2.875) theta3 theta4 gripper]);
    
end
