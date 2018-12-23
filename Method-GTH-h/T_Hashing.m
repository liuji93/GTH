function [Wt] = T_Hashing( Xs,Xt,paras)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   initalization
Xt = Xt'; % make sure d x nt
Xs = Xs'; % make sure d x ns

%%
data_t          = Xt;
[eigvec,eigval] = eig(data_t*data_t');
[~,I]           = sort(diag(eigval),'descend');
Wt              = eigvec(:,I(1:paras.nbit)); 
clear I; clear eigvec;  clear eigval; clear data_t; clear mean_Xt;

%%
data_s          = Xs;
[eigvec,eigval] = eig(data_s*data_s');
[~,I]           = sort(diag(eigval),'descend'); 
Ws              = eigvec(:,I(1:paras.nbit));
clear I; clear eigvec;  clear eigval; clear data_t; clear mean_Xt;

%%
A = sign(2*rand(paras.nbit,paras.ns)-1);
B = sign(2*rand(paras.nbit,paras.nt)-1);
%%
value =[];
for iter = 1:paras.max_iter
    E          = (Wt-Ws);
    R          = rand(paras.d,paras.nbit);
    E          = (R.*E).^2;
    %E          = E./sum(sum(E));
    E_vec      = E(:);
    E_vec_sort = sort(E_vec);
    delta      = E_vec_sort(ceil(paras.median_c*length(E_vec)));
    beta       = paras.beta_c/delta;
    m          = 1./(1+1./exp(-beta*(E_vec-delta)));
    m          = sqrt(m);
    M          = reshape(m,paras.d,paras.nbit);
    %% updata W1
    Wt             = update_Wt(Xt,Wt,Ws,B,M,paras);

    %% update W2
    Ws             = update_Ws(Xs,Wt,Ws,A,M,paras);
    
    %% update R
%     [Q1,Omg,Q2]    = svd(Wt'*Ws);
%     R              = Q2*Q1';
%R              = eye(paras.nbit);
    %% update A
    A              = sign(Ws'*Xs);
    %A              = Ws'*Xs;
    %% update B
    B              = sign(Wt'*Xt);
    %B              = Wt'*Xt;
    value(iter)    = norm(Wt-Ws,'fro')+paras.lambda1*norm(B-Wt'*Xt,'fro')+paras.lambda2*norm(A-Ws'*Xs,'fro');
    
end
plot(value)
B = (B>0);
B = B';   % make sure nt x nbit
end

