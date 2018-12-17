function [ F,G ] = Ws_obj(Ws,Wt,Xs,A,paras)
I      = eye(paras.d);
F      = norm(Wt-Ws,'fro')^2+paras.lambda2*norm(A-Ws'*Xs,'fro')^2;
M      = I+paras.lambda2*Xs*Xs';
N      = -2*Wt-2*paras.lambda2*Xs*A';
G      = 2*M*Ws+N;
end

