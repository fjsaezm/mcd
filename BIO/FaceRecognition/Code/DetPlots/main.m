clear all
close all


load true_scores
load impostor_scores

[EER,DCF_opt,ThresEER]=Eval_Footstep_Det11(true_scores,impostor_scores,'r');