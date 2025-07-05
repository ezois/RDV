function [decstumps,Amax,tafmax]=my_gentle_ada_boost(Learning_Set, Validation_Set, TL,TH)
% Uses my_dec_stumps_Learn(Learning_Set) function.
% Returns the T-commitees of stumps "decstumps"
u=Learning_Set.L; % the distance features
v=Learning_Set.V; % the (-1 +1) class labels
w=Learning_Set.W; % the weight distrinutions
Amax=-inf;
tafmax=1;

uHV=Validation_Set.L; % the distance features of the validation set
vHV=Validation_Set.V; % the (-1 +1) class labels of the validation set

% TL: Maximum stopping criterion 2000
% TH: Early stopping criterion 100
figure, 
for taf=1:TL
    % disp(taf)
    % Train f(t) using Learning_Set,
    % decstumps is updated by the taf-indexed member.
    decstumps(taf).data=my_dec_stumps_Learn(Learning_Set);
    % update w distribution
    for l=1:length(w)
        if u(l,decstumps(taf).data.dtaf)<decstumps(taf).data.taftaf
            w(l)=w(l)*exp(-v(l)*decstumps(taf).data.rholefttaf);
        else
            w(l)=w(l)*exp(-v(l)*decstumps(taf).data.rhorighttaf);            
        end
    end
    % Renormalize w
    Learning_Set.W=w/sum(w); % sending it to my_dec_stumps_Learn again
    w=Learning_Set.W; %keeping new values for update
    
    % Calling Validation Set for temporary commitee decstumps of taf-length
    for l=1:size(uHV,1)
        % s holds the sum of the taf-leaves responses for each uHV-sample of
        % the Validation set 
        s(l)=0;
        for k=1:taf %counnting the responses of the 1:taf-leaves
            if uHV(l,decstumps(k).data.dtaf)<decstumps(k).data.taftaf
                s(l)=s(l)+decstumps(k).data.rholefttaf;
            else
                s(l)=s(l)+decstumps(k).data.rhorighttaf;
            end
        end
    end
    % Calculation of AUC over the Validation Set
    [far,pd,t,auc]=perfcurve(vHV,s,1);    
    if auc > Amax
        Amax=auc; 
        tafmax=taf;
        counter=0;
    else
        counter=counter+1;
        if counter==TH
            break; 
        end
    end    
    plot(far,pd,'r'), title([' ROC @ validation, AUC= ' num2str(auc) '  Amax= ' num2str(Amax) '  taf= ' num2str(taf) '  tafmax= ' num2str(tafmax)]), grid; 
    xlabel('False positive rate'); ylabel('True positive rate'); grid on; drawnow();
end






