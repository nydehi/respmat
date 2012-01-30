function clean_plots(handles)


           
%% Clean Mean plots           
        % FLOW
        plot(handles.axe_FlowMean , 1  );
        set(handles.axe_FlowMean , 'NextPlot' , 'add');

        % PRESSURES
        plot(handles.axe_PawMean ,  1  );
        plot(handles.axe_PesoMean ,  1  );
        plot(handles.axe_PdiMean , 1  );

        title(handles.axe_PawMean , 'Paw' );  
        set(handles.axe_PesoMean , 'NextPlot' , 'add');
    
        title(handles.axe_PesoMean , 'Peso' );
        title(handles.axe_PdiMean  , 'Pga' );
        title(handles.axe_FlowMean  , 'Flux' );

        % CAMPBELL    
        title(handles.axe_campbell, 'Campbell');
        plot(handles.axe_campbell , 1 , 1 ); 

  
        
    
    
% Next plot is REPLACE
    set(handles.axe_Paw, 'NextPlot' , 'replace');
    set(handles.axe_Peso, 'NextPlot' , 'replace');
    set(handles.axe_Pdi, 'NextPlot' , 'replace');
    set(handles.axe_Flow, 'NextPlot' , 'replace');
    set(handles.axe_campbell, 'NextPlot' , 'replace');
    set(handles.axe_PawMean, 'NextPlot' , 'replace');
    set(handles.axe_PesoMean, 'NextPlot' , 'replace');
    set(handles.axe_PdiMean, 'NextPlot' , 'replace');
    set(handles.axe_FlowMean, 'NextPlot' , 'replace');