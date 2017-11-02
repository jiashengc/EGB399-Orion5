function moveArm(claw, x1, y1, x2, y2)
    
    % Pick Up
    reverseKinematics(claw, x1, y1, 100, 320);
    pause(2);
    reverseKinematics(claw, x1, y1, 0, 320);
    pause(2);
    reverseKinematics(claw, x1, y1, 0, 150);
    pause(2);
    reverseKinematics(claw, x1, y1, 100, 150);
    pause(2);
    
    % Drop Off
    reverseKinematics(claw, x2, y2, 100, 150);
    pause(2);
    reverseKinematics(claw, x2, y2, 0, 150);
    pause(2);
    reverseKinematics(claw, x2, y2, 0, 320);
    pause(2);
    reverseKinematics(claw, x2, y2, 100, 320);
    pause(2);
    
    %claw.setAllJointsPosition([-135 (90*2.875) 90 90 300]);
    
end
