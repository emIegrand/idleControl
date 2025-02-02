function [eta_0, eta_1, beta_0, THETA_e] = identify_ti(dataFile, pars, plot_validation_toggle)
%% IDENTIFY ENGINE TORQUE AND INERTIA PARAMETERS
    %% Load data
        data = load(dataFile);
        meas = data.meas;

    %% Initialize V_m such that the model runs
        id_pars_init = [ pars.init.eta_0;
                         pars.init.eta_1; 
                         pars.init.beta_0;
                         pars.init.THETA_e ];

    %% Set fminsearch function
        efun_fminsearch = @(id_pars) model_error(id_pars, meas, pars, plot_validation_toggle);

    %% Call fminsearch
        id_pars = fminsearch(efun_fminsearch, id_pars_init, pars.fmin_opt);

    %% Declare output variables
        eta_0 = id_pars(1);
        eta_1 = id_pars(2);
        beta_0 = id_pars(3);
        THETA_e = id_pars(4);

end

function [error] = model_error(id_pars , meas, pars, plot_validation_toggle)
%% ERROR FUNCTION FOR T_e AND THETA_e
    pars.id.eta_0 = id_pars(1);
    pars.id.eta_1 = id_pars(2);
    pars.id.beta_0 = id_pars(3);
    pars.id.THETA_e = id_pars(4);
    [~, ~, w_e_model] = sim('full_model.slx',... 
                            [meas.time(1) meas.time(end)],...
                            pars.sim_opt,...
                            [meas.time, meas.u_alpha.signals.values, ...
                            meas.du_ign.signals.values,...
                            meas.u_l.signals.values,...
                            meas.P_l.signals.values]); %% add other inputs

    error = sum(sqrt((meas.omega_e.signals.values./pars.init.w_e - w_e_model./pars.init.w_e).^2));

    if plot_validation_toggle
        get(0,'CurrentFigure'); % use current figure - do not set it on top in each update process
        plot(meas.time, meas.omega_e.signals.values, 'b');hold on;grid on;
        plot(meas.time,w_e_model,'-r');
        ylabel('Engine Speed [rad/s]');
        set(gca,'YLim',[min(meas.omega_e.signals.values) - ...
            1/10*mean(meas.omega_e.signals.values) ...
            max(meas.omega_e.signals.values) + ...
            1/10*mean(meas.omega_e.signals.values)]);

        plot(meas.time(meas.u_l.signals.values>0), 40+10.*meas.u_l.signals.values(meas.u_l.signals.values>0),...
            'g','Linewidth',3);hold off; % "holf off" is important here, otherwise you always see the results of all past simulations.

        xlabel('Time [s]');
        legend('Measurements','Simulation','Load state','Location','SE');
        set(gca,'XLim',[meas.time(1) meas.time(end)]);


        drawnow
    end 
end

