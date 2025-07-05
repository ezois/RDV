function NEG_SET=mix_SF_RF(GSF,GRF,popul,psf,prf)
% popul: How many samples will the NEGSET have
% psf: percentage of skilled forgery: 1 -->>> 100%  
% prf: percentage of skilled forgery: 1 -->>> 100% 
% SOS psf+prf=1
GSFidx=sort(randsample(1:size(GSF,1),round(psf*popul)));
GRFidx=sort(randsample(1:size(GRF,1),round(prf*popul)));
NEG_SET=[GSF(GSFidx,:);GRF(GRFidx,:)];
