function  X = DenoiseOutput_LowMemoryReq(D,S,sizeIMin,PatchSize,idex)
%Version 1: 11/02/2009
%Updated in 03/08/2010
%Written by Mingyuan Zhou, Duke ECE, mz1@ee.duke.edu
channelNum = size(D,1)/PatchSize^2;
X = zeros(sizeIMin(1),sizeIMin(2),channelNum);
X = reshape(X,[],channelNum);
Weight = conv2(full(sparse(idex(:,1),idex(:,2),1,sizeIMin(1)-PatchSize+1,sizeIMin(2)-PatchSize+1)),ones(PatchSize,PatchSize),'full');
for p=1:PatchSize^2;
    for channel=1:channelNum        
        [posi,posj] = ind2sub([PatchSize,PatchSize],p);
        ind = sub2ind(sizeIMin(1:2),idex(:,1)+posi-1,idex(:,2)+posj-1);        
        X(ind,channel) = X(ind,channel) + S*D(p+(channel-1)*PatchSize^2,:)';       
    end
end    
X = reshape(X,sizeIMin(1),sizeIMin(2),[]);
for channel=1:channelNum   
    X(:,:,channel) = X(:,:,channel)./(Weight+realmin);
end