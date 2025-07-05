if isfile('ResWI_intCEDAR_psf0_tngvc_DT_cov10.mat')
    clear
    clc
    load('ResWI_intCEDAR_psf0_tngvc_DT_cov10.mat')
end

trgt=10; % best 10/10 reps

for rep=1:5
    for isegm=1:14
        % SVM
        for wri=1:size(SVM_RESNREF(rep).res(isegm).RESNREF,1) % 5x2 first fold
            srt10=sort([SVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF10]);
            srt9=sort([SVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF9]);
            srt8=sort([SVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF8]);
            
            m_svm10(wri)=mean(srt10(1:trgt));
            m_svm9(wri)=mean(srt9(1:trgt));
            m_svm8(wri)=mean(srt8(1:trgt));
        end

        for wri=1:size(ISVM_RESNREF(rep).res(isegm).RESNREF,1) % 5x2 second fold
            srt10=sort([ISVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF10]);
            srt9=sort([ISVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF9]);
            srt8=sort([ISVM_RESNREF(rep).res(isegm).RESNREF(wri,:).SF8]);
            
            im_svm10(wri)=mean(srt10(1:trgt));
            im_svm9(wri)=mean(srt9(1:trgt));
            im_svm8(wri)=mean(srt8(1:trgt));
        end
        mm_svm10(rep,isegm)=mean([m_svm10 im_svm10]);
        mm_svm9(rep,isegm)=mean([m_svm9 im_svm9]);
        mm_svm8(rep,isegm)=mean([m_svm8 im_svm8]);
        clear m_svm* im_svm* srt* 
        
        % DSC
        for wri=1:size(DTS_RESNREF(rep).res(isegm).RESNREF,1) % 5x2 first fold
            srt10=sort([DTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF10]);
            srt9=sort([DTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF9]);
            srt8=sort([DTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF8]);
            
            m_dts10(wri)=mean(srt10(1:trgt));
            m_dts9(wri)=mean(srt9(1:trgt));
            m_dts8(wri)=mean(srt8(1:trgt));
        end

        for wri=1:size(IDTS_RESNREF(rep).res(isegm).RESNREF,1) % 5x2 second fold
            srt10=sort([IDTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF10]);
            srt9=sort([IDTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF9]);
            srt8=sort([IDTS_RESNREF(rep).res(isegm).RESNREF(wri,:).SF8]);
            
            im_dts10(wri)=mean(srt10(1:trgt));
            im_dts9(wri)=mean(srt9(1:trgt));
            im_dts8(wri)=mean(srt8(1:trgt));
        end
        mm_dts10(rep,isegm)=mean([m_dts10 im_dts10]);
        mm_dts9(rep,isegm)=mean([m_dts9 im_dts9]);
        mm_dts8(rep,isegm)=mean([m_dts8 im_dts8]);
        clear m_dts* im_dts* srt* 
    end
end

figure(1), 
title('CEDAR, blind intra, 5x2, averages')
hold on, grid on
plot(mean(mm_svm10)*100,'ro--'),
plot(mean(mm_svm9)*100,'go--'), 
plot(mean(mm_svm8)*100,'bo--'), 
xlabel('# Selected segments: 1-14'), ylabel('Average user EER (%) ')
legend('SVM-AIRM:10th','SVM-AIRM:9th','SVM-AIRM:8th')
axis([1 14 0 1.4])

figure(2), 
title('CEDAR, blind intra, 5x2, averages')
hold on, grid on
plot(mean(mm_dts10)*100,'ro--'),
plot(mean(mm_dts9)*100,'go--'), 
plot(mean(mm_dts8)*100,'bo--'), 
xlabel('# Selected segments: 1-14'), ylabel('Average user EER (%) ')
legend('DSC-AIRM:10th','DSC-AIRM:9th','DSC-AIRM:8th')
axis([1 14 0 1.4])
