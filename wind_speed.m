%%%% data input %%%%

v_unmodified = csvread('wind_speed.csv',1,1,[1,1,24,1]);   % wind speed
v=repelem(v_unmodified,60);

a=(1:24)';



%%%%% variables %%%%%


rho= 1.2;    % Density of the air


%%%%%  Macro model %%%%
P_den_max= 2 * rho * 3.14159 * v.^3/ 675;
t_power= 1:length(P_den_max);

%%%%% graphs %%%%
figure
plot(t_power/1440,P_den_max);
datetick('x','HH:MM');
set(gca,'fontsize',13)
ylim([0 5]);
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power density/ Wm\textsuperscript{-2}','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'power_density_wind.eps',style);  

figure         
p = polyfit(a/24,v_unmodified,3);
v_2 = polyval(p,a/24);
plot(a/24,v_unmodified,'.',a/24,v_2,'MarkerSize',16,'linewidth',2);
datetick('x','HH:MM');
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',16);
ylabel('Wind speed /ms\textsuperscript{-1}','Interpreter', 'Latex','FontSize',16);
legend('data point','line of best fit')
set(gca,'fontsize',16); 
set(gcf,'color','w');
ylim([3 9]);
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'wind.eps',style);


%%%% Micro-model %%%%

figure
plot(current_output)
title('')
xlabel('time/s','Interpreter', 'Latex','FontSize',16);
ylabel('Current / A','Interpreter', 'Latex','FontSize',16);
set(gca,'fontsize',16); 
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'current_output_simulink_wind.eps',style);
figure
plot(voltage_output)
title('')
xlabel('time/s','Interpreter', 'Latex','FontSize',16);
ylabel('Voltage / V','Interpreter', 'Latex','FontSize',16);
set(gca,'fontsize',16); 
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'voltage_output_simulink_wind.eps',style);
