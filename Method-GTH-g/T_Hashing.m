function [Wt] = T_Hashing( Xs,Xt,paras)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   initalization
Xt = Xt'; % make sure d x nt
Xs = Xs'; % make sure d x ns

data_t          = Xt;
[eigvec,eigval] = eig(data_t*data_t');
[~,I]           = sort(diag(eigval),'descend');
Wt              = eigvec(:,I(1:paras.nbit)); 
clear I; clear eigvec;  clear eigval; clear data_t; clear mean_Xt;


data_s          = Xs;
[eigvec,eigval] = eig(data_s*data_s');
[~,I]           = sort(diag(eigval),'descend'); 
Ws              = eigvec(:,I(1:paras.nbit));
clear I; clear eigvec;  clear eigval; clear data_t; clear mean_Xt;
% [Q1,Omg,Q2]     = svd(Wt'*Ws);
%  R              = Q2*Q1';
%R              = eye(paras.nbit);
A      = sign(2*rand(paras.nbit,paras.ns)-1);
B      = sign(2*rand(paras.nbit,paras.nt)-1);
% Laplace matrix for source domain
I     = eye(paras.ns);
%
value = zeros(paras.max_iter,1);
for iter = 1:paras.max_iter
    %% updata W1
    Wt             = update_Wt(Xt,Wt,Ws,B,paras);

    %% update W2
    Ws             = update_Ws(Xs,Wt,Ws,A,paras);
    
    %% update R
%     [Q1,Omg,Q2]    = svd(Wt'*Ws);
%     R              = Q2*Q1';
%R              = eye(paras.nbit);
    %% update A
    A              = sign(Ws'*Xs);
    
    %% update B
    B              = sign(Wt'*Xt);
    value(iter)    = norm(Wt-Ws,'fro')+paras.lambda1*norm(B-Wt'*Xt,'fro')+paras.lambda2*norm(A-Ws'*Xs,'fro');
    
end
%plot(value)
B = (B>0);
B = B';   % make sure nt x nbit
end

