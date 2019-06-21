run('biomass.m')
run('wind_speed.m')
run('irradiance_temp.m')

%%%% graph for electrical demand %%%%

demand_unmodified= csvread('gridwatch.csv',0,2,[0,2,287,2]); 

demand= repelem(demand_unmodified,5)*1*10^9*1*10^-4;

demand_electricity= repelem(demand_unmodified,5)*1*10^9*0.264*1*10^-4;
t=1:length(demand_electricity);

figure
plot(t/1440,demand/10^6)
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power/ MW','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'demand.eps',style);

figure
plot(t/1440,demand_electricity/10^6)
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power/ MW','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'demand_electricity.eps',style);


eff_solar= 0.201;        % efficiency of solar PV

eff_wind= 0.8;  % efficinecy of wind tubrine


%%%% Total Electrical supply %%%%
figure
P_den_total= (eff_solar * P_max) + (eff_wind*P_den_max);
plot(t/1440,P_den_total)
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power density/ Wm\textsuperscript{-2}','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'P_den_total.eps',style);

%%%% Area required %%%% 
    
E_supply=trapz(t,P_den_total);
E_demand=trapz(t,demand_electricity);

area_needed= E_demand/E_supply;
P_total= area_needed*P_den_total;


%%%% graph for electricity supply and demand %%%%

figure
plot(t/1440,demand_electricity/10^6);
hold on
plot(t/1440,P_total/10^6)
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power demand/ MW','Interpreter', 'Latex','FontSize',18);
legend('demand','supply')
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'supply_vs_demand_electricity.eps',style);

%%%% electrcity storage %%%%

for i=1:length(demand_electricity)
        if P_total(i)>demand_electricity(i)
           P_storage(i)=P_total(i)-demand_electricity(i);
        else
            P_storage(i)=0;
        end
end

for i=1:length(demand_electricity)
        if P_total(i)<demand_electricity(i)
           P_depletion(i)=P_total(i)-demand_electricity(i);
        else
            P_depletion(i)=0;
        end
end



figure
plot(t/1440,P_storage/10^6)
hold on
plot(t/1440,P_depletion/10^6)
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power Stored/ MW','Interpreter', 'Latex','FontSize',18);
legend('surplus','penury')
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'power_stored.eps',style);  


%%%% Heat supply ****

cal_value=21.7*10^6;
P_heat= I_v10* cal_value;


%%%% graph for heat demand %%%% 

demand_heat= repelem(demand_unmodified,5)*1*10^9*0.405*1*10^-4;
figure
plot(t/1440,demand_heat/10^6);
hold on
plot(t/1440,P_heat/10^6);
datetick('x','HH:MM')
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Power demand/ MW','Interpreter', 'Latex','FontSize',18);
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
ylim([0 1600])
legend('heat demand','heat supply')
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'demand_heat.eps',style);  

