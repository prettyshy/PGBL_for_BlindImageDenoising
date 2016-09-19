function im_mycbcr = rgb2mycbcr(im)

[h,w,ch] = size(im);
im_mycbcr = zeros(h,w,ch);
if ch==1
    im_mycbcr = im;
elseif ch==3
    im_mycbcr(:,:,1) = 0.666*im(:,:,2)+0.334*im(:,:,1);
    im_mycbcr(:,:,2) = 0.666/1.6*(im(:,:,1)-im(:,:,2));
    im_mycbcr(:,:,3) = 0.5*(im(:,:,3)-0.666*im(:,:,2)-0.334*im(:,:,1));
end


