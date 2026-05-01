%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% experiments.m
%
% This script runs the full set of counterfactual "no-wedge" experiments
% reported in the paper.
%
% For each wedge:
%   - The Dynare model file WGAGalicia.mod is modified in-place.
%   - One wedge is fixed to a constant value.
%   - The model is solved under perfect foresight.
%   - Simulated paths are extracted and stored.
%
% The second part of the script:
%   - Constructs data and counterfactual log-deviations.
%   - Produces all figures used in the paper.
%   - Computes variance-share ("sigma") statistics.
%   - Exports a LaTeX table.
%
% IMPORTANT:
%   This script edits WGAGalicia.mod using fixed line numbers.
%   Any change in WGAGalicia.mod line numbering will break the script.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%
%%% NO A wedge components
%%%%%%%%%%%%%%%%%%%%%%

% Fix the efficiency wedge A to its initial value A_1
replaceLine = 135;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    A = A_1;        ');
fclose(fid1);

% Use NoApaths as exogenous input and solve the model
replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=NoApaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

% Run Dynare without clearing previously computed variables
dynare WGAGalicia noclearall

% Store simulated paths (column 1 corresponds to No-A experiment)
yc_t(:,1) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,1) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,1) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,1) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,1) = yc_t(:,1)./hc_t(:,1);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NO pi_h wedge components
%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore A to steady state
replaceLine = 135;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    A = A_bar;     ');
fclose(fid1);

% Fix household labor wedge pi_h
replaceLine = 136;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_h = pi_h1;    ');
fclose(fid1);

replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopihpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

dynare WGAGalicia noclearall

yc_t(:,2) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,2) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,2) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,2) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,2) = yc_t(:,2)./hc_t(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NO pi_x wedge components
%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore pi_h
replaceLine = 136;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_h = pi_h_bar;   ');
fclose(fid1);

% Fix investment wedge pi_x
replaceLine = 137;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_x = pi_x1;    ');
fclose(fid1);

replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopixpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

dynare WGAGalicia noclearall

yc_t(:,3) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,3) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,3) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,3) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,3) = yc_t(:,3)./hc_t(:,3);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NO pi_g wedge components
%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore pi_x
replaceLine = 137;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_x = pi_x_bar;   ');
fclose(fid1);

% Fix resource wedge pi_g
replaceLine = 138;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_g = pi_g1;    ');
fclose(fid1);

replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopigpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

dynare WGAGalicia noclearall

yc_t(:,4) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,4) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,4) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,4) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,4) = yc_t(:,4)./hc_t(:,4);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NO pi_n wedge components
%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore pi_g
replaceLine = 138;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_g = pi_g_bar;    ');
fclose(fid1);

% Fix population growth wedge pi_n
replaceLine = 139;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_n = pi_n1;    ');
fclose(fid1);

replaceLine = 149;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopinpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

dynare WGAGalicia noclearall

yc_t(:,5) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,5) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,5) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,5) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,5) = yc_t(:,5)./hc_t(:,5);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NO pi_f wedge components
%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore pi_n
replaceLine = 139;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_n = pi_n_bar;   ');
fclose(fid1);

% Fix firm labor wedge pi_f
replaceLine = 140;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_f = pi_f1;    ');
fclose(fid1);

replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopifpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

dynare WGAGalicia noclearall

yc_t(:,6) = oo_.endo_simul(strcmp('y',M_.endo_names),2:997);
cc_t(:,6) = oo_.endo_simul(strcmp('sl',M_.endo_names),2:997);
xc_t(:,6) = oo_.endo_simul(strcmp('x',M_.endo_names),2:997);
hc_t(:,6) = oo_.endo_simul(strcmp('l',M_.endo_names),2:997);
yh_t(:,6) = yc_t(:,6)./hc_t(:,6);

% Restore pi_f
replaceLine = 140;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'    pi_f = pi_f_bar;   ');
fclose(fid1);
replaceLine = 150;
fid1 = fopen("WGAGalicia.mod","r+");
for k = 1:(replaceLine-1)
    fgetl(fid1);
end
fseek(fid1,0,'cof');
fprintf(fid1,'\nperfect_foresight_setup(periods=997,datafile=Nopifpaths);');
fprintf(fid1,'\nperfect_foresight_solver(maxit=200, stack_solve_algo = 6);');
fprintf(fid1,'\n ');
fclose(fid1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FIGURES AND TABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load PathsGalicia.mat y x l sl
y=y(2:end);
l=l(2:end);
x=x(2:end);
sl=sl(2:end);
y_t_data = log(y(find(timeline>=1967 & timeline<=2020))./y(find(timeline==1967)));
h_t_data = log(l(find(timeline>=1967 & timeline<=2020))./l(find(timeline==1967)));
x_t_data = log(x(find(timeline>=1967 & timeline<=2020))./x(find(timeline==1967)));
ls_t_data = log(sl(find(timeline>=1967 & timeline<=2020))./sl(find(timeline==1967)));

y_t_data = y_t_data';
h_t_data = h_t_data';
x_t_data = x_t_data';
ls_t_data =ls_t_data';
for i=1:6
    ycm_t(:,i)=log(yc_t(find(timeline>=1967 & timeline<=2020),i)./yc_t(find(timeline==1967),i));
    xcm_t(:,i)=log(xc_t(find(timeline>=1967 & timeline<=2020),i)./xc_t(find(timeline==1967),i));
    hcm_t(:,i)=log(hc_t(find(timeline>=1967 & timeline<=2020),i)./hc_t(find(timeline==1967),i));
    ccm_t(:,i)=log(cc_t(find(timeline>=1967 & timeline<=2020),i)./cc_t(find(timeline==1967),i));
end


% Output and A pi_h and pi_x components
figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,1),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,2),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,3),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.05,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.07,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.05,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.07,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.05,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.07,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.05,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'y_t','y_{A}','y_{\pi_h}','y_{\pi_x}'},'Location','Southwest')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTyc_t.png');
hold off
close


% Output and pi_f, pi_g and pi_n components

figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,6),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,4),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),y_t_data-ycm_t(:,5),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.35,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.36,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.35,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.36,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.35,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.36,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.35,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'y_t','y_{\pi_f}','y_{\pi_g}','y_{\pi_n}'},'Location','best')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTyc_t2.png');
hold off
close

% Labour and A pi_h and pi_x components

figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,1),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,2),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,3),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.3,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.315,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.08,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.089,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.08,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.089,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.1,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'l_t','l_{A}','l_{\pi_h}','l_{\pi_x}'},'Location','best')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOThc_t.png');
hold off
close


