classdef MouseFinder
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    ImagesFolder
    fileds
    nImages 
  end
  
  
  methods
    function obj = MouseFinder()
      %MouseFinder Initilize with default folder name
      obj.ImagesFolder = ['images' filesep]; 
      
    end
    
    function nImages = getNumberOfImages(obj)
      % -2 becaouse dir returns also . and ..
      nImages=  numel(dir(obj.ImagesFolder))-2;
    end
    
    
    function scrollrawimages(obj)   
    end
    
    function img = getimage(obj, ImageNumner)
      % Load and preprocess image. 
      img = obj.preprocessrawimage(obj.getrawimage(ImageNumner));
    end
    
    function img = getrawimage(obj,ImageNumber)
      % get raw image
      img = imread([obj.ImagesFolder sprintf('img%0.3i.jpeg',ImageNumber)]);
    end
    
    function imgOUT = preprocessrawimage(imgIN)
      % Here some preprocessing can be applied
      imgOUT = imgIN(:,:,1);
    end
  end
end

