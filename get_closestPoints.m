function idx = get_closestPoints(x,y,X,Y)

L1 = sqrt( (x-X(1))*(x-X(1))+ (y-Y(1))*(y-Y(1)) );
idx = 1;
for i=1:1:length(X)
    L2 = sqrt( (x-X(i))*(x-X(i)) + (y-Y(i))*(y-Y(i)) );
    if L2<L1
        L1 = L2 ;
        idx = i ;
    end
end
   
end