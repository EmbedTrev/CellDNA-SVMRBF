%% ML_Slide_Example_SVM_LinearPolyRBF.m
function ML_Slide_Example_SVM_LinearPolyRBF
dbstop if error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load fisheriris
X = zscore(meas(51 : 150, [3 , 4]));     % use only 2 vars for plotting & visual
Y = species(51 : 150);
%% prepare grid data for plotting decision boundary
gap = 0.01;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)) : gap : max(X(:,1)), ...
                            min(X(:,2)) : gap : max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
%% some SVM parameters
BoxCNum = 1;
PolyOrder = 5;
%% build different SVMs
figure,
Linear_SVM = fitcsvm(X, Y, 'BoxConstraint', BoxCNum);
PlotDecisionArea(Linear_SVM, X, Y, xGrid, 1, 'Linear SVM')
Poly_SVM = fitcsvm(X, Y, 'BoxConstraint', BoxCNum, ...
                    'KernelFunction', 'polynomial', 'PolynomialOrder', PolyOrder);
PlotDecisionArea(Poly_SVM, X, Y, xGrid, 2, ['Poly' num2str(PolyOrder) 'SVM'])
                
RBF_SVM = fitcsvm(X, Y, 'BoxConstraint', BoxCNum, ...
                    'KernelFunction', 'RBF');
PlotDecisionArea(RBF_SVM, X, Y, xGrid, 3, 'RBF SVM')
return;
%%                
function PlotDecisionArea(Mdl, X, Y, xGrid, subplot_Loc, TitleStr)
[yhat, Scores] = predict(Mdl, xGrid);
%[~,maxScore] = max(Scores,[],2);
subplot(3,1, subplot_Loc),
gscatter(xGrid(:,1), xGrid(:,2), yhat, 'cg'), hold on,
gscatter(X(:,1), X(:,2), Y, 'rb', '.', 10);
title(['\bf' TitleStr])
axis tight, drawnow