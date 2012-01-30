function [Volume , Plung , Pdia , ind] = extractFeatures (  filtered_data   )

    Volume = cumtrapz( filtered_data(:,1) );
    Plung = filtered_data(:,3) - filtered_data(:,2) ;  
    Pdia = filtered_data(:,4) - filtered_data(:,2) ;
    ind = crossing(filtered_data(:,1));

end