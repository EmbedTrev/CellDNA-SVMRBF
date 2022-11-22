%% Trevor Tracy
%% a8.m
function a8
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

% Put Data in X and Y
%X = cdReg(:, [1 2 3 4 5 6 7 8 9 10 11 12 13]); % option 0 for all data
X = cdReg(:, [5 4]); % option for visual boundary
X = table2array(X);
Y = table2array(Y);

% Setup SVM Inputs
ContraintBox = 1;

% Build RBF SVM
RBF_SVM = fitcsvm(X, Y, 'BoxConstraint', ContraintBox, 'KernelFunction', 'RBF', 'KernelScale', 1);

% Prepare Grid for Plotting
gap = 0.01;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)) : gap : max(X(:,1)), min(X(:,2)) : gap : max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];

% Reformat X and Y
x_cell = num2cell(X);
y_cell = num2cell(Y);

% Plot RBF SVM
Plot2DDecisionBoundary(RBF_SVM, X, Y, xGrid, 'RBF SVM')

% Get Accuracy, Precision, and Recall for Each Class
[predictClasses,proba] = predict(RBF_SVM, X);
CFM_Stats(Y, predictClasses)

% 5. Roc Curves
[xpos, ypos, T, AUC0] = perfcurve(Y, proba(:, 1), 0);
figure, plot(xpos, ypos)
xlim([-0.05 1.05]), ylim([-0.05 1.05]), xlabel('\bf FP rate'),  ylabel('\bf TP rate')
title('\bf ROC for class 0')
[xpos, ypos, T, AUC1] = perfcurve(Y, proba(:, 2), 1);
figure, plot(xpos, ypos)
xlim([-0.05 1.05]), ylim([-0.05 1.05]), xlabel('\bf FP rate'),  ylabel('\bf TP rate')
title('\bf ROC for class 1')

return;
              
function Plot2DDecisionBoundary(model, X, Y, gridIn, plotTitle)
[yh, ~] = predict(model, gridIn);
gscatter(gridIn(:,1), gridIn(:,2), yh, 'cg'), hold on,
gscatter(X(:,1), X(:,2), Y, 'rb', '.', 10);
title(['\bf' plotTitle])
axis tight, drawnow


