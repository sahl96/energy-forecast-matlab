%%%% constant inputs %%%%
m=(0.01/100)*15000*10^6/365; 
density_volatile= 853;

t1=25+273.15;
rho1 = 1.2;                       
cp1 = 1005;

m_h2o= 0.327*m/(24*3600);
dry_fraction= (1-0.327)*m;
cp_h2o = 4180;

cp_prch = 119.8;                   
m_prch = dry_fraction * 0.959/(24*3600);
h = 39180;
i_v_pl= (m_prch/density_volatile);


ks = 300;     % exchange coefficient                      
s= 1.24;      % surface area 

t10=400+273.15;
d10=diff(t10);
t20=randi([400 500],1440,1);

V1=1.06;
i_v1=0.375;


%%%% Macro scale model %%%%  

 I_v10=  1/(V1*t10) *(i_v1.*t1...
    - (ks*s)*(t10-t20)/(rho1*cp1)...
    + ( m_h2o*t20*cp_h2o)/(rho1*cp1) ...
    + (m_prch*t20* cp_prch)/(rho1 * cp1)...
    + (i_v_pl * h)/(rho1 * cp1));




%%%% graph %%%%

t_biomass=1:length(I_v10);
plot(t_biomass/1440,I_v10);
datetick('x','HH:MM');
set(gca,'fontsize',13)
xlabel('Hour of the day','Interpreter', 'Latex','FontSize',18);
ylabel('Biogas flow rate /m\textsuperscript{3}s\textsuperscript{-1}','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'biomass.eps',style);

%%%% Micro scale model graph %%%%     
figure
plot(biogas_output,'LineWidth',2)
ylim([0 1])
set(gca,'fontsize',13)
title('')
xlabel('time/ s','Interpreter', 'Latex','FontSize',18);
ylabel('Biogas flow rate /m\textsuperscript{3}s\textsuperscript{-1}','Interpreter', 'Latex','FontSize',18);
set(gcf,'color','w');
style = hgexport('factorystyle');
%style.Color = 'gray';
hgexport(gcf,'biogas_simulink.eps',style);
