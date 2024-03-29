function acqData = compute_results(acqData ) 
% this function extract all the parameters from the data


%% Initialise data

% Conversion factor
LcmH20_to_J = 0.0980 ;

% Extract data for more convenience
Flow = acqData.Flow.mean ;
Pes = acqData.Pes.mean ;
Pga = acqData.Pga.mean ;
Paw = acqData.Paw.mean ;
Ccw = acqData.Ccw ;
Ts = acqData.Ts ;
L = acqData.Lmean ;
P = acqData.Pmean ;
   
% Create new data    
timeVector = (0:Ts:length(Flow)*Ts)./1000 ;
Vol = cumtrapz( timeVector(1:length(Flow))  , Flow ) ;
Plung = Pes - Paw ; 
% Pes offset (start at zero for works)
Pes = Pes - Pes(1) ;
Pdi = Pga - Pes ;
    
% Gas Leak correction
% if abs((Vol(1)-Vol(L))/max(Vol)) > 0.1 % More than 10% leak
%     error('process_data:StrongAirLeak','Leak detected in airflow is too important');
% end
% shift = 1:1:L;
% shift = shift .* ( Vol(L)-Vol(1) )/L ;

% Check if Pes is inversted



%% Compute acqData    

% Dynamic lung compliance   (L/cmH20)
CLdyn = -abs((Vol(P) - Vol(1))/(Plung(P) - Plung(1)));

% AutoPEEP  (L/cmH20)
if ~isfield(acqData,'AutoPEEPIdx') % If not manually entered
    [AutoPEEP AutoPEEPIdx AutoPEEPpts] = compute_autoPEEP ;
else
    AutoPEEPIdx = acqData.AutoPEEPIdx;
    if AutoPEEPIdx > length(acqData.Pes.mean)             
        AutoPEEPIdx = length(acqData.Pes.mean) ;
    end
    acqData.AutoPEEPpts = [acqData.AutoPEEPIdx  length(Pes)];
    AutoPEEPpts = acqData.AutoPEEPpts;
    AutoPEEP = acqData.AutoPEEP;
end

% Swing (max-min upon the period) (cmH20)
if abs(max(Pdi) - Pdi(AutoPEEPIdx))>abs(Pdi(AutoPEEPIdx) - min(Pdi))
    SwingPdi = max(Pdi) - Pdi(AutoPEEPIdx) ; 
else
    SwingPdi = -(Pdi(AutoPEEPIdx) - min(Pdi)) ; 
end
SwingPes = min(Pes) - Pes(AutoPEEPIdx) ; 
SwingPga = SwingPdi + SwingPes ; 
Gilbert = SwingPga/SwingPdi ;

% Time parameters (s)
Ti = P * Ts/1000 ;
Texp = (L - P) * Ts/1000 ;
Ttot = L * Ts/1000 ;
Ti_Ttot = Ti / Ttot ;  
freq = 60 * 1000 /(L*Ts) ; % (cycles/min)
timeV = (1:1:L).*Ts/1000 ;

%Volume parameters
Vt = max(Vol) - min(Vol);
Vt_Ti = Vt  / Ti ;
FR_VT = freq / Vt ;
VOLexp = max(Vol) - min(Vol);

%% Product time products

% Pressure*Time Product (cmH20/cycle) 
PesCW = Vol/Ccw  ; % Chest wall recoil pressure
PesCW = PesCW - ( PesCW(AutoPEEPIdx) - Pes(AutoPEEPIdx) );
PTPes1 = trapz( timeV(AutoPEEPIdx:end) , PesCW(AutoPEEPIdx:end) - Pes(AutoPEEPIdx:end) ) ;  
PTPes2 = trapz( timeV(1:P) , PesCW(1:P) - Pes(1:P) ) ;  
PTPesUpper = PTPes1 + PTPes2 ;
PTPesC = PTPesUpper ;
PTPes = 60*PTPesC/Ttot; 

% for PTProduct Diaphragmatique (cmH20/cycle)
PTPdi1 = trapz( timeV(AutoPEEPIdx:end) , Pdi(AutoPEEPIdx:end) - Pdi(AutoPEEPIdx)  ) ;
PTPdi2 = trapz( timeV(1:P) , Pdi(1:P) - Pdi(AutoPEEPIdx)  ) ;
PTPdiC = PTPdi1 + PTPdi2 ;
PTPdi = 60*PTPdiC/Ttot; 

