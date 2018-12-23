%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script ufor evaluate the performance, and you can
% get Precision-Recall curve, mean Average Precision (mAP) curves, 
% Recall-The number of retrieved samples curve.
% Version control: from 2013.07.22 to 2018.03.24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
addpath('./utils/');
db_name = 'PIE';

query_ID = [];

param.choice = 'evaluation_PR_MAP';

loopnbits = [64];
%loopnbits = [64];
runtimes = 1; % change 8 times to make the rusult more smooth

param.pos = [1:10:40 50:50:1000]; % The number of retrieved samples: Recall-The number of retrieved samples curve
param.r = loopnbits(1);
%exp_data          = construct_dataset(0);

%'GTH-g','GTH-h'
hashmethods = {'GTH-h'};
nhmethods = length(hashmethods);

for k = 1:runtimes
    fprintf('The %d run time, start constructing data\n\n', k);
    %exp_data = construct_data(db_name, double(db_data), param, runtimes);
    exp_data          = construct_dataset(0);
    fprintf('Constructing data finished\n\n');
    for i =1:length(loopnbits)
        fprintf('======start %d bits encoding======\n\n', loopnbits(i));
        %param.nbits = loopnbits(i);
        param.query_ID = query_ID;
        for j = 1:nhmethods
             [recall{k}{i, j}, precision{k}{i, j}, mAP{k}{i,j}, rec{k}{i, j}, pre{k}{i, j}, ~] = demo(exp_data, param, hashmethods{1, j});
        end
    end
    %clear exp_data;
end

% plot attribution
line_width = 2;
marker_size = 8;
xy_font_size = 14;
legend_font_size = 12;
linewidth = 1.6;
title_font_size = xy_font_size;



% average MAP
for j = 1:nhmethods
    for i =1: length(loopnbits)
        tmp = zeros(size(mAP{1, 1}{i, j}));
        for k = 1:runtimes
            tmp = tmp+mAP{1, k}{i, j};
        end
        MAP{i, j} = tmp/runtimes;
    end
    clear tmp;
end
    

% save result
result_name = ['./ResultSaveToMat/final_' db_name '_result' '.mat'];
%save(result_name, 'precision', 'recall', 'rec', 'MAP', 'mAP', 'hashmethods', 'nhmethods', 'loopnbits');

%choose_bits = 5; % i: choose the bits to show
%choose_times = 3; % k is the times of run times
choose_bits = 1; % i: choose the bits to show
choose_times = 1; % k is the times of run times
%% show recall vs. the number of retrieved sample.
figure('Color', [1 1 1]); hold on;
posEnd = 8;
for j = 1: nhmethods
    pos = param.pos;
    recc = rec{choose_times}{choose_bits, j};
    %p = plot(pos(1,1:posEnd), recc(1,1:posEnd));
    p = plot(pos(1,1:end), recc(1,1:end));
    color = gen_color(j);
    marker = gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

str_nbits =  num2str(loopnbits(choose_bits));
set(gca, 'linewidth', linewidth);
h1 = xlabel('The number of retrieved samples');
h2 = ylabel(['Recall @ ', str_nbits, ' bits']);
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(hashmethods);
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
box on;
grid on;
hold off;

%% show precision vs. the number of retrieved sample.
figure('Color', [1 1 1]); hold on;
posEnd = 8;
for j = 1: nhmethods
    pos = param.pos;
    prec = pre{choose_times}{choose_bits, j};
    %p = plot(pos(1,1:posEnd), recc(1,1:posEnd));
    p = plot(pos(1,1:end), prec(1,1:end));
    color = gen_color(j);
    marker = gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

str_nbits =  num2str(loopnbits(choose_bits));
set(gca, 'linewidth', linewidth);
h1 = xlabel('The number of retrieved samples');
h2 = ylabel(['Precision @ ', str_nbits, ' bits']);
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(hashmethods);
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
box on;
grid on;
hold off;

%% show precision vs. recall , i is the selection of which bits.
figure('Color', [1 1 1]); hold on;

for j = 1: nhmethods
    p = plot(recall{choose_times}{choose_bits, j}, precision{choose_times}{choose_bits, j});
    color=gen_color(j);
    marker=gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

str_nbits = num2str(loopnbits(choose_bits));
h1 = xlabel(['Recall @ ', str_nbits, ' bits']);
h2 = ylabel('Precision');
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(hashmethods);
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
set(gca, 'linewidth', linewidth);
box on;
grid on;
hold off;

%% show mAP. This mAP function is provided by Yunchao Gong
% figure('Color', [1 1 1]); hold on;
% for j = 1: nhmethods
%     map = [];
%     for i = 1: length(loopnbits)
%         map = [map, MAP{i, j}];
%     end
%     p = plot(log2(loopnbits), map);
%     color=gen_color(j);
%     marker=gen_marker(j);
%     set(p,'Color', color);
%     set(p,'Marker', marker);
%     set(p,'LineWidth', line_width);
%     set(p,'MarkerSize', marker_size);
% end
% 
% h1 = xlabel('Number of bits');
% h2 = ylabel('mean Average Precision (mAP)');
% title(db_name, 'FontSize', title_font_size);
% set(h1, 'FontSize', xy_font_size);
% set(h2, 'FontSize', xy_font_size);
% axis square;
% set(gca, 'xtick', log2(loopnbits));
% set(gca, 'XtickLabel', {'8', '16', '32', '64', '128'});
% set(gca, 'linewidth', linewidth);
% hleg = legend(hashmethods);
% set(hleg, 'FontSize', legend_font_size);
% set(hleg, 'Location', 'best');
% box on;
% grid on;
% hold off;
