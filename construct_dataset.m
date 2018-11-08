function [ exp_data ] = construct_dataset(topNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load PIE29 %target data
Xt = fea;
yt = gnd;
clear fea; clear gnd;

load PIE05 %source data
Xs = fea;
ys = gnd;
clear fea; clear gnd;

[ndata, D] = size(Xt);
R = randperm(ndata);
num_test = 500;
Xt_test  = Xt(R(1:num_test), :);
% test_ID = R(1:num_test);
R(1: num_test) = [];
Xt_train       = Xt(R, :);
% train_ID = R;
num_test      = size(Xt_test,1);
num_training  = size(Xt_train,1);
if topNum == 0
    topNum = round(0.02 * size(Xt_train,1));
end
% topNum = 500;
DtrueTestTraining = distMat(Xt_test, Xt_train);

[~,ind] = sort(DtrueTestTraining,2);
ind = ind(:,1:topNum);
WtrueTestTraining = zeros(num_test,num_training);

for i=1:num_test
     WtrueTestTraining(i,ind(i,:)) = 1;
end
clear DtrueTestTraining;
exp_data.OCHXt_train       = Xt_train;
exp_data.OCHXt_test        = Xt_test;
samplemean                 = mean(Xt_train,1);
Xs                         = Xs-repmat(samplemean,size(Xs,1),1);
Xt_train                   = Xt_train-repmat(samplemean,size(Xt_train,1),1);
Xt_test                    = Xt_test-repmat(samplemean,size(Xt_test,1),1);
exp_data.noDAmodel_input   = [Xs;Xt_train];
exp_data.Xs                = Xs;
exp_data.Xt_train          = Xt_train;
exp_data.Xt_test           = Xt_test;
exp_data.WtrueTestTraining = WtrueTestTraining;
end