%% Get compliance vectors


% Volume constant correction for Campbell diagram
Voffset = AutoPEEP*(abs(CLdyn*Ccw))/(abs(CLdyn)+abs(Ccw)) ;
Vol = Vol - ( min(Vol) - Voffset ) ;  

XLim = [min(Pes) max(Pes)] ;
YLim = [min(Vol) max(Vol)] ;
if YLim(1)>0
    YLim(1)=0 ;
end
SupPres1 = Pes(1) - Voffset/CLdyn ; 
a0 = Vol(1) - CLdyn*Pes(1) ; 
InfPres1 = (YLim(2) - a0)/CLdyn ;

% CLdyn vector in P/V axes
CLdynIntervalSize = SupPres1 - InfPres1 ;
CLdynPresVector = InfPres1:CLdynIntervalSize/100:SupPres1; 
CLdynVect = CLdynPresVector.*CLdyn + a0 ;    

% Ccw vector in P/V axes
InfPres2 = SupPres1; 
b0 =  - Ccw * InfPres2 ;
SupPres2 = ( CLdynVect(1) - b0 )/Ccw;            
CcwVect = 0:CLdynVect(1)/100:CLdynVect(1) ;
CcwPresVector = InfPres2:(SupPres2-InfPres2)/100:SupPres2 ; 
     


%% Work of breathing

if quantile(Paw,.9)-quantile(Paw,.1)>3
    % MECHANICAL VENTILLATION
    
    Wres_insp = 0 ;
    Wres_exp = 0 ;
    Wexp = 0 ;
    Wres = 0 ;
    Wel = 0;
    Wpeep = 0;
    
    IndMin = find(CcwVect>Vol(1));
    IndMax = find(CcwVect<Vol(P));
    Indexes = IndMin(1):IndMax(end);
    W = -LcmH20_to_J*polyarea([Pes(P:-1:1) CcwPresVector(Indexes)],[Vol(P:-1:1) CcwVect(Indexes)] ) - Weep ; 
    % Resistance
    Res = 0 ;
    

else
    % FREE BREATHING
    
    % Elastic WOB (Using trapeze formula)
    Pcl = Pes(P);
    Vcl = Vol(P);
    Pcw = min(CcwPresVector) + Vcl/Ccw ;
    h = Vcl-Voffset ; %heigth
    B = Pcw - Pcl ; % Big base
    b = AutoPEEP ; % Small Base
    
    IndMin = find(CcwVect>Vol(1));
    IndMax = find(CcwVect<Vol(P));
    Wpeep = AutoPEEP*sqrt( (CcwPresVector(IndMin(1)) - CcwPresVector(IndMax(end)))^2 + (CcwVect(IndMin(1)) - CcwVect(IndMax(end)))^2   );
    Wel = -LcmH20_to_J*h*(b+B)/2 - Wpeep ; % We use the trapeze surface formula A=h(b+B)/2

    % Resistive WOB (Using integration)
    Wres_insp = -LcmH20_to_J*polyarea(Pes(1:P),Vol(1:P)) ;
    Wres_exp = 0;% -LcmH20_to_J*polyarea(Pes(P:L),Vol(P:L)) ;
    Wres = Wres_insp + Wres_exp ; 

    % Expiratory WOB
    Wexp = 0 ;
    Indexes = find( inpolygon(CcwPresVector,CcwVect,Pes,Vol)==1 );
    % Look for points of the Ccw curve inside the Campbell loop
    if (length(Indexes)>10) % If more than 10              
        Imin = get_closestPoints( CcwPresVector(max(Indexes)) , CcwVect(max(Indexes)) ,Pes,Vol) ;
        Imax = get_closestPoints( CcwPresVector(min(Indexes)) , CcwVect(min(Indexes)) ,Pes,Vol) ;
        Wexp = -LcmH20_to_J*polyarea([Pes(Imin:Imax) CcwPresVector(Indexes)],[Vol(Imin:Imax) CcwVect(Indexes)] ) ;    
    end

    % Work of Breathing
    %------------------+
    W = Wel + Wres_insp + Wexp + Wpeep;
    % Resistance
    Res = -(1/LcmH20_to_J)*Wres_insp*Ti/(Vt*Vt) ;
