d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
im = rngmap;
imd = double(im);
sigma = 100;   % experiment with this parameter to get best result
imcircles = imd - gsmoothn(imd, [sigma 0 0], 'Region', 'same');
% display the result, converting to grayscale to make display clearer
imshow(mean(imcircles, 3), []);