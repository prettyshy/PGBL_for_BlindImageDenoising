clear;

Original_image_dir  =    '../grayimages/';
fpath = fullfile(Original_image_dir, 'house.png');
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
for nSig = [50 10 20 30 40] %noise stand deviation
    RannSig = nSig;
    Rmatname = sprintf('VBPGBPFA_nSig%d_RannSig%d.mat',nSig,RannSig);
    for Sample = 1:1
        imPSNR{Sample} = [];
        imSSIM{Sample} = [];
        for i = 1:im_num
            %% read clean image
            IMname = regexp(im_dir(i).name, '\.', 'split');
            IMname = IMname{1};
            IMin0=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
            %% generate noisy image
            randn('seed',Sample-1)
            IMin = IMin0 + nSig/255*randn(size(IMin0));
            
            %% denoising
            Hyper.RannSig = RannSig;
            [Iout,NoiseVar,~] = BPFA_Denoise_MoG(IMin,IMin0,Hyper);
            Iout(Iout>1)=1;
            Iout(Iout<0)=0;
            %% output
            imPSNR{Sample} = [imPSNR{Sample} csnr( Iout*255,IMin0*255, 0, 0 )];
            imSSIM{Sample}  = [imSSIM{Sample} cal_ssim( Iout*255, IMin0*255, 0, 0 )];
            imwrite(Iout, ['Ours_Gaussian_' IMname '_' num2str(nSig) '.png']);
            fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name,csnr( Iout*255, IMin0*255, 0, 0 ),cal_ssim( Iout*255, IMin0*255, 0, 0 ));
        end
        RanIndex = RannSig;
        SmPSNR(Sample) = mean(imPSNR{Sample});
        SmSSIM(Sample) = mean(imSSIM{Sample});
        save(Rmatname,'nSig','imPSNR','imSSIM','SmPSNR','SmSSIM','RanIndex');
    end
    RmPSNR(Ran) = mean(SmPSNR);
    RmSSIM(Ran) = mean(SmSSIM);
    RanIndex = RannSig;
    save(Rmatname,'nSig','RmPSNR','RmSSIM','SmPSNR','SmSSIM','imPSNR','imSSIM','RanIndex');
end

