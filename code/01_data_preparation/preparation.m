%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DATA FOR: DRIVERS OF REGIONAL ECONOMIC DEVELOPMENT:
%%% TECHNOLOGICAL CHANGE VERSUS MARKET DISTORTIONS IN GALICIA, 1967–2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script constructs the model variables from the raw data.
% It also computes the initial transition paths required by Dynare
% to recover the model wedges.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% BDMORES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%% GALICIA
% VABpbcorr : Gross Value Added at basic prices, current prices,
%             thousand euros (VAB precios básicos a precios corrientes
%             miles de euros), 1955–2021
%
% FBCFcorr  : Gross Fixed Capital Formation, current prices,
%             thousand euros of 2015 (FBCF precios corrientes
%             miles euros de 2015), 1964–2020
%
% GCFHcorr  : Household final consumption expenditure, current prices
%             (Gasto en consumo final de los hogares precios corrientes),
%             1967–2021
%
% GCFHcons  : Household final consumption expenditure, constant 2015 prices
%             (Gasto en consumo final de los hogares precios ctes 2015),
%             1967–2021
%
% POBL      : Total population, persons
%             (Población total en personas), 1964–2021
%
% OCUPpt    : Employment, thousands of persons
%             (Número de ocupados en miles de personas), 1955–2021
%
% RT        : Labour income, thousand current euros
%             (Rentas del trabajo en miles de euros corrientes), 1955–2021
%
% %%%%%%%%%%%%%%%%%%%%% SPAIN
% GCF       : National final consumption expenditure, current prices
%             (Gasto en Consumo Final Nacional precios corrientes),
%             1980–2021
%
% GCFnpish  : National final consumption expenditure of NPISH, current prices
%             (Gasto en Consumo Final Nacional de las Isflsh precios corrientes),
%             1980–2021
%
% GCFaapp   : National final consumption expenditure of general government,
%             current prices
%             (Gasto en Consumo Final Nacional de las Aapp. precios corrientes),
%             1980–2021

load datBDMORES % File containing the original data extracted from BDMORES
time = 1955:2021;

% Construct Galicia’s final consumption expenditure by preserving
% the shares of NPISH and general government consumption in total
% final consumption observed at the national level.
alpha1 = GCFnpish(1:end-1) ./ GCF(1:end-1);
alpha2 = GCFaapp(1:end-1) ./ GCF(1:end-1);

% For the initial observations, when regional disaggregation is not directly
% available, the average national shares over the first five years are used.
% Thereafter, year-specific national shares are applied.
CP = [GCFHcons(1:13) ./ mean(1 - alpha1(1:5) - alpha2(1:5)), ...
      GCFHcons(14:end-1) ./ (1 - alpha1 - alpha2)];

% Per capita consumption
C = CP ./ POBL(4:end-1);

% Consumption deflator
P = GCFHcorr ./ GCFHcons;

% Per capita output at constant prices
Y = (VABpbcorr(find(time == 1967):end-1) ./ P(1:end-1)) ./ POBL(4:end-1);

% Sample size
T = length(Y);

% The first observation of each series is set to zero because
% Dynare ignores the first observation in this implementation.

% Employment rate
l(2:T+1) = OCUPpt(find(time == 1967):end-1) .* 1000 ./ POBL(4:end-1);

% Per capita investment at constant prices
X = (FBCFcorr(4:end) ./ P(1:end-1)) ./ POBL(4:end-1);

