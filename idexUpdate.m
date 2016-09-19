
function idexNew = idexUpdate(sizeIMin, PatchSize,colj,rowi)
%Update the index of the patches in the training data
%Version 1: 09/12/2009
%Version 2: 11/02/2009
%Version 3: 11/18/2009
%Updated in 03/08/2010
%Written by Mingyuan Zhou, Duke ECE, mz1@ee.duke.edu
idexMat=false(sizeIMin(1)-PatchSize+1,sizeIMin(2)-PatchSize+1);
if colj==1 && rowi==1
    idexMat([rowi:PatchSize:end-1,end],[colj:PatchSize:end-1,end])=true;
elseif colj==1 && rowi~=1
    idexMat(rowi:PatchSize:end-1,[colj:PatchSize:end-1,end])=true;
elseif colj~=1 && rowi==1
    idexMat([rowi:PatchSize:end-1,end],colj:PatchSize:end-1)=true;
else
    idexMat(rowi:PatchSize:end-1,colj:PatchSize:end-1)=true;
end
[idexNewi,idexNewj] = find(idexMat);
idexNew = [idexNewi,idexNewj];
end