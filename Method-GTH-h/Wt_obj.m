function [F,G] = Wt_obj(Wt,Ws,Xt,B,M,paras )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
F      = norm(M.*(Wt-Ws),'fro')^2+paras.lambda1*norm(B-Wt'*Xt)^2;
G      = 2*M.*M.*(Wt-Ws)+2*paras.lambda1*(-Xt*B'+Xt*Xt'*Wt);
end