% Labour income share
SL = RT ./ VABpbcorr;
sl(2:T+1) = SL(find(time == 1967):end-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gamy  = 0.0228;
mu    = 1;
nu    = -3;
delta = 0.0330;

Phi   = (1 * (1 + gamy)) - (1 - delta);
phi   = 0.25 / Phi;
beta  = 0.9741;
sg    = 1;
rho   = -0.388;

% Capital share, calibrated as one minus the average labour share
% over the final eleven observations.
alfa = 1 - mean(sl(end-10:end));

%%%%%%%% Detrending

% Remove the balanced-growth component from output, consumption,
% and investment.
for i = 2:T+1
    y(i) = Y(i-1) / ((1 + gamy)^(i-2));
    c(i) = C(i-1) / ((1 + gamy)^(i-2));
    x(i) = X(i-1) / ((1 + gamy)^(i-2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wedge computation (except pi_x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Population wedge
pi_n(2:T+1) = POBL(5:end) ./ POBL(4:end-1);

% Resource wedge
pi_g(2:T+1) = Y ./ (C + X);

% Capital stock
% Initial capital condition
KY0 = 1.7;
k(1) = KY0 * y(2);

for i = 1:T
    % Recover the capital stock recursively using the law of motion
    % for capital, including depreciation and quadratic adjustment costs.
    k(i+1) = (((1 - delta) * k(i)) + x(i+1) ...
             - ((phi / 2) * k(i) * (((x(i+1) / k(i)) - Phi)^2))) ...
             / ((1 + gamy) * pi_n(i+1));
end

% Efficiency wedge
for i = 2:T+1
    A(i) = y(i) / ...
           (((alfa * (k(i)^rho)) + ((1 - alfa) * (l(i)^rho)))^(1/rho));
end

% Labour wedges
pi_h(1) = 0;
pi_f(1) = 0;

% Household labour wedge
pi_h(2:T+1) = ((mu .* c(2:T+1) .* (l(2:T+1).^(1 - nu))) ./ y(2:T+1)) ...
              ./ sl(2:T+1);

% Firm labour wedge
pi_f(2:T+1) = sl(2:T+1) ./ ...
              (1 - (alfa * (alfa + ((1 - alfa) * ((k(2:T+1) ./ l(2:T+1)).^(-rho)))).^-1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preparing data for Dynare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Steady-state objects are approximated by the average over the
% final eleven observations of the detrended sample.
sle = mean(sl(end-10:end));
ye  = mean(y(end-10:end));
xe  = mean(x(end-10:end));
ce  = mean(c(end-10:end));

pi_g_bar = ye / (ce + xe);

le = mean(l(end-10:end));
pi_n_bar = 1;

% Steady-state ratios
yh = ye / le;
cy = ce / ye;
kh = yh * ((pi_g_bar^-1) - cy) / (((pi_n_bar * (1 + gamy)) - 1 + delta));
ke = le * kh;

% Steady-state household labour wedge
pi_h_bar = ((mu * ce * (le)^(1 - nu)) / ye) / sle;

% Steady-state firm labour wedge
pi_f_bar = ((1 - (alfa * (alfa + ((1 - alfa) * ((kh)^(-rho))))^-1)) / sle)^(-1);

% Output-capital ratio
yk = ye / ke;

% Steady-state investment wedge
pi_x_bar = (((alfa * (alfa + ((1 - alfa) * ((kh)^(-rho))))^-1)) * yk) ...
           / (((1 + gamy) / beta) - 1 + delta);

% Steady-state efficiency level
A_bar = ye / (((alfa * (ke^rho)) + ((1 - alfa) * (le^rho)))^(1/rho));

%%% Endogenous and exogenous variables beyond 2020

% Speed of convergence to the steady state
bb = 0.03;

for i = T+1:1:1020
    % Extend each variable beyond the sample by imposing smooth
    % convergence from its terminal observed value to its steady-state level.
    y(i)    = y(T+1)    * exp(-bb * (i - T)) + ye       * (1 - exp(-bb * (i - T)));
    x(i)    = x(T+1)    * exp(-bb * (i - T)) + xe       * (1 - exp(-bb * (i - T)));
    l(i)    = l(T+1)    * exp(-bb * (i - T)) + le       * (1 - exp(-bb * (i - T)));
    pi_g(i) = pi_g(T+1) * exp(-bb * (i - T)) + pi_g_bar * (1 - exp(-bb * (i - T)));

    % Consumption is recovered residually from the resource constraint.
    c(i) = (y(i) / pi_g(i)) - x(i);

    k(i)    = k(T+1)    * exp(-bb * (i - T)) + ke       * (1 - exp(-bb * (i - T)));
    pi_n(i) = pi_n(T+1) * exp(-bb * (i - T)) + pi_n_bar * (1 - exp(-bb * (i - T)));
    A(i)    = A(T+1)    * exp(-bb * (i - T)) + A_bar    * (1 - exp(-bb * (i - T)));
    pi_h(i) = pi_h(T+1) * exp(-bb * (i - T)) + pi_h_bar * (1 - exp(-bb * (i - T)));
    pi_f(i) = pi_f(T+1) * exp(-bb * (i - T)) + pi_f_bar * (1 - exp(-bb * (i - T)));
    sl(i)   = sl(T+1)   * exp(-bb * (i - T)) + sle      * (1 - exp(-bb * (i - T)));
end

% Initial condition for the investment wedge:
% it is fixed at its steady-state value over the full extended horizon.
pi_x = ones(1,1020) .* pi_x_bar;

% Initial capital stock for Dynare
K0 = k(1);

save PathsGalicia A pi_h pi_f pi_x pi_n pi_g k y x l c sl
save EEGalicia ye xe ce le ke A_bar pi_h_bar pi_f_bar pi_x_bar pi_g_bar pi_n_bar sle K0
