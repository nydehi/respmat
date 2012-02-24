function acqData = process_gui_io(acqData,handles)
% Process the manual inputs to compute values

acqData.studyCode = get( handles.edit_lastname , 'String');
acqData.subjectCode = get( handles.edit_firstname , 'String');
acqData.comments = get( handles.edit_comments , 'String');  

% Compute CVI
%TODO : or get CVI if already present 
acqData.age =  str2double(get( handles.edit_age , 'String')) ;
acqData.height = str2double( get( handles.edit_size , 'String') );
acqData.sex = get( handles.popup_sex , 'Value') ;
[acqData.cvi,acqData.Ccw] = compute_ccw(acqData.age,acqData.height,acqData.sex);

% Thres Tolerance
acqData.tolThres =  get(handles.sliderTol,'Value') ;

