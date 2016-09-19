function   X =  Get_Patches( im, ps ,step)

[h, w,ch]  =  size(im);
maxr         =  h-ps+1;
maxc         =  w-ps+1;
r         =  1:step:maxr;
r         =  [r r(end)+1:maxr];
c         =  1:step:maxc;
c         =  [c c(end)+1:maxc];
X = zeros(ps^2*ch,maxr*maxc,'double');
l    =  0;
for k = 1:ch
    for i  = 1:ps
        for j  = 1:ps
            l    =  l+1;
            blk     =  im(i:end-ps+i,j:end-ps+j,k);
            X(l,:) =  blk(:)';
        end
    end
end
