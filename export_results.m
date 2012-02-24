function export_results(  results )
% this function print the results in a CSV format


if exist('results','var')
    
    if isfield(results,'fidOut') 
        fid = results.fidOut ;
 
        warn = lastwarn ;
        if ~isempty(warn)
            fprintf( fid , '%s\n' , warn );
        else
            toBePrinted =  [ 
                results.age ;
                results.height ;
                results.sex ;
                results.Ccw ;
                results.PTPesC ;
                results.Ti ;
                results.Ti + results.Texp ;
                results.Vt ;
                results.SwingPes ;
                results.CLdyn ; 
                results.PTPdiC ;
                results.Wel ;
                results.Wres ;
                results.Res ;
                
                results.AutoPEEP ;
                ] ; 
            fprintf( fid , '%s\t' , results.File(1:end-4) ) ;
            for i = 1:length(toBePrinted)
               fprintf( fid , '%.3f\t' , toBePrinted(i) ) ;
            end
            fprintf( fid , '\n' ) ;

        end    
    else
        warndlg('Can''t find export file');
    end
end