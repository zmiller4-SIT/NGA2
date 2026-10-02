
clear; clc; close all

Re_g = 3000;
We_g = 2250;
visc_ratio = 0.99;      % mu_g / mu_l
density_ratio = 1000;   % rho_l / rho_g
Mach_gas = 0.6;         % U_g / c_g
gamma_g = 1.4;
gamma_l = 4.4;

% calculated variables, using:
% rho_l = Pamb = delta_g = delta_l = 1
U_g = Mach_gas * sqrt(gamma_g*density_ratio);
mu_g = U_g / (density_ratio * Re_g);
U_l = visc_ratio * U_g;
mu_l = mu_g / visc_ratio;
sigma = U_g^2 / (density_ratio * We_g);

disp(' ')
fprintf('Gas Velocity: %.10f\n', U_g);
fprintf('Gas Viscosity: %.10e\n', mu_g);
fprintf('Liquid Velocity: %.10f\n', U_l);
fprintf('Liquid Viscosity: %.10e\n', mu_l);
fprintf('Surface Tension Coefficient: %.10e\n', sigma);

disp(' ')


% reading plot over line from ParaView
data = readmatrix('PlotOverLine2.csv');
% Keep only valid points
data(data(:,3) == 0,:) = [];
U = data(:,1);
y = data(:,6);
% shifted erf to compare to
dy_by2 = 0.09375;
uG = @(y) U_g * erf(y-dy_by2);
uL = @(y) U_l * erf(y-dy_by2);
% One y vector
y_erf = linspace(min(y), max(y), 500);
% Piecewise velocity profile
U_erf = zeros(size(y_erf));
liquid = y_erf < dy_by2;
gas = y_erf >= dy_by2;
U_erf(liquid) = uL(y_erf(liquid));
U_erf(gas) = uG(y_erf(gas));
% Plot
figure(1)
hold on
plot(y, U, 'o-', 'DisplayName', 'ParaView')
plot(y_erf, U_erf, '--', 'DisplayName', 'erf')
xlabel('y', FontSize=17)
ylabel('U', FontSize=17)
legend('Location','best',FontSize=20)
title('Shifted Erf Compared to Line Plot',FontSize=22)
grid on
hold off




% y_new = data(:,6)-dy_by2;
% % unshifted erf to compare to
% uG_new = @(y) U_g * erf(y);
% uL_new = @(y) U_l * erf(y);
% % One y vector
% y_erf = linspace(min(y), max(y), 500);
% % Piecewise velocity profile
% U_erf = zeros(size(y_erf));
% liquid = y_erf < 0;
% gas = y_erf >= 0;
% U_erf(liquid) = uL_new(y_erf(liquid));
% U_erf(gas) = uG_new(y_erf(gas));
% % Plot
% figure(2)
% hold on
% plot(y_new, U, 'o-', 'DisplayName', 'ParaView')
% plot(y_erf, U_erf, '--', 'DisplayName', 'erf')
% xlabel('y', FontSize=17)
% ylabel('U', FontSize=17)
% legend('Location','best',FontSize=20)
% title('Unshifted Erf Compared to Shifted Line Plot',FontSize=22)
% grid on
% hold off


