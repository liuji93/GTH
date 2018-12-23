function [ Ws] = update_Ws( Xs,Wt,Ws,A,M,paras)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
G      = 2*M.*M.*(Ws-Wt)+2*paras.lambda2*(-Xs*A'+Xs*Xs'*Ws);
%G      = G./norm(G,'fro')^2;
WG     = Ws'*G-G'*Ws;
II     = eye(size(WG));
WG     = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
for t=1:10
     %WGt  = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
     Ws   = Ws*WG; 
     t    = Ws'*Ws;
     G    = 2*M.*M.*(Ws-Wt)+2*paras.lambda2*(-Xs*A'+Xs*Xs'*Ws);
    % G     = G./norm(G,'fro')^2;
     WG   = Ws'*G-G'*Ws;
     WG   = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
end

end





