function [DTS_RESNREF, SVM_RESNREF]=...
    WI_same_TVDT_test(testdbmat,decstumps,tafmax, SVMModel, NREFS, segments_index_test,TESTW,nosigs,nosigsf)                                                 

%% TESTING WITH REFERENCES (NREF)
socm=size(testdbmat.G(1,1).cov(1).cov,1);
% pre-allocation
GREFS=sort(randsample(1:nosigs,NREFS));
GTEST=1:nosigs;GTEST(GREFS)=[];
DTS_tmpsrepGGTESTlocREFS(1:length(GTEST),1:NREFS,1:length(segments_index_test))=0;
SVM_tmpsrepGGTESTlocREFS(1:length(GTEST),1:NREFS,1:length(segments_index_test))=0;
QG(1:socm,1:socm,1:length(GTEST),1:length(segments_index_test))=0;
for stop_segm=1:length(segments_index_test)
    DTS_srepGGTESTlocREFS(stop_segm).score(1:length(GTEST),1:NREFS)=0;
    SVM_srepGGTESTlocREFS(stop_segm).score(1:length(GTEST),1:NREFS)=0;
end
% end of pre-allocation

disp('Computing error rates with REFS...')
for SignerIDidx=1:length(TESTW)
    SignerIDidx
    for urn=1:10 % 10 repetitions
        rng(urn)
        GREFS=sort(randsample(1:nosigs,NREFS));
        % REFERENCE SET
        for iref=1:NREFS
            for kx=1:length(segments_index_test)
                segmREF=testdbmat.G(TESTW(SignerIDidx),GREFS(iref)).cov(segments_index_test(kx)).cov;
                segmREF=segmREF+diag(ones(1,size(segmREF,1))*0.001*trace(segmREF));
                X(:,:,iref,kx)=segmREF;
            end
        end
        % Genuine TEST Set
        GTEST=1:nosigs;GTEST(GREFS)=[];
        for igtest=1:length(GTEST)
            for kx=1:length(segments_index_test)
                segmQREF=testdbmat.G(TESTW(SignerIDidx),GTEST(igtest)).cov(segments_index_test(kx)).cov;
                segmQREF=segmQREF+diag(ones(1,size(segmQREF,1))*0.001*trace(segmQREF));
                QG(:,:,igtest,kx)=segmQREF;
            end
            for iref=1:NREFS
                for kx=1:length(segments_index_test)
                    T1G=X(:,:,iref,kx);
                    IT1G=conv2vec_with_logm(T1G);
                    T2Q=QG(:,:,igtest,kx);
                    IT2Q=conv2vec_with_logm(T2Q);
                    v_temp=abs(IT1G-IT2Q);
                    DTS_dm_GQG=decstumps_response(decstumps,v_temp,tafmax);
                    [~,SVM_dm_GQG]=predict(SVMModel,v_temp);
                    DTS_tmpsrepGGTESTlocREFS(igtest,iref,kx)=DTS_dm_GQG;
                    SVM_tmpsrepGGTESTlocREFS(igtest,iref,kx)=SVM_dm_GQG(2);
                end
                for stop_segm=1:length(segments_index_test)
                    if stop_segm==1
                        DTS_SSGGTESTlocREFS=squeeze(DTS_tmpsrepGGTESTlocREFS(igtest,iref,:));
                        DTS_srepGGTESTlocREFS(stop_segm).score(igtest,iref)=DTS_SSGGTESTlocREFS(stop_segm);

                        SVM_SSGGTESTlocREFS=squeeze(SVM_tmpsrepGGTESTlocREFS(igtest,iref,:));
                        SVM_srepGGTESTlocREFS(stop_segm).score(igtest,iref)=SVM_SSGGTESTlocREFS(stop_segm);
                    else
                        DTS_SSGGTESTlocREFS=sort(squeeze(DTS_tmpsrepGGTESTlocREFS(igtest,iref,:)),'descend');
                        DTS_srepGGTESTlocREFS(stop_segm).score(igtest,iref)=mean(DTS_SSGGTESTlocREFS(1:stop_segm));

                        SVM_SSGGTESTlocREFS=sort(squeeze(SVM_tmpsrepGGTESTlocREFS(igtest,iref,:)),'descend');
                        SVM_srepGGTESTlocREFS(stop_segm).score(igtest,iref)=mean(SVM_SSGGTESTlocREFS(1:stop_segm));
                    end
                end
            end
        end
        % Sorting columns for examining other measures like the second or third...
        % pre-allocation
        for stop_segm=1:length(segments_index_test)
            DTS_NREFscoreF1GG(stop_segm).NREFscoreF1GG=0;
            DTS_NREFscoreF2GG(stop_segm).NREFscoreF2GG=0;
            DTS_NREFscoreF3GG(stop_segm).NREFscoreF3GG=0;
            DTS_NREFscoreF4GG(stop_segm).NREFscoreF4GG=0;
            DTS_NREFscoreF5GG(stop_segm).NREFscoreF5GG=0;
            DTS_NREFscoreF6GG(stop_segm).NREFscoreF6GG=0;
            DTS_NREFscoreF7GG(stop_segm).NREFscoreF7GG=0;
            DTS_NREFscoreF8GG(stop_segm).NREFscoreF8GG=0;
            DTS_NREFscoreF9GG(stop_segm).NREFscoreF9GG=0;
            DTS_NREFscoreF10GG(stop_segm).NREFscoreF10GG=0;
            SVM_NREFscoreF1GG(stop_segm).NREFscoreF1GG=0;
            SVM_NREFscoreF2GG(stop_segm).NREFscoreF2GG=0;
            SVM_NREFscoreF3GG(stop_segm).NREFscoreF3GG=0;
            SVM_NREFscoreF4GG(stop_segm).NREFscoreF4GG=0;
            SVM_NREFscoreF5GG(stop_segm).NREFscoreF5GG=0;
            SVM_NREFscoreF6GG(stop_segm).NREFscoreF6GG=0;
            SVM_NREFscoreF7GG(stop_segm).NREFscoreF7GG=0;
            SVM_NREFscoreF8GG(stop_segm).NREFscoreF8GG=0;
            SVM_NREFscoreF9GG(stop_segm).NREFscoreF9GG=0;
            SVM_NREFscoreF10GG(stop_segm).NREFscoreF10GG=0;
        end
        for stop_segm=1:length(segments_index_test)
            DTS_srepGGTESTlocREFS(stop_segm).score=sort(DTS_srepGGTESTlocREFS(stop_segm).score,2);
            SVM_srepGGTESTlocREFS(stop_segm).score=sort(SVM_srepGGTESTlocREFS(stop_segm).score,2);
            % pooling or selectiong.
            DTS_NREFscoreF1GG(stop_segm).NREFscoreF1GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,1);
            DTS_NREFscoreF2GG(stop_segm).NREFscoreF2GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,2);
            DTS_NREFscoreF3GG(stop_segm).NREFscoreF3GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,3);
            DTS_NREFscoreF4GG(stop_segm).NREFscoreF4GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,4);
            DTS_NREFscoreF5GG(stop_segm).NREFscoreF5GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,5);            

            SVM_NREFscoreF1GG(stop_segm).NREFscoreF1GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,1);
            SVM_NREFscoreF2GG(stop_segm).NREFscoreF2GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,2);
            SVM_NREFscoreF3GG(stop_segm).NREFscoreF3GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,3);
            SVM_NREFscoreF4GG(stop_segm).NREFscoreF4GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,4);
            SVM_NREFscoreF5GG(stop_segm).NREFscoreF5GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,5);

            if NREFS>5
                DTS_NREFscoreF6GG(stop_segm).NREFscoreF6GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,6);
                DTS_NREFscoreF7GG(stop_segm).NREFscoreF7GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,7);
                DTS_NREFscoreF8GG(stop_segm).NREFscoreF8GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,8);
                DTS_NREFscoreF9GG(stop_segm).NREFscoreF9GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,9);
                DTS_NREFscoreF10GG(stop_segm).NREFscoreF10GG=DTS_srepGGTESTlocREFS(stop_segm).score(:,10);

                SVM_NREFscoreF6GG(stop_segm).NREFscoreF6GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,6);
                SVM_NREFscoreF7GG(stop_segm).NREFscoreF7GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,7);
                SVM_NREFscoreF8GG(stop_segm).NREFscoreF8GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,8);
                SVM_NREFscoreF9GG(stop_segm).NREFscoreF9GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,9);
                SVM_NREFscoreF10GG(stop_segm).NREFscoreF10GG=SVM_srepGGTESTlocREFS(stop_segm).score(:,10);
            end
        end

        % Skilled forgery TEST test
        SFTEST=1:nosigsf;
        
        % pre-allocation
        DTS_tmpsrepGSFTESTlocREFS(1:length(SFTEST),1:NREFS,1:length(segments_index_test))=0;
        SVM_tmpsrepGSFTESTlocREFS(1:length(SFTEST),1:NREFS,1:length(segments_index_test))=0;
        QF(1:socm,1:socm,1:length(SFTEST),1:length(segments_index_test))=0;
        for stop_segm=1:length(segments_index_test)
            DTS_srepGSFTESTlocREFS(stop_segm).score(1:length(SFTEST),1:NREFS)=0;
            SVM_srepGSFTESTlocREFS(stop_segm).score(1:length(SFTEST),1:NREFS)=0;
        end

        for isfest=1:length(SFTEST)
            for kx=1:length(segments_index_test)
                segmQREF=testdbmat.F(TESTW(SignerIDidx),isfest).cov(segments_index_test(kx)).cov;
                segmQREF=segmQREF+diag(ones(1,size(segmQREF,1))*0.001*trace(segmQREF));
                QF(:,:,isfest,kx)=segmQREF;
            end
            for iref=1:NREFS
                for kx=1:length(segments_index_test)
                    T1G=X(:,:,iref,kx);
                    IT1G=conv2vec_with_logm(T1G);
                    T2QF=QF(:,:,isfest,kx);
                    IT2QF=conv2vec_with_logm(T2QF);
                    % vTEST=real(LDV_spd_geo(T1G,T2QF));
                    v_temp=abs(IT1G-IT2QF);
                    DTS_dm_GQF=decstumps_response(decstumps,v_temp,tafmax);
                    [~,SVM_dm_GQF]=predict(SVMModel,v_temp);

                    DTS_tmpsrepGSFTESTlocREFS(isfest,iref,kx)=DTS_dm_GQF;
                    SVM_tmpsrepGSFTESTlocREFS(isfest,iref,kx)=SVM_dm_GQF(2);
                end
                for stop_segm=1:length(segments_index_test)
                    if stop_segm==1
                        DTS_SSGGTESTlocREFS=squeeze(DTS_tmpsrepGSFTESTlocREFS(isfest,iref,:));
                        DTS_srepGSFTESTlocREFS(stop_segm).score(isfest,iref)=DTS_SSGGTESTlocREFS(stop_segm);

                        SVM_SSGGTESTlocREFS=squeeze(SVM_tmpsrepGSFTESTlocREFS(isfest,iref,:));
                        SVM_srepGSFTESTlocREFS(stop_segm).score(isfest,iref)=SVM_SSGGTESTlocREFS(stop_segm);
                    else
                        DTS_SSGGTESTlocREFS=sort(squeeze(DTS_tmpsrepGSFTESTlocREFS(isfest,iref,:)),'descend');
                        DTS_srepGSFTESTlocREFS(stop_segm).score(isfest,iref)=mean(DTS_SSGGTESTlocREFS(1:stop_segm));

                        SVM_SSGGTESTlocREFS=sort(squeeze(SVM_tmpsrepGSFTESTlocREFS(isfest,iref,:)),'descend');
                        SVM_srepGSFTESTlocREFS(stop_segm).score(isfest,iref)=mean(SVM_SSGGTESTlocREFS(1:stop_segm));
                    end
                end
            end
        end
        % same thing here, sort and select..
        % pre-allocation
        for stop_segm=1:length(segments_index_test)
            DTS_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF=0;
            DTS_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF=0;
            DTS_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF=0;
            DTS_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF=0;
            DTS_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF=0;
            DTS_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF=0;
            DTS_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF=0;
            DTS_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF=0;
            DTS_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF=0;
            DTS_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF=0;
            SVM_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF=0;
            SVM_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF=0;
            SVM_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF=0;
            SVM_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF=0;
            SVM_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF=0;
            SVM_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF=0;
            SVM_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF=0;
            SVM_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF=0;
            SVM_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF=0;
            SVM_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF=0;
        end
        % end pre-allocation.

        for stop_segm=1:length(segments_index_test)
            DTS_srepGSFTESTlocREFS(stop_segm).score=sort(DTS_srepGSFTESTlocREFS(stop_segm).score,2);
            SVM_srepGSFTESTlocREFS(stop_segm).score=sort(SVM_srepGSFTESTlocREFS(stop_segm).score,2);
            % pooling or selectioning
            DTS_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,1);
            DTS_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,2);
            DTS_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,3);
            DTS_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,4);
            DTS_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,5);

            SVM_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,1);
            SVM_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,2);
            SVM_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,3);
            SVM_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,4);
            SVM_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,5);

            if NREFS>5
                DTS_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,6);
                DTS_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,7);
                DTS_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,8);
                DTS_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,9);
                DTS_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF=DTS_srepGSFTESTlocREFS(stop_segm).score(:,10);

                SVM_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,6);
                SVM_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,7);
                SVM_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,8);
                SVM_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,9);
                SVM_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF=SVM_srepGSFTESTlocREFS(stop_segm).score(:,10);
            end
        end

        % ROC curves and associate error rates for NREF reference samples
        labels=[ones(1,length(DTS_NREFscoreF1GG(stop_segm).NREFscoreF1GG)) -ones(1,length(DTS_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF))];
        for stop_segm=1:length(segments_index_test)
            % if strcmp(matlabRelease.Release,'R2023a')
                % DTS
                [DTS_F1far,DTS_F1pd,~,~]=perfcurve(labels,[DTS_NREFscoreF1GG(stop_segm).NREFscoreF1GG ; DTS_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF],1);
                [DTS_F2far,DTS_F2pd,~,~]=perfcurve(labels,[DTS_NREFscoreF2GG(stop_segm).NREFscoreF2GG ; DTS_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF],1);
                [DTS_F3far,DTS_F3pd,~,~]=perfcurve(labels,[DTS_NREFscoreF3GG(stop_segm).NREFscoreF3GG ; DTS_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF],1);
                [DTS_F4far,DTS_F4pd,~,~]=perfcurve(labels,[DTS_NREFscoreF4GG(stop_segm).NREFscoreF4GG ; DTS_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF],1);
                [DTS_F5far,DTS_F5pd,~,~]=perfcurve(labels,[DTS_NREFscoreF5GG(stop_segm).NREFscoreF5GG ; DTS_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF],1);
                % figure(1); title('NREF')
                % plot(F1far,F1pd,'b*'), drawnow(); hold on
                % plot(F2far,F2pd,'r-'), drawnow();
                % plot(F3far,F3pd,'g+'), drawnow();
                % plot(F4far,F4pd,'ko'), drawnow();
                DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF1=min(mean([1-DTS_F1pd' ; DTS_F1far']));
                DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF2=min(mean([1-DTS_F2pd' ; DTS_F2far']));
                DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF3=min(mean([1-DTS_F3pd' ; DTS_F3far']));
                DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF4=min(mean([1-DTS_F4pd' ; DTS_F4far']));
                DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF5=min(mean([1-DTS_F5pd' ; DTS_F5far']));

                % SVM
                [SVM_F1far,SVM_F1pd,~,~]=perfcurve(labels,[SVM_NREFscoreF1GG(stop_segm).NREFscoreF1GG ; SVM_NREFscoreF1GSF(stop_segm).NREFscoreF1GSF],1);
                [SVM_F2far,SVM_F2pd,~,~]=perfcurve(labels,[SVM_NREFscoreF2GG(stop_segm).NREFscoreF2GG ; SVM_NREFscoreF2GSF(stop_segm).NREFscoreF2GSF],1);
                [SVM_F3far,SVM_F3pd,~,~]=perfcurve(labels,[SVM_NREFscoreF3GG(stop_segm).NREFscoreF3GG ; SVM_NREFscoreF3GSF(stop_segm).NREFscoreF3GSF],1);
                [SVM_F4far,SVM_F4pd,~,~]=perfcurve(labels,[SVM_NREFscoreF4GG(stop_segm).NREFscoreF4GG ; SVM_NREFscoreF4GSF(stop_segm).NREFscoreF4GSF],1);
                [SVM_F5far,SVM_F5pd,~,~]=perfcurve(labels,[SVM_NREFscoreF5GG(stop_segm).NREFscoreF5GG ; SVM_NREFscoreF5GSF(stop_segm).NREFscoreF5GSF],1);
                % figure(1); title('NREF')
                % plot(F1far,F1pd,'b*'), drawnow(); hold on
                % plot(F2far,F2pd,'r-'), drawnow();
                % plot(F3far,F3pd,'g+'), drawnow();
                % plot(F4far,F4pd,'ko'), drawnow();

                SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF1=min(mean([1-SVM_F1pd' ; SVM_F1far']));
                SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF2=min(mean([1-SVM_F2pd' ; SVM_F2far']));
                SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF3=min(mean([1-SVM_F3pd' ; SVM_F3far']));
                SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF4=min(mean([1-SVM_F4pd' ; SVM_F4far']));
                SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF5=min(mean([1-SVM_F5pd' ; SVM_F5far']));
                if NREFS >=5
                    [DTS_F6far,DTS_F6pd,~,~]=perfcurve(labels,[DTS_NREFscoreF6GG(stop_segm).NREFscoreF6GG ; DTS_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF],1);
                    [DTS_F7far,DTS_F7pd,~,~]=perfcurve(labels,[DTS_NREFscoreF7GG(stop_segm).NREFscoreF7GG ; DTS_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF],1);
                    [DTS_F8far,DTS_F8pd,~,~]=perfcurve(labels,[DTS_NREFscoreF8GG(stop_segm).NREFscoreF8GG ; DTS_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF],1);
                    [DTS_F9far,DTS_F9pd,~,~]=perfcurve(labels,[DTS_NREFscoreF9GG(stop_segm).NREFscoreF9GG ; DTS_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF],1);
                    [DTS_F10far,DTS_F10pd,~,~]=perfcurve(labels,[DTS_NREFscoreF10GG(stop_segm).NREFscoreF10GG ; DTS_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF],1);
                    % figure(1); title('NREF')
                    % plot(F1far,F1pd,'b*'), drawnow(); hold on
                    % plot(F2far,F2pd,'r-'), drawnow();
                    % plot(F3far,F3pd,'g+'), drawnow();
                    % plot(F4far,F4pd,'ko'), drawnow();
                    DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF6=min(mean([1-DTS_F6pd' ; DTS_F6far']));
                    DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF7=min(mean([1-DTS_F7pd' ; DTS_F7far']));
                    DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF8=min(mean([1-DTS_F8pd' ; DTS_F8far']));
                    DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF9=min(mean([1-DTS_F9pd' ; DTS_F9far']));
                    DTS_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF10=min(mean([1-DTS_F10pd' ; DTS_F10far']));

                    [SVM_F6far,SVM_F6pd,~,~]=perfcurve(labels,[SVM_NREFscoreF6GG(stop_segm).NREFscoreF6GG ; SVM_NREFscoreF6GSF(stop_segm).NREFscoreF6GSF],1);
                    [SVM_F7far,SVM_F7pd,~,~]=perfcurve(labels,[SVM_NREFscoreF7GG(stop_segm).NREFscoreF7GG ; SVM_NREFscoreF7GSF(stop_segm).NREFscoreF7GSF],1);
                    [SVM_F8far,SVM_F8pd,~,~]=perfcurve(labels,[SVM_NREFscoreF8GG(stop_segm).NREFscoreF8GG ; SVM_NREFscoreF8GSF(stop_segm).NREFscoreF8GSF],1);
                    [SVM_F9far,SVM_F9pd,~,~]=perfcurve(labels,[SVM_NREFscoreF9GG(stop_segm).NREFscoreF9GG ; SVM_NREFscoreF9GSF(stop_segm).NREFscoreF9GSF],1);
                    [SVM_F10far,SVM_F10pd,~,~]=perfcurve(labels,[SVM_NREFscoreF10GG(stop_segm).NREFscoreF10GG ; SVM_NREFscoreF10GSF(stop_segm).NREFscoreF10GSF],1);
                    % figure(1); title('NREF')
                    % plot(F1far,F1pd,'b*'), drawnow(); hold on
                    % plot(F2far,F2pd,'r-'), drawnow();
                    % plot(F3far,F3pd,'g+'), drawnow();
                    % plot(F4far,F4pd,'ko'), drawnow();
                    SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF6=min(mean([1-SVM_F6pd' ; SVM_F6far']));
                    SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF7=min(mean([1-SVM_F7pd' ; SVM_F7far']));
                    SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF8=min(mean([1-SVM_F8pd' ; SVM_F8far']));
                    SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF9=min(mean([1-SVM_F9pd' ; SVM_F9far']));
                    SVM_RESNREF(stop_segm).RESNREF(SignerIDidx,urn).SF10=min(mean([1-SVM_F10pd' ; SVM_F10far']));
                end
        %  end
        end
    end
end