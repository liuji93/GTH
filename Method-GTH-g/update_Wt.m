function [ Wt] = update_Wt(Xt,Wt,Ws,B,paras)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
I  = eye(paras.d);
%cont
G      = (2*I+paras.lambda1*Xt*Xt')*Wt-2*Ws-2*paras.lambda1*Xt*B';
WG     = Wt'*G-G'*Wt;
II     = eye(size(WG));
WG     = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
for t=1:5
     %WGt  = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
     Wt   = Wt*WG;   
     G    = (2*I+paras.lambda1*Xt*Xt')*Wt-2*Ws-2*paras.lambda1*Xt*B';
     WG   = Wt'*G-G'*Wt;
     WG   = (II+(paras.tao/2)*WG)\(II-(paras.tao/2)*WG);
end

end