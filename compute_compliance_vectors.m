function [CLdynPresVector CLdynVect CcwPresVector CcwVect Voffset Vol] = compute_compliance_vectors( Vol , Plung , CLdyn , Ccw )
% This function compute the dynamic lung compliamce and chest wall compliance lines for the Campbell diagram 

% Volume constant correction for Campbell diagram
Voffset = AutoPEEP*(abs(CLdyn*Ccw))/(abs(CLdyn)+abs(Ccw)) ;
Vol = Vol - ( min(Vol) - Voffset ) ;  

XLim = [min(Plung) max(Plung)] ;
YLim = [min(Vol) max(Vol)] ;
if YLim(1)>0
    YLim(1)=0 ;
end
SupPres1 = Plung(1) - Voffset/CLdyn ; 
 a0 = Vol(1) - CLdyn*Plung(1) ; 
% InfPres1 = min( meanPes ) ;
 InfPres1 = (YLim(2) - a0)/CLdyn ;
 if InfPres1 > XLim(1)
    % InfPres1 = XLim(1) ;
 end
 CLdynIntervalSize = SupPres1 - InfPres1 ;
 CLdynPresVector = InfPres1:CLdynIntervalSize/100:SupPres1; 
 CLdynVect = CLdynPresVector.*CLdyn + a0 ;    
% Ccw vector in P/V axes
%-----------------------+
 InfPres2 = SupPres1; 
 b0 =  - Ccw * InfPres2 ;
 SupPres2 = ( CLdynVect(1) - b0 )/Ccw;            
 CcwVect = 0:CLdynVect(1)/100:CLdynVect(1) ;
 CcwPresVector = InfPres2:(SupPres2-InfPres2)/100:SupPres2 ; 
     