% Apply Principal Component Analysis (PCA) to dial tone data
%
% Samuli Siltanen February 2021

% Load data. Note that all the 10 data vectos have the same length
load tensounds s1 s2 s3 s4 s5 s6 s7 s8 s9 s0 sf
len = length(s1);

% Initialize sample matrices
N = 2^11;
K = floor(len/N);
s1mat = zeros(N,K);
s2mat = zeros(N,K);
s3mat = zeros(N,K);
s4mat = zeros(N,K);
s5mat = zeros(N,K);
s6mat = zeros(N,K);
s7mat = zeros(N,K);
s8mat = zeros(N,K);
s9mat = zeros(N,K);
s0mat = zeros(N,K);

% Chop the original signals into K snippets, each stored as one column in
% the corresponding matrix
for iii = 1:K
    s1mat(:,iii) = s1((iii-1)*N+[1:N]);
    s2mat(:,iii) = s2((iii-1)*N+[1:N]);
    s3mat(:,iii) = s3((iii-1)*N+[1:N]);
    s4mat(:,iii) = s4((iii-1)*N+[1:N]);
    s5mat(:,iii) = s5((iii-1)*N+[1:N]);
    s6mat(:,iii) = s6((iii-1)*N+[1:N]);
    s7mat(:,iii) = s7((iii-1)*N+[1:N]);
    s8mat(:,iii) = s8((iii-1)*N+[1:N]);
    s9mat(:,iii) = s9((iii-1)*N+[1:N]);
    s0mat(:,iii) = s0((iii-1)*N+[1:N]);
end

% Build a big matrix containing samples of all the data as columns
Ntrain = 5;
X = [s1mat(:,1:Ntrain),s2mat(:,1:Ntrain),s3mat(:,1:Ntrain),s4mat(:,1:Ntrain),s5mat(:,1:Ntrain),s6mat(:,1:Ntrain),s7mat(:,1:Ntrain),s8mat(:,1:Ntrain),s9mat(:,1:Ntrain),s0mat(:,1:Ntrain)];
Xall = [s1mat,s2mat,s3mat,s4mat,s5mat,s6mat,s7mat,s8mat,s9mat,s0mat];

%% Calculate FFTs

% Fast Fourier transform applied to columns
FX = fftshift(fft(X),1);
FXall = fftshift(fft(Xall),1);

% Crop the FFTs
ind1 = round(.505*size(FX,1));
ind2 = round(.55*size(FX,1));
FX = FX(ind1:ind2,:);
FXall = FXall(ind1:ind2,:);

% Take absolute value
FX = abs(FX);
FXall = abs(FXall);

% Normalize FX (seems like a bad idea)
% FX = FX-repmat(mean(FX.').',1,size(FX,2));
% FX = FX./repmat(std(FX.').',1,size(FX,2));

% Calculate the relevant eigenvalues and eigenvectors
[V,D] = eig(FX*FX.');

B = V(:,(end-2):end);
tmp1 = B.'*FXall;

figure(10)
clf
msize = 20;
plot3(tmp1(1,1:K),tmp1(2,1:K),tmp1(3,1:K),'r.','markersize',msize)
hold on 
plot3(tmp1(1,K+[1:K]),tmp1(2,K+[1:K]),tmp1(3,K+[1:K]),'b.','markersize',msize)
plot3(tmp1(1,2*K+[1:K]),tmp1(2,2*K+[1:K]),tmp1(3,2*K+[1:K]),'m.','markersize',msize)
plot3(tmp1(1,3*K+[1:K]),tmp1(2,3*K+[1:K]),tmp1(3,3*K+[1:K]),'k.','markersize',msize)
plot3(tmp1(1,4*K+[1:K]),tmp1(2,4*K+[1:K]),tmp1(3,4*K+[1:K]),'g.','markersize',msize)
plot3(tmp1(1,5*K+[1:K]),tmp1(2,5*K+[1:K]),tmp1(3,5*K+[1:K]),'c.','markersize',msize)
p6 = plot3(tmp1(1,6*K+[1:K]),tmp1(2,6*K+[1:K]),tmp1(3,6*K+[1:K]),'c.','markersize',msize);
set(p6,'color',[.5 .5 .5])
p7 = plot3(tmp1(1,7*K+[1:K]),tmp1(2,7*K+[1:K]),tmp1(3,7*K+[1:K]),'c.','markersize',msize);
set(p7,'color',[.1 .5 .1])
p8 = plot3(tmp1(1,8*K+[1:K]),tmp1(2,8*K+[1:K]),tmp1(3,8*K+[1:K]),'c.','markersize',msize);
set(p8,'color',[.3 .1 1])
p9 = plot3(tmp1(1,9*K+[1:K]),tmp1(2,9*K+[1:K]),tmp1(3,9*K+[1:K]),'c.','markersize',msize);
set(p9,'color',[.6 .1 .1])

