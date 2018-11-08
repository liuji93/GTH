function [ Ws] = update_Ws( Xs,Wt,Ws,A,paras)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
I  = eye(paras.d);
%cont
M      = I+paras.lambda2*Xs*Xs';
N      = -2*Wt-2*paras.lambda2*Xs*A';
G      = 2*M*Ws+N;
WG     = Ws'*G-G'*Ws;
II     = eye(size(WG));
WG     = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
for t=1:5
     %WGs   = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
     Ws   = Ws*WG;     
end
end





