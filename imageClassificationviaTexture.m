fid = fopen('D:\\Dropbox\\ods\\ia_hw2\\cs484_hw2_data\\files.txt');
files = textscan(fid,'%s','Delimiter','\n');
filurls=files{1};
bin=9;
hogs=zeros(length(filurls),bin,1);
%hogs1=zeros(length(filurls),1);
X=ones(500,1);
for a=1:500
X(a)=ceil(a/50);
end
i=1;
%figure;
%figure;
%j=1;
while i<501
   
%        figure(1);
 %       subplot(2,2,j);
        imag = imread(strcat('D:\\Dropbox\\ods\\ia_hw2\\cs484_hw2_data\\',filurls{i}));
        imagr = rgb2gray(imag);
        %imshow(imagr);
        [C1, Ct1] = edge(imagr,'canny',[],3.0);
        k = 0.75;
        %imshow(C1);
        C2 = edge(C1,'canny',k*Ct1,3.0);
  %      imshow(C2);
        hog=HOG(C2,bin);
     %   figure(2);
        hogs(i,:)=hog;
    %    hogs1(i)=max(hogs(i));
   %   subplot(2,2,j);
     %hist(hog);
      %  j=j+1;
        i=i+1;
end
k=50;

[idx,ctrs] = kmeans(hogs,k);
plot(1:500,idx,'o');