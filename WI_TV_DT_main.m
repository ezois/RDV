clear('all')
%% Code to support the publication: Vasilakis, N., Chorianopoulos, C., & Zois, E. N. (2025). A Riemannian Dichotomizer Approach on Symmetric
%% Positive Definite Manifolds for Offline, Writer-Independent Signature Verification.
%% Applied Sciences, 15(13), 7015. https://doi.org/10.3390/app15137015
%% Date: 10. July, 2025.

%% 1. Should you make use of the suggested experimental protocol, pls. refer the following papers which make use of it:
%% a) A Riemannian Dichotomizer Approach on Symmetric Positive Definite Manifolds for Offline, Writer-Independent Signature Verification
% N. Vasilakis, C. Chorianopoulos and E. N. Zois
% Applied Sciences 2025 Vol. 15 Issue 13 Pages 7015: doi:10.3390/app15137015 
%% b) Similarity Distance Learning on SPD Manifold for Writer Independent Offline Signature Verification
% E. N. Zois, D. Tsourounis and D. Kalivas
% IEEE Transactions on Information Forensics and Security 2024 Vol. 19 Pages 1342-1356
% DOI: 10.1109/TIFS.2023.3333681
%% c) Metric meta-learning and intrinsic Riemannian embedding for writer independent offline signature verification
% A. Giazitzis and E. N. Zois
% Expert Systems with Applications 2025 Vol. 261 Pages 125470
% DOI: 10.1016/j.eswa.2024.125470
%% d) SigmML: Metric meta-learning for Writer Independent Offline Signature Verification in the Space of SPD Matrices 
% A. Giazitzis and E. N. Zois
% 2024 IEEE/CVF Winter Conference on Applications of Computer Vision (WACV) 3-8 Jan. 2024 2024
% Pages: 6300-6310
% DOI: 10.1109/WACV57701.2024.00619
%% e) Janus-Faced Handwritten Signature Attack: A Clash Between a Handwritten Signature Duplicator and a Writer Independent Metric Meta-learning Offline Signature Verifier, 
% A. Giazitzis, M. Diaz, E. N. Zois and M. A. Ferrer, 
% Proc. ICDAR 2024, Cham 2024, 
% Publisher: Springer Nature Switzerland 
% Pages: 216-232. 
% doi.org/10.1007/978-3-031-70536-6_13

%% 2. (Important) pls. send email to ezois@uniwa.gr to provide link with the .mat files (they are large)
% a) CEDAR_covs10_v5_new_thlauto (The covariances of the CEDAR signature dataset ~100MB)
% b) ResWI_intCEDAR_psf0_tngvc_DT_cov10 (preloaded results 300MB)
% and uncomment line #42: {addpath(genpath('.\mat_files'))}
CEDAR_filename='CEDAR_covs10_v5_new_thlauto.mat'; % covariance descriptor at SPD P_10

%% addpath
addpath(genpath('.\Ada_boost'))
addpath(genpath('.\IP_code'))
addpath(genpath('.\SVM_code_train'))
addpath(genpath('.\Some_Code'))
% addpath(genpath('.\mat_files'))

% Learning (i.e. Train & Validate) with CEDAR, Testing with CEDAR (blind-intra) 
traindbname='CEDAR'; nowriters=55;
load(eval([traindbname '_filename'])) %
tr_dbname=eval(traindbname);

% Learning on the 1x1 window >>> One covariance
segments_index_train=1;

% Testing on all 14 window >>> 14 covariances
segments_index_test=1:14; % include all segments at testing.
% segments_index_test=1:5; % include 1x1, 2x2 segments at testing.

% (Learning stage): psf controls the mixture of the negative class G-F. For example, if psf=0 then the negative class is
% derived from G-RF (100%RF). If psf=1 then the negative class is derived from G-SF (0%RF). If psf=0.5 then the negative class is
% derived from 50% G-RF and 50% G-SF (50%RF), etc.
psf=0;
prf=1-psf;
ratG_NEG=0.5; % ratio of training-validation populations. 
percofDEVW=0.5; % Writers of the Learning/train dataset
NODEVW=round(nowriters*percofDEVW);
NREFS=10; % How many samples will be used as references during the testing stage.

%% Internal blind 5x2 fold. 
for i=1:5
    %% First half fold.
    disp(['CEDAR psf=' num2str(psf) ' i=' num2str(i) 'a'])
    rng(i) % The actual code of the paper call the rng(shuffle) command.
    
    % Development writers (or Development Set)
    DEVW=sort(randsample(1:nowriters,NODEVW));

    % Testing writers (or Exploitation Set)
    TESTW=1:nowriters;TESTW(DEVW)=[];

    [DTS_RESNREF(i).res, SVM_RESNREF(i).res]=WI_same_TVDT(eval(traindbname),ratG_NEG,psf,prf,DEVW,TESTW,NREFS,segments_index_train, segments_index_test);

    %% Second half fold. 
    disp(['CEDAR psf=' num2str(psf) ' i=' num2str(i) 'b'])
    [IDTS_RESNREF(i).res, ISVM_RESNREF(i).res]= WI_same_TVDT(eval(traindbname),ratG_NEG,psf,prf,TESTW,DEVW,NREFS,segments_index_train, segments_index_test);
    
    % The i-th fold is completed (a and b)
end

% % ifilename=strcat(['ResWI_int' traindbname '_psf' num2str(psf) '_tngvc_DT_cov10.mat']);
% % save(['MODELS_WI_same_diff_geodesic\' ifilename],'DTS_RESNREF','IDTS_RESNREF','SVM_RESNREF','ISVM_RESNREF','-v7.3');

rmpath(genpath('.\Ada_boost'))
rmpath(genpath('.\IP_code'))
rmpath(genpath('.\SVM_code_train'))
rmpath(genpath('.\Some_Code'))
% rmpath(genpath('.\mat_files'))

% call post_process to diplay the results. 
post_process