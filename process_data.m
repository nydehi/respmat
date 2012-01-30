function acqData = process_data(acqData ) 
% this function process the data


% Pre-processing
acqData = preprocess_acqData( acqData );
% get mean cycles (filt/unfilt)
if isempty(lastwarn)
    acqData = get_mean_cycle( acqData , 0 ) ;
    acqData = get_mean_cycle( acqData , 1 ) ;
    % Processing
    acqData = compute_results( acqData );
end
    

