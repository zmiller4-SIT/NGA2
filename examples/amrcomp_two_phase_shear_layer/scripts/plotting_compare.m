% IC_compare.m
% Computes the discrete erf velocity IC in MATLAB (cell-center value and
% cell average via the integral, same formulas as the solver) and compares
% them to the solver output exported from ParaView.
clear; clc; close all

% ======================= inputs =======================
% fluid params
visc_ratio    = 0.99;    % mu_g / mu_l
density_ratio = 1000;    % rho_l / rho_g
Mach_gas      = 0.6;     % U_g / c_g
gamma_g       = 1.4;

% grid params
ny  = 64;
Ly  = 12;
amr = 0;
ylo = -0.5*Ly;           % bottom of domain (solver%amr%ylo)

% ParaView PlotOverLine exports
% noted from which simulations in overleaf
file_center  = '../saved_simulations/plot_over_line_cell_center.csv';
file_average = '../saved_simulations/plot_over_line_cell_average.csv';
%file_average = 'saved_simulations/plot_over_line_cell_average_ny128.csv'; % testing auto python trace

% ===================== end of inputs ====================

U_gas = Mach_gas * sqrt(gamma_g*density_ratio);
U_liq = visc_ratio * U_gas;

nyc = ny * 2^amr;
dy  = Ly / nyc;
interface_location = dy/2;

% ---- discrete IC in MATLAB, same as the solver ----
y_cc      = zeros(1, nyc);
u_center  = zeros(1, nyc);
u_average = zeros(1, nyc);
for j = 1:nyc
    y_cc(j) = ylo + (j - 0.5)*dy;

    if y_cc(j) >= interface_location
        U = U_gas;
    else
        U = U_liq;
    end

    % cell-center value
    u_center(j) = U * erf(y_cc(j) - interface_location);

    % cell average: integral of erf over the cell divided by dy
    lo_bound = ylo + (j-1)*dy - interface_location;
    hi_bound = ylo +  j   *dy - interface_location;
    integral_hi = hi_bound*erf(hi_bound) + exp(-hi_bound^2)/sqrt(pi);
    integral_lo = lo_bound*erf(lo_bound) + exp(-lo_bound^2)/sqrt(pi);
    u_average(j) = U / (hi_bound - lo_bound) * (integral_hi - integral_lo);
end

% ---- solver output from ParaView ----
[y_sim_c, U_sim_center]  = loadLine(file_center,  Ly, dy, nyc);
[y_sim_a, U_sim_average] = loadLine(file_average, Ly, dy, nyc);

% ---- compare ----
diff_center  = U_sim_center  - u_center;
diff_average = U_sim_average - u_average;
fprintf('cell center:  max |solver - matlab| = %.3e\n', max(abs(diff_center)));
fprintf('cell average: max |solver - matlab| = %.3e\n', max(abs(diff_average)));

figure(1); hold on
plot(y_cc,    u_center,      '-',  'DisplayName', 'MATLAB cell center')
plot(y_sim_c, U_sim_center,  'o',  'DisplayName', 'solver cell center')
plot(y_cc,    u_average,     '--', 'DisplayName', 'MATLAB cell average')
plot(y_sim_a, U_sim_average, 's',  'DisplayName', 'solver cell average')
xlabel('y', 'FontSize', 17); ylabel('U', 'FontSize', 17)
title('Velocity IC: solver vs MATLAB', 'FontSize', 20)
legend('Location', 'best', 'FontSize', 14); grid on; hold off

figure(2); hold on
plot(y_cc, diff_center,  'o', 'DisplayName', 'cell center')
plot(y_cc, diff_average, 's', 'DisplayName', 'cell average')
xlabel('y', 'FontSize', 17); ylabel('solver - MATLAB', 'FontSize', 17)
title('Difference from MATLAB', 'FontSize', 20)
legend('Location', 'best', 'FontSize', 14); grid on; hold off

% ---- cell center only ----
figure(3)
subplot(2,1,1); hold on
plot(y_cc,    u_center,     '-', 'DisplayName', 'MATLAB')
plot(y_sim_c, U_sim_center, 'o', 'DisplayName', 'solver')
ylabel('U', 'FontSize', 17)
title('Cell center: solver vs MATLAB', 'FontSize', 20)
legend('Location', 'best', 'FontSize', 14); grid on; hold off
subplot(2,1,2)
plot(y_cc, diff_center, 'o')
xlabel('y', 'FontSize', 17); ylabel('solver - MATLAB', 'FontSize', 17)
grid on

% ---- cell average only ----
figure(4)
subplot(2,1,1); hold on
plot(y_cc,    u_average,     '-', 'DisplayName', 'MATLAB')
plot(y_sim_a, U_sim_average, 's', 'DisplayName', 'solver')
ylabel('U', 'FontSize', 17)
title('Cell average: solver vs MATLAB', 'FontSize', 20)
legend('Location', 'best', 'FontSize', 14); grid on; hold off
subplot(2,1,2)
plot(y_cc, diff_average, 's')
xlabel('y', 'FontSize', 17); ylabel('solver - MATLAB', 'FontSize', 17)
grid on


% ======================= local functions =======================
function [y, U] = loadLine(file, Ly, dy, nyc)
% Reads a PlotOverLine CSV by column name, removes the endpoints at
% y = +-Ly/2 and duplicate samples, and returns one value per cell sorted by y.
    fid = fopen(file, 'r');
    header = strrep(strsplit(fgetl(fid), ','), '"', '');
    fclose(fid);
    data = readmatrix(file);
    y = data(:, strcmp(header, 'Points:1'));
    U = data(:, strcmp(header, 'U'));

    keep = abs(y) < 0.5*Ly - 0.25*dy;               % drop endpoints
    y = y(keep);  U = U(keep);

    [~, idx] = unique(floor((y + 0.5*Ly)/dy));      % one sample per cell, sorted
    y = y(idx).';  U = U(idx).';

    if numel(U) ~= nyc
        error('%s: found %d cells, expected %d', file, numel(U), nyc);
    end
end