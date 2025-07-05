function [decstumps, Amax, tafmax]=decstumps_train(Learning_Set,Validation_Set)
% Stumps commitees 
% TL: Maximum stopping criterion
% TL=2000;
TL=150; % Demo
% TH: Early stopping criterion
% TH=100;
TH=15; % Demo
disp(['Begin: Decision Tree leaves...'])
% Train and Generalising with Learning and Validation Sets
[decstumps, Amax, tafmax]=my_gentle_ada_boost(Learning_Set, Validation_Set, TL,TH);