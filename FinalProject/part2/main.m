%% main function 


%% fine-tune cnn

[net, info, expdir] = finetune_cnn();

%% extract features and train svm

% make sure the imdb-caltech.mat file is placed in folder
% data/cnn_assignment-lenet, while also the pretrained model file exists
expdir = 'data/cnn_assignment-lenet';
nets.fine_tuned = load('finetuned-model.mat'); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net;
data = load(fullfile(expdir, 'imdb-caltech.mat'));

%% train SVM and get accuracies
train_svm(nets, data);

%% visualise features with tSNE
% 3rd argument can be 'pretrained' or 'finetuned'
visualise_features(nets, data, 'pretrained');