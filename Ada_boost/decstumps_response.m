function srep=decstumps_response(decstumps,dis_gg,tafmax)
% tafmax for now is disabled. 
uT=dis_gg; % the distance features of the validation or testing set

    % s holds the sum of the taf-leaves responses for each uHV-sample of
    % the Validation set
    srep=0;
    for k=1:length(decstumps)%tafmax %counnting the responses of the leaves
        if uT(1,decstumps(k).data.dtaf)<decstumps(k).data.taftaf
            srep=srep+decstumps(k).data.rholefttaf;
        else
            srep=srep+decstumps(k).data.rhorighttaf;
        end
    end
end
