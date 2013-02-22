function acqData = filter_data( acqData )
% This function filters data


% Detrend data
FlowR = detrend( acqData.data(:,acqData.seq(1)) );
PesR = detrend( acqData.data(:,acqData.seq(2)) ) ;
PawR = detrend( acqData.data(:,acqData.seq(3)) );
PgaR = detrend( acqData.data(:,acqData.seq(4)) ); 

% Create time series
timeV = (1:size(acqData.data,1)) * acqData.Ts/1000 ; 
tsFlow = timeseries( acqData.data(:,1), timeV ) ;%1 %3
tsPes = timeseries( acqData.data(:,2) , timeV ) ;%2 %1 
tsPaw = timeseries( acqData.data(:,3) , timeV ) ;%3  %4
tsPga = timeseries( acqData.data(:,4) , timeV ) ;%4  %2

% Define and apply temporal filter
BP_filter = [.05 5] ;
tsFlow = idealfilter(tsFlow , BP_filter , 'pass');
tsPes = idealfilter(tsPes , BP_filter , 'pass');
tsPaw = idealfilter(tsPaw , BP_filter , 'pass');
tsPga = idealfilter(tsPga , BP_filter , 'pass');

acqData.Flow.filt = tsFlow.Data ;
acqData.Pes.filt =  tsPes.Data - 5;
acqData.Paw.filt = tsPaw.Data ;
acqData.Pga.filt = tsPga.Data ;

% Create new data   
Ts = acqData.Ts ;
timeVector = (0:Ts:length(acqData.Flow.filt)*Ts)./1000 ;
acqData.Vol.filt = cumtrapz( timeVector(1:length(acqData.Flow.filt)) , acqData.Flow.filt ) ;
acqData.Plung.filt = acqData.Paw.filt - acqData.Flow.filt ; 
acqData.Pdi.filt = acqData.Pga.filt - acqData.Flow.filt ;

acqData.Flow.ufilt = FlowR ;
acqData.Pes.ufilt =  PesR - 5;
acqData.Paw.ufilt = PawR ;
acqData.Pga.ufilt = PgaR ;
acqData.Plung.ufilt = acqData.Pes.ufilt - acqData.Paw.ufilt ; 
acqData.Pdi.ufilt = acqData.Pga.ufilt - acqData.Pes.ufilt ;
