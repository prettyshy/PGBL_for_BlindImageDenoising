function X = Update_Input(X,Xj,idexNew,PatchSize)
%Version 1: 11/02/2009
%Updated in 03/08/2010
%Written by Mingyuan Zhou, Duke ECE, mz1@ee.duke.edu
N = size(idexNew,1);
P = size(IMin,3)*PatchSize^2;
XNew = zeros(P,N);
for i=1:N
    Pos1 = idexNew(i,1)+(0:PatchSize-1);
    Pos2 = idexNew(i,2)+(0:PatchSize-1);    
    XNew(:,i) = reshape(IMin(Pos1,Pos2,:),[],1);
end
X = [X,XNew];
end
