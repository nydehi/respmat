function tscAVG = getAVGData( tsc , info )

    intervals = info.intervals ;
    Ts = info.Ts ;
    Events = tsc.Volume.Events;

% Generate Avg shape
    maxInterval = int32(max(intervals)/Ts);
    MeanVol = []; MeanPaw = []; MeanPeso = []; MeanPga = [];
    for (idx=1:1:length(Events))
        currentPeriodVol = gettsafterevent( tsc.Volume , 'inspStart' , idx );
%         currentPeriodPaw = gettsafterevent( tsc.Paw , 'inspStart' , idx );
        currentPeriodPeso = gettsafterevent( tsc.Peso , 'inspStart' , idx );
%         currentPeriodPga = gettsafterevent( tsc.Pga , 'inspStart' , idx );
        
        if (length(currentPeriodVol)<maxInterval)
            currentPeriodVol = [currentPeriodVol.Data ; zeros(maxInterval-length(currentPeriodVol),1)];
%             currentPeriodPaw = [currentPeriodPaw.Data ; zeros(maxInterval-length(currentPeriodPaw),1)];
            currentPeriodPeso = [currentPeriodPeso.Data ; zeros(maxInterval-length(currentPeriodPeso),1)];
%             currentPeriodPga = [currentPeriodPga.Data ; zeros(maxInterval-length(currentPeriodPga),1)];  	
        else
            currentPeriodVol = currentPeriodVol.Data(1:maxInterval);
%             currentPeriodPaw = currentPeriodPaw.Data(1:maxInterval);
            currentPeriodPeso = currentPeriodPeso.Data(1:maxInterval);
%             currentPeriodPga = currentPeriodPga.Data(1:maxInterval);
        end
        if (idx==1)
            MeanVol = currentPeriodVol;
%             MeanPaw = currentPeriodPaw;
            MeanPeso = currentPeriodPeso;
%             MeanPga = currentPeriodPga;
        else
            MeanVol = MeanVol + currentPeriodVol;
%             MeanPaw = MeanPaw + currentPeriodPaw;
            MeanPeso = MeanPeso + currentPeriodPeso;
%             MeanPga = MeanPga + currentPeriodPga;
        end
    end
    MeanVol = MeanVol / idx ;
%     MeanPaw = MeanPaw / idx ;
    MeanPeso = MeanPeso / idx ;
%     MeanPga = MeanPga / idx ;

    tsVolumeAVG = timeseries( MeanVol , 'Name' , 'Volume' ) ;
    tsPesoAVG = timeseries(MeanPeso  , 'Name' , 'Peso' ) ;
%     tsPawAVG = timeseries(MeanPaw  , 'Name' , 'Paw' ) ;
%     tsPgaAVG = timeseries( MeanPga , 'Name' , 'Pga' ) ;   

    tscAVG = tscollection({tsVolumeAVG, tsPesoAVG } , 'name' , 'resp_data_mean' );
    flowNull = crossing(diff(tscAVG.Volume.Data));
    tscAVG = tscAVG(1:flowNull(2));
    
end