% Labour and pi_f, pi_g and pi_n components
figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,6),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,4),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),h_t_data-hcm_t(:,5),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.3,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.315,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.08,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.089,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.08,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.089,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.1,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'l_t','l_{\pi_f}','l_{\pi_g}','l_{\pi_n}'},'Location','best')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOThc_t2.png');
hold off
close


% Investment and A pi_h and pi_x components

figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,1),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,2),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,3),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.1,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.135,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.1,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.135,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.1,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.135,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy) max(ylimy)];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.1,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'x_t','x_{A}','x_{\pi_h}','x_{\pi_x}'},'Location','Northwest')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTxc_t.png');
hold off
close
% Investment pi_f, pi_g and pi_n components

figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,6),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,4),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),x_t_data-xcm_t(:,5),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy)+0.2 max(ylimy)+0.2];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy)-0.1,'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.135,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.2 max(ylimy)+0.2];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy)-0.1,'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.135,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.2 max(ylimy)+0.2];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy)-0.1,'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.135,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.2 max(ylimy)+0.2];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy)-0.1,'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'x_t','x_{\pi_f}','x_{\pi_g}','x_{\pi_n}'},'Location','Northwest')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTxc_t2.png');
hold off
close




% Labour share and z pi_h and pi_x components

figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,1),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,2),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,3),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy),'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.01,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy),'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.01,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy),'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.01,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy),'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'s_{l}','s_{lA}','s_{l\pi_h}','s_{l\pi_x}'},'Location','best')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTcc_t.png');
hold off
close


