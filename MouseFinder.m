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
      fig = figure;
      slider = obj.createslider(fig);
      ImageHandle = imagesc(getrawimage(obj,slider.Value));
      TitleHandle =  title(sprintf('Image %i',slider.Value));
      addlistener(slider,'Value','PostSet',@updplot);
      % Nested function for updating plot:
      function updplot(~, event)
        sliderValue = round(event.AffectedObject.Value);
        set(ImageHandle, 'CData', getrawimage(obj,sliderValue))
        set(TitleHandle, 'String', sprintf('Image %i',sliderValue))
      end
    end
    
    function slider = createslider(obj, fig)
        slider = uicontrol('Parent', fig, 'Style', 'slider',...
        'Units', 'Normalized', 'Position', [0 0 .5 .05]);
      set(slider, 'Min',1)
      set(slider, 'Max', obj.getNumberOfImages)
      set(slider, 'SliderStep', [1/obj.getNumberOfImages 0.1])
      set(slider,  'Value', 10)
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

