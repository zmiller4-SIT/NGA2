
clear; clc; close all

% fluid params
Re_g = 3000;
We_g = 2250;
visc_ratio = 0.99;      % mu_g / mu_l
density_ratio = 1000;   % rho_l / rho_g
Mach_gas = 0.6;         % U_g / c_g
gamma_g = 1.4;
gamma_l = 4.4;
PinfL = 6000;
PL = 1;
rhoL = 1;
% grid / sim params
alpha = 1.5;
num_per = 6;
nx = 256;
Ly = 6*pi;
Lx = 2*num_per*pi/alpha;
amr = 0;
ny = 3*alpha*nx/num_per;
LSS = sqrt(gamma_l*(PinfL+PL)/rhoL);
CFL = 0.25;

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



dt_x = CFL*Lx / (nx * 2^amr * (U_l+LSS) );
dt_y = CFL*Ly / (ny * 2^amr * (LSS) );

fprintf('dt_x: %.10f\n', dt_x);
fprintf('dt_y: %.10e\n', dt_y);
fprintf('ny: %.10f\n', ny);


