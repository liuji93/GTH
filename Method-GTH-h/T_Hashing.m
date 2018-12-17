function [Wt] = T_Hashing( Xs,Xt,paras)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
setting.record = 0; %
setting.mxitr  = paras.in_iter;
setting.xtol = 1e-5;
setting.gtol = 1e-5;
setting.ftol = 1e-8;
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
values = zeros(paras.max_iter,1);
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
    [Wt, ~]        = OptStiefelGBB(Wt, @Wt_obj, setting,Ws,Xt,B,M,paras);

    %% update W2
    [Ws, ~]        = OptStiefelGBB(Ws, @Ws_obj, setting,Wt,Xs,A,M,paras);    

    %% update A
    A              = sign(Ws'*Xs);
    
    %% update B
    B              = sign(Wt'*Xt);
    values(iter)   =  norm(M.*(Wt-Ws),'fro')+paras.lambda1*norm(B-Wt'*Xt,'fro')+paras.lambda2*norm(A-Ws'*Xs,'fro');
end
plot(values)
B = (B>0);
B = B';   % make sure nt x nbit
end

