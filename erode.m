im=imread('test.tif');
filterim=strel('square',6);
[filterOffsetX ,filterOffsetY]=size(filterim);
[sourceWidth,sourceHeight]=size(im);
newim=im;

morphType='dilation';

if strcmp(morphType,'dilation')
for offsetY = filterOffsetY:( sourceHeight - filterOffsetY) 
        for offsetX = filterOffsetX:(sourceWidth - filterOffsetX) 
			 
				if im(offsetX,offsetY) == 1
					newim((offsetX-filterOffsetX/2+1):(offsetX+filterOffsetX/2),(offsetY-filterOffsetY/2+1):(offsetY+filterOffsetY/2)) = (newim((offsetX-filterOffsetX/2+1):(offsetX+filterOffsetX/2),(offsetY-filterOffsetY/2+1):(offsetY+filterOffsetY/2))+filterim)>0;
                end
        end
end
end

if strcmp(morphType,'erosion')
for offsetY = filterOffsetY:( sourceHeight - filterOffsetY) 
        for offsetX = filterOffsetX:(sourceWidth - filterOffsetX) 
			 
				if im(offsetX,offsetY) == 0
					newim((offsetX-filterOffsetX/2+1):(offsetX+filterOffsetX/2),(offsetY-filterOffsetY/2+1):(offsetY+filterOffsetY/2))=zeros(filterOffsetX,filterOffsetY);
                end
        end
    end
end

imshow(newim);
   
                        
   
   