function acqData = preprocess_acqData( acqData )
% this function pre-processed the data and returns clean data

% this describes the order in which data are supposed to be
%  seq = [ 3 1 4 2 ]; % describe the data order
acqData.seq = [ 1 2 3 4 ] ;


%% filter data
acqData.Ts = acqData.hdr.graph.sample_time; % Acq Sampling time

% Filter data
acqData = filter_data( acqData  );

% Extract names for more convenience
Flow = acqData.Flow.filt ;
Pes = acqData.Pes.filt ; 
Paw = acqData.Paw.filt ;
Pga = acqData.Pga.filt ;


%% Create events
% detect zero crossing events => begin inspiration, expiration
nullFlow = crossing(Flow) ;
% make it begin at inspiration
if (length(nullFlow)<3)
    error('preprocess_acqData:NoFlow','Airflow data is corrupted');
end
if ( Flow(nullFlow(2)-1) < Flow(nullFlow(2)+1) )
    nullFlow(1) = [];
end

%% Generate feature vectors
inspStart = nullFlow(1:2:length(nullFlow));
expStop = nullFlow(3:2:length(nullFlow));
expStart = nullFlow(2:2:length(nullFlow)); 
M = min([length(inspStart) length(expStart) length(expStop)]) ;
inspStart = inspStart(1:M);
expStop = expStop(1:M);
expStart = expStart(1:M);

%% Detect outliers
% By impossible values   
intervals = expStop - inspStart;
outliers = find( intervals*acqData.Ts/1000 < 1 ) ;
intervalsb = intervals ;
intervalsb(outliers) = [] ; 

% By interval size
TolThres = acqData.tolThres ; % Tolerance threshold for Std deviation from mean
[~,indx] = sort(abs(intervals-mean(intervals)),'descend');
outliers = [outliers indx(1:round((1-TolThres)*length(indx))) ];

% By artefacts
[muFlow sigmaFlow] = normfit(Flow);
[muPes sigmaPes] = normfit(Pes);
[muPga sigmaPga] = normfit(Pga);
[muPaw sigmaPaw] = normfit(Paw);
muFlow  = median(Flow);
muPes  = median(Pes);
muPga  = median(Pga);
muPaw  = median(Paw);
                                                          % The x4 factor is used to convert the percentage
                                                          % threshold in a number of allow std from mean in
                                                          % raw signals     
artifacted = find( abs(Flow - muFlow*ones(length(Flow),1))>4*TolThres*sigmaFlow*ones(length(Flow),1) )';
artifacted = [artifacted find(abs(Pes - muPes*ones(length(Pes),1))>4*TolThres*sigmaPes*ones(length(Pes),1))'];        
artifacted = [artifacted find(abs(Pga - muPga*ones(length(Pga),1))>4*TolThres*sigmaPga*ones(length(Pga),1))'];
artifacted = [artifacted find(abs(Paw - muPaw*ones(length(Paw),1))>4*TolThres*sigmaPaw*ones(length(Paw),1))'];
for i=1:1:length(artifacted)
    outliers = unique([outliers find(expStop>artifacted(i),1)]);            
end

%delete periods with artefacts
inspStart(outliers) = [];
expStop(outliers) = [];
expStart(outliers) = [];  
outliers = zeros(size(inspStart));

% By leak detection (after removal of artefacted areas)
for i=1:1:length(inspStart)
    VolMax = trapz(  Flow(inspStart(i):expStart(i)) ) ;
    VolFin = trapz(  Flow(expStart(i):expStop(i)) ) ;
    leak = abs(VolMax+VolFin)/VolMax;
    if leak>0.3
        outliers(i) = 1 ;
    end
end

%delete periods with leaks
inspStart(outliers==1) = [];
expStop(outliers==1) = [];
expStart(outliers==1) = [];   

% Generate an error if not enough good quality data
if (length(inspStart)<3)
    warning('preprocess_acqData:NotEnoughData', 'Too many artifacts, not enough good quality data');
end

% Generate titles
acqData.Flow.title = ['FLOW : ' acqData.hdr.per_chan_data(acqData.seq(1)).comment_text ' in ' acqData.hdr.per_chan_data(acqData.seq(1)).units_text] ;   
acqData.Pes.title = ['PESO : ' acqData.hdr.per_chan_data(acqData.seq(2)).comment_text ' in ' acqData.hdr.per_chan_data(acqData.seq(2)).units_text] ;
acqData.Paw.title = ['PAW : ' acqData.hdr.per_chan_data(acqData.seq(3)).comment_text ' in ' acqData.hdr.per_chan_data(acqData.seq(3)).units_text] ;
acqData.Pga.title = ['PGA : ' acqData.hdr.per_chan_data(acqData.seq(4)).comment_text ' in ' acqData.hdr.per_chan_data(acqData.seq(4)).units_text] ;
acqData.Pdi.title = ['PDI (cmH2O)'] ;

% Save good periods 
acqData.expStart = expStart ;
acqData.inspStart = inspStart ;
acqData.expStop = expStop ;






end