%��̬ѧ�ؽ�����open_by_reconstruction������
%���������IΪ�����ε�ͼ��lanmdΪ�ṹԪ�ĳߴ��С
%���������OΪͨ��open_by_reconstruction��õ�ͼ��

function O=open_by_reconstruction(I,lanmd)
se=strel('disk',lanmd);
se1=strel('disk',1);

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
