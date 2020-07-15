%% This code is the Self-Organising Fuzzy Logic (SOF) classifier
clear all
clc
close all

tic

for vez=1:33
     BD = GerarBanco;
    
for nfold=1:5

%% The SOF classifier conducts offline learning from static datasets
Input.TrainingData=BD{nfold,1};    % Input data samples
Input.TrainingLabel=BD{nfold,2};   % Labels of the input data samples
GranLevel=2.9;                % Level of granularity (Once being fixed in offline training stage, it cannot be changed further)
DistanceType='Mahalanobis';  % Type of distance/dissimilarity SOF classifier uses, which can be 'Mahalanobis', 'Cosine' or 'Euclidean'
Mode='OfflineTraining';      % Operating mode, which can be 'OfflineTraining', 'EvolvingTraining' or 'Validation'
[Output1]=SOFClassifier(Input,GranLevel,Mode,DistanceType); 
% Output1.TrainedClassifier  - Offline primed SOF classifier
%% The SOF classifier conducts validation on testing data
Input=Output1;               % Offline primed SOF classifier
Input.TestingData=BD{nfold,3};     % Testing 
Input.TestingLabel=BD{nfold,4};    % Labels of the tetsing data samples
Mode='Validation';           % Operating mode, which can be 'OfflineTraining', 'EvolvingTraining' or 'Validation'
[Output2]=SOFClassifier(Input,GranLevel,Mode,DistanceType);
% Output2.TrainedClassifier  - Trained SOF classifier (same as the input)
% Output.EstimatedLabel      - Estimated label of validation data
% Output.ConfusionMatrix     - onfusion matrix of the result

acerto_teste(nfold+5*(vez-1),1)=100*((length(find((Output2.EstimatedLabel-Input.TestingLabel)==0))))/size(Input.TestingLabel,1);
end
end

mean_acerto_teste=mean(acerto_teste);

std_acerto_teste=std(acerto_teste);

tempo=toc;
fprintf('\nMédia da taxa de acerto do Teste %.2f%%\n',mean_acerto_teste);
fprintf('\nDesvio padrão da taxa de acerto do Teste %.2f%\n',std_acerto_teste);
fprintf('\nTempo %.2f%\n',tempo);