claw = TheClaw();

for id = claw.BASE:claw.WRIST
    claw.setJointTorqueEnable(id, 1);
    claw.setJointControlMode(id, claw.POS_TIME);
    claw.setJointTimeToPosition(id, 2);
end

claw.setConfigValue('clawLoadLimit', 220);

startAngleBase = 235;

%%
claw.setAllJointsPosition([startAngleBase (60*2.875) 210 180 50])