classdef MouseFinder
  % MouseFinder
  properties
    ImagesFolder
    AreaList
    ImagesWhereAreaIsEmpty
    AreasEmptyImages
  end

  methods
    function obj = MouseFinder()
      %MouseFinder Initilize with default folder name
      obj.ImagesFolder = ['images' filesep]; 
      obj.AreaList =  [70 70, 200,450;...
                      270 70, 200,450;...
                      470 70, 200,450];
      obj.ImagesWhereAreaIsEmpty = [1,1,9];
      obj.AreasEmptyImages = obj.getEmptyAreas();
    end
    
    function nAreas = getAreasNumber(obj)
      nAreas = size(obj.AreaList,1);
    end
    function handles = drawareas(obj)
      for iArea = 1:obj.getAreasNumber()
        handles(iArea) = rectangle('Position', obj.AreaList(iArea,:),...
          'EdgeColor', 'r', 'LineWidth', 2); %#ok<AGROW>
      end
    end
    
    function showresults(obj, MauseLocation)
      fig = figure;
      
      slider = obj.createslider(fig);
      subplot(1,3,1:2)
      ImageHandle = imagesc(getrawimage(obj,slider.Value));
      AreasHandles = drawareas(obj);
      set(AreasHandles(MauseLocation(slider.Value)), 'EdgeColor', [0 1 0])
      TitleHandle =  title(sprintf('Image %i',slider.Value));
      addlistener(slider,'Value','PostSet',@updplot);
      % Nested function for updating plot:
      function updplot(~, event)
        set(AreasHandles, 'EdgeColor', [1 0 0])
        sliderValue = round(event.AffectedObject.Value);
        set(AreasHandles(MauseLocation(sliderValue)), 'EdgeColor', [0 1 0])
        set(ImageHandle, 'CData', getrawimage(obj,sliderValue))
        set(TitleHandle, 'String', sprintf('Image %i Location [%i]',...
          sliderValue, MauseLocation(sliderValue)))
      end
      
      subplot(1,3,3)
      uv = unique(MauseLocation);
      bins = histc(MauseLocation,uv);
      pie(bins, num2str(uv'))
      title('Time spend in each location')
    end
    
    function imgOut = imcropArea(obj, img, areanum)
       imgOut = imcrop(img,  obj.AreaList(areanum,:));
    end
    
    function AreaDiff = getdifference(obj, img)
      AreaDiff = obj.AreasEmptyImages;
      for iArea = 1:numel(obj.AreasEmptyImages)
          imgdiff = abs(obj.AreasEmptyImages{iArea} - obj.imcropArea(img, iArea));
          imgdiff(imgdiff<10) = 0;
          AreaDiff{iArea} = imgdiff;
      end  
    end
    
    function location = getLocationWithMouse(~, AreaDiff)
      % There could be another test, what about if mouse escapes? :)
     [~, location] = max(cellfun(@(x) mean(x,'all') , AreaDiff));
    end
    
    function MouseLocation= findmouselocation(obj)
      MouseLocation = zeros(1,obj.getNumberOfImages);
      nImages = obj.getNumberOfImages;
      f = waitbar(0,'Please wait...');
      for i = 1:nImages
        img = obj.getimage(i);
        AreaDiff = getdifference(obj, img);
        MouseLocation(i) = obj.getLocationWithMouse(AreaDiff);
        if rem(i,20),waitbar(i/nImages,f,'Please wait..'); end
      end
      close(f)
    end
    
    function showdiff(~, AreaDiff)
      nAreas = numel(AreaDiff);
      for iArea = 1:nAreas
        subplot(1,nAreas, iArea)
        imagesc(AreaDiff{iArea})
      end
    end
    
    function EmptyAreas = getEmptyAreas(obj)
      % Load images and cut empty images. Save them for later calculations
      nAreas = size(obj.AreaList,1);
      for iArea = 1:nAreas
        EmptyAreas{iArea} = imcrop(obj.getimage(obj.ImagesWhereAreaIsEmpty(iArea)),...
        obj.AreaList(iArea,:)); %#ok<AGROW>
      end
    end
    
    function showEmptyAreas(obj)
      fig = figure;
      nAreas = numel(obj.AreasEmptyImages);
      for iArea = 1:nAreas
        figure(fig)
        subplot(1,nAreas, iArea)
        imagesc(obj.AreasEmptyImages{iArea})
      end
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
    
    function imgOUT = preprocessrawimage(~,imgIN)
      % Here some preprocessing can be applied
      imgOUT = imgIN(:,:,1);
    end
  end
end

