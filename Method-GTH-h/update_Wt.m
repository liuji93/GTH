function [ Wt] = update_Wt(Xt,Wt,Ws,B,M,paras)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%cont
G      = 2*M.*M.*(Wt-Ws)+2*paras.lambda1*(-Xt*B'+Xt*Xt'*Wt);
WG     = Wt'*G-G'*Wt;
II     = eye(size(WG));
WG     = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
for t=1:5
     %WGt  = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
     Wt   = Wt*WG;    
end

end