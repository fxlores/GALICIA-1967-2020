% post_wedgescomputation.m
% Run this script AFTER Dynare has solved wedgescomputation.mod
% in the same MATLAB session.

clearvars -except M_ oo_ options_
close all;
clc;

% -------------------------------------------------------------------------
% 1. Load steady-state objects used by your no-wedge files
% -------------------------------------------------------------------------
load(fullfile('EEGalicia.mat'), ...
     'ye','xe','ce','le','ke','A_bar','pi_h_bar','pi_f_bar', ...
     'pi_x_bar','pi_g_bar','pi_n_bar','sle','K0');

timeline = 1967:2020;
T = numel(timeline);

% -------------------------------------------------------------------------
% 2. Output folders
% -------------------------------------------------------------------------
data_out = fullfile('data');
fig_out  = fullfile('figures');

if ~exist(data_out,'dir')
    mkdir(data_out);
end

if ~exist(fig_out,'dir')
    mkdir(fig_out);
end

% -------------------------------------------------------------------------
% 3. Robust name matching for Dynare variables
% -------------------------------------------------------------------------
endo_names = strtrim(cellstr(M_.endo_names));
exo_names  = strtrim(cellstr(M_.exo_names));

pick_endo = @(nm,cols) oo_.endo_simul(strcmp(endo_names,nm), cols).';
pick_exo  = @(nm,rows) oo_.exo_simul(rows, strcmp(exo_names,nm));

% -------------------------------------------------------------------------
% 4. Baseline simulated paths (your original logic)
% -------------------------------------------------------------------------
A    = pick_endo('A',1:999);
pi_h = pick_endo('pi_h',1:999);
pi_f = pick_endo('pi_f',1:999);
pi_x = pick_endo('pi_x',1:999);
pi_g = pick_endo('pi_g',1:999);
pi_n = pick_exo('pi_n',1:999);

k  = ones(999,1) .* ke;
y  = ones(999,1) .* ye;
x  = ones(999,1) .* xe;
c  = ones(999,1) .* ce;
l  = ones(999,1) .* le;
sl = ones(999,1) .* sle;

pi_f1 = pick_endo('pi_f',2);
pi_h1 = pick_endo('pi_h',2);
pi_x1 = pick_endo('pi_x',2);
pi_g1 = pi_g_bar;   % in your code you overwrite the simulated value with pi_g_bar
A_1   = pick_endo('A',2);
pi_n1 = pick_exo('pi_n',2);

% -------------------------------------------------------------------------
% 5. Save no-wedge paths
% -------------------------------------------------------------------------

% No pi_f
pi_f_save = ones(999,1) .* pi_f1;
save(fullfile(data_out,'Nopifpaths.mat'), ...
     'A','pi_h','pi_f_save','pi_x','pi_g','pi_n','k','y','x','l','c','sl');

% No pi_h
pi_h_save = ones(999,1) .* pi_h1;
save(fullfile(data_out,'Nopihpaths.mat'), ...
     'A','pi_f','pi_h_save','pi_x','pi_g','pi_n','k','y','x','l','c','sl');

% No pi_x
pi_x_save = ones(999,1) .* pi_x1;
save(fullfile(data_out,'Nopixpaths.mat'), ...
     'A','pi_f','pi_h','pi_x_save','pi_g','pi_n','k','y','x','l','c','sl');

% No pi_g
pi_g_save = ones(999,1) .* pi_g1;
save(fullfile(data_out,'Nopigpaths.mat'), ...
     'A','pi_f','pi_h','pi_x','pi_g_save','pi_n','k','y','x','l','c','sl');

% No pi_n
pi_n_save = ones(999,1) .* pi_n1;
save(fullfile(data_out,'Nopinpaths.mat'), ...
     'A','pi_f','pi_h','pi_x','pi_g','pi_n_save','k','y','x','l','c','sl');

% No A
A_save = ones(999,1) .* A_1;
save(fullfile(data_out,'NoApaths.mat'), ...
     'A_save','pi_f','pi_h','pi_x','pi_g','pi_n','k','y','x','l','c','sl');

% Append one-period values to EEGalicia
save(fullfile('EEGalicia.mat'), ...
     'pi_f1','pi_h1','pi_x1','pi_g1','A_1','pi_n1','-append');

% -------------------------------------------------------------------------
% 6. Historical wedge series over the sample
% -------------------------------------------------------------------------
A_t    = pick_endo('A',2:T+1);
pi_f_t = pick_endo('pi_f',2:T+1);
pi_h_t = pick_endo('pi_h',2:T+1);
pi_x_t = pick_endo('pi_x',2:T+1);
pi_g_t = pick_endo('pi_g',2:T+1);
pi_n_t = pick_exo('pi_n',2:T+1);

save(fullfile(data_out,'wedgesGalicia.mat'), ...
     'A_t','pi_f_t','pi_h_t','pi_x_t','pi_g_t','pi_n_t');

s_bar = [A_bar pi_f_bar pi_h_bar pi_x_bar pi_g_bar pi_n_bar];
save(fullfile(data_out,'s_barPF.mat'),'s_bar');

% -------------------------------------------------------------------------
% 7. Figures
% -------------------------------------------------------------------------

% A wedge
f = figure('Visible','off');
plot(timeline, log(A_t(1:T)./A_t(1)), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
ylabel('logs','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'APF.png'),'Resolution',300);
close(f);

% Firm labor wedge
f = figure('Visible','off');
plot(timeline, log(pi_f_t(1:T)./pi_f_t(1)), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
set(gca,'YLim',[-1.6 0.2]);
ylabel('logs','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'pifPF.png'),'Resolution',300);
close(f);

% Investment wedge
f = figure('Visible','off');
plot(timeline, log(pi_x_t(1)./pi_x_t(1:T)), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
ylabel('logs','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'pixPF.png'),'Resolution',300);
close(f);

% Household labor wedge
f = figure('Visible','off');
plot(timeline, log(pi_h_t(1:T)./pi_h_t(1)), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
set(gca,'YLim',[-1.6 0.2]);
ylabel('logs','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'pihPF.png'),'Resolution',300);
close(f);

% Resource wedge
f = figure('Visible','off');
plot(timeline, log(pi_g_t(1:T)./pi_g_t(1)), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
ylabel('logs','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'pigPF.png'),'Resolution',300);
close(f);

% Population wedge
f = figure('Visible','off');
plot(timeline, pi_n_t(1:T), 'Color',[0 0 1], 'LineWidth', 3);
set(gca,'XTick',1967:3:2020);
ylabel('Growth Rate','FontSize',12,'FontWeight','bold');
xlabel('Year','FontSize',12,'FontWeight','bold');
grid on;
exportgraphics(f, fullfile(fig_out,'pinPF.png'),'Resolution',300);
close(f);
