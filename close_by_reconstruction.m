%��̬ѧ�ؽ�����close_by_reconstruction������
%���������IΪ�����ε�ͼ��lanmdΪ�ṹԪ�ĳߴ��С
%���������CΪͨ��close_by_reconstruction��õ�ͼ��

function C=close_by_reconstruction(I,lanmd)
se=strel('disk',lanmd);
se1=strel('disk',1);

close_by_reconstruction=imdilate(I,se);

N=100000000;
n=0;

for i=1:N
temp=imerode(close_by_reconstruction,se1);
close_by_reconstruction=max(temp,I);
n=n+1;
temp=imerode(close_by_reconstruction,se1);
close_by_reconstruction1=max(temp,I);
if close_by_reconstruction==close_by_reconstruction1
    break
end
end
C=close_by_reconstruction;
% figure
% imshow(C)