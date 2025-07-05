function [SVMModel_final,auc]=SVM_train(Learning_Set,Validation_Set,sflag)
Xtrain=[Learning_Set.L];
Ytrain=[Learning_Set.V];
XVal=[Validation_Set.L];
YVal=[Validation_Set.V];
C=2.^(0:1:12);
hold on
% figure(1), 
for i=1:length(C)    
    SVMModel_train = fitcsvm(Xtrain,Ytrain,'Standardize',sflag,'KernelFunction','rbf','KernelScale','auto','BoxConstraint',C(i));
    [label_test,score_test] = predict(SVMModel_train,XVal);
    score_test_all=score_test(:,2);
    [far.global,pd.global,t.global,auc(i).global] =perfcurve(YVal,score_test_all,1);
    figure(1); plot(far.global,pd.global);xlabel('False positive rate'); ylabel('True positive rate'); grid on;...
    title(['ROC curve @Validation set ' num2str(i) '/13']); drawnow;
    axis([0 0.3 0.7 1])
end
[mauc,imauc]=max([auc(:).global]);

Ctest=C(imauc);
clear far pd auc t
rng;
SVMModel_final = fitcsvm(Xtrain,Ytrain,'Standardize',sflag,'KernelFunction','rbf','KernelScale','auto','BoxConstraint',Ctest);
[label_test,score_test] = predict(SVMModel_final,XVal);
score_test_all=score_test(:,2);
close all;
clear auc
[far.global,pd.global,t.global,auc.global] =perfcurve(YVal,score_test_all,1);
plot(far.global,pd.global,'-');xlabel('False positive rate'); ylabel('True positive rate')
axis([0 0.3 0.7 1])
pause(1)
close all;
