
clear; clc; close all
% this is matlab program to plot monitor file for single spcurr sim
% there are checks for cap_file to not have errors plotting other sims

font_axes = 16;
font_title = 18;
font_legend = 17;
line_thickness = 3;
CFL = 0.3;

% path_cfl = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/monitor/cfl";
% path_conservation = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/monitor/conservation";
% path_rescue = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/monitor/rescue";
% path_simulation = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/monitor/simulation";
% path_timing = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/monitor/timing";

path_cfl = "monitor/cfl";
path_conservation = "monitor/conservation";
path_rescue = "monitor/rescue";
path_simulation = "monitor/simulation";
path_timing = "monitor/timing";
path_capillary = "monitor/capillary";


cfl_data = readmatrix(path_cfl);
conservation_data = readmatrix(path_conservation);
simulation_data = readmatrix(path_simulation);
timing_data = readmatrix(path_timing);


% Time and time step
figure(1)
plot(cfl_data(:,1), cfl_data(:,2), LineWidth=line_thickness)
xlabel('time step', FontSize=font_axes)
ylabel('time', FontSize=font_axes)
title('Simulation Time', FontSize=font_title)
grid on
figure(2)
plot(cfl_data(:,1), cfl_data(:,3), LineWidth=line_thickness)
% ylim([0.0003 0.0004])
xlabel('time step', FontSize=font_axes)
ylabel('\Deltat', FontSize=font_axes)
title('Time Step Size', FontSize=font_title)
grid on
% % Liquid and gas internal energy
% figure(5)
% plot(conservation_data(:,1), conservation_data(:,6), 'DisplayName', 'Liquid', LineWidth=line_thickness)
% hold on
% plot(conservation_data(:,1), conservation_data(:,7), 'DisplayName', 'Gas', LineWidth=line_thickness)
% hold off
% xlabel('time step', FontSize=font_axes)
% ylabel('Internal Energy', FontSize=font_axes)
% title('Liquid and Gas Internal Energy', FontSize=font_title)
% legend(FontSize=font_legend)
% grid on


% CFL plotting, not sure if better with plot or semilogy
max_CFLa = max(cfl_data(:,7:9), [], 2);
max_CFLv = max(cfl_data(:,10:12), [], 2);
figure(3)
semilogy(cfl_data(:,2), max_CFLa, 'DisplayName', 'CFLa', LineWidth=line_thickness, Color='b')
hold on
semilogy(cfl_data(:,2), cfl_data(:,13), 'DisplayName', 'CFLst', LineWidth=line_thickness, Color='r')
semilogy(cfl_data(:,2), max_CFLv, 'DisplayName', 'CFLv', LineWidth=line_thickness, Color='g')
yline(CFL, '--', 'DisplayName', sprintf('CFL = %.2f', CFL), 'Color', 'y')
xlabel('Time', FontSize=font_axes)
ylabel('CFL', FontSize=font_axes)
title('Maximum CFL', FontSize=font_title)
legend(FontSize=font_legend)
hold off
grid on



if isfile(path_capillary)
    capillary_data = readmatrix(path_capillary);
    % plotting Ca number
    figure(8)
    plot(capillary_data(:,2), capillary_data(:,5), LineWidth=line_thickness)
    xlabel('time', FontSize=font_axes)
    ylabel('Capillary Number', FontSize=font_axes)
    title('Capillary Number Over Time', FontSize=font_title)
    grid on
    disp('capillary number at t=25')
    disp(capillary_data(end, 5))
    % Average Capillary Number from t = 20 to the end
    t_start = 20;
    start_index = find(capillary_data(:,2) >= t_start, 1, 'first');
    Ca_values = capillary_data(start_index:end, 5);
    Ca_average = mean(Ca_values);
    fprintf('First time used: %.8f\n', capillary_data(start_index,2));
    fprintf('Timestep at t >= 20: %.0f\n', capillary_data(start_index,1));
    fprintf('Final time: %.8f\n', capillary_data(end,2));
    fprintf('Average Capillary Number from t >= 20: %.8e\n', Ca_average);
    disp(' ')
end


