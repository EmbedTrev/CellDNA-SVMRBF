%% Trevor Tracy
%% a8.m
clear all, close all hidden

% Load the csv file
cd = readtable('ML_HW_Data_CellDNA.csv');

% Convert dependent variable to binary
Y = cd(:,[14]);
tempTable = table2array(Y);
tempTable(tempTable~=0)=1;
Y = array2table(tempTable);

% Run zscores on numerical values: columns 1-13 [0-12]
% Make array (to perform zscore), then revert data to table again
cdReg = cd;
cdReg(:, [1 2 3 4 5 6 7 8 9 10 11 12 13]) = ...
    array2table(zscore(table2array(cd(:, [1 2 3 4 5 6 7 8 9 10 11 12 13]))));
cdReg(:, 14) = Y;

% Logistic Regression Model
X = cdReg(:, [1 2 3 4 5 6 7 8 9 10 11 12 13]);
X = table2array(X);
Y = table2array(Y);

svm_mdl = fitcsvm(X, Y, 'Standardize', true, 'ScoreTransform', 'logit')
svm_mdl_score = fitcsvm(X, Y)
[predictClasses,proba] = predict(svm_mdl, X);
[predictClasses_b,scores] = predict(svm_mdl_score, X);

% 1. Number of support vectors
numSV = size(svm_mdl.SupportVectors,1)
%228

% 2. List top 3 records that have the smallest **absolute** values decision values
Col1 = scores;
Col1(:,2) = [];
[B,I] = mink(Col1,3,'ComparisonMethod','abs')
%781,463,340

% 3a. What are the decision values "wT • X + b” for the following records: 131, 165, 892, 1057
rec131 = scores(131,:)
rec165 = scores(165,:)
rec892 = scores(892,:)
rec1057= scores(1057,:)

% 3b. Anything special about those values of these few records?
% The absolute value of these records is very high and therefore have a
% higher probability of being correctly predicted using the model.

% 3c. Also, what are the probabilities of belonging to the class 1 (i.e. the 2nd class) for those records? 
prob131 = proba(131,2)
prob165 = proba(165,2)
prob892 = proba(892,2)
prob1057= proba(1057,2)

% 4. precision, recall, F-measure
CFM_Stats(Y, predictClasses_b)

% 5. Roc Curves
[xpos, ypos, T, AUC0] = perfcurve(Y, proba(:, 1), 0);
figure, plot(xpos, ypos)
xlim([-0.05 1.05]), ylim([-0.05 1.05]), xlabel('\bf FP rate'),  ylabel('\bf TP rate')
title('\bf ROC for class 0')
[xpos, ypos, T, AUC1] = perfcurve(Y, proba(:, 2), 1);
figure, plot(xpos, ypos)
xlim([-0.05 1.05]), ylim([-0.05 1.05]), xlabel('\bf FP rate'),  ylabel('\bf TP rate')
title('\bf ROC for class 1')


