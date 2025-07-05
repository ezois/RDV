function [DTS_RESNREF, SVM_RESNREF]=...
    WI_same_TVDT(traindbmat,ratG_NEG,psf,prf,DEVW,TESTW,NREFS,segments_index_train,segments_index_test)

%% Format of covariances: traindbmat.G(writer_number, sig_sample).cov(segment_index).cov
% traindbmat.G contain the Genuine signatures
% traindbmat.F contain the Forgery signatures
% writer_number = 1:55 for CEDAR
% sig_sample = 1:24 for CEDAR
% segment_index = 1:14 i.e.: 1=1x1, 2=2x2(1st), 3=2x2(2nd), ..., 6=3x3(1st), 14=3x3(9th)

% ratG_NEG is between 0(full ) - 1
%# Dataset and Number_of_Segments
socm=size(traindbmat.G(1,1).cov(1).cov,1);
nosigs=24; nosigsf=nosigs;

%% Development Set
disp('Development Writers processing....')

% Create Pairs indexes
deiktes=nchoosek(1:nosigs,2);
lines=size(deiktes,1);
kk=0;
SOCM=socm*(socm+1)/2;
nosgm=segments_index_train;

%% Learning stage
% Learning only on the 1x1 window (Covariance of the entire part of the image)
% Positive class: G-G
for SignerIDidx=1:length(DEVW) 
    for j=1:lines
        kk=kk+1;
        X=traindbmat.G(DEVW(SignerIDidx),deiktes(j,1)).cov(1).cov;        
        IX=conv2vec_with_logm(X);
        Y=traindbmat.G(DEVW(SignerIDidx),deiktes(j,2)).cov(1).cov;        
        IY=conv2vec_with_logm(Y);
        % vDEV=LDV_spd_geo(X,Y);
        GGDEV(kk,1:SOCM)=abs(IX-IY);
    end
end

% Negative class: G-RF
kk=0;
for SignerIDidx=1:length(DEVW)
    % Random Forgery Set
    SetofForgSigners=DEVW;
    SetofForgSigners(SignerIDidx)=[];
    RFSigners=sort(randsample(SetofForgSigners,lines,true));
    for j=1:lines
        kk=kk+1;
        X=traindbmat.G(DEVW(SignerIDidx),deiktes(j,1)).cov(1).cov;
        IX=conv2vec_with_logm(X);        
        % Random Forgery
        Y=traindbmat.G(RFSigners(j),randsample(nosigs,1)).cov(1).cov; 
        IY=conv2vec_with_logm(Y);        
        GRFDEV(kk,1:SOCM)=abs(IX-IY);
    end
end

% Negative class: G-SF
kk=0;
for SignerIDidx=1:length(DEVW)
    for j=1:lines
        kk=kk+1;
        X=traindbmat.G(DEVW(SignerIDidx),deiktes(j,1)).cov(1).cov;
        IX=conv2vec_with_logm(X);        
        % Skilled Forgery Set
        Y=traindbmat.F(DEVW(SignerIDidx),deiktes(j,2)).cov(1).cov;
        IY=conv2vec_with_logm(Y);        
        GSFDEV(kk,1:SOCM)=abs(IX-IY);
    end
end

% mix S-SG and G-Rf forgeries
% popul: How many samples will the NEG_SET have
% psf: percentage of skilled forgery: 1 -->>> 100%, 0 -->>> 0%   
% prf: percentage of random forgery:  1 -->>> 100%, 0 -->>> 0% 
% SOS psf+prf=1
popul=size(GGDEV,1);
NEG_SETDEV=mix_SF_RF(GSFDEV,GRFDEV,popul,psf,prf);

% Parameter ratG_NEG selects the percentage of samples for the Learning_Set
% so it is the percentage of samples for the Validation_Set
[Learning_Set, Validation_Set]=make_learn_valid(GGDEV,NEG_SETDEV,ratG_NEG);

% SVM classifier
[SVMModel,~]=SVM_train(Learning_Set,Validation_Set,true);

% adaboost & dec_stumps learning
[decstumps, Amax, tafmax]=decstumps_train(Learning_Set,Validation_Set);

close all;

%% Testing stage
disp('Testing Writers processing....')
testdbmat=traindbmat;
[DTS_RESNREF, SVM_RESNREF]=WI_same_TVDT_test(testdbmat,decstumps,tafmax, SVMModel, NREFS, segments_index_test,TESTW,nosigs,nosigsf);
 
models.decstumps=decstumps;
models.tafmax=tafmax;
models.SVMModel=SVMModel;
%%
% % % filename=strcat([traindb 'v4' num2str(socm) '_ratG_NEG=' num2str(ratG_NEG) '_psf=' num2str(psf) '_prf=' num2str(prf)  '.mat']);
% % % save(['TRAIN_MODELS_WI_geodesic\' filename], 'decstumps', 'Amax', 'tafmax','SVMModel','auc_SVM')

