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
deltanSig = 10;

nSig = 15; %noise stand deviation
SpikyRatio = 0.15; %0.3, 0.5

imPSNR = []; 
imSSIM = [];
for i = 1:im_num
    %% define image name
    IMname = regexp(im_dir(i).name, '\.', 'split');
    IMname = IMname{1};
    IMname = [IMname,'_',num2str(nSig),'_',num2str(fix(SpikyRatio*100))];
    %% read clean image
    IMin0=im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    %% add Gaussian noise
    randn('seed',0)
    IMin = IMin0 + nSig/255*randn(size(IMin0));
    %% add Poisson noise
    % IMin = imnoise(IMin,'poisson'); % Poisson noise
    %% add spiky noise or "salt and pepper" noise
    SpikyNoiseMatrix = zeros(size(IMin0));
    randn('seed',0)
    SampleIndex = randperm(numel(IMin0));
    randn('seed',0)
    NoiseMatrix = zeros(size(IMin0));
    NoiseMatrix(SampleIndex(1: fix(SpikyRatio*numel(NoiseMatrix)))) = rand(1,fix(SpikyRatio*numel(NoiseMatrix)))*2-1; %binary matrix indicating which pixel values are observed
    IMin = min( max(IMin + NoiseMatrix,0),1);
    % IMin = imnoise(IMin,'salt & pepper', SpikyRatio); %"salt and pepper" noise
    fprintf('%s :\n',im_dir(i).name);
    imwrite(IMin, ['NoisyGauSpi_' IMname '_' num2str(nSig) '_' num2str(SpikyRatio) '.png']);
    %% denoising
    Hyper.RannSig = NoiseLevel(IMin*255);
    [Iout,NoiseVar,~] = BPFA_Denoise_Mixed(IMin,IMin0,Hyper);
    Iout(Iout>1)=1;
    Iout(Iout<0)=0;
    %% output
    imPSNR = [imPSNR csnr( Iout*255,IMin0*255, 0, 0 )];
    imSSIM  = [imSSIM cal_ssim( Iout*255, IMin0*255, 0, 0 )];
    imwrite(Iout, ['Mixed_DenoisedGauSpi_' IMname '_' num2str(nSig) '_' num2str(SpikyRatio) '.png']);
    fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name,csnr( Iout*255, IMin0*255, 0, 0 ),cal_ssim( Iout*255, IMin0*255, 0, 0 ));
end
%% save output
mPSNR = mean(imPSNR);
mSSIM = mean(imSSIM);
result = sprintf('PGBPFA_Mixed_GauSpi_%d.mat',nSig);
save(result,'nSig','imPSNR','imSSIM','mPSNR','mSSIM');
