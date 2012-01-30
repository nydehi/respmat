function    meanCycles = get_mean_cycles( dataStruct )

cycleNbr = results.cycleNumber ;
cycleSize = results.size ;
cycleMeanSize = floor(mean(cycleSize));
Pes2 = zeros ( cycleNbr , cycleMeanSize) ;
Pga2 = zeros ( cycleNbr , cycleMeanSize) ;
Paw2 = zeros ( cycleNbr , cycleMeanSize) ;
Flow2 = zeros ( cycleNbr , cycleMeanSize) ;

for (i=1:1:cycleNbr)
    L(i) = expStop(i) - inspStart(i);
    P(i) = einspStop(i) - inspStart(i);
    Pes = results.Pes{i} ;
    Pga = results.Pga{i} ;
    Paw = results.Paw{i} ;
    Flow = results.Flow{i} ;
    y = cycleSize(i) ;
    x = cycleMeanSize - cycleSize(i) ;

    if x > 0
        % Points have to be added
        %-----------------------+
        k = 0;
        Pes2(i,:) = [Pes' zeros(1 , x)];
        Paw2(i,:) = [Paw' zeros(1 , x)];
        Pga2(i,:) = [Pga' zeros(1 , x)];
        Flow2(i,:) = [Flow' zeros(1 , x)];        
        for idx = 1:1:x
            j = floor(idx * y/x) + 1 ;
            if j+1<=length(Flow)
                interpVal = ( Pes(j) + Pes(j+1) ) / 2 ;
                Pes2(i,:) = [ Pes2(i,1:j+k) interpVal Pes2(i,j+1+k:(x+y-1)) ];        
                interpVal = ( Paw(j) + Paw(j+1) ) / 2 ;
                Paw2(i,:) = [ Paw2(i,1:j+k) interpVal Paw2(i,j+1+k:(x+y-1)) ];        
                interpVal = ( Pga(j) + Pga(j+1) ) / 2 ;
                Pga2(i,:) = [ Pga2(i,1:j+k) interpVal Pga2(i,j+1+k:(x+y-1)) ];
                interpVal = ( Flow(j) + Flow(j+1) ) / 2 ;
                Flow2(i,:) = [ Flow2(i,1:j+k) interpVal Flow2(i,j+1+k:(x+y-1)) ];        
                k = k + 1 ;
            end            
        end            
    elseif x<0 
        % Points to be deleted
        %---------------------+
        a = 1:1:-x ;
        vect = floor(-(y+x)/x * a );
        Pes2_ = Pes ;
        Paw2_ = Paw;
        Pga2_ = Pga;
        Flow2_ = Flow ;
        Vol2_(vect ) = [] ;
        Pes2_(vect ) = [] ;
        Paw2_(vect ) = [] ;
        Pga2_(vect ) = [] ;
        Flow2_(vect ) = [] ;
        Pes2(i,:) = Pes2_(1:cycleMeanSize) ;
        Paw2(i,:) = Paw2_(1:cycleMeanSize) ;            
        Pga2(i,:) = Pga2_(1:cycleMeanSize) ;
        Flow2(i,:) = Flow2_(1:cycleMeanSize) ;
    else
        %% Same length as mean-length
        %-----------------------------+
        Pes2(i,:) = Pes ;
        Paw2(i,:) = Paw;
        Pga2(i,:) = Pga;
        Flow2(i,:) = Flow ;
    end
end

while sum(  Pes2(:,size(Pes2,2))==0 ;
         Paw2(:,size(Paw2,2))==0 ;
         Pga2(:,size(Pga2,2))==0 ;
         Flow2(:,size(Flow2,2))==0 ] ) ~= 0
     Pes2(:,size(Pes2,2)) = [] ;
     Paw2(:,size(Paw2,2)) = [] ;
     Pga2(:,size(Pga2,2)) = [] ;
     Flow2(:,size(Flow2,2)) = [] ;
end


meanCycles.L = mean(L) ;
meanCycles.P = mean(P) ;
meanCycles.Pes = mean(Pes2) ;
meanCycles.Paw = mean(Paw2) ;
meanCycles.Pga = mean(Pga2) ;
meanCycles.Flow = mean(Flow2) ;
% Create new data    
meanCycles.time = (0:Ts:length(Flow)*Ts)./1000 ;
meanCycle.Volume = cumtrapz( timeVector(1:length(meanCycles.Flow))  , meanCycles.Flow ) ;
% Plung = Paw - Peso ; 
meanCycles.Pdia = meanCycles.Pga - meanCycles.Pes ;
    