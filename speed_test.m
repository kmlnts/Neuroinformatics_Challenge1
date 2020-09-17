% Script for calculation mouse location used to compared time of
% calculation during refacoring
tic
MF = MouseFinder();
ml = MF.findmouselocation();
toc