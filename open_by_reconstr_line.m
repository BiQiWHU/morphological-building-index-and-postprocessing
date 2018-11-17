%形态学重建开（open_by_reconstruction）运算
%输入参数：I为单波段的图像，lanmd为结构元的尺寸大小
%输出参数：O为通过open_by_reconstruction获得的图像

function O=open_by_reconstr_line(I,s,d)
se=strel('line',s,d);
se1=strel('line',3,d);

open_by_reconstruction=imerode(I,se);

N=100000000;
n=0;

for i=1:N
temp=imdilate(open_by_reconstruction,se1);
open_by_reconstruction=min(temp,I);
n=n+1;
temp=imdilate(open_by_reconstruction,se1);
open_by_reconstruction1=min(temp,I);
if open_by_reconstruction==open_by_reconstruction1
    break
end
end
O=open_by_reconstruction;
% figure
% imshow(O)
