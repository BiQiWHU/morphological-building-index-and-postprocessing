%---------------------------
%         mbi algorithm
% input: a RGB 3-channel aerial image
% parameter setting: image size(width & length),
%                    Window size(the min size,the max size,and the step size)
% output: MBI feature map, a 8-bit gray image
%---------------------------

clear all 
%%
%---------------------------------
% parameter settings
%---------------------------------
% image size (width and length)
width=2885;
length=2561;

% window size (min window size, max window size and step size)
step = 5;
Smin = 2;
Smax = 42;

%%
%---------------------------------
% the input of this matlab file
%---------------------------------
I = imread('01RGB.bmp');
%figure(1);
%imshow(I);
%%
%---------------------------------
% step1 the generation of brightness image
%---------------------------------
[col, row, channel] = size(I);

I_r = I(:,:,1);
I_g = I(:,:,2);
I_b = I(:,:,3);

I_final = I(:,:,1);

for i = 1:col
    for j = 1:row
        I_final(i,j) = max(max(I_r(i,j), I_g(i,j)), I_b(i,j));
        %for each pixel, find the max grayvalue among RGB channels
        % if it does not look well, consider use hist equalization
    end
end

%figure(2);
%imshow(I_final);
%%
%------------
% step two
% note: it just illustrates the basic priciples and is not invovled in the 
%       algorithm
%------------
% lanmd = 9;
% opening_profile(:,:,1)=open_by_reconstruction(I_final,lanmd);

% Delt_opening_profile(:,:,1)=I_final(:,:,1) - opening_profile(:,:,1);

%%        
%--------------
% step three and four
% directional THR and its multi-scale average
%--------------

S = (Smax - Smin) / step + 1;
%SUM = 0;
t = 1;
SUM_opening_profiles1 = uint32(zeros(length,width)); %¿í*³¤
SUM_opening_profiles2 = uint32(zeros(length,width));
SUM_THR = uint32(zeros(length,width));
for  s = Smin : step : Smax
    for d = 0:45:135
         % using the fuction of linear morphological elements
         opening_profile_line1(:,:)=open_by_reconstr_line(I_final, s, d);
         index =  d / 45  + 1;
         Delt_opening_profile1(:,:,index)=I_final(:,:) - opening_profile_line1(:,:);
        
    end
        SUM_opening_profile1(:,:) = abs(uint32(Delt_opening_profile1(:,:,1)))+abs(uint32(Delt_opening_profile1(:,:,2)))+abs(uint32(Delt_opening_profile1(:,:,3)))+abs(uint32(Delt_opening_profile1(:,:,4)));
        mean_opening_profile1(:,:,1) = SUM_opening_profile1(:,:)/4;
        % average them
    s = s + step;
    
    for d = 0:45:135
         % using the fuction of linear morphological elements
        opening_profile_line2(:,:)=open_by_reconstr_line(I_final, s, d);
         index =  d / 45  + 1;
         Delt_opening_profile2(:,:,index)=I_final(:,:) - opening_profile_line2(:,:);
      
    end
        SUM_opening_profile2(:,:) = abs(uint32(Delt_opening_profile2(:,:,1)))+abs(uint32(Delt_opening_profile2(:,:,2)))+abs(uint32(Delt_opening_profile2(:,:,3)))+abs(uint32(Delt_opening_profile2(:,:,4)));
        mean_opening_profile2(:,:,1) = SUM_opening_profile2(:,:)/4;     
    s = s - step;
    
    THR(:,:,t) = mean_opening_profile2(:,:) - mean_opening_profile1(:,:);
    t = t + 1;      
end

THR1(:,:) = THR(:,:,1);
THR2(:,:) = THR(:,:,2);
THR3(:,:) = THR(:,:,3);
THR4(:,:) = THR(:,:,4);

 SUM_THR(:,:) = abs(THR1(:,:)) + abs(THR2(:,:)) +  abs(THR3(:,:)) +  abs(THR4(:,:));
 BMI(:,:) = SUM_THR(:,:) / 4;
 
 %%
 BMI_final = uint8(BMI);
 BMI_final = mat2gray(BMI_final);
 imwrite(BMI_final,'avrMBI.bmp');
 
 %figure(3);
 %imshow(BMI_final);


