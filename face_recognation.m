w=load_database();
ri=round(400*rand(1,1));            % Randomly pick an index.
r=w(:,ri);                          % r contains the image we later on will use to test the algorithm
v=w(:,[1:ri-1 ri+1:end]);           % v contains the rest of the 399 images.
N=100;                               % Number of signatures used for each image.
O=uint8(ones(1,size(v,2)));
m=uint8(mean(v,2));                 % m is the maen of all images.
vzm=v-uint8(single(m)*single(O));   % vzm is v with the mean removed.
L=single(vzm)'*single(vzm);
[V,D]=eig(L);
V=single(vzm)*V;
V=V(:,end:-1:end-(N-1));            % Pick the eignevectors corresponding to the N largest eigenvalues.
cv=zeros(size(v,2),N);

cv=single(vzm)'*V;    % Each row in cv is the signature for one image.

%% Recognition
%  Now, we run the algorithm and see if we can correctly recognize the face.
subplot(121);
imshow(reshape(r,112,92));title('Looking for ...','FontWeight','bold','Fontsize',16,'color','red');
subplot(122);
p=r-m;                              % Subtract the mean
s=single(p)'*V;
z=[];
for i=1:size(v,2)
    z=[z,norm(cv(i,:)-s,2)];
    if(rem(i,10)==0),imshow(reshape(v(:,i),112,92)),end;
    drawnow;
end
[a,i]=min(z);
subplot(122);
imshow(reshape(v(:,i),112,92));title('Found!','FontWeight','bold','Fontsize',16,'color','red');
