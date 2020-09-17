%% Example Title
% Summary of example objective

%% Section 1 Title
% Description of first code block
MF = MouseFinder();
img = MF.getrawimage(1);
imagesc(img);

%%
assert(isequal(MF.getNumberOfImages, 600))

% 
MF.scrollrawimages()