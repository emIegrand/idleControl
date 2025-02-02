function [  ] = validation(dataFile, pars)
%VALIDATION function, gives some cool plots as an output

%% load data
data = load(dataFile);
meas = data.meas;
w_e_model = run_model(meas, pars);

%% engine speed comparison
get(0,'CurrentFigure'); % use current figure - do not set it on top in each update process
plot(meas.time, meas.omega_e.signals.values, 'b');hold on;grid on;
plot(meas.time(2:end),w_e_model,'-r');
ylabel('Engine Speed [rad/s]');
set(gca,'YLim',[min(meas.omega_e.signals.values) - ...
    1/10*mean(meas.omega_e.signals.values) ...
    max(meas.omega_e.signals.values) + ...
    1/10*mean(meas.omega_e.signals.values)]);

plot(meas.time(meas.u_l.signals.values>0), 50+0.*meas.u_l.signals.values(meas.u_l.signals.values>0),...
    'g','Linewidth',3);hold off; % "holf off" is important here, otherwise you always see the results of all past simulations.

xlabel('Time [s]');
legend('Measurements','Simulation','Load state','Location','SE');
set(gca,'XLim',[meas.time(1) meas.time(end)]);


drawnow
end


function [ w_e_model ] = run_model(meas, pars)
 [~, ~, w_e_model] = sim('full_model.slx',... 
                            [meas.time(1) meas.time(end)],...
                            pars.sim_opt,...
                            [meas.time, meas.u_alpha.signals.values, ...
                            meas.du_ign.signals.values,...
                            meas.u_l.signals.values,...
                            meas.P_l.signals.values]); %% add other inputs
end
