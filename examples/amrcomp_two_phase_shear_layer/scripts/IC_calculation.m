
clear; clc; close all

% fluid params
Re_g = 3000;
We_g = 2250;
visc_ratio = 0.99;      % mu_g / mu_l
density_ratio = 1000;   % rho_l / rho_g
Mach_gas = 0.6;         % U_g / c_g
gamma_g = 1.4;
gamma_l = 4.4;
% grid / sim params
ny = 64;
Ly = 12;
amr = 0;


%numb_points = 2*ny;
numb_points = 10000;

%%%%%%%%%%%%% end of inputs %%%%%%%%%%%%%

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





