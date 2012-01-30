function    acqData = get_mean_cycle( acqData , type )
% This function returns the mean values of selected cycles
% if type = 0 process unfilt data
% if type = 1 process filtered data

cycleNbr = length(acqData.expStop) ;
inspStart = acqData.inspStart ;
expStop = acqData.expStop ;
expStart = acqData.expStart ;
L = expStop - inspStart ;
P = expStart - inspStart ;
cycleMeanSize = floor(mean(L));
Pes2 = zeros ( cycleNbr , cycleMeanSize) ;
Pga2 = zeros ( cycleNbr , cycleMeanSize) ;
Paw2 = zeros ( cycleNbr , cycleMeanSize) ;
Flow2 = zeros ( cycleNbr , cycleMeanSize) ;


for (i=1:1:cycleNbr)
    
    switch type
        case 0
            Pes = acqData.Pes.ufilt((1:1:L(i)) +inspStart(i)) ;
            Pga = acqData.Pga.ufilt((1:1:L(i)) +inspStart(i)) ;
            Paw = acqData.Paw.ufilt((1:1:L(i)) +inspStart(i)) ;
            Flow = acqData.Flow.ufilt((1:1:L(i)) +inspStart(i)) ;
        case 1
            Pes = acqData.Pes.filt((1:1:L(i)) +inspStart(i)) ;
            Pga = acqData.Pga.filt((1:1:L(i)) +inspStart(i)) ;
            Paw = acqData.Paw.filt((1:1:L(i)) +inspStart(i)) ;
            Flow = acqData.Flow.filt((1:1:L(i)) +inspStart(i)) ;
    end    

    y = L(i) ;
    x = cycleMeanSize - L(i) ;

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
            if j+1<=length(Pes)
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
        vect = round(-(y+x)/x * a );
        Pes2_ = Pes ;
        Paw2_ = Paw;
        Pga2_ = Pga;
        Flow2_ = Flow ;
        Pes2_(vect ) = [] ;
        Paw2_(vect ) = [] ;
        Pga2_(vect ) = [] ;
        Flow2_(vect ) = [] ;
        Pes2(i,:) = Pes2_(1:cycleMeanSize) ;
        Paw2(i,:) = Paw2_(1:cycleMeanSize) ;            
        Pga2(i,:) = Pga2_(1:cycleMeanSize) ;
        Flow2(i,:) = Flow2_(1:cycleMeanSize) ;
    else
        % Same length as average length
        %-----------------------------+
        Pes2(i,:) = Pes ;
        Paw2(i,:) = Paw;
        Pga2(i,:) = Pga;
        Flow2(i,:) = Flow ;
    end
end

while sum( [ Pes2(:,size(Pes2,2))==0 ;
         Paw2(:,size(Paw2,2))==0 ;
         Pga2(:,size(Pga2,2))==0 ;
         Flow2(:,size(Flow2,2))==0 ] ) ~= 0
     Pes2(:,size(Pes2,2)) = [] ;
     Paw2(:,size(Paw2,2)) = [] ;
     Pga2(:,size(Pga2,2)) = [] ;
     Flow2(:,size(Flow2,2)) = [] ;
end

acqData.cycleNumber = cycleNbr ;
acqData.P = P;
acqData.L = L;
acqData.Pmean = floor(mean(P)) - 1 ;
acqData.Lmean = length(Pes2) ;


if trapz(1:acqData.Pmean,mean(Pes2(:,1:acqData.Pmean),1))>0
    warning('get_mean_cycle:DataInverted','Pes or Flow has been inverted');
    Pes2 = -Pes2 ;
end
    

switch type
    case 0
        acqData.Pes.umean = mean(Pes2,1) ;
        acqData.Paw.umean = mean(Paw2,1) ;
        acqData.Pga.umean = mean(Pga2,1) ;
        acqData.Flow.umean = mean(Flow2,1) ;
    case 1
        acqData.Pes.mean = mean(Pes2,1) ;
        acqData.Paw.mean = mean(Paw2,1) ;
        acqData.Pga.mean = mean(Pga2,1) ;
        acqData.Flow.mean = mean(Flow2,1) ;
end
        




