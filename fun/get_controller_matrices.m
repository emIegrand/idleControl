function [A, B, C, D] = get_controller_matrices(system, pars)
%% CALCULATES CONTROLLER MATRICES
%Dc is zero matrix with appropriate dimensions
Dc = [0;0];


A = [system.extension.A, -system.extension.B*pars.des.K; zeros(11,1), system.ext.A-system.ext.B*pars.des.K-pars.des.L*system.ext.C];
                
B = [system.extension.B*Dc; -pars.des.L];

C = [system.extension.C -system.extension.D*pars.des.K];

D = [system.extension.D*Dc];