end




%% Store Results    
acqData.inspSize = P ;
acqData.size = L ;
acqData.Vol.mean = Vol ;
acqData.Pdi.mean = Pdi ;
acqData.Plung.mean = Plung ;
acqData.timeV = timeVector ;   
acqData.Pdi.umean = acqData.Pga.umean - acqData.Pes.umean ;
acqData.Pdi.umean = acqData.Pdi.umean - acqData.Pdi.umean(1) ;

% Enregistrement des parametres
%------------------------------+
% Swing (max-min upon the period) (cmH20)
    acqData.SwingPga = SwingPga ; 
    acqData.SwingPes = SwingPes ; 
    acqData.SwingPdi = SwingPdi ;
    acqData.Gilbert = Gilbert ;
% Dynamic lung compliance   (L/cmH20)
    acqData.CLdyn = CLdyn ;
% Resistance (cmH2O/L/s)
    acqData.Res = Res ;
% AutoPEEP  (L/cmH20)
    acqData.AutoPEEP = AutoPEEP ; 
    acqData.AutoPEEPpts = AutoPEEPpts ;
    acqData.AutoPEEPIdx = AutoPEEPpts(1);
%Time parameters    (s)
    acqData.Ti = Ti ;
    acqData.Texp = Texp ;
    acqData.Ttot = Ttot ;
    acqData.Ti_Ttot = Ti_Ttot ;  
    acqData.freq = freq ; % (cycles/min)
% Pressure*Time Product (cmH20*s)
    acqData.Pes.mean = Pes ;
    acqData.Pga.umean = acqData.Pga.umean - acqData.Pga.umean(1) ;
    acqData.Pes.umean = acqData.Pes.umean - acqData.Pes.umean(1) ;
    acqData.PesCW.mean = PesCW ;
    acqData.PTPes = PTPes;
    acqData.PTPdi = PTPdi;
    acqData.PTPesC = PTPesC; % (cmH20/cycle)
    acqData.PTPdiC = PTPdiC; % (cmH20/cycle)
%Volume parameters
    acqData.Vt = Vt;
    acqData.Vt_Ti  = Vt_Ti;
    acqData.FR_VT = FR_VT;
    acqData.VOLexp = VOLexp;
    acqData.Voffset = Voffset ;
% Compliance 
    acqData.CLdynPresVector = CLdynPresVector ;
    acqData.CLdynVect = CLdynVect ;
    acqData.CcwPresVector = CcwPresVector ;
    acqData.CcwVect = CcwVect ;
% Calcul des travaux
    acqData.Wel = Wel ;
    acqData.Wres_insp = Wres_insp;
    acqData.Wres_exp = Wres_exp ;
    acqData.Wres = Wres; 
    acqData.W = W ;
    acqData.Wpeep = Wpeep ;
    acqData.Wexp = Wexp ;            
    
%% NESTED FUNCTIONS

function [AutoPEEP AutoPEEPIdx AutoPEEPpts] = compute_autoPEEP
% this function estimates the autoPEEP for a given Pes and returns the
% value in cmH2O with the points.

dPes = diff(Pes);
inflexion = crossing(dPes);
last = length(inflexion) ;
AutoPEEP = 0;
AutoPEEPpts = [L-3 L];
 if Pes( inflexion(last) ) < Pes (length(Pes)) && last > 1
     if inflexion(last) > 2*L/3 && inflexion(last-1) > 2*L/3  % Means both points are in the end part of the curve
         AutoPEEP = Pes( inflexion(last-1)  ) - Pes( length(Pes) );
         AutoPEEPpts = [ inflexion(last-1) inflexion(last) ] ;
     else
         AutoPEEP = 0 ;
     end
 else
    AutoPEEP = Pes( inflexion(last) ) - Pes( length(Pes) );
    AutoPEEPpts = [ inflexion(last) length(Pes) ] ;
    %AutoPEEP = max( Pes ) - Pes( length(Pes) );
 end   
if AutoPEEP < 0
    AutoPEEP = 0;
end

AutoPEEPIdx = AutoPEEPpts(1);

end

end

