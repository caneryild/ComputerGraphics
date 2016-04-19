%Supepixel--Caner yildirim 21100818
ind=5;
img=imread(strcat('cs484_hw3_data\image0', int2str(ind), '.jpg'));
[imx,imy]=size(img);
[labels, numlabels] = slicmex(img,500,20);%numlabels is the same as number of superpixels
%figure;
%imagesc(labels);

%Gabor
imgray=rgb2gray(img);
[eoc,bpc]=gaborconvolve(imgray,4,4,3,1.7,0.65,1.3);


%for gabor features, cell to array 
eos=zeros(4,4,imx,imy/3);
bps=zeros(4,1,imx,imy/3);
for i=1:4
    bps(i,1,:,:)=bpc{i,1};

    %imwrite(bpc{i,1},strcat('bp3',int2str(i),'.png'));
    for j=1:4    
    eos(i,j,:,:)=eoc{i,j};
    %imwrite(eoc{i,j},strcat('eo3',int2str(i),int2str(j),'.png'));
    end
end

%gabor-rgb avearaging init.
rsumavg=zeros(numlabels,1);
gsumavg=zeros(numlabels,1);
bsumavg=zeros(numlabels,1);
eosumavg=zeros(numlabels,1);
bpsumavg=zeros(numlabels,1);

%rgb averager
for curlab=1:numlabels
[r c]=find(labels==curlab);
res=[r,c];
for j=1:length(r)
rsumavg(curlab)=rsumavg(curlab)+img(res( j,1),res(j,2),1);
gsumavg(curlab)=gsumavg(curlab)+img(res( j,1),res(j,2),2);
bsumavg(curlab)=bsumavg(curlab)+img(res( j,1),res(j,2),3);
end
rsumavg(curlab)=rsumavg(curlab)/length(r);
gsumavg(curlab)=gsumavg(curlab)/length(r);
bsumavg(curlab)=bsumavg(curlab)/length(r);
end

%gabor averager
for curlab=1:numlabels
    for curi=1:4
        for curj=1:4
            eosumavg(curlab)=eosumavg(curlab)+sum(sum(eos(curi,curj,:,:)));
        end
        bpsumavg(curlab)=bpsumavg(curlab)+sum(sum(bps(curi,1,:,:)));
    end
    eosumavg(curlab)=eosumavg(curlab)/16;
    bpsumavg(curlab)=bpsumavg(curlab)/4;
end

features=[rsumavg gsumavg bsumavg eosumavg bpsumavg];

%find which superpixels will be merged
IterationNo=1;

for curIter=1:IterationNo;
equ=[];
for cury=1:19
    for curx=1:19
        
        distx=abs((features(cury*22+curx,:)-features(cury*22+curx+1,:))*(features(cury*22+curx,:)-features(cury*22+curx+1,:))');
        disty=abs((features(cury*22+curx,:)-features((cury+1)*22+curx,:))*(features(cury*22+curx,:)-features((cury+1)*22+curx,:))');
        if(distx<0.01)
       %     cury*22+curx,cury*22+curx+1;
            equ=[equ;cury*22+curx,cury*22+curx+1];
        end
        
        if(disty<0.01)
       %     cury*22+curx,(cury+1)*22+curx;
            equ=[equ;cury*22+curx,(cury+1)*22+curx ];
        end
    end
end

%merge them-sean ft tenka
for ind=1:length(equ)
labels(find(labels==equ(ind,2)))=equ(ind,1);
eosumavg(equ(ind,2))=eosumavg(equ(ind,1));
bpsumavg(equ(ind,2))=bpsumavg(equ(ind,1));
rsumavg(equ(ind,2))=rsumavg(equ(ind,1));
gsumavg(equ(ind,2))=gsumavg(equ(ind,1));
bsumavg(equ(ind,2))=bsumavg(equ(ind,1));
features=[rsumavg gsumavg bsumavg eosumavg bpsumavg];
end
end
figure;
imagesc(labels);