
% this is MatLab program to graph monitor files for spcurr automated
% outputs
clear;
clc;
close all

% Select which simulation to plot
CFL = 0.3;
plot_case = 3;


font_axes = 16;
font_title = 18;
font_legend = 17;
line_thickness = 3;

% setting paths
folders = dir();
folders = folders([folders.isdir]);
folders = folders(~ismember({folders.name}, {'.', '..'}));



% storing data from each case in nested struct
cases = struct();
for i = 1:length(folders)

    case_name = matlab.lang.makeValidName(folders(i).name);

    % Capillary
    capillaryFile = fullfile(folders(i).folder, folders(i).name, 'monitor', 'capillary');
    if isfile(capillaryFile), cases.(case_name).capillary = readmatrix(capillaryFile); end
    % Simulation
    simulationFile = fullfile(folders(i).folder, folders(i).name, 'monitor', 'simulation');
    if isfile(simulationFile), cases.(case_name).simulation = readmatrix(simulationFile); end
    % Rescue
    rescueFile = fullfile(folders(i).folder, folders(i).name, 'monitor', 'rescue');
    if isfile(rescueFile), cases.(case_name).rescue = readmatrix(rescueFile); end
    % CFL
    cflFile = fullfile(folders(i).folder, folders(i).name, 'monitor', 'cfl');
    if isfile(cflFile), cases.(case_name).cfl = readmatrix(cflFile); end
end

% Get simulation names
names = fieldnames(cases);
% Preallocate results
Ca_t25 = NaN(length(names), 1);
Ca_average = NaN(length(names), 1);

if isfile(capillaryFile)
    for i = 1:length(names)
        % Get capillary data for this simulation
        capillary_data = cases.(names{i}).capillary;
        % Find first timestep at or after t = 25
        t25_index = find(capillary_data(:,2) >= 25, 1, 'first');
        % Find first timestep at or after t = 20
        t20_index = find(capillary_data(:,2) >= 20, 1, 'first');
        % Capillary number at t = 25
        if ~isempty(t25_index), Ca_t25(i) = capillary_data(t25_index, 5); end
        % Average Capillary Number from t = 20 to t = 25
        if ~isempty(t20_index) && ~isempty(t25_index)
            Ca_values = capillary_data(t20_index:t25_index, 5);
            Ca_average(i) = mean(Ca_values);
        end
    end
    % Create results tables
    t25_table = table(names, Ca_t25, 'VariableNames', {'Simulation', 'Ca_at_t25'});
    average_table = table(names, Ca_average, 'VariableNames', {'Simulation', 'Ca_average_20_to_25'});
    % Display tables
    disp('Capillary Number at t = 25')
    disp(t25_table)
    disp('Average Capillary Number from t = 20 to t = 25')
    disp(average_table)
end

% Get data for selected case
cfl_data = cases.(names{plot_case}).cfl;
simulation_data = cases.(names{plot_case}).simulation;
rescue_data = cases.(names{plot_case}).rescue;
if isfile(capillaryFile), capillary_data = cases.(names{plot_case}).capillary; end

% Time
figure(1)
plot(cfl_data(:,1), cfl_data(:,2), LineWidth=line_thickness)
xlabel('Time step', FontSize=font_axes)
ylabel('Time', FontSize=font_axes)
title(['Simulation Time for ', names{plot_case}], FontSize=font_title, Interpreter='none')
grid on


% Time step size
figure(2)
plot(cfl_data(:,1), cfl_data(:,3), LineWidth=line_thickness)
xlabel('Time step', FontSize=font_axes)
ylabel('\Deltat', FontSize=font_axes)
title(['Time Step Size for ', names{plot_case}], FontSize=font_title, Interpreter='none')
grid on


% CFL
max_CFLa = max(cfl_data(:,7:9), [], 2);
max_CFLv = max(cfl_data(:,10:12), [], 2);
figure(3)
semilogy(cfl_data(:,2), max_CFLa, 'DisplayName', 'CFLa', LineWidth=line_thickness)
hold on
semilogy(cfl_data(:,2), cfl_data(:,13), 'DisplayName', 'CFLst', LineWidth=line_thickness)
semilogy(cfl_data(:,2), max_CFLv, 'DisplayName', 'CFLv', LineWidth=line_thickness)
yline(CFL, '--', 'DisplayName', sprintf('CFL = %.2f', CFL))
xlabel('Time', FontSize=font_axes)
ylabel('CFL', FontSize=font_axes)
title(['Maximum CFL for ', names{plot_case}], FontSize=font_title, Interpreter='none')
legend(FontSize=font_legend)
hold off
grid on


% Liquid pressure minimum and maximum
figure(10)
plot(simulation_data(:,2), simulation_data(:,10), 'DisplayName', 'PLmin', LineWidth=line_thickness)
hold on
plot(simulation_data(:,2), simulation_data(:,11), 'DisplayName', 'PLmax', LineWidth=line_thickness)
xlabel('Time', FontSize=font_axes)
ylabel('Liquid Pressure', FontSize=font_axes)
title(['Liquid Pressure Over Time for ', names{plot_case}], FontSize=font_title, Interpreter='none')
legend(FontSize=font_legend)
hold off
grid on


% Gas density minimum and maximum
figure(11)
plot(simulation_data(:,2), simulation_data(:,14), 'DisplayName', 'Gas density min', LineWidth=line_thickness)
hold on
plot(simulation_data(:,2), simulation_data(:,15), 'DisplayName', 'Gas density max', LineWidth=line_thickness)
xlabel('Time', FontSize=font_axes)
ylabel('Gas Density', FontSize=font_axes)
title(['Gas Density Over Time for ', names{plot_case}], FontSize=font_title, Interpreter='none')
legend(FontSize=font_legend)
hold off
grid on


% Liquid density minimum and maximum
figure(15)
plot(simulation_data(:,2), simulation_data(:,8), 'DisplayName', 'Liquid density min', LineWidth=line_thickness)
hold on
plot(simulation_data(:,2), simulation_data(:,9), 'DisplayName', 'Liquid density max', LineWidth=line_thickness)
xlabel('Time', FontSize=font_axes)
ylabel('Liquid Density', FontSize=font_axes)
title(['Liquid Density Over Time for ', names{plot_case}], FontSize=font_title, Interpreter='none')
legend(FontSize=font_legend)
hold off
grid on

if isfile(capillaryFile)
    % Capillary Number
    figure(8)
    plot(capillary_data(:,2), capillary_data(:,5), LineWidth=line_thickness)
    xlabel('Time', FontSize=font_axes)
    ylabel('Capillary Number', FontSize=font_axes)
    title(['Capillary Number for ', names{plot_case}], FontSize=font_title, Interpreter='none')
    grid on
end


% Check which rescue quantities were used
if isfile(rescueFile)
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
    disp(' ')
    disp(['Rescue quantities used for ', names{plot_case}, ':'])
    for col = 3:size(rescue_data, 2)
        if sum(rescue_data(:,col)) ~= 0, disp(column_names{col-2}); end
    end
    disp(' ')
end



