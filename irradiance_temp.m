% irradiance from simulation in W\m^2
G = csvread('matlab_import.csv',0,5,[0,5,1439,5]);  

% temperature from met office
temperature= csvread('matlab_import.csv',0,7,[0,7,1439,7]);  

T=temperature+273.15; 


%%%% Inputs %%%%

width_pv=1.559; 
length_pv= 1.046;
I_do=0.766e-6;      % diode reversal current
T_n=25+273.15;      % nominal temperature
q=1.602e-19;        % electron charge 
ef=856.9;           % diode emission factor
k=1.3806503e-23;    % Boltzmann constant
I_pv_n=6.466;        % current at nominal condition
K_i=3.5e-3;         % short-circuit current/temperature coefficient 
dT= T-T_n;          % T - T_n
G_n= 1000;          % nominal irradiance 
R_p=262.03;         % parallel resistance in an equivalent circuit     
N_s= 8*12;          % number of cells in an array 
n_i=0.958383;       % usual ideality constant 
V_mp= 54.7;         % maximum voltage point 
I_mp= 5.98;         % maximum current point 
Area= 39.5*10;      % area under IV curve @ 1000 W/m^2 
V_oc= 64.9;         % open circuit voltage
I_sc= 6.46;         % short circuit current 

%%%% Macro model %%%%
area_panel= width_pv*length_pv;

Eg= N_s*(1.16-7.02e-4*((T.*T)./(T-1108)));

alpha= N_s*n_i*k*T/q; 

R_s= 2*( (V_oc/I_sc) - (Area/(I_sc^2)) - ((k*T)/(q*I_sc)));

V_t= N_s*k*T/q;     % Thermal voltage


Io= I_do*((T/T_n).^3).*exp(((q*Eg)/(ef*k)).*((1./T_n)-(1./T)));


I_pv= (I_pv_n + (K_i* dT)).*G/G_n;


P_max= (V_mp *(I_pv - Io.*(exp((q*(V_mp + R_s*I_mp))./(k*T.*alpha*N_s)) -1)...
      - (V_mp + (R_s*I_mp))/(R_p)) )/area_panel;

%%%% Micro model %%%%

n = 60;   % average every 60 units


avg_irradiance_per_hour = arrayfun(@(i) mean(G(i:i+n-1)),...
    1:n:length(G)-n+1)'; % average sun per hour


avg_temp_per_hour = arrayfun(@(i) mean(T(i:i+n-1)),...
    1:n:length(T)-n+1)';  % average temperature per hour



t= (1:1440)';
t_power= 1:length(P_max);


  
  
%%%% graphs %%%%


plot(t_power/1440,G);
datetick('x','HH:MM');
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',16);
ylabel('Irradiance/Wm\textsuperscript{-2}','Interpreter', 'Latex','FontSize',16);
set(gca,'fontsize',16)
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'sun.eps',style);

figure

% Plot graph for temperature

p = polyfit(t/1440,temperature,3);
avg_temp_per_hour_2 = polyval(p,t/1440);
plot(t/1440,temperature,'.',t/1440,avg_temp_per_hour_2,'MarkerSize',8,'linewidth',1)
ylim([10 22])
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',16);
ylabel('Temperature /$^{\circ}$C','Interpreter', 'Latex','FontSize',16);
legend('data point','line of best fit')
datetick('x','HH:MM');
set(gca,'fontsize',16);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'temp.eps',style);

figure

% plot graph for power density
plot(P_max);
plot(t_power/1440,P_max);
datetick('x','HH:MM');
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power density/ Wm\textsuperscript{-2}','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'power_density_svp.eps',style);  


%%%% Micro-model %%%%

figure
plot(current,'LineWidth',2)
ylim([200 210])
title('')
ylabel('Current / A','Interpreter', 'Latex','FontSize',18);
xlabel('Time/ s','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'micromodel_svp_current.eps',style);

figure

plot(voltage)
ylim([400 410])
set(gca,'fontsize',13)
title('')
xlabel('Time/ s','Interpreter', 'Latex','FontSize',18);
ylabel('Voltage / V','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'micromodel_svp_voltage.eps',style);
