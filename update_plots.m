 function update_plots( results , handles )
% This function updates plots


% TODO
% Solve Pga / Pdi
% remove scales but the one at the bottom
% Display "average cycle"


%% Initialise


% define colors
ufiltColor = [.8 , .8 , .9] ;
wobColor =  [ .8 , .8 , .99  ] ;
warnColor = [1 , .8 , .5] ;

%% Plot raw data 
% Flow
plot(handles.axe_Flow  , results.Flow.filt  );
set(handles.axe_Flow, 'NextPlot' , 'add');    
plot(handles.axe_Flow , get(handles.axe_Flow ,'XLim' ) , [0 0] , '--k' );
set(handles.axe_Flow, 'NextPlot' , 'add'); 
set(handles.axe_Flow,   'YTick' , []); 
set(handles.axe_Flow, 'XTick' , 0:(length(results.Flow.filt)/10):length(results.Flow.filt) );
set(handles.axe_Flow, 'XTickLabel' , num2str( (0:(length(results.Flow.filt)/10):length(results.Flow.filt))'*results.Ts*1e-3/60  ,1 ) );
xlabel(handles.axe_Flow,'All cycles, T in minutes');

% Pressures
plot(handles.axe_Paw , results.Paw.filt );
set(handles.axe_Paw, 'XTick' , [] , 'YTick' , []); 
plot(handles.axe_Peso , results.Pes.filt );
set(handles.axe_Peso, 'XTick' , [] , 'YTick' , []); 
plot(handles.axe_Pdi , results.Pdi.filt );
set(handles.axe_Pdi, 'XTick' , [] , 'YTick' , []); 

% Next plot is add
set(handles.axe_Paw, 'NextPlot' , 'add');
set(handles.axe_Peso, 'NextPlot' , 'add');
set(handles.axe_Pdi, 'NextPlot' , 'add');

%% Plot events 
beginInsp = results.inspStart ;
plot(handles.axe_Paw , beginInsp , results.Paw.filt(beginInsp)  , '^k'  );
%legend(handles.axe_Paw , results.Paw.title ,'Location', 'Best' );
plot(handles.axe_Peso , beginInsp , results.Pes.filt(beginInsp)  , '^k'  );
%legend(handles.axe_Peso , results.Pes.title ,'Location', 'Best');
plot(handles.axe_Pdi , beginInsp , results.Pdi.filt(beginInsp)  , '^k'  );
%legend(handles.axe_Pdi  , results.Pdi.title ,'Location', 'Best');
plot(handles.axe_Flow , beginInsp , results.Flow.filt(beginInsp)  , '^k'  );
legend(handles.axe_Flow  , results.Flow.title , 'Zero Flow','Inspiration Start' ,'Location', 'Best');

% Next plot is add
set(handles.axe_Paw, 'NextPlot' , 'replace');
set(handles.axe_Peso, 'NextPlot' , 'replace');
set(handles.axe_Pdi, 'NextPlot' , 'replace');
set(handles.axe_Flow, 'NextPlot' , 'replace');
    
%% Display Mean Cycle

if isempty(lastwarn)
    % No warning
    set( handles.text_ERROR, 'BackgroundColor' ,'white');
    set( handles.text_ERROR, 'String' , '' );
    
    % define variables for convenience
    meanVol = results.Vol.mean ;
    meanPes = results.Pes.mean ;
    meanPga = results.Pga.mean ;
    meanPdi = results.Pdi.mean ;
    meanFlow = results.Flow.mean ;    
    meanPaw = results.Paw.mean ;
    meanLung = results.Plung.mean ;
    Idx = results.AutoPEEPIdx ;
    P = results.Pmean ;
    L = length(meanPes) ;

    % Flow
    set(gcf,'CurrentAxes',handles.axe_FlowMean);
    plot( results.Flow.umean , 'color' , ufiltColor ); hold on
    plot( meanFlow  );
    plot( get(handles.axe_FlowMean ,'XLim' ) , [0 0] , '--k'  );
    set(handles.axe_FlowMean, 'NextPlot' , 'replace');
    %legend(handles.axe_FlowMean,'Unfilt. Flow','Flow','Location','NorthEast');
    set(handles.axe_FlowMean, 'XTick' , 0:L/3:L );
    set(handles.axe_FlowMean, 'XTickLabel' , num2str( (0:L/3:L)'*results.Ts*1e-3 ,1) );
    xlabel(handles.axe_FlowMean,'Average cycle, t in s');
    ylabel(handles.axe_FlowMean,'Flow (L/s)');
    hold off

    % Paw
    set(gcf,'CurrentAxes',handles.axe_PawMean);
    plot( results.Paw.umean , 'color' , ufiltColor ); hold on
    plot(handles.axe_PawMean , meanPaw );
    %legend('Paw','Location','Best');
    set(handles.axe_PawMean,  'XTick' , []); 
    ylabel(handles.axe_PawMean,'Paw (cmH_2O)');
    hold off


    % Pdi with Swing value
    set(gcf,'CurrentAxes',handles.axe_PdiMean);

    plot( results.Pdi.umean + meanPdi(1) , 'color' , ufiltColor  );
    hold on 
    quiver( Idx , meanPdi(Idx) , 0 , results.SwingPdi , 1 );
    area( Idx:L , meanPdi(Idx:L), meanPdi(results.AutoPEEPpts(1)) , 'FaceColor',wobColor);
    area( meanPdi(1:P), meanPdi(results.AutoPEEPpts(1)), 'FaceColor',wobColor);
    plot( meanPdi );
    %legend('PTPdi','Swing Pdi','Pdi','Location','Best')
    set(handles.axe_PdiMean,  'XTick' , []); 
    ylabel(handles.axe_PdiMean,'Pdi (cmH_2O)');
    hold off

    % Pes with :
    set(gcf,'CurrentAxes',handles.axe_PesoMean);
    plot( results.Pes.umean, 'color' , ufiltColor);
    hold on;
        % plot autoPEEP and set the AutoPEEP slider
    if (isnan(results.AutoPEEPpts(1))~=1)
        plot(handles.axe_PesoMean , results.AutoPEEPpts , meanPes(results.AutoPEEPpts)  , '+r' );
        set(handles.slider_PEEP , 'Max' , length(meanPes) );
        set(handles.slider_PEEP , 'Min' , 0  );
        set(handles.slider_PEEP , 'Value' , results.AutoPEEPpts(1)  );
        set(handles.slider_PEEP,'Enable','on');
    end    
        % SwingPes
    quiver( Idx , meanPes(Idx) , 0 , results.SwingPes , 1  ); 
        % Pes Ccw for PTP
    fill([1:P P:-1:1],[meanPes(1:P) results.PesCW.mean(P:-1:1)],wobColor);
    fill([Idx:L L:-1:Idx],[meanPes(Idx:L) results.PesCW.mean(L:-1:Idx)],wobColor) ;
        % Value and title
    plot( meanPes );    
    %legend( 'Raw Pes' , 'PEEPi' , 'Swing Pes' ,'PTPes' ,'Location' , 'Best');
    set(handles.axe_PesoMean,  'XTick' , []); 
    ylabel(handles.axe_PesoMean,'Pes (cmH_2O)');
    hold off

    %% Campbell with
    set(gcf,'CurrentAxes',handles.axe_campbell);
    title('Campbell''s diagramm');
        % Elestic WOB
        if results.Wres == 0
            % Mechanical ventillation
            IndMin = find(results.CcwVect>meanVol(1));
            IndMax = find(results.CcwVect<meanVol(P));
            Indexes = IndMin(1):IndMax(end);
            fill( [meanPes(P:-1:1) results.CcwPresVector(Indexes) ] , [meanVol(P:-1:1) results.CcwVect(Indexes) ] , wobColor ) ; hold on;
        else
            % Free breathing
            fill( meanPes(1:results.Pmean) , meanVol(1:results.Pmean) ,wobColor) ; hold on;
        end
        % PV curve
    plot(handles.axe_campbell , meanPes , meanVol  ); 
        % CLdyn Line
    plot(handles.axe_campbell , results.CLdynPresVector , results.CLdynVect , 'red') ;
        % Ccw Line
    plot(handles.axe_campbell , results.CcwPresVector , results.CcwVect , 'green') ;  
    ylabel(handles.axe_campbell,'Pes (cmH_2O)');
    xlabel(handles.axe_campbell,'Volume (L)');
    legend(handles.axe_campbell,'Wob','PV','CLdyn','Ccw','Location','Best');
    hold off


    



else
    %% s
    set( handles.text_ERROR, 'BackgroundColor' , warnColor);
    set( handles.text_ERROR, 'String' , lastwarn );
    clean_plots(handles);
        
        

 
end
                