function save_to_pdf( figureHandle , fileName )    
   % set(figureHandle,'PaperUnits','centimeters');
   % set(figureHandle,'PaperPosition',[0 0  29.7 21]);
    set(figureHandle,'InvertHardcopy','off');
    set(figureHandle,'PaperType','A4');
    orient landscape
    %set(figureHandle,'PaperOrientation','landscape');
    print('-dpdf','-loose',fileName);
    %saveas(figureHandle,fileName,'png')
end