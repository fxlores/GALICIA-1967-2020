%----------------------------------------------------------------
% ENDOGENOUS VARIABLES
% These are the model variables solved endogenously by Dynare
% in the counterfactual experiment.
%
% In this experiment, wedges are taken as exogenous inputs
% and the economy is solved given those wedges.
%----------------------------------------------------------------
var y ${y}$ (long_name='output')
    c ${c}$ (long_name='consumption')
    x ${x}$ (long_name='investment')
    l ${l}$ (long_name='labor')
    sl ${\varepsilon}$ (long_name='Labour output elasticity / labor share')
    k ${k}$ (long_name='capital')
;

%----------------------------------------------------------------
% EXOGENOUS VARIABLES (WEDGES)
% These variables are treated as deterministic exogenous paths.
% They are read from the data file specified in perfect_foresight_setup.
%
% In this particular experiment, pi_f is fixed to a constant path
% (its initial value), while the remaining wedges follow their
% estimated paths.
%----------------------------------------------------------------
varexo A ${A}$ (long_name='Hicks efficiency wedge')
       pi_h ${\pi_h}$ (long_name='Household labor wedge')
       pi_f ${\pi_f}$ (long_name='Firm labor wedge')
       pi_x ${\pi_x}$ (long_name='Investment wedge')
       pi_g ${\pi_g}$ (long_name='Resource wedge')
       pi_n ${\pi_n}$ (long_name='Population growth rate')
;

%----------------------------------------------------------------
% PARAMETERS
% Structural parameters of the model.
% Their calibration is discussed in Section 4.2 (Calibration) of the paper.
%----------------------------------------------------------------
parameters beta ${\beta}$ (long_name='discount factor')
           alfa ${\alfa}$ (long_name='capital weight in production function')
           rho ${\rho}$ (long_name='elasticity of substitution parameter')
           mu ${\mu}$ (long_name='labor disutility parameter')
           gamy ${\gamma_y}$ (long_name='output per worker growth rate')
           phi ${\phi}$ (long_name='capital adjustment cost parameter')
           Phi ${\Phi}$ (long_name='steady-state investment-capital ratio')
           nu ${\nu}$ (long_name='Frisch elasticity parameter')
           sg ${\sigma}$ (long_name='intertemporal elasticity of substitution')
           delta ${\delta}$ (long_name='depreciation rate')
;

%----------------------------------------------------------------
% TIME VARIABLES (used for plotting and post-processing)
%----------------------------------------------------------------
timeline = 1967:1:2020;
T = length(timeline);

%----------------------------------------------------------------
% PARAMETER VALUES
% These numerical values are assigned directly in the code.
%----------------------------------------------------------------
set_param_value('alfa',0.4294);
set_param_value('gamy',0.0228);
set_param_value('mu',1);
set_param_value('nu',-3);
set_param_value('rho',-0.388);
set_param_value('delta',0.0330);
set_param_value('Phi',(1*(1+gamy))-(1-delta));
set_param_value('phi',0.25/Phi);
% set_param_value('phi',0);  % alternative specification without adjustment costs
set_param_value('beta',0.9741);
set_param_value('sg',1);

%----------------------------------------------------------------
% MODEL EQUATIONS
% The economy is solved taking wedges as exogenous inputs.
%----------------------------------------------------------------
model;

    % (1) Euler equation for investment with adjustment costs.
    % Given consumption growth and future returns, this equation
    % determines investment dynamics.
    (1+gamy)*pi_x =
        beta*(c/c(+1))*
        (((alfa*(alfa+((1-alfa)*((l(+1)/(k))^(rho))))^-1)*y(+1)/k)
        -((pi_x(+1)/(1-(phi*((x(+1)/k)-Phi))))
        *(((phi/2)*(((x(+1)/k)-Phi)^2))
        -((phi*((x(+1)/k)-Phi))*(x(+1)/k))
        -(1-delta))))
        *(1-(phi*((x/k(-1))-Phi)));

    % (2) Resource constraint with the resource wedge pi_g.
    % Output is allocated between consumption and investment.
    0 = (pi_g*(c+x)) - y;

    % (3) CES production function.
    % Output is produced using capital and labor, scaled by
    % the efficiency wedge A.
    y^rho = (A^rho)*((alfa*((k(-1))^(rho))) + ((1-alfa)*(l^rho)));

    % (4) Capital accumulation equation with growth and adjustment costs.
    x = ((1+gamy)*pi_n*k) - ((1-delta)*k(-1))
        + ((phi/2)*k(-1)*(((x/k(-1))-Phi)^2));

    % (5) Household intratemporal optimality condition.
    % This equation links labor supply to consumption and the
    % household labor wedge pi_h.
    mu*(c^sg)*(l^(1-nu))/y = sl*pi_h;

    % (6) Firm-side labor demand condition.
    % The labor share is distorted by the firm labor wedge pi_f.
    sl = (1-(alfa*(alfa+((1-alfa)*((l/k(-1))^(rho))))^-1))*pi_f;

end;

%----------------------------------------------------------------
% STEADY STATE AND INITIAL CONDITIONS
%----------------------------------------------------------------
load EEGalicia ye xe ce le ke pi_g_bar pi_n_bar pi_h_bar pi_f_bar ...
               A_bar pi_x_bar sle K0 A_1 pi_h1 pi_f1 pi_x1 pi_g1 pi_n1

% Initial condition for capital (required because k appears with a lag)
histval;
    k(0) = K0;
end;

% Terminal balanced-growth path.
% The perfect-foresight solution converges to this path.
initval;
    k    = ke;
    y    = ye;
    x    = xe;
    c    = ce;
    l    = le;
    sl   = sle;
    A = A_bar;        
    pi_h = pi_h_bar;   
    pi_x = pi_x_bar;       
    pi_g = pi_g_bar;        
    pi_n = pi_n_bar;            
    pi_f = pi_f_bar;    
end;

%----------------------------------------------------------------
% PERFECT-FORESIGHT SOLUTION
% This solves the economy given the exogenous wedge paths.
% 
%----------------------------------------------------------------



perfect_foresight_setup(periods=997,datafile=Nopifpaths);
perfect_foresight_solver(maxit=200, stack_solve_algo = 6);
               
   


 