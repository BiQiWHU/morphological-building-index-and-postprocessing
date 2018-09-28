%---------------------------
%         post processing of MBI feature image
% input: a 8-bit gray MBI feature image
%        a 3-channel image of the same region with NIR,red and green bands
% parameter setting: threshold of feature image segmentation 
%                    threshold of NDVI and NDWI,
%                    threshold of area, shape index
%                   
% output: a feature image masked by NDVI and NDWI
%         a bulding map in a binary image form
%---------------------------

clear all
%% parameter settings
Tndvi=0.1;
Tndwi=0.1;
Tmbi=0.3;
% threshold of noise areas
A=30;
% threshold of length-width ratio 
LWR=5.5;

%% input
INIR = imread('01NIR.bmp');
IMBI = imread('avrMBI.bmp');

%% generate NDVI and NDWI mask, remove them from MBI feature image
I_nir = INIR(:,:,1);
I_red = INIR(:,:,2);
I_green = INIR(:,:,3);

[col, row, channel] = size(INIR);
% NDVI
I_ndvi=(I_nir-I_red)./(I_nir+I_red);
% NDWI
I_ndwi=(I_green-I_nir)./(I_green+I_nir);

for i = 1:col
    for j = 1:row
        if I_ndvi(i,j)>Tndvi || I_ndwi(i,j)>Tndwi
            IMBI(i,j)=0;
            I_ndvi(i,j)=1;
        else
            I_ndvi(i,j)=0;
        end
    end
end

% output ndvi&ndwi mask
I_ndvi_final = uint8(I_ndvi);
I_ndvi_final = mat2gray(I_ndvi_final);
imwrite(I_ndvi_final,'NDVINDWImask.bmp');
% output MBI feature image
imwrite(IMBI,'MBIfeaturemasked.bmp');

%% segmenation
Tmbi=Tmbi*255;

for i = 1:col
    for j = 1:row
        if IMBI(i,j)>Tmbi
            IMBI(i,j)=255;
        else
            IMBI(i,j)=0;
        end
    end
end
% output building map with no post-processing
imwrite(IMBI,'BMnopost.bmp');

%% area and shape index
% area, fill holes and remove small objects to reduce false alarms
% step1 fill holes, using closing reconstruction
se = strel('disk',2);
IMBI=imclose(IMBI,se);
IMBI = imfill(IMBI,'holes');
% bw = imfill(IMBI,'holes');
% ed=edge(bw);

% step2 use regionprop to get the attributes of each object
stats = regionprops(IMBI, 'Area','Perimeter','MajorAxisLength','MinorAxisLength','PixelList' ); 

% step3 calculate area(A), length-width ratio(LWR), shape index, remove roads
hold on
for i=1:size(stats)    
    %imshow(openbw)    
    %rectangle('Position',[stats(i).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),    
    %plot(centroids(i,1), centroids(i,2), 'b*');             
    %get the area of each region
    area = stats(i).Area;  
    %get the perimeters of each region
    perimeter=stats(i).Perimeter;
    %get the length of each region
    length=stats(i).MajorAxisLength;
    %get the width of each region
    width=stats(i).MinorAxisLength;
    
    % calculate length-width ratio and shape index
    LWratio=length/width;
    ShapeIndex=4*pi*area/perimeter^2;
    
    if area < A || LWratio<LWR                                      
        %if the region's area is less than the threshold
        % then it is treated as noise and is plotted black
        pointList = stats(i).PixelList;                     
        % get every pixel's coordinate of each region     
        rIndex=pointList(:,2);cIndex=pointList(:,1);        
        pointList = stats(i).PixelList;                     
        %plot it black        
        openbw(rIndex,cIndex)=0;                             
    end
end
hold off

% L = bwlabel(bw);
% L1 = bwlabel(ed);
% 
% Ar=zeros(1,max(L(:)));
% perimeter=zeros(1,max(L1(:)));
% 
% metric=zeros(1,max(L1(:)));
% %Pwl=zeros(1,max(L1(:)));
% %Pr=zeros(1,max(L1(:)));
% 
% for i=1:max(L(:))
%     % area of each region
%     Ar(i)=sum(bw(L==i));
%     % perimeter of each region
%     perimeter(i)=sum(ed(L==i));
%     % shape index of each region
%     metric(i) = 4*pi*Ar(i)/perimeter(i)^2;
% end
%% final output
imwrite(IMBI,'buildingmap.bmp');



