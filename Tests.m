

%% Tests Script
MF = MouseFinder();
img = MF.getrawimage(1);
fig = figure; imagesc(img); close(fig)

%% 
assert(isequal(MF.getNumberOfImages, 600))

% Function allows to scrall raw images:
MF.scrollrawimages()

% Check empty areas
MF.showEmptyAreas()

% Find mouse locations:
ml = MF.findmouselocation();

% Show Results:
MF.showresults(ml);