% Labour share pi_f, pi_g and pi_n components
figurey = figure;
h1=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data,"k","linewidth",2.5)
hold on
h2=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,6),"Color",'blue',"linestyle","--","linewidth",2.5)
hold on
h3=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,4),"Color",'blue',"linestyle","-.","linewidth",2.5)
hold on
h4=plot(timeline(find(timeline>=1967 & timeline<=2020)),ls_t_data-ccm_t(:,5),"Color",'blue',"linestyle",":","linewidth",2.5)
grid on
axy = gca(figurey);
axy.YGrid = 'on';
axy.XGrid = 'off';
axy.GridColor = [0.85 0.85 0.85];
axy.GridAlpha = 0.5;
axy.GridLineStyle = '--';
axy.LineWidth = 1;
ylimy = axy.YLim;
% Shaded area representing recessions according to Lores(2026)
x_patch = [1973 1986 1986 1973];
y_patch = [min(ylimy) min(ylimy)  max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Oil recessions');
text(1974,max(ylimy),'Oil Recessions','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1974,max(ylimy)-0.01,'Industrial Restructuring','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [1991 1994 1994 1991];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The European Crisis');
text(1992,max(ylimy),'European','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(1992,max(ylimy)-0.01,'Crisis','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2007 2014 2014 2007];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The Double Recession');
text(2008,max(ylimy),'Great','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
text(2008,max(ylimy)-0.01,'Recession','FontSize',8,'FontWeight','bold','Color','k','HandleVisibility', 'off')
x_patch = [2019 2020 2020 2019];
y_patch = [min(ylimy) min(ylimy) max(ylimy)+0.05 max(ylimy)+0.05];
patch(x_patch, y_patch, [0 0.4 0.8], 'FaceAlpha', 0.3,'EdgeColor', 'none', 'DisplayName', 'The COVID-19 recession');
text(2014,max(ylimy),'COVID-19','FontSize',7,'FontWeight','bold','Color','k','HandleVisibility', 'off')
legend([h1 h2 h3 h4],{'s_{l}','s_{l\pi_f}','s_{l\pi_g}','s_{l\pi_n}'},'Location','best')
legend('boxoff')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'XTick',[1967:2:2020]);
ylabel('logs','FontSize',12,'FontWeight','bold')
xlabel('Year','FontSize',12,'FontWeight','bold')
saveas(gcf,'figures/NOTcc_t2.png');
hold off
close


y_t_data = log(y(find(timeline>=1967 & timeline<=2020)));
h_t_data = log(l(find(timeline>=1967 & timeline<=2020)));
x_t_data = log(x(find(timeline>=1967 & timeline<=2020)));
ls_t_data = log(sl(find(timeline>=1967 & timeline<=2020)));


y_t_data = y_t_data';
h_t_data = h_t_data';
x_t_data = x_t_data';
ls_t_data =ls_t_data';
for i=1:6

     ycm_t(:,i)=log(yc_t(find(timeline>=1967 & timeline<=2020),i));
     xcm_t(:,i)=log(xc_t(find(timeline>=1967 & timeline<=2020),i));
     hcm_t(:,i)=log(hc_t(find(timeline>=1967 & timeline<=2020),i));
     ccm_t(:,i)=log(cc_t(find(timeline>=1967 & timeline<=2020),i));

end
% Table of statistics of components 
   fid2=fopen("tables/table2stats.tex","w");
   fprintf(fid2,'\\begin{table}[h]');
   fprintf(fid2,'\\caption{\\textsc{Statistics.}} \\label{2statistics} ');
   fprintf(fid2,'\n \\begin{center}');
   fprintf(fid2,'\n \\begin{tabular}{l|cc|cc|cc|cc|cc|cc}');
   fprintf(fid2,'\n \\hline\\hline');
   fprintf(fid2,'\n \\textbf{Variable}  &${\\rho}_{p,A}^{\\mathbf{\\Delta y}}$ & $\\mathtt{P}_{A}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{h}}^{\\mathbf{\\Delta y}}$ & $\\mathtt{P}_{\\pi_{h}}^{\\mathbf{y}}$ &${\\rho}_{p,\\pi_{x}}^{\\mathbf{\\Delta y}}$ & $\\mathtt{P}_{\\pi_{x}}^{\\mathbf{y}}$ &${\\rho}_{p,\\pi_{f}}^{\\mathbf{\\Delta y}}$ & $\\mathtt{P}_{\\pi_{f}}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{g}}^{\\mathbf{\\Delta y}}$ & $\\mathtt{P}_{\\pi_{g}}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{n}}^{\\mathbf{\\Delta y}}$& $\\mathtt{P}_{\\pi_{n}}^{\\mathbf{y}}$\\\\'); 
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{Entire Sample} }		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data-ycm_t(:,1:6)), diff(y_t_data), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data-mean(y_t_data)-(ycm_t(:,1:6)-mean(ycm_t(:,1:6),1)), y_t_data-mean(y_t_data).*ones(length(y_t_data),6));
rho_ph = corr(diff(h_t_data-hcm_t(:,1:6)), diff(h_t_data), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data-mean(h_t_data)-(hcm_t(:,1:6)-mean(hcm_t(:,1:6),1)), h_t_data-mean(h_t_data).*ones(length(h_t_data),6));
rho_px = corr(diff(x_t_data-xcm_t(:,1:6)), diff(x_t_data), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data-mean(x_t_data)-(xcm_t(:,1:6)-mean(xcm_t(:,1:6),1)), x_t_data-mean(x_t_data).*ones(length(x_t_data),6));
rho_pl = corr(diff(ls_t_data-ccm_t(:,1:6)), diff(ls_t_data), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data-mean(ls_t_data)-(ccm_t(:,1:6)-mean(ccm_t(:,1:6),1)), ls_t_data-mean(ls_t_data).*ones(length(ls_t_data),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The Economic Miracle} 1967-1973}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1967 & timeline<=1973))-ycm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(y_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1967 & timeline<=1973))-mean(y_t_data(find(timeline>=1967 & timeline<=1973)))-(ycm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(ycm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), y_t_data(find(timeline>=1967 & timeline<=1973))-mean(y_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(y_t_data(find(timeline>=1967 & timeline<=1973))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1967 & timeline<=1973))-hcm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(h_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1967 & timeline<=1973))-mean(h_t_data(find(timeline>=1967 & timeline<=1973)))-(hcm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(hcm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), h_t_data(find(timeline>=1967 & timeline<=1973))-mean(h_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(h_t_data(find(timeline>=1967 & timeline<=1973))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1967 & timeline<=1973))-xcm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(x_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1967 & timeline<=1973))-mean(x_t_data(find(timeline>=1967 & timeline<=1973)))-(xcm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(xcm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), x_t_data(find(timeline>=1967 & timeline<=1973))-mean(x_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(x_t_data(find(timeline>=1967 & timeline<=1973))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1967 & timeline<=1973))-ccm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(ls_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1967 & timeline<=1973))-mean(ls_t_data(find(timeline>=1967 & timeline<=1973)))-(ccm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(ccm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), ls_t_data(find(timeline>=1967 & timeline<=1973))-mean(ls_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(ls_t_data(find(timeline>=1967 & timeline<=1973))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The Oil Recessions} 1973-1982}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1973 & timeline<=1982))-ycm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(y_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1973 & timeline<=1982))-mean(y_t_data(find(timeline>=1973 & timeline<=1982)))-(ycm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(ycm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), y_t_data(find(timeline>=1973 & timeline<=1982))-mean(y_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(y_t_data(find(timeline>=1973 & timeline<=1982))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1973 & timeline<=1982))-hcm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(h_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1973 & timeline<=1982))-mean(h_t_data(find(timeline>=1973 & timeline<=1982)))-(hcm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(hcm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), h_t_data(find(timeline>=1973 & timeline<=1982))-mean(h_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(h_t_data(find(timeline>=1973 & timeline<=1982))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1973 & timeline<=1982))-xcm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(x_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1973 & timeline<=1982))-mean(x_t_data(find(timeline>=1973 & timeline<=1982)))-(xcm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(xcm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), x_t_data(find(timeline>=1973 & timeline<=1982))-mean(x_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(x_t_data(find(timeline>=1973 & timeline<=1982))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1973 & timeline<=1982))-ccm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(ls_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1973 & timeline<=1982))-mean(ls_t_data(find(timeline>=1973 & timeline<=1982)))-(ccm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(ccm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), ls_t_data(find(timeline>=1973 & timeline<=1982))-mean(ls_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(ls_t_data(find(timeline>=1973 & timeline<=1982))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The Industrial Reestructuring} 1982-1986 }		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1982 & timeline<=1986))-ycm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(y_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1982 & timeline<=1986))-mean(y_t_data(find(timeline>=1982 & timeline<=1986)))-(ycm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(ycm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), y_t_data(find(timeline>=1982 & timeline<=1986))-mean(y_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(y_t_data(find(timeline>=1982 & timeline<=1986))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1982 & timeline<=1986))-hcm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(h_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1982 & timeline<=1986))-mean(h_t_data(find(timeline>=1982 & timeline<=1986)))-(hcm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(hcm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), h_t_data(find(timeline>=1982 & timeline<=1986))-mean(h_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(h_t_data(find(timeline>=1982 & timeline<=1986))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1982 & timeline<=1986))-xcm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(x_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1982 & timeline<=1986))-mean(x_t_data(find(timeline>=1982 & timeline<=1986)))-(xcm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(xcm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), x_t_data(find(timeline>=1982 & timeline<=1986))-mean(x_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(x_t_data(find(timeline>=1982 & timeline<=1986))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1982 & timeline<=1986))-ccm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(ls_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1982 & timeline<=1986))-mean(ls_t_data(find(timeline>=1982 & timeline<=1986)))-(ccm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(ccm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), ls_t_data(find(timeline>=1982 & timeline<=1986))-mean(ls_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(ls_t_data(find(timeline>=1982 & timeline<=1986))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The European Integration} 1986-1991}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1986 & timeline<=1991))-ycm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(y_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1986 & timeline<=1991))-mean(y_t_data(find(timeline>=1986 & timeline<=1991)))-(ycm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(ycm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), y_t_data(find(timeline>=1986 & timeline<=1991))-mean(y_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(y_t_data(find(timeline>=1986 & timeline<=1991))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1986 & timeline<=1991))-hcm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(h_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1986 & timeline<=1991))-mean(h_t_data(find(timeline>=1986 & timeline<=1991)))-(hcm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(hcm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), h_t_data(find(timeline>=1986 & timeline<=1991))-mean(h_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(h_t_data(find(timeline>=1986 & timeline<=1991))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1986 & timeline<=1991))-xcm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(x_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1986 & timeline<=1991))-mean(x_t_data(find(timeline>=1986 & timeline<=1991)))-(xcm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(xcm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), x_t_data(find(timeline>=1986 & timeline<=1991))-mean(x_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(x_t_data(find(timeline>=1986 & timeline<=1991))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1986 & timeline<=1991))-ccm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(ls_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1986 & timeline<=1991))-mean(ls_t_data(find(timeline>=1986 & timeline<=1991)))-(ccm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(ccm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), ls_t_data(find(timeline>=1986 & timeline<=1991))-mean(ls_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(ls_t_data(find(timeline>=1986 & timeline<=1991))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The European Crisis} 1991-1994}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1991 & timeline<=1994))-ycm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(y_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1991 & timeline<=1994))-mean(y_t_data(find(timeline>=1991 & timeline<=1994)))-(ycm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(ycm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), y_t_data(find(timeline>=1991 & timeline<=1994))-mean(y_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(y_t_data(find(timeline>=1991 & timeline<=1994))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1991 & timeline<=1994))-hcm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(h_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1991 & timeline<=1994))-mean(h_t_data(find(timeline>=1991 & timeline<=1994)))-(hcm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(hcm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), h_t_data(find(timeline>=1991 & timeline<=1994))-mean(h_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(h_t_data(find(timeline>=1991 & timeline<=1994))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1991 & timeline<=1994))-xcm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(x_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1991 & timeline<=1994))-mean(x_t_data(find(timeline>=1991 & timeline<=1994)))-(xcm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(xcm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), x_t_data(find(timeline>=1991 & timeline<=1994))-mean(x_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(x_t_data(find(timeline>=1991 & timeline<=1994))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1991 & timeline<=1994))-ccm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(ls_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1991 & timeline<=1994))-mean(ls_t_data(find(timeline>=1991 & timeline<=1994)))-(ccm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(ccm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), ls_t_data(find(timeline>=1991 & timeline<=1994))-mean(ls_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(ls_t_data(find(timeline>=1991 & timeline<=1994))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The Pre‑Great Recession Expansion} 1994-2007}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=1994 & timeline<=2007))-ycm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(y_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=1994 & timeline<=2007))-mean(y_t_data(find(timeline>=1994 & timeline<=2007)))-(ycm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(ycm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), y_t_data(find(timeline>=1994 & timeline<=2007))-mean(y_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(y_t_data(find(timeline>=1994 & timeline<=2007))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=1994 & timeline<=2007))-hcm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(h_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=1994 & timeline<=2007))-mean(h_t_data(find(timeline>=1994 & timeline<=2007)))-(hcm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(hcm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), h_t_data(find(timeline>=1994 & timeline<=2007))-mean(h_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(h_t_data(find(timeline>=1994 & timeline<=2007))),6));
rho_px = corr(diff(x_t_data(find(timeline>=1994 & timeline<=2007))-xcm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(x_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=1994 & timeline<=2007))-mean(x_t_data(find(timeline>=1994 & timeline<=2007)))-(xcm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(xcm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), x_t_data(find(timeline>=1994 & timeline<=2007))-mean(x_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(x_t_data(find(timeline>=1994 & timeline<=2007))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=1994 & timeline<=2007))-ccm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(ls_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=1994 & timeline<=2007))-mean(ls_t_data(find(timeline>=1994 & timeline<=2007)))-(ccm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(ccm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), ls_t_data(find(timeline>=1994 & timeline<=2007))-mean(ls_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(ls_t_data(find(timeline>=1994 & timeline<=2007))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{The Great Recession} 2007-2014}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=2007 & timeline<=2014))-ycm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(y_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=2007 & timeline<=2014))-mean(y_t_data(find(timeline>=2007 & timeline<=2014)))-(ycm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(ycm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), y_t_data(find(timeline>=2007 & timeline<=2014))-mean(y_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(y_t_data(find(timeline>=2007 & timeline<=2014))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=2007 & timeline<=2014))-hcm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(h_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=2007 & timeline<=2014))-mean(h_t_data(find(timeline>=2007 & timeline<=2014)))-(hcm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(hcm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), h_t_data(find(timeline>=2007 & timeline<=2014))-mean(h_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(h_t_data(find(timeline>=2007 & timeline<=2014))),6));
rho_px = corr(diff(x_t_data(find(timeline>=2007 & timeline<=2014))-xcm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(x_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=2007 & timeline<=2014))-mean(x_t_data(find(timeline>=2007 & timeline<=2014)))-(xcm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(xcm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), x_t_data(find(timeline>=2007 & timeline<=2014))-mean(x_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(x_t_data(find(timeline>=2007 & timeline<=2014))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=2007 & timeline<=2014))-ccm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(ls_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=2007 & timeline<=2014))-mean(ls_t_data(find(timeline>=2007 & timeline<=2014)))-(ccm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(ccm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), ls_t_data(find(timeline>=2007 & timeline<=2014))-mean(ls_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(ls_t_data(find(timeline>=2007 & timeline<=2014))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline');
   fprintf(fid2,'\n  \\multicolumn{13}{c}{\\textbf{Post‑Great Recession expansion} 2014-2019}		    \\\\');
   fprintf(fid2,'\n \\hline');
rho_py = corr(diff(y_t_data(find(timeline>=2014 & timeline<=2019))-ycm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(y_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
rho_cy = concordance_corr(y_t_data(find(timeline>=2014 & timeline<=2019))-mean(y_t_data(find(timeline>=2014 & timeline<=2019)))-(ycm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(ycm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), y_t_data(find(timeline>=2014 & timeline<=2019))-mean(y_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(y_t_data(find(timeline>=2014 & timeline<=2019))),6));
rho_ph = corr(diff(h_t_data(find(timeline>=2014 & timeline<=2019))-hcm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(h_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
rho_ch = concordance_corr(h_t_data(find(timeline>=2014 & timeline<=2019))-mean(h_t_data(find(timeline>=2014 & timeline<=2019)))-(hcm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(hcm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), h_t_data(find(timeline>=2014 & timeline<=2019))-mean(h_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(h_t_data(find(timeline>=2014 & timeline<=2019))),6));
rho_px = corr(diff(x_t_data(find(timeline>=2014 & timeline<=2019))-xcm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(x_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
rho_cx = concordance_corr(x_t_data(find(timeline>=2014 & timeline<=2019))-mean(x_t_data(find(timeline>=2014 & timeline<=2019)))-(xcm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(xcm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), x_t_data(find(timeline>=2014 & timeline<=2019))-mean(x_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(x_t_data(find(timeline>=2014 & timeline<=2019))),6));
rho_pl = corr(diff(ls_t_data(find(timeline>=2014 & timeline<=2019))-ccm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(ls_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
rho_cl = concordance_corr(ls_t_data(find(timeline>=2014 & timeline<=2019))-mean(ls_t_data(find(timeline>=2014 & timeline<=2019)))-(ccm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(ccm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), ls_t_data(find(timeline>=2014 & timeline<=2019))-mean(ls_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(ls_t_data(find(timeline>=2014 & timeline<=2019))),6));
rho_p=[rho_ph'; rho_py'; rho_px'; rho_pl'];
rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
P=rho_c./sum(rho_c,2);
   fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(1,1) P(1,1) rho_p(1,2)  P(1,2) rho_p(1,3) P(1,3) rho_p(1,6) P(1,6) rho_p(1,4) P(1,4) rho_p(1,5) P(1,5)]');
   fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(2,1) P(2,1) rho_p(2,2)  P(2,2) rho_p(2,3) P(2,3) rho_p(2,6) P(2,6) rho_p(2,4) P(2,4) rho_p(2,5) P(2,5)]');
   fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(3,1) P(3,1) rho_p(3,2)  P(3,2) rho_p(3,3) P(3,3) rho_p(3,6) P(3,6) rho_p(3,4) P(3,4) rho_p(3,5) P(3,5)]');
   fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f \\\\',[rho_p(4,1) P(4,1) rho_p(4,2)  P(4,2) rho_p(4,3) P(4,3) rho_p(4,6) P(4,6) rho_p(4,4) P(4,4) rho_p(4,5) P(4,5)]');
   fprintf(fid2,'\n \\hline\\hline');
   fprintf(fid2,'\n \\end{tabular}');
   fprintf(fid2,'\n \\end{center}');
   fprintf(fid2,'\n \\end{table}');
   fclose(fid2);




% % Table of statistics of components 
%    fid2=fopen("tables/table3stats.tex","w");
%    fprintf(fid2,'\\begin{table}[h]');
%    fprintf(fid2,'\\caption{\\textsc{Statistics.}} \\label{sigma-statistics} \\tiny');
%    fprintf(fid2,'\n \\begin{center}');
%    fprintf(fid2,'\n \\begin{tabular}{lccc>{\\columncolor{mBlue!10}}cccc>{\\columncolor{mBlue!10}}cccc>{\\columncolor{mBlue!10}}cccc>{\\columncolor{mBlue!10}}cccc>{\\columncolor{mBlue!10}}cccc>{\\columncolor{mBlue!10}}c}');
%    fprintf(fid2,'\n \\hline\\hline');
%    fprintf(fid2,'\n \\textbf{Variable} &${\\sigma}_{A}^{\\mathbf{y}}$ &${\\rho}_{p,A}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,A}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{A}^{\\mathbf{y}}$&${\\sigma}_{\\pi_{h}}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{h}}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,\\pi_{h}}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{\\pi_{h}}^{\\mathbf{y}}$ & ${\\sigma}_{\\pi_x}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{x}}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,\\pi_{x}}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{\\pi_{x}}^{\\mathbf{y}}$ & ${\\sigma}_{\\pi_f}^{\\mathbf{y}}$ &${\\rho}_{p,\\pi_{f}}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,\\pi_{f}}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{\\pi_{f}}^{\\mathbf{y}}$&  ${\\sigma}_{\\pi_g}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{g}}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,\\pi_{g}}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{\\pi_{g}}^{\\mathbf{y}}$&  ${\\sigma}_{\\pi_n}^{\\mathbf{y}}$&${\\rho}_{p,\\pi_{n}}^{\\mathbf{\\Delta y}}$ &${\\rho}_{c,\\pi_{n}}^{\\mathbf{\\tilde{y}}}$& $\\mathtt{P}_{\\pi_{n}}^{\\mathbf{y}}$\\\\'); 
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{Entire Sample} }		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(:,1:6)))./sum(1./var(ycm_t(:,1:6)));
% rho_py = corr(diff(y_t_data-ycm_t(:,1:6)), diff(y_t_data), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data-mean(y_t_data)-(ycm_t(:,1:6)-mean(ycm_t(:,1:6),1)), y_t_data-mean(y_t_data).*ones(length(y_t_data),6));
% sgh=(1./var(hcm_t(:,1:6)))./sum(1./var(hcm_t(:,1:6)));
% rho_ph = corr(diff(h_t_data-hcm_t(:,1:6)), diff(h_t_data), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data-mean(h_t_data)-(hcm_t(:,1:6)-mean(hcm_t(:,1:6),1)), h_t_data-mean(h_t_data).*ones(length(h_t_data),6));
% sgx=(1./var(xcm_t(:,1:6)))./sum(1./var(xcm_t(:,1:6)));  
% rho_px = corr(diff(x_t_data-xcm_t(:,1:6)), diff(x_t_data), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data-mean(x_t_data)-(xcm_t(:,1:6)-mean(xcm_t(:,1:6),1)), x_t_data-mean(x_t_data).*ones(length(x_t_data),6));
% sgl=(1./var(ccm_t(:,1:6)))./sum(1./var(ccm_t(:,1:6))); 
% rho_pl = corr(diff(ls_t_data-ccm_t(:,1:6)), diff(ls_t_data), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data-mean(ls_t_data)-(ccm_t(:,1:6)-mean(ccm_t(:,1:6),1)), ls_t_data-mean(ls_t_data).*ones(length(ls_t_data),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The Economic Miracle} 1967-1973}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1967 & timeline<=1973),1:6)))./sum(1./var(ycm_t(find(timeline>=1967 & timeline<=1973),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1967 & timeline<=1973))-ycm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(y_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1967 & timeline<=1973))-mean(y_t_data(find(timeline>=1967 & timeline<=1973)))-(ycm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(ycm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), y_t_data(find(timeline>=1967 & timeline<=1973))-mean(y_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(y_t_data(find(timeline>=1967 & timeline<=1973))),6));
% sgh=(1./var(hcm_t(find(timeline>=1967 & timeline<=1973),1:6)))./sum(1./var(hcm_t(find(timeline>=1967 & timeline<=1973),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1967 & timeline<=1973))-hcm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(h_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1967 & timeline<=1973))-mean(h_t_data(find(timeline>=1967 & timeline<=1973)))-(hcm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(hcm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), h_t_data(find(timeline>=1967 & timeline<=1973))-mean(h_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(h_t_data(find(timeline>=1967 & timeline<=1973))),6));
% sgx=(1./var(xcm_t(find(timeline>=1967 & timeline<=1973),1:6)))./sum(1./var(xcm_t(find(timeline>=1967 & timeline<=1973),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1967 & timeline<=1973))-xcm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(x_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1967 & timeline<=1973))-mean(x_t_data(find(timeline>=1967 & timeline<=1973)))-(xcm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(xcm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), x_t_data(find(timeline>=1967 & timeline<=1973))-mean(x_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(x_t_data(find(timeline>=1967 & timeline<=1973))),6));
% sgl=(1./var(ccm_t(find(timeline>=1967 & timeline<=1973),1:6)))./sum(1./var(ccm_t(find(timeline>=1967 & timeline<=1973),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1967 & timeline<=1973))-ccm_t(find(timeline>=1967 & timeline<=1973),1:6)), diff(ls_t_data(find(timeline>=1967 & timeline<=1973))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1967 & timeline<=1973))-mean(ls_t_data(find(timeline>=1967 & timeline<=1973)))-(ccm_t(find(timeline>=1967 & timeline<=1973),1:6)-mean(ccm_t(find(timeline>=1967 & timeline<=1973),1:6),1)), ls_t_data(find(timeline>=1967 & timeline<=1973))-mean(ls_t_data(find(timeline>=1967 & timeline<=1973))).*ones(length(ls_t_data(find(timeline>=1967 & timeline<=1973))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The Oil Recessions} 1973-1982}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1973 & timeline<=1982),1:6)))./sum(1./var(ycm_t(find(timeline>=1973 & timeline<=1982),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1973 & timeline<=1982))-ycm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(y_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1973 & timeline<=1982))-mean(y_t_data(find(timeline>=1973 & timeline<=1982)))-(ycm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(ycm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), y_t_data(find(timeline>=1973 & timeline<=1982))-mean(y_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(y_t_data(find(timeline>=1973 & timeline<=1982))),6));
% sgh=(1./var(hcm_t(find(timeline>=1973 & timeline<=1982),1:6)))./sum(1./var(hcm_t(find(timeline>=1973 & timeline<=1982),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1973 & timeline<=1982))-hcm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(h_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1973 & timeline<=1982))-mean(h_t_data(find(timeline>=1973 & timeline<=1982)))-(hcm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(hcm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), h_t_data(find(timeline>=1973 & timeline<=1982))-mean(h_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(h_t_data(find(timeline>=1973 & timeline<=1982))),6));
% sgx=(1./var(xcm_t(find(timeline>=1973 & timeline<=1982),1:6)))./sum(1./var(xcm_t(find(timeline>=1973 & timeline<=1982),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1973 & timeline<=1982))-xcm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(x_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1973 & timeline<=1982))-mean(x_t_data(find(timeline>=1973 & timeline<=1982)))-(xcm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(xcm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), x_t_data(find(timeline>=1973 & timeline<=1982))-mean(x_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(x_t_data(find(timeline>=1973 & timeline<=1982))),6));
% sgl=(1./var(ccm_t(find(timeline>=1973 & timeline<=1982),1:6)))./sum(1./var(ccm_t(find(timeline>=1973 & timeline<=1982),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1973 & timeline<=1982))-ccm_t(find(timeline>=1973 & timeline<=1982),1:6)), diff(ls_t_data(find(timeline>=1973 & timeline<=1982))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1973 & timeline<=1982))-mean(ls_t_data(find(timeline>=1973 & timeline<=1982)))-(ccm_t(find(timeline>=1973 & timeline<=1982),1:6)-mean(ccm_t(find(timeline>=1973 & timeline<=1982),1:6),1)), ls_t_data(find(timeline>=1973 & timeline<=1982))-mean(ls_t_data(find(timeline>=1973 & timeline<=1982))).*ones(length(ls_t_data(find(timeline>=1973 & timeline<=1982))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The Industrial Reestructuring} 1982-1986 }		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1982 & timeline<=1986),1:6)))./sum(1./var(ycm_t(find(timeline>=1982 & timeline<=1986),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1982 & timeline<=1986))-ycm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(y_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1982 & timeline<=1986))-mean(y_t_data(find(timeline>=1982 & timeline<=1986)))-(ycm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(ycm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), y_t_data(find(timeline>=1982 & timeline<=1986))-mean(y_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(y_t_data(find(timeline>=1982 & timeline<=1986))),6));
% sgh=(1./var(hcm_t(find(timeline>=1982 & timeline<=1986),1:6)))./sum(1./var(hcm_t(find(timeline>=1982 & timeline<=1986),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1982 & timeline<=1986))-hcm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(h_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1982 & timeline<=1986))-mean(h_t_data(find(timeline>=1982 & timeline<=1986)))-(hcm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(hcm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), h_t_data(find(timeline>=1982 & timeline<=1986))-mean(h_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(h_t_data(find(timeline>=1982 & timeline<=1986))),6));
% sgx=(1./var(xcm_t(find(timeline>=1982 & timeline<=1986),1:6)))./sum(1./var(xcm_t(find(timeline>=1982 & timeline<=1986),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1982 & timeline<=1986))-xcm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(x_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1982 & timeline<=1986))-mean(x_t_data(find(timeline>=1982 & timeline<=1986)))-(xcm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(xcm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), x_t_data(find(timeline>=1982 & timeline<=1986))-mean(x_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(x_t_data(find(timeline>=1982 & timeline<=1986))),6));
% sgl=(1./var(ccm_t(find(timeline>=1982 & timeline<=1986),1:6)))./sum(1./var(ccm_t(find(timeline>=1982 & timeline<=1986),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1982 & timeline<=1986))-ccm_t(find(timeline>=1982 & timeline<=1986),1:6)), diff(ls_t_data(find(timeline>=1982 & timeline<=1986))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1982 & timeline<=1986))-mean(ls_t_data(find(timeline>=1982 & timeline<=1986)))-(ccm_t(find(timeline>=1982 & timeline<=1986),1:6)-mean(ccm_t(find(timeline>=1982 & timeline<=1986),1:6),1)), ls_t_data(find(timeline>=1982 & timeline<=1986))-mean(ls_t_data(find(timeline>=1982 & timeline<=1986))).*ones(length(ls_t_data(find(timeline>=1982 & timeline<=1986))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The European Integration} 1986-1991}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1986 & timeline<=1991),1:6)))./sum(1./var(ycm_t(find(timeline>=1986 & timeline<=1991),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1986 & timeline<=1991))-ycm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(y_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1986 & timeline<=1991))-mean(y_t_data(find(timeline>=1986 & timeline<=1991)))-(ycm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(ycm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), y_t_data(find(timeline>=1986 & timeline<=1991))-mean(y_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(y_t_data(find(timeline>=1986 & timeline<=1991))),6));
% sgh=(1./var(hcm_t(find(timeline>=1986 & timeline<=1991),1:6)))./sum(1./var(hcm_t(find(timeline>=1986 & timeline<=1991),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1986 & timeline<=1991))-hcm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(h_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1986 & timeline<=1991))-mean(h_t_data(find(timeline>=1986 & timeline<=1991)))-(hcm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(hcm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), h_t_data(find(timeline>=1986 & timeline<=1991))-mean(h_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(h_t_data(find(timeline>=1986 & timeline<=1991))),6));
% sgx=(1./var(xcm_t(find(timeline>=1986 & timeline<=1991),1:6)))./sum(1./var(xcm_t(find(timeline>=1986 & timeline<=1991),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1986 & timeline<=1991))-xcm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(x_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1986 & timeline<=1991))-mean(x_t_data(find(timeline>=1986 & timeline<=1991)))-(xcm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(xcm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), x_t_data(find(timeline>=1986 & timeline<=1991))-mean(x_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(x_t_data(find(timeline>=1986 & timeline<=1991))),6));
% sgl=(1./var(ccm_t(find(timeline>=1986 & timeline<=1991),1:6)))./sum(1./var(ccm_t(find(timeline>=1986 & timeline<=1991),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1986 & timeline<=1991))-ccm_t(find(timeline>=1986 & timeline<=1991),1:6)), diff(ls_t_data(find(timeline>=1986 & timeline<=1991))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1986 & timeline<=1991))-mean(ls_t_data(find(timeline>=1986 & timeline<=1991)))-(ccm_t(find(timeline>=1986 & timeline<=1991),1:6)-mean(ccm_t(find(timeline>=1986 & timeline<=1991),1:6),1)), ls_t_data(find(timeline>=1986 & timeline<=1991))-mean(ls_t_data(find(timeline>=1986 & timeline<=1991))).*ones(length(ls_t_data(find(timeline>=1986 & timeline<=1991))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The European Crisis} 1991-1994}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1991 & timeline<=1994),1:6)))./sum(1./var(ycm_t(find(timeline>=1991 & timeline<=1994),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1991 & timeline<=1994))-ycm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(y_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1991 & timeline<=1994))-mean(y_t_data(find(timeline>=1991 & timeline<=1994)))-(ycm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(ycm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), y_t_data(find(timeline>=1991 & timeline<=1994))-mean(y_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(y_t_data(find(timeline>=1991 & timeline<=1994))),6));
% sgh=(1./var(hcm_t(find(timeline>=1991 & timeline<=1994),1:6)))./sum(1./var(hcm_t(find(timeline>=1991 & timeline<=1994),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1991 & timeline<=1994))-hcm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(h_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1991 & timeline<=1994))-mean(h_t_data(find(timeline>=1991 & timeline<=1994)))-(hcm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(hcm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), h_t_data(find(timeline>=1991 & timeline<=1994))-mean(h_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(h_t_data(find(timeline>=1991 & timeline<=1994))),6));
% sgx=(1./var(xcm_t(find(timeline>=1991 & timeline<=1994),1:6)))./sum(1./var(xcm_t(find(timeline>=1991 & timeline<=1994),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1991 & timeline<=1994))-xcm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(x_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1991 & timeline<=1994))-mean(x_t_data(find(timeline>=1991 & timeline<=1994)))-(xcm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(xcm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), x_t_data(find(timeline>=1991 & timeline<=1994))-mean(x_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(x_t_data(find(timeline>=1991 & timeline<=1994))),6));
% sgl=(1./var(ccm_t(find(timeline>=1991 & timeline<=1994),1:6)))./sum(1./var(ccm_t(find(timeline>=1991 & timeline<=1994),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1991 & timeline<=1994))-ccm_t(find(timeline>=1991 & timeline<=1994),1:6)), diff(ls_t_data(find(timeline>=1991 & timeline<=1994))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1991 & timeline<=1994))-mean(ls_t_data(find(timeline>=1991 & timeline<=1994)))-(ccm_t(find(timeline>=1991 & timeline<=1994),1:6)-mean(ccm_t(find(timeline>=1991 & timeline<=1994),1:6),1)), ls_t_data(find(timeline>=1991 & timeline<=1994))-mean(ls_t_data(find(timeline>=1991 & timeline<=1994))).*ones(length(ls_t_data(find(timeline>=1991 & timeline<=1994))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The Pre‑Great Recession Expansion} 1994-2007}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=1994 & timeline<=2007),1:6)))./sum(1./var(ycm_t(find(timeline>=1994 & timeline<=2007),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=1994 & timeline<=2007))-ycm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(y_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=1994 & timeline<=2007))-mean(y_t_data(find(timeline>=1994 & timeline<=2007)))-(ycm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(ycm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), y_t_data(find(timeline>=1994 & timeline<=2007))-mean(y_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(y_t_data(find(timeline>=1994 & timeline<=2007))),6));
% sgh=(1./var(hcm_t(find(timeline>=1994 & timeline<=2007),1:6)))./sum(1./var(hcm_t(find(timeline>=1994 & timeline<=2007),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=1994 & timeline<=2007))-hcm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(h_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=1994 & timeline<=2007))-mean(h_t_data(find(timeline>=1994 & timeline<=2007)))-(hcm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(hcm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), h_t_data(find(timeline>=1994 & timeline<=2007))-mean(h_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(h_t_data(find(timeline>=1994 & timeline<=2007))),6));
% sgx=(1./var(xcm_t(find(timeline>=1994 & timeline<=2007),1:6)))./sum(1./var(xcm_t(find(timeline>=1994 & timeline<=2007),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=1994 & timeline<=2007))-xcm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(x_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=1994 & timeline<=2007))-mean(x_t_data(find(timeline>=1994 & timeline<=2007)))-(xcm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(xcm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), x_t_data(find(timeline>=1994 & timeline<=2007))-mean(x_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(x_t_data(find(timeline>=1994 & timeline<=2007))),6));
% sgl=(1./var(ccm_t(find(timeline>=1994 & timeline<=2007),1:6)))./sum(1./var(ccm_t(find(timeline>=1994 & timeline<=2007),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=1994 & timeline<=2007))-ccm_t(find(timeline>=1994 & timeline<=2007),1:6)), diff(ls_t_data(find(timeline>=1994 & timeline<=2007))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=1994 & timeline<=2007))-mean(ls_t_data(find(timeline>=1994 & timeline<=2007)))-(ccm_t(find(timeline>=1994 & timeline<=2007),1:6)-mean(ccm_t(find(timeline>=1994 & timeline<=2007),1:6),1)), ls_t_data(find(timeline>=1994 & timeline<=2007))-mean(ls_t_data(find(timeline>=1994 & timeline<=2007))).*ones(length(ls_t_data(find(timeline>=1994 & timeline<=2007))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{The Great Recession} 2007-2014}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=2007 & timeline<=2014),1:6)))./sum(1./var(ycm_t(find(timeline>=2007 & timeline<=2014),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=2007 & timeline<=2014))-ycm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(y_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=2007 & timeline<=2014))-mean(y_t_data(find(timeline>=2007 & timeline<=2014)))-(ycm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(ycm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), y_t_data(find(timeline>=2007 & timeline<=2014))-mean(y_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(y_t_data(find(timeline>=2007 & timeline<=2014))),6));
% sgh=(1./var(hcm_t(find(timeline>=2007 & timeline<=2014),1:6)))./sum(1./var(hcm_t(find(timeline>=2007 & timeline<=2014),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=2007 & timeline<=2014))-hcm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(h_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=2007 & timeline<=2014))-mean(h_t_data(find(timeline>=2007 & timeline<=2014)))-(hcm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(hcm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), h_t_data(find(timeline>=2007 & timeline<=2014))-mean(h_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(h_t_data(find(timeline>=2007 & timeline<=2014))),6));
% sgx=(1./var(xcm_t(find(timeline>=2007 & timeline<=2014),1:6)))./sum(1./var(xcm_t(find(timeline>=2007 & timeline<=2014),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=2007 & timeline<=2014))-xcm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(x_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=2007 & timeline<=2014))-mean(x_t_data(find(timeline>=2007 & timeline<=2014)))-(xcm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(xcm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), x_t_data(find(timeline>=2007 & timeline<=2014))-mean(x_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(x_t_data(find(timeline>=2007 & timeline<=2014))),6));
% sgl=(1./var(ccm_t(find(timeline>=2007 & timeline<=2014),1:6)))./sum(1./var(ccm_t(find(timeline>=2007 & timeline<=2014),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=2007 & timeline<=2014))-ccm_t(find(timeline>=2007 & timeline<=2014),1:6)), diff(ls_t_data(find(timeline>=2007 & timeline<=2014))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=2007 & timeline<=2014))-mean(ls_t_data(find(timeline>=2007 & timeline<=2014)))-(ccm_t(find(timeline>=2007 & timeline<=2014),1:6)-mean(ccm_t(find(timeline>=2007 & timeline<=2014),1:6),1)), ls_t_data(find(timeline>=2007 & timeline<=2014))-mean(ls_t_data(find(timeline>=2007 & timeline<=2014))).*ones(length(ls_t_data(find(timeline>=2007 & timeline<=2014))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline');
%    fprintf(fid2,'\n  \\multicolumn{25}{c}{\\textbf{Post‑Great Recession expansion} 2014-2019}		    \\\\');
%    fprintf(fid2,'\n \\hline');
% sgy    = (1./var(ycm_t(find(timeline>=2014 & timeline<=2019),1:6)))./sum(1./var(ycm_t(find(timeline>=2014 & timeline<=2019),1:6)));
% rho_py = corr(diff(y_t_data(find(timeline>=2014 & timeline<=2019))-ycm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(y_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
% rho_cy = concordance_corr(y_t_data(find(timeline>=2014 & timeline<=2019))-mean(y_t_data(find(timeline>=2014 & timeline<=2019)))-(ycm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(ycm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), y_t_data(find(timeline>=2014 & timeline<=2019))-mean(y_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(y_t_data(find(timeline>=2014 & timeline<=2019))),6));
% sgh=(1./var(hcm_t(find(timeline>=2014 & timeline<=2019),1:6)))./sum(1./var(hcm_t(find(timeline>=2014 & timeline<=2019),1:6)));
% rho_ph = corr(diff(h_t_data(find(timeline>=2014 & timeline<=2019))-hcm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(h_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
% rho_ch = concordance_corr(h_t_data(find(timeline>=2014 & timeline<=2019))-mean(h_t_data(find(timeline>=2014 & timeline<=2019)))-(hcm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(hcm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), h_t_data(find(timeline>=2014 & timeline<=2019))-mean(h_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(h_t_data(find(timeline>=2014 & timeline<=2019))),6));
% sgx=(1./var(xcm_t(find(timeline>=2014 & timeline<=2019),1:6)))./sum(1./var(xcm_t(find(timeline>=2014 & timeline<=2019),1:6)));  
% rho_px = corr(diff(x_t_data(find(timeline>=2014 & timeline<=2019))-xcm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(x_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
% rho_cx = concordance_corr(x_t_data(find(timeline>=2014 & timeline<=2019))-mean(x_t_data(find(timeline>=2014 & timeline<=2019)))-(xcm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(xcm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), x_t_data(find(timeline>=2014 & timeline<=2019))-mean(x_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(x_t_data(find(timeline>=2014 & timeline<=2019))),6));
% sgl=(1./var(ccm_t(find(timeline>=2014 & timeline<=2019),1:6)))./sum(1./var(ccm_t(find(timeline>=2014 & timeline<=2019),1:6))); 
% rho_pl = corr(diff(ls_t_data(find(timeline>=2014 & timeline<=2019))-ccm_t(find(timeline>=2014 & timeline<=2019),1:6)), diff(ls_t_data(find(timeline>=2014 & timeline<=2019))), 'Type', 'Pearson');
% rho_cl = concordance_corr(ls_t_data(find(timeline>=2014 & timeline<=2019))-mean(ls_t_data(find(timeline>=2014 & timeline<=2019)))-(ccm_t(find(timeline>=2014 & timeline<=2019),1:6)-mean(ccm_t(find(timeline>=2014 & timeline<=2019),1:6),1)), ls_t_data(find(timeline>=2014 & timeline<=2019))-mean(ls_t_data(find(timeline>=2014 & timeline<=2019))).*ones(length(ls_t_data(find(timeline>=2014 & timeline<=2019))),6));
% rho_p=[(1+rho_ph')/2; (1+rho_py')/2; (1+rho_px')/2; (1+rho_pl')/2];
% rho_c=[(1+rho_ch)/2; (1+rho_cy)/2; (1+rho_cx)/2; (1+rho_cl)/2];
% P=(rho_p.*rho_c)./sum(rho_p.*rho_c,2);
% sg=[sgh;sgy;sgx;sgl];
%    fprintf(fid2,'\n  $l$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(1,1) rho_p(1,1) rho_c(1,1) P(1,1) sg(1,2) rho_p(1,2) rho_c(1,2) P(1,2) sg(1,3) rho_p(1,3) rho_c(1,3) P(1,3) sg(1,6) rho_p(1,6) rho_c(1,6) P(1,6) sg(1,4) rho_p(1,4) rho_c(1,4) P(1,4) sg(1,5) rho_p(1,5) rho_c(1,5) P(1,5)]');
%    fprintf(fid2,'\n  $y$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(2,1) rho_p(2,1) rho_c(2,1) P(2,1) sg(2,2) rho_p(2,2) rho_c(2,2) P(2,2) sg(2,3) rho_p(2,3) rho_c(2,3) P(2,3) sg(2,6) rho_p(2,6) rho_c(2,6) P(2,6) sg(2,4) rho_p(2,4) rho_c(2,4) P(2,4) sg(2,5) rho_p(2,5) rho_c(2,5) P(2,5)]');
%    fprintf(fid2,'\n  $x$    & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(3,1) rho_p(3,1) rho_c(3,1) P(3,1) sg(3,2) rho_p(3,2) rho_c(3,2) P(3,2) sg(3,3) rho_p(3,3) rho_c(3,3) P(3,3) sg(3,6) rho_p(3,6) rho_c(3,6) P(3,6) sg(3,4) rho_p(3,4) rho_c(3,4) P(3,4) sg(3,5) rho_p(3,5) rho_c(3,5) P(3,5)]');
%    fprintf(fid2,'\n  $s_l$  & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f & %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f	& %8.3f     & %8.3f	& %8.3f\\\\',[sg(4,1) rho_p(4,1) rho_c(4,1) P(4,1) sg(4,2) rho_p(4,2) rho_c(4,2) P(4,2) sg(4,3) rho_p(4,3) rho_c(4,3) P(4,3) sg(4,6) rho_p(4,6) rho_c(4,6) P(4,6) sg(4,4) rho_p(4,4) rho_c(4,4) P(4,4) sg(4,5) rho_p(4,5) rho_c(4,5) P(4,5)]');
%    fprintf(fid2,'\n \\hline\\hline');
%    fprintf(fid2,'\n \\end{tabular}');
%    fprintf(fid2,'\n \\end{center}');
%    fprintf(fid2,'\n \\end{table}');
%    fclose(fid2);






