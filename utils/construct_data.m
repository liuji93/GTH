
function exp_data = construct_data(db_name, db_data, param, runtimes)

addpath('./utils/');

choice = param.choice;

% construct data
fprintf('starting construct %s database\n\n', db_name);

% normalize the data
%db_data = normalize1(db_data);

% parameters
averageNumberNeighbors = 50;    % ground truth is 50 nearest neighbor
if strcmp(db_name, 'CIFAR10-Gist320')
    num_test = 1000;                % for cifar10, 1000 query test point, rest are database
elseif strcmp(db_name, 'CIFAR10-Gist512')
    num_test = 1000;                % for Gist512CIFAR10, 1000 query test point, rest are database
elseif strcmp(db_name, 'CALTECH256')
    num_test = 1000;                % for caltech256, 500 query test point, rest are database
elseif strcmp(db_name, 'CALTECH256-CNN1024')
    num_test = 1000;                % for caltech256, 500 query test point, rest are database
end


% split up into training and test set
[ndata, ~] = size(db_data);
switch(choice)
    case 'visualization'
        s = RandStream('mt19937ar','Seed',0);
        R = randperm(s, ndata);
    case 'evaluation_PR'
        if (runtimes == 1)
            s = RandStream('mt19937ar','Seed',0);
            R = randperm(s, ndata);
        else
            R = randperm(ndata); 
        end 
    case 'evaluation_PR_MAP'
        if (runtimes == 1)
            s = RandStream('mt19937ar','Seed',0);
            R = randperm(s, ndata);
        else
            R = randperm(ndata); 
        end     
end
test_data = db_data(R(1:num_test), :);
test_ID = R(1:num_test);
R(1: num_test) = [];
train_data = db_data(R, :);
train_ID = R;
num_training = size(train_data, 1);

% % define ground-truth neighbors (this is only used for the evaluation):
R = randperm(num_training); 
DtrueTraining = distMat(train_data(R(1:100), :), train_data); % sample 100 points to find a threshold
Dball = sort(DtrueTraining, 2); %DtrueTraining sort by row
clear DtrueTraining;
Dball = mean(Dball(:, averageNumberNeighbors));
% scale data so that the target distance is 1
train_data = train_data / Dball;
test_data = test_data / Dball;
Dball = 1;
% threshold to define ground truth
DtrueTestTraining = distMat(test_data, train_data);
WtrueTestTraining = DtrueTestTraining < Dball;
clear DtrueTestTraining;

% define ground-truth neighbors (this is only used for the evaluation):
Nneighbors=0.02*num_training;
DtrueTestTraining = distMat(test_data, train_data); % size = [Ntest x Ntraining]
%����������ѵ������֮��ľ���
[Dball, I] = sort(DtrueTestTraining,2); %�������У�ÿһ�б�ʾ�����������ݵ���ѵ���������ݵ�ľ���
exp_data.knn_p2 = I(:,1:Nneighbors); %����������ݵ��1000���������� 10000*1000
exp_data.dis_p2 = Dball(:,1:Nneighbors); %����������ݵ��1000�����ڵ�ŷʽ���� 10000*1000


% generate training ans test split and the data matrix
XX = [train_data; test_data];
% center the data, VERY IMPORTANT
sampleMean = mean(XX,1);
XX = (double(XX)-repmat(sampleMean,size(XX,1),1));

% % normalize the data
% XX_normalized = normalize1(XX);

exp_data.train_data = XX(1:num_training, :);
exp_data.test_data = XX(num_training+1:end, :);
exp_data.db_data = XX;

% exp_data.train_data_norml = XX_normalized(1:num_training, :);
% exp_data.test_data_norml = XX_normalized(num_training+1:end, :);
% exp_data.db_data_norml = XX_normalized;

exp_data.train_ID = train_ID;
exp_data.test_ID = test_ID;

exp_data.WTT = WtrueTestTraining;

cons_data_name = ['./DB-FeaturesAfterProcessing/pre_' db_name  '.mat'];
save(cons_data_name, 'exp_data');


fprintf('constructing %s database has finished\n\n', db_name);