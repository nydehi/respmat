
function acqData = load_data_file( Path , File , handles  )

%% Open file
acqData = {};
% define default values

    acqData.hdr.per_chan_data(1).comment_text = 'Pes';
    acqData.hdr.per_chan_data(2).comment_text = 'Pga';
    acqData.hdr.per_chan_data(3).comment_text = 'Flow';
    acqData.hdr.per_chan_data(4).comment_text = 'Paw';
    acqData.hdr.per_chan_data(1).units_text = 'cmH20';
    acqData.hdr.per_chan_data(2).units_text = 'cmH20';
    acqData.hdr.per_chan_data(3).units_text = 'L/s';
    acqData.hdr.per_chan_data(4).units_text = 'cmH20';
    
    
if ( strcmp(File(length(File)-2:length(File)),'acq')==1 || strcmp(File(length(File)-2:length(File)),'ACQ')==1 )   
    % ACQ FILE
    %----------+
    acqData = load_acq( [Path File] );
elseif strcmp(File(length(File)-2:length(File)),'xls')==1
    % XLS FILE
    %----------+
    Fsample = inputdlg({'Prompt sampling frequency (Hz):'}) ;
    Tsample = 1000/str2double(Fsample{1});
    acqData.hdr.graph.sample_time = Tsample ;
    acqData.data = xlsread( [Path File] ) ;    % Get the data 
elseif strcmp(File(length(File)-2:length(File)),'csv')==1
    % CSV FILE
    %----------+
    Fsample = inputdlg({'Prompt sampling frequency (Hz):'}) ;
    Tsample = 1000/str2double(Fsample{1});
    acqData.hdr.graph.sample_time = Tsample ;
    acqData.data = dlmread( [Path File] , ';' ) ; % Get the data
elseif strcmp(File(length(File)-2:length(File)),'txt')==1
    % TXT FILE
    %----------+
    Fsample = inputdlg({'Prompt sampling frequency (Hz):'}) ;
    Tsample = 1000/str2double(Fsample{1});
    acqData.hdr.graph.sample_time = Tsample ;
    acqData.data = dlmread( [Path File] , '\t' ) ; % Get the data
else
    error('load_processed_file:WrongFileFormat','Sorry the file format is not supported');    
end    
acqData.Path = Path ;
acqData.File = File ;