% % plotting Umag_max
% figure(7)
% plot(capillary_data(:,2), capillary_data(:,4), LineWidth=line_thickness)
% xlabel('time', FontSize=font_axes)
% ylabel('Umag_{max}', FontSize=font_axes)
% title('Velocity mag over time', FontSize=font_title)
% grid on
% % plotting 80x80 and 40x40 Ca for La = 10^6
% path_80_80 = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/simulation_matrix/80x80_grid/Rea_1e2_Wea_1e1/monitor/capillary";
% path_40_40 = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/simulation_matrix/40x40_grid/Rea_1e2_Wea_1e1/monitor/capillary";
% cap_data_80_80 = readmatrix(path_80_80);
% cap_data_40_40 = readmatrix(path_40_40);
% figure(9)
% plot(cap_data_40_40(:,2), cap_data_40_40(:,5), 'DisplayName', '40x40', LineWidth=line_thickness)
% hold on
% plot(cap_data_80_80(:,2), cap_data_80_80(:,5), 'DisplayName', '80x80', LineWidth=line_thickness)
% hold off
% xlabel('time', FontSize=font_axes)
% ylabel('Capillary Number', FontSize=font_axes)
% title('Capillary Number Over Time for La=10^6', FontSize=font_title)
% legend(FontSize=font_legend)
% grid on





% % time weighted ave compared to simple mean
% % Average Capillary Number from t = 20 to the end
% t_start = 20;
% % Find first recorded time at or after t = 20
% start_index = find(capillary_data(:,2) >= t_start, 1, 'first');
% % Extract time and Capillary Number
% time_values = capillary_data(start_index:end, 2);
% Ca_values = capillary_data(start_index:end, 5);
% % Time-weighted average using trapezoidal integration
% Ca_integral = trapz(time_values, Ca_values);
% Ca_average_weighted = Ca_integral / (time_values(end) - time_values(1));
% fprintf('First time used: %.8f\n', time_values(1));
% fprintf('Final time: %.8f\n', time_values(end));
% fprintf('Time-weighted average Ca: %.8e\n', Ca_average_weighted);
% % Simple arithmetic mean for comparison
% Ca_average_simple = mean(Ca_values);
% fprintf('Simple mean Ca: %.8e\n', Ca_average_simple);
% fprintf('Difference: %.8e\n', Ca_average_weighted - Ca_average_simple);



% plotting drop properties
figure(10) % pressure max and min
plot(simulation_data(:,2), simulation_data(:,10), 'DisplayName', 'PLmin', LineWidth=line_thickness, Color='b')
hold on
plot(simulation_data(:,2), simulation_data(:,11), 'DisplayName', 'PLmax', LineWidth=line_thickness, Color='r')
xlabel('time', FontSize=font_axes)
ylabel('Liquid Pressure', FontSize=font_axes)
title('Liquid Pressure Over Time', FontSize=font_title)
legend(FontSize=font_legend)
hold off
grid on
figure(11) % gas density max and min (14 15) (liquid is 8 and 9) (min then max)
plot(simulation_data(:,2), simulation_data(:,14), 'DisplayName', 'gas density min', LineWidth=line_thickness, Color='b')
hold on
plot(simulation_data(:,2), simulation_data(:,15), 'DisplayName', 'gas density max', LineWidth=line_thickness, Color='r')
xlabel('time', FontSize=font_axes)
ylabel('Gas Density', FontSize=font_axes)
title('gas density over time', FontSize=font_title)
legend(FontSize=font_legend)
hold off
grid on
figure(15) % liquid rho min and max
plot(simulation_data(:,2), simulation_data(:,8), 'DisplayName', 'liquid density min', LineWidth=line_thickness, Color='b')
hold on
plot(simulation_data(:,2), simulation_data(:,9), 'DisplayName', 'liquid density max', LineWidth=line_thickness, Color='r')
xlabel('time', FontSize=font_axes)
ylabel('Liquid Density', FontSize=font_axes)
title('liquid density over time', FontSize=font_title)
legend(FontSize=font_legend)
hold off
grid on

