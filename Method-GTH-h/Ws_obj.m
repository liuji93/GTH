function [ F,G ] = Ws_obj(Ws,Wt,Xs,A,M,paras)
F      = norm(M.*(Wt-Ws),'fro')^2+paras.lambda2*norm(A-Ws'*Xs,'fro')^2;
G      = 2*M.*M.*(Ws-Wt)+2*paras.lambda2*(-Xs*A'+Xs*Xs'*Ws);
end

