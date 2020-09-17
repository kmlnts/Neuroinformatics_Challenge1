% Usage example:
% The idea of program is simple:
% Find location on image and define rectangle around it. 
% Find images where this location is empty
% For each image find difference between empty location and location in
% current image. If there is mouse, the difference is significant
% In that solution the color of mouse does not matter. 

% The additional pre proscessing can be done
% Parralel computing can be used
% Position of mouse can be extracted also
MF = MouseFinder();
MF.LocationList = [70 70, 200,450;...
               270 70, 200,450;...
               470 70, 200,450];
MF.ImagesWhereLocationIsEmpty = [1,1,9];

% Find mouse locations:
ml = MF.findmouselocation();

% Show Results:
MF.showresults(ml);