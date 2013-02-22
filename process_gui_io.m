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
CVI = get(handles.edit_cvi,'String');

if strcmp(CVI,'L')
    [acqData.cvi,acqData.Ccw] = compute_ccw(acqData.age,acqData.height,acqData.sex);
else
    CVI = str2num(CVI);
    if CVI > 0 && CVI < 10
        [acqData.cvi,acqData.Ccw] = compute_ccw(acqData.age,acqData.height,acqData.sex,CVI);
    else
        [acqData.cvi,acqData.Ccw] = compute_ccw(acqData.age,acqData.height,acqData.sex);
    end
end

% Thres Tolerance
acqData.tolThres =  get(handles.sliderTol,'Value') ;

