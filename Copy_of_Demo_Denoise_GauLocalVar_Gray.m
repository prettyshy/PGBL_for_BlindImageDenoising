clear;

Original_image_dir  =    '../grayimages/';
fpath = fullfile(Original_image_dir, '*.png');
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
Hyper.step = 2;
Hyper.MaxIteration = 20;
nlsp = 6;
Hyper.nlsp = nlsp;
for scale = [0.3]
    imPSNR = [];
    imSSIM = [];
    for i = 8:im_num
        %% read clean image
        IMname = regexp(im_dir(i).name, '\.', 'split');
        IMname = IMname{1};
        IMin0=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
        rand('seed',0);
        V = scale*rand(size(IMin0));
        %% Generate noisy observation
        IMin = imnoise(IMin0,'localvar',V);
        fprintf('%s :\n',im_dir(i).name);
        imwrite(IMin, ['Noisy_GauLoVa_' IMname '_' num2str(scale) '.png']);
        %% denoising assuming AWGN
        Hyper.RannSig = NoiseLevel(IMin*255);
        [Iout,NoiseVar,~] = BPFA_Denoise_Mixed(IMin,IMin0,Hyper);
        Iout(Iout>1)=1;
        Iout(Iout<0)=0;
        imPSNR = [imPSNR csnr( Iout*255,IMin0*255, 0, 0 )];
        imSSIM  = [imSSIM cal_ssim( Iout*255, IMin0*255, 0, 0 )];
        %% output
        fprintf('VBGMBPFA: PSNR = %f',csnr(Iout*255, IMin0*255, 0,0));
        imwrite(Iout, ['Denoise_GauLoVa_' IMname '_' num2str(scale) '.png']);
        fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name,csnr( Iout*255, IMin0*255, 0, 0 ),cal_ssim( Iout*255, IMin0*255, 0, 0 ));
    end
    mPSNR = mean(imPSNR);
    mSSIM = mean(imSSIM);
    fprintf('The average PSNR = %2.4f, SSIM = %2.4f. \n', mPSNR,mSSIM);
    result = sprintf('VBPGBPFA_GauLoVa_scale%d.mat',scale);
    save(result,'mPSNR','mSSIM','imPSNR','imSSIM');
end
for scale = [0.5 1]
    imPSNR = [];
    imSSIM = [];
    for i = 1:im_num
        %% read clean image
        IMname = regexp(im_dir(i).name, '\.', 'split');
        IMname = IMname{1};
        IMin0=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
        rand('seed',0);
        V = scale*rand(size(IMin0));
        %% Generate noisy observation
        IMin = imnoise(IMin0,'localvar',V);
        fprintf('%s :\n',im_dir(i).name);
        imwrite(IMin, ['Noisy_GauLoVa_' IMname '_' num2str(scale) '.png']);
        %% denoising assuming AWGN
        Hyper.RannSig = NoiseLevel(IMin*255);
        [Iout,NoiseVar,~] = BPFA_Denoise_Mixed(IMin,IMin0,Hyper);
        Iout(Iout>1)=1;
        Iout(Iout<0)=0;
        imPSNR = [imPSNR csnr( Iout*255,IMin0*255, 0, 0 )];
        imSSIM  = [imSSIM cal_ssim( Iout*255, IMin0*255, 0, 0 )];
        %% output
        fprintf('VBGMBPFA: PSNR = %f',csnr(Iout*255, IMin0*255, 0,0));
        imwrite(Iout, ['Denoise_GauLoVa_' IMname '_' num2str(scale) '.png']);
        fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name,csnr( Iout*255, IMin0*255, 0, 0 ),cal_ssim( Iout*255, IMin0*255, 0, 0 ));
    end
    mPSNR = mean(imPSNR);
    mSSIM = mean(imSSIM);
    fprintf('The average PSNR = %2.4f, SSIM = %2.4f. \n', mPSNR,mSSIM);
    result = sprintf('VBPGBPFA_GauLoVa_scale%d.mat',scale);
    save(result,'mPSNR','mSSIM','imPSNR','imSSIM');
end