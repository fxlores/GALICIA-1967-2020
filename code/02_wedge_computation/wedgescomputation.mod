%----------------------------------------------------------------
% ENDOGENOUS VARIABLES
% These are the variables solved for by Dynare along the perfect-foresight path:
% - k      : capital stock
% - A      : Hicks-neutral efficiency wedge
% - pi_h   : household labor wedge
% - pi_f   : firm labor wedge
% - pi_x   : investment wedge
% - pi_g   : resource wedge
%----------------------------------------------------------------
var k ${k}$ (long_name='capital')
    A ${A}$ (long_name='Hicks efficiency wedge')
    pi_h ${\pi_h}$ (long_name='Household labor wedge')
    pi_f ${\pi_f}$ (long_name='Firm labor wedge')
    pi_x ${\pi_x}$ (long_name='investment wedge')
    pi_g ${\pi_g}$ (long_name='resource wedge')
;

%----------------------------------------------------------------
% EXOGENOUS VARIABLES
% In this perfect-foresight exercise, these are not stochastic shocks.
% They are deterministic time paths taken from the data file PathsGalicia:
% - y     : output
% - c     : consumption
% - x     : investment
% - l     : labor
% - pi_n  : population growth factor
% - sl    : labor share
%----------------------------------------------------------------
varexo y ${y}$ (long_name='output')
       c ${c}$ (long_name='consumption')
       x ${x}$ (long_name='investment')
       l ${l}$ (long_name='labor')
       pi_n ${\pi_n}$ (long_name='Population growth rate')
       sl ${\varepsilon}$ (long_name='Labour share')
;

%----------------------------------------------------------------
% PARAMETERS
% These parameters are calibrated outside the model equations and then
% assigned numerical values below.
%----------------------------------------------------------------
parameters beta ${\beta}$ (long_name='discount factor')
           alfa ${\alfa}$ (long_name='capital wheight in production function')
           rho ${\rho}$ (long_name='Parameter of elasticity of substitution')
           mu ${\mu}$ (long_name='labour disutility')
           gamy ${\gamma_y}$ (long_name='output per worker growth rate')
           phi ${\phi}$ (long_name='adjustment cost parameter')
           Phi ${\Phi}$ (long_name='adjustment cost parameter')
           nu ${\nu}$ (long_name='Frisch Elasticity')
           sg ${\sigma}$ (long_name='intertemporal elasticity of substitution for consumption')
           delta ${\delta}$ (long_name='Depreciation Rate')
;

%----------------------------------------------------------------
% TIME DIMENSION OF THE HISTORICAL SAMPLE
% This vector is later used in the post-processing section for figures.
%----------------------------------------------------------------
timeline = 1967:1:2020;
T = length(timeline);

%----------------------------------------------------------------
% CALIBRATED PARAMETER VALUES
% These values are fixed before solving the model.
%----------------------------------------------------------------
set_param_value('alfa',0.4294);
set_param_value('gamy',0.0228);
set_param_value('mu',1);
set_param_value('nu',-3);
set_param_value('delta',0.0330);
set_param_value('Phi',(1*(1+gamy))-(1-delta));
set_param_value('phi',0.25/Phi);
set_param_value('beta',0.9741);
set_param_value('sg',1);
set_param_value('rho',-0.388);

%----------------------------------------------------------------
% MODEL EQUATIONS
% There are six equations for the six endogenous variables:
% k, A, pi_h, pi_f, pi_x, pi_g.
%----------------------------------------------------------------
model;

    % (1) Intertemporal Euler-type condition that recovers the investment wedge pi_x.
    % It links current and future consumption, the marginal return to capital,
    % and adjustment costs.
    (1+gamy)*pi_x =
        beta*(c/c(+1))*
        (((((alfa*(alfa+((1-alfa)*((l(+1)/(k))^(rho))))^-1))*y(+1)/k)
        -((pi_x(+1)/(1-(phi*((x(+1)/k)-Phi))))
        *(((phi/2)*(((x(+1)/k)-Phi)^2))
        -((phi*((x(+1)/k)-Phi))*(x(+1)/k))
        -(1-delta))))
        *(1-(phi*((x/k(-1))-Phi))));

    % (2) Resource constraint with the resource wedge pi_g.
    % Rearranged, this implies y = pi_g*(c+x).
    0 = (pi_g*(c+x)) - y;

    % (3) CES production function used to back out the efficiency wedge A.
    y^rho = (A^rho)*((alfa*((k(-1))^(rho))) + ((1-alfa)*(l^rho)));

    % (4) Capital accumulation equation with growth, depreciation,
    % and quadratic adjustment costs.
    x = ((1+gamy)*pi_n*k) - ((1-delta)*k(-1))
        + ((phi/2)*k(-1)*(((x/k(-1))-Phi)^2));

    % (5) Intratemporal condition of the household, used to recover pi_h.
    mu*(c^sg)*(l^(1-nu))/y = sl*pi_h;

    % (6) Firm-side labor wedge equation linking labor share and pi_f.
    sl = (1 - (alfa*(alfa+((1-alfa)*((l/k(-1))^(rho))))^-1))*pi_f;

end;

%----------------------------------------------------------------
% LOAD STEADY-STATE OBJECTS AND INITIAL CONDITIONS
% EEGalicia contains the steady-state values computed previously.
%----------------------------------------------------------------
load EEGalicia ye xe ce le ke pi_g_bar pi_n_bar pi_h_bar pi_f_bar A_bar pi_x_bar sle K0

%----------------------------------------------------------------
% INITIAL HISTORICAL VALUE FOR CAPITAL
% histval sets the lagged initial condition k(0), which is needed because
% k enters the model with one lag.
%----------------------------------------------------------------
histval;
    k(0) = K0;
end;

%----------------------------------------------------------------
% TERMINAL BALANCED-GROWTH PATH
% initval provides the terminal values toward which the perfect-foresight
% path converges.
%----------------------------------------------------------------
initval;
    k    = ke;
    y    = ye;
    x    = xe;
    c    = ce;
    l    = le;
    sl   = sle;
    A    = A_bar;
    pi_h = pi_h_bar;
    pi_f = pi_f_bar;
    pi_x = pi_x_bar;
    pi_n = pi_n_bar;
end;

% Compute/check the steady state around the terminal balanced-growth path.
steady;

%----------------------------------------------------------------
% PERFECT-FORESIGHT SOLUTION
% The data file PathsGalicia provides the exogenous trajectories.
% Dynare then solves for the endogenous wedges and capital path.
%----------------------------------------------------------------
perfect_foresight_setup(periods=998,datafile=PathsGalicia);
perfect_foresight_solver(stack_solve_algo = 6);



