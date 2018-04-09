function visualise_features(nets, data, model)
%% replace loss with the classification as we will extract features
nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';

% get the SVM data (prediction on train and test set
[svm.pre_trained.trainset, svm.pre_trained.testset] = get_svm_data(data, nets.pre_trained);
[svm.fine_tuned.trainset,  svm.fine_tuned.testset] = get_svm_data(data, nets.fine_tuned);

pre_trained_obj = svm.pre_trained.trainset;
fine_tuned_obj = svm.fine_tuned.trainset;

labels = [1 2 3 4];

% make use of cnn_tsne which is the downloaded algorithm (named differently
% because of the original tsne function)
if strcmp(model, 'pretrained')
    cnn_tsne(pre_trained_obj.features, arrayfun(@(i) labels(pre_trained_obj.labels(i)),1:length(pre_trained_obj.labels)));
elseif strcmp(model, 'finetuned')
    cnn_tsne(fine_tuned_obj.features, arrayfun(@(i) labels(fine_tuned_obj.labels(i)),1:length(fine_tuned_obj.labels)));
end

end

function [trainset, testset] = get_svm_data(data, net)

trainset.labels = [];
trainset.features = [];

testset.labels = [];
testset.features = [];
for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:,:,:,i));
    feat = res(end-3).x; feat = squeeze(feat);
    
    if(data.images.set(i) == 1)
        
        trainset.features = [trainset.features feat];
        trainset.labels   = [trainset.labels;  data.images.labels(i)];
        
    else
        
        testset.features = [testset.features feat];
        testset.labels   = [testset.labels;  data.images.labels(i)];
        
        
    end
    
end

trainset.labels = trainset.labels;
trainset.features = trainset.features';

testset.labels = testset.labels;
testset.features = testset.features';

end
