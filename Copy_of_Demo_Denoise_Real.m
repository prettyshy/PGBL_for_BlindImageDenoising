clear;
warning off;
Original_image_dir  =    '../1_Results/NoisyImage/Real/';
fpath = fullfile(Original_image_dir, 'Real_SolvayConf1927.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
% set parameters
c0 = 1e-6;
d0 = 1e-6;
e0 = 1e-6;
f0  = 1e-6; 
Hyper.c0=c0;
Hyper.d0=d0;
Hyper.e0=e0;
Hyper.f0=f0;
Hyper.PatchSize = 8;
Hyper.step = 3;
nlsp = 6;
Hyper.nlsp = nlsp;
Hyper.MaxIteration = 20;

for i = 1:im_num
    IMin=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    IMname = S{1};
    % color or gray image
    [h,w,ch] = size(IMin);
    if h >= 600 
        IMin = IMin(ceil(h/2)-300+1:ceil(h/2)+300,:,:);
    end
    if w >= 800 
        IMin = IMin(:,ceil(w/2)-400+1:ceil(w/2)+400,:);
    end
    [h,w,ch] = size(IMin);
    if ch==1
        IMin_y = IMin;
    else
        % change color space, work on illuminance only
        IMin_ycbcr = rgb2ycbcr(IMin);
        IMin_y = IMin_ycbcr(:, :, 1);
        IMin_cb = IMin_ycbcr(:, :, 2);
        IMin_cr = IMin_ycbcr(:, :, 3);
    end
    %% denoising
    Hyper.RannSig = NoiseLevel(IMin_y*255);
    fprintf('The noise level is %2.2f.\n',Hyper.RannSig);
    tic
    [Iout_y,NoiseVar,~] = BPFA_Denoise_Mixed_Real(IMin_y,IMin_y,Hyper);
    toc
    Iout_y(Iout_y>1)=1;
    Iout_y(Iout_y<0)=0;
    if ch==1
        Iout = Iout_y;
    else
        Iout_ycbcr = zeros([h,w,ch]);
        Iout_ycbcr(:, :, 1) = Iout_y;
        Iout_ycbcr(:, :, 2) = IMin_cb;
        Iout_ycbcr(:, :, 3) = IMin_cr;
        Iout = ycbcr2rgb(Iout_ycbcr);
    end
    %% output
    imwrite(Iout, ['../1_Results/VBGMBPFA/VBGMBPFA_32_Denoised_Real_' IMname '.png']);
end