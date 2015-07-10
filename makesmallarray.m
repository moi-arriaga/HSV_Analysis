% arr=xlsread('VideoMeasurements.xlsx');
% for q=1:126
%    if arr(q,3)==4000
%       arr(q,1)=arr(q,1)+9; 
%    end
%    
%    if arr(q,3)==8000
%       arr(q,1)=arr(q,1)+18; 
%    end
% end
% smallarr=ones(27,18);
for i=1:27
 
    
    for q=1:126
        if arr(q,1)==i
            i
            q
            smallarr(i,:)=arr(q,:);
            break;
        end
    end
    
end