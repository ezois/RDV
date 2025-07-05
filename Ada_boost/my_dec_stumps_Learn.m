function decstumps=my_dec_stumps_Learn(Learning_Set)
% calling decstumps(taf).data=my_dec_stumps(Learning_Set);
% L=(LRS_GEN+LRS_RF)
% Parameter u is  [1:(LRS_GEN+LRS_RF), D-dimensional distance vectors]
% Parameter v is  [1:(LRS_GEN+LRS_RF)] class vectors of +1 or -1
% Parameter w is  [1:(LRS_GEN+LRS_RF)] the distribution weight with initial
% values of 1/L where L=(LRS_GEN+LRS_RF)
u=Learning_Set.L;
v=Learning_Set.V;
w=Learning_Set.W;

L=size(u,1);
D=size(u,2);

rholefttaf=0; rhorighttaf=0; etot=inf; Wbigplus=0; Wbigminus=0; Wleft=0; Wrigth=0;
Wbigplus=sum(w(v==1)); 
Wbigminus=1-Wbigplus; 
[su,isu]=sort(u); %Sorting each column to su and indexd isu
for d=1:D % select a d-column: a d-feature
    %sucol=su(:,d);
    isucol=isu(:,d);    
    v1=v(isucol);
    w1=w(isucol);
    Wsmallplus=0;
    Wsmallminus=0;
    for l=1:L-1
        if v1(l)==1
            Wsmallplus=Wsmallplus+w1(l);
        else
            Wsmallminus=Wsmallminus+w1(l);
        end
        if su(l,d)~=su(l+1,d)
            eleft=1-max([Wsmallplus Wsmallminus]);
            eright=1-max([Wbigplus-Wsmallplus Wbigminus-Wsmallminus]);
            if (eleft+eright)<etot 
                etot=eleft+eright;
                dtf=d;
                tftf=mean([su(l,d) su(l+1,d)]);
            end
        end
    end
end
%This code most probably is an error.
% % % % sleft=0; sright=0; pleft=0; pright=0;
% % % % for l=1:L 
% % % %     if su(l,dtf)<tftf
% % % %         sleft=sleft+w1(l)*v1(l);
% % % %         pleft=pleft+w1(l); 
% % % %     else
% % % %         sright=sright+w1(l)*v1(l);
% % % %         pright=pright+w1(l); 
% % % %     end
% % % % end

%This code most probably is the correct one.
sleft=0; sright=0; pleft=0; pright=0;
for l=1:L 
    if u(l,dtf)<tftf
        sleft=sleft+w(l)*v(l);
        pleft=pleft+w(l); 
    else
        sright=sright+w(l)*v(l);
        pright=pright+w(l); 
    end
end


% creating the structure decstumps
decstumps.dtaf=dtf; 
decstumps.taftaf=tftf; 
decstumps.rholefttaf=sleft/pleft;
decstumps.rhorighttaf=sright/pright;
                
                
            
        
        
    
    

