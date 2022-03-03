function [EER] = compute_eer_svm (X_train, X_test, ...
                                  y_train, y_test, ...
                                  kernel_type,...
                                  plot_eer)


    
    % Possible kernels: 'rbf', 'polynormial', 'linear'
    % Presets for kernel
    scale = 'auto';
    degree = 2;

    classes = unique(y_train);
    n_users = numel(classes);
    SVMModels = cell(n_users,1);
    
    % Train a classifier per user
    % (One vs all)
    parfor i = 1:n_users
        idx = y_train == i;

        if strcmp(kernel_type,'polynomial')
            SVMModels{i} = fitcsvm(X_train,idx, ...
                "KernelFunction",kernel_type, ...
                "PolynomialOrder",degree, ...
                "Standardize",true);
        elseif strcmp(kernel_type,'rbf')
            SVMModels{i} = fitcsvm(X_train,idx, ...
                "KernelFunction",kernel_type, ...
                "KernelScale",scale);
        else % linear case
            SVMModels{i} = fitcsvm(X_train,idx);
        end
    end
    
    
    TargetScores = [];
    NonTargetScores = [];
    
    parfor i=1:n_users  % For each user
        % Predict 
        [none , scores]=predict(SVMModels{i}, X_test);
    
        % Create a Mask to determine TargetScores
        userLabels = y_test(:, 1) == i;
        % Apply Positive and negative masks to obtain Scores vectors
        TargetScores=[TargetScores, scores(userLabels, 2)'];
        NonTargetScores=[NonTargetScores, scores(~userLabels, 2)'];
    end
    
    
    [EER] = Eval_Det(TargetScores, NonTargetScores, 'b', plot_eer);


end