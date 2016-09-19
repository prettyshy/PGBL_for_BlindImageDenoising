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
nlsp = 6;
Hyper.nlsp = nlsp;
Hyper.MaxIteration = 20;
for nSig = [10 20] %noise stand deviation
    for SpikyRatio = [0.15 0.3]% 0.5
        for Sample=1:1
            imPSNR{Sample} = [];
            imSSIM{Sample} = [];
            for i =1:im_num
                %% define image name
                IMname = regexp(im_dir(i).name, '\.', 'split');
                IMname = IMname{1};
                %% read clean image
                IMin0=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
                %% add Gaussian noise
                randn('seed',0)
                IMin = IMin0 + nSig/255*randn(size(IMin0));
                %                 %% add spiky noise or "salt and pepper" noise
                %                 rand('seed',Sample-1)
                %                 IMin = imnoise(IMin, 'salt & pepper', SpikyRatio); %"salt and pepper" noise
                %% add spiky noise 0 or random-valued impulse noise 1
                rand('seed',0)
                [IMin,Narr]          =   impulsenoise(IMin*255,SpikyRatio,1);
                PSNR          =    csnr( IMin, IMin0*255, 0, 0 );
                SSIM          =    cal_ssim(IMin, IMin0*255, 0, 0 );
                fprintf('The initial value of PSNR = %2.2f  SSIM=%2.4f\n', PSNR, SSIM);
                fprintf('%s :\n',im_dir(i).name);
                imwrite(IMin/255, ['../1_Results/NoisyImage/GauRVIN/Noisy_GauRVIN_' IMname '_' num2str(nSig) '_' num2str(SpikyRatio) '_' num2str(Sample) '.png']);
                %% AMF
                [IMinAMF,ind]=adpmedft(IMin,19);
                %                 ind=(IMinAMF~=noiseI)&((IMin==255)|(IMin==0));
                %                 IMinAMF(~ind)=IMin(~ind);
                fprintf('%s :\n',im_dir(i).name);
                imwrite(IMinAMF/255, ['../1_Results/NoisyImage/Noisy_AMF_GauRVIN_' IMname '_' num2str(nSig) '_' num2str(SpikyRatio) '_' num2str(Sample) '.png']);
                %% denoising
                Hyper.RannSig = NoiseLevel(IMinAMF);
                [Iout,NoiseVar,~] = BPFA_Denoise_Mixed(IMinAMF/255,IMin0,Hyper);
                Iout(Iout>1)=1;
                Iout(Iout<0)=0;
                %% output
                imPSNR{Sample} = [imPSNR{Sample} csnr( Iout*255,IMin0*255, 0, 0 )];
                imSSIM{Sample}  = [imSSIM{Sample} cal_ssim( Iout*255, IMin0*255, 0, 0 )];
                imwrite(Iout, ['VBPGBPFA_AMF_GauRVIN_' IMname '_' num2str(nSig) '_' num2str(SpikyRatio) '_' num2str(Sample) '.png']);
                fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name,csnr( Iout*255, IMin0*255, 0, 0 ),cal_ssim( Iout*255, IMin0*255, 0, 0 ));
            end
            %% save output
            SmPSNR(Sample) = mean(imPSNR{Sample});
            SmSSIM(Sample) = mean(imSSIM{Sample});
            result = sprintf('VBPGBPFA_AMF_GauRVIN_%d_%2.2f.mat',nSig,SpikyRatio);
            save(result,'nSig','imPSNR','imSSIM','SmPSNR','SmSSIM');
        end
        %% save output
        mPSNR = mean(SmPSNR);
        mSSIM = mean(SmSSIM);
        result = sprintf('VBPGBPFA_AMF_GauRVIN_%d_%2.2f.mat',nSig,SpikyRatio);
        save(result,'nSig','imPSNR','imSSIM','SmPSNR','SmSSIM','mPSNR','mSSIM');
    end
end
