%% IDLE SPEED CONTROL EXERCISE
% -------------------------------------------------------------------------
% Michael Chadwick, Twan van der Sijs & Emiel Legrand
% ETH Zurich - Institute for Dynamics and Systems Constrol
% Engine Systems (November 2017)
% -------------------------------------------------------------------------
% Master file
% -------------------------------------------------------------------------

%% PREPARE WORKSPACE
    clear;
    clc;
    close all;

    addpath(genpath('.'));

%% TOGGLE OPTIONS
    identify_params = 1; % general switch

    identify_throttle_toggle = 1;
    identify_engine_toggle = 1;
    identify_manifold_toggle = 1;
    identify_inertia_toggle = 1;

    plot_validation_toggle = 1;
    convert_data_toggle = 0;

%% LOAD PARAMETERS
    fprintf('------ MAIN -------\n \n');
    fprintf('$ Loading parameters ...');
    run params;
    run parinit;
    fprintf(' Done\n');

%% CODE
    %% Data conversion
        if convert_data_toggle
          fprintf('$ Converting data ...');
          convert_data('dynamic_0006_extracted.mat');
          fprintf(' Done\n');
        end

    %% Parameter identification
        if identify_params
            
            if identify_throttle_toggle
                fprintf('\n$ Identify throttle parameters ...'); 
                [pars.id.alpha_0, pars.id.alpha_1] = ...
                    identify_throttle('quasistatic_0007_extracted.mat', ...
                                      pars, ...
                                      0);
                fprintf(' Done\n');
            end
            
            if identify_engine_toggle
                fprintf('$ Identify engine parameters ...');
                [pars.id.gamma_0, pars.id.gamma_1] = ...
                    identify_engine('quasistatic_0007_extracted.mat', ...
                                    pars, ...
                                    0);
                fprintf(' Done\n');
            end
              if identify_manifold_toggle
                  fprintf('$ Identify intake manifold volume ...\n');
                  [pars.id.V_m] = ...
                       identify_md2('dynamic_0028_extracted.mat', ...
                                           pars, ...
                                           plot_validation_toggle);
              end
%             
%             if identify_manifold_toggle
%                 fprintf('$ Identify intake manifold volume ...\n');
%                 [pars.id.V_m] = ...
%                     identify_intakemfd('dynamic_0028_extracted.mat', ...
%                                        pars, ...
%                                        plot_validation_toggle);
%                 fprintf('... Done\n');
%             end
%             
            if identify_inertia_toggle
                fprintf('$ Identify torque and inertia ...');
                [pars.id.eta_0, ...
                 pars.id.eta_1, ...
                 pars.id.beta_0, ...
                 pars.id.THETA_e] = ...
                    identify_ti('dynamic_0028_extracted.mat', ...
                                pars, ...
                                plot_validation_toggle);
                fprintf(' Done\n');
            end
        end

%% LOAD IDENTIFIED PARAMETERS
%run parid;

fprintf('\n------ END --------\n');