if isfile(path_rescue)
    rescue_data = readmatrix(path_rescue);
    % check names list and order
    % Check which rescue quantities were used
    column_names = {
        'LiqResc n'
        'LiqResc dm'
        'LiqResc dE'
        'GasResc n'
        'GasResc dm'
        'GasResc dE'
        'Diss n'
        'Diss dm'
        'Quad n'
        'Swap n'
        'Floor n'
        'Floor dE'
        'Stuck n'
        'Pool n'
        };
    % Check columns 3 through the end
    disp(' ')
    for col = 3:size(rescue_data, 2)
        if sum(rescue_data(:,col)) ~= 0
            %fprintf('%s: sum = %.6e\n', column_names{col-2}, sum(rescue_data(:,col)));
            disp(column_names{col-2})
        end
    end
end

%%%%%%%%%%% plotting CFLv and rhoG compare for PT vs P relax %%%%%%%%
% % 80x80 Rea_1e2 Wea_1e0 with PTrelax and Prelax
% % plot CFLv vs time one graph (for both PTrelax and Prelax)
% % plot rho_min and rho_max for both relax classes vs time
% % CFLv should have 2 lines, rho min and max should have 4
% % pick a convection like dottted or dashed and color to easy tell apart the
% % min and max and also which relax class is being used
% path_PTrelax_cfl = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr_full_run_wrong_relax/simulation_matrix/80x80_grid/Rea_1e2_Wea_1e0/monitor/cfl";
% path_PTrelax_sim = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr_full_run_wrong_relax/simulation_matrix/80x80_grid/Rea_1e2_Wea_1e0/monitor/simulation";
% % currently running so path is not permanent path, might prob have to
% % change later
% path_Prelax_cfl = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/80x80_Rea_1e2_Wea_1e0_Prelax/monitor/cfl";
% path_Prelax_sim = "/home/zmiller4/NGA2_all/Simulations/amrcomp_spcurr/80x80_Rea_1e2_Wea_1e0_Prelax/monitor/simulation";
% CFL_PTrelax_data = readmatrix(path_PTrelax_cfl);
% sim_PTrelax_data = readmatrix(path_PTrelax_sim);
% CFL_Prelax_data = readmatrix(path_Prelax_cfl);
% sim_Prelax_data = readmatrix(path_Prelax_sim);
% % CFLv is max CFL_PTrelax_data (10,11,12)
% % or CFLPrelax_data (10,11,12)
% % rho G min and max are sim_data 14 and 15 (14 is min)
% % 80x80 Rea_1e2 Wea_1e0 with PTrelax and Prelax
% % CFLv
% max_CFLv_PTrelax = max(CFL_PTrelax_data(:,10:12), [], 2);
% max_CFLv_Prelax = max(CFL_Prelax_data(:,10:12), [], 2);
% figure(12)
% plot(CFL_PTrelax_data(:,2), max_CFLv_PTrelax, ':', 'DisplayName', 'PTrelax', 'LineWidth', line_thickness, 'Color', 'b')
% hold on
% plot(CFL_Prelax_data(:,2), max_CFLv_Prelax, '--', 'DisplayName', 'Prelax', 'LineWidth', line_thickness, 'Color', 'r')
% hold off
% xlabel('time', FontSize=font_axes)
% ylabel('CFLv', FontSize=font_axes)
% title('CFLv Over Time', FontSize=font_title)
% legend(FontSize=font_legend)
% grid on
% % rho min and max
% figure(13)
% % PTrelax
% plot(sim_PTrelax_data(:,2), sim_PTrelax_data(:,14), ':', 'DisplayName', 'PTrelax \rho_{min}', 'LineWidth', line_thickness, 'Color', 'b')
% hold on
% plot(sim_PTrelax_data(:,2), sim_PTrelax_data(:,15), '--', 'DisplayName', 'PTrelax \rho_{max}', 'LineWidth', line_thickness, 'Color', 'b')
% % Prelax
% plot(sim_Prelax_data(:,2), sim_Prelax_data(:,14), '--', 'DisplayName', 'Prelax \rho_{min}', 'LineWidth', line_thickness, 'Color', 'r')
% plot(sim_Prelax_data(:,2), sim_Prelax_data(:,15), ':', 'DisplayName', 'Prelax \rho_{max}', 'LineWidth', line_thickness, 'Color', 'r')
% hold off
% xlabel('time', FontSize=font_axes)
% ylabel('\rho', FontSize=font_axes)
% title('Minimum and Maximum Density Over Time', FontSize=font_title)
% legend(FontSize=font_legend)
% grid on



% fig 16 next



