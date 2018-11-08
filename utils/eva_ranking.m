function [ evaluation_info ] = eva_ranking( rank, trueRank, pos)
        
[ntest, ~] = size(rank);

M_set = pos;

%�ж�Rank(n,:)�е�Ԫ���Ƿ�ΪtrueRank(n,:)�е�Ԫ��
for n = 1:ntest  
    rank(n,:) = ismember(rank(n,:), trueRank(n,:));    
end

truth_num=size(trueRank,2);

 for i_M=1:length(M_set)
     M=M_set(i_M);
    
     Ntrue=sum(rank(:,1:M),2);
     
     Pi=Ntrue/M;
     P(i_M)=mean(Pi,1);
     
     Ri=Ntrue/truth_num;
     R(i_M)=mean(Ri,1);
 end

evaluation_info.recall=R;
evaluation_info.precision=P;
evaluation_info.M_set=M_set;
