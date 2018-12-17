function [F,G] = Wt_obj(Wt,Ws,Xt,B,paras )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
I      = eye(paras.d);
F      = norm(Wt-Ws,'fro')^2+paras.lambda1*norm(B-Wt'*Xt)^2;
M      = I+paras.lambda1*Xt*Xt';
N      = -2*Ws-2*paras.lambda1*Xt*B';
G      = 2*M*Wt + N;
end

