
% LEARNER LIST

% 1: normal learner: train on train + validation data (experiment Fig 2)
% 2: monotone simple: M_SIMPLE but discards validation data after
% comparison  (experiment Fig 1)
% 3: monotone binomial test: M_HT but discards validation data after
% hypothesis test (experiment Fig 1)

% 4: crossval slow: very inefficient CV learner (unused in paper)
% 5: crossval fast: M_CV in the paper (experiment Fig 2)

% 6: monotone binomial test add val: M_HT in paper (experiment Fig 2)
% 7: monotone binomial test reuse val: not in paper
% 8: monotone simple add val: M_SIMPLE in paper (experiment Fig 2)
% 9: monotone simple reuse val: not in paper

% 10: optimal regularization: unused in paper
% 11: normal learner: train on training data only, ignores validation data (experiment Fig 1)

% 12: optimal regularization val add: \lambda_S in paper (experiment Fig 2)
% 13: optimal regularization crossval fast: unused in paper

% test.m: hypothesis test