function [recall, precision, mAP, rec, pre, retrieved_list] = demo(exp_data, param, method)

Xs                = exp_data.Xs ;
Xt_train          = exp_data.Xt_train;
rate              = 1;
RR                = 1:round(rate*size(Xt_train,1));
Xt_train_input    = Xt_train(RR,:);
Xt_test           = exp_data.Xt_test;
WtrueTestTraining = exp_data.WtrueTestTraining;
pos               = param.pos;
r                 = param.r;
%several state of art methods
switch(method)
    %% ITQ method proposed in CVPR11 paper
    
    case 'GTH-g'
        addpath('./Method-GTH-g/');
	    fprintf('......%s start ......\n\n', 'GTH-g');
paras.nbit     = r;
paras.lambda1  = 0.1;
paras.lambda2  = 1;
paras.tao      = 0.1;
paras.max_iter = 10;
paras.in_iter  = 50;
[paras.nt,paras.d] = size(Xt_train_input);
[paras.ns,paras.d] = size(Xs);

%% learning
Wt      = T_Hashing(Xs,Xt_train_input,paras);
B_train = (Xt_train*Wt>0);
B_test  = (Xt_test*Wt>0);
B_trn      = compactbit(B_train);
B_tst      = compactbit(B_test);

    case 'GTH-h'
        addpath('./Method-GTH-h/');
	    fprintf('......%s start ......\n\n', 'GTH-h');
paras.nbit     = r;
paras.lambda1  = 0.1;
paras.lambda2  = 1;
paras.tao      = 0.1;
paras.max_iter = 10;
paras.in_iter  = 50;
paras.median_c = 0.8;
paras.beta_c   = 10;
[paras.nt,paras.d] = size(Xt_train_input);
[paras.ns,paras.d] = size(Xs);
%% learning
Wt      = T_Hashing(Xs,Xt_train_input,paras);
B_train = (Xt_train*Wt>0);
B_test  = (Xt_test*Wt>0);        
B_trn      = compactbit(B_train);
B_tst      = compactbit(B_test);        
end

% compute Hamming metric and compute recall precision
Dhamm = hammingDist(B_tst, B_trn);
[~, rank] = sort(Dhamm, 2, 'ascend');
clear B_tst B_trn;
choice = param.choice;
switch(choice)
    case 'evaluation_PR_MAP'
        clear train_data test_data;
        [recall, precision, ~] = recall_precision(WtrueTestTraining, Dhamm);
	[rec, pre]= recall_precision5(WtrueTestTraining, Dhamm, pos); % recall VS. the number of retrieved sample
        [mAP] = area_RP(recall, precision);
        retrieved_list = [];
    case 'evaluation_PR'
        clear train_data test_data;
        eva_info = eva_ranking(rank, trueRank, pos);
        rec = eva_info.recall;
        pre = eva_info.precision;
        recall = [];
        precision = [];
        mAP = [];
        retrieved_list = [];
    case 'visualization'
        num = param.numRetrieval;
        retrieved_list =  visualization(Dhamm, ID, num, train_data, test_data); 
        recall = [];
        precision = [];
        rec = [];
        pre = [];
        mAP = [];
end

end
