function     [cvi,Ccw] = compute_ccw(age,size,sex,cvi)
% Compute Ccw give abaques with 3 parameters


if nargin<4
    cvi = 0;
    if age > 18
        if sex == 1
            cvi = 6.10*size/100 - 0.028*age - 4.65 ;      
        elseif sex == 2
            cvi = 4.66*size/100 - 0.026*age - 3.28 ;
        end
    elseif age <= 18
        if sex == 1
            if size > 150
                cvi = 8.4*size/100 - 9.9 ;      
            else
                cvi = 5.7*size/100 - 5.26 ;
            end 
        elseif sex == 2           
            if size > 150
                cvi = 5*size/100 - 4.5 ;      
            else
                cvi = 5.5*size/100 - 5.39 ; 
            end     
        end    
    end
end

Ccw = 0.04*cvi ;