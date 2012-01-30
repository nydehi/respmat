function testAutoPEEPvsFlowRelation(fileName)
acqData = load_acq( fileName );

    dVol = wden(acqData.data(:,2),'heursure','s','one',5,'sym8') ;
    Peso = wden(acqData.data(:,1),'heursure','s','one',5,'sym8') ;
    
    ddVol = wden( diff(dVol) ,'heursure','s','one',5,'sym8') ;

    Ts = acqData.hdr.graph.sample_time; % Acq Sampling time
    timeVector = (0:Ts:length(dVol)*Ts)./1000 ;
    Vol = cumtrapz( timeVector(1:length(dVol))  , dVol ) ;
    
    
    figure;
    hold on;
    plot(Peso,'r');
    plot(dFlow.*40 + 5,'b');
    plot(d2Flow.*2000 + 10 ,'g');
    plot(dFlow.*40 + d2Flow.*2000 + 20 , 'black');
    
    
    