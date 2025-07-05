function [Learning_Set, Validation_Set]=make_learn_valid(GG,NEGSET,val)
% Creates Learning_Set, Validation_Set
% NEGSET may contain mixtures of G-Skilled forgery & G-Random forgery
% the parameter val selects the percentage of samples for the Learning_Set
% (1-val) is the percentage of samples for the Validation_Set
% EXAMPLE: val=0.5 means 50% of the samples of (G-G and NEGSET) form the
% Learning_Set and 50% of the samples of (GG and NEGSET) form the
% Validation_Set. 
kk=size(GG,1);
kk1=size(NEGSET,1);
GGLidx=sort(randsample(1:kk,round(val*kk)));
VGGLidx=1:kk; VGGLidx(GGLidx)=[];

GRFLidx=sort(randsample(1:kk1,round(val*kk1)));
VRFLidx=1:kk1; VRFLidx(GRFLidx)=[];

Learning_Set.L1=GG(GGLidx,:);
Learning_Set.L2=NEGSET(GRFLidx,:);
Learning_Set.L=[Learning_Set.L1;Learning_Set.L2];
Learning_Set.V=[ones(1,size(Learning_Set.L1,1)) -1*ones(1,size(Learning_Set.L2,1))]';
Learning_Set.W=ones(size(Learning_Set.L,1),1)/size(Learning_Set.L,1);
Learning_Set.L1=[];
Learning_Set.L2=[];
Validation_Set.L1=GG(VGGLidx,:);
Validation_Set.L2=NEGSET(VRFLidx,:);
Validation_Set.L=[Validation_Set.L1;Validation_Set.L2];
Validation_Set.V=[ones(1,size(Validation_Set.L1,1)) -1*ones(1,size(Validation_Set.L2,1))]';
Validation_Set.L=[Validation_Set.L1;Validation_Set.L2];
Validation_Set.V=[ones(1,size(Validation_Set.L1,1)) -1*ones(1,size(Validation_Set.L2,1))]';
Validation_Set.L1=[];
Validation_Set.L2=[];
