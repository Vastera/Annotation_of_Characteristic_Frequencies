%f_ps=50.0425;% the generated power frequency
%c_s=f_ps/6;% sun gear frequency coefficients
%%%%%%%%% frequency calculation %%%%%%%%%%%
f_s=mean(abs(v0));% sun gear frequency
Z_s=36;Z_p=35;Z_r=108;D_roller=0.0035;D_pitch=0.0195;N_roller=10;
[f_c,f_p_s,f_i,f_o,f_cg,f_b,f_m,f_sf,f_pf,f_rf] = CharacteristicFreq(f_s,Z_s,Z_p,Z_r,4,D_roller,D_pitch,N_roller);
 

Fault_Type='Outer';% Baseline, Outer, RE, Inner
Spectrum_Type='Envelope'; % in the case with gear meshing, only 'Orignianl' is used
switch Fault_Type
    case 'Baseline'
        if strcmpi(Spectrum_Type,'Original')
%% Baseline Original
f_string={'f_ps','f_c','f_s'};
eval(gene_name_value(f_string))
err=1*10^(-1);
N_max=[2,15,10]; 
weight_Coef=[2,2,1]*3;%the bigger them are, the more important the error is!!
        elseif strcmpi(Spectrum_Type,'Envelope')
%% Baseline Envelope or Frequency Demodulation
f_string={'f_ps','f_c','f_s'};
eval(gene_name_value(f_string))
err=2*10^(-1);
N_max=[2,15,10]; 
weight_Coef=[2,2,1]*3;
        end
       case 'Outer'
            if strcmpi(Spectrum_Type,'Original')
%% Outer Original
f_string={'f_ps','f_p_s','f_o','f_c','f_s'};
eval(gene_name_value(f_string))
err=5*10^(-1);
N_max=[2,10,10,10,4];
weight_Coef=[5,1,3,1,1]*0.5;%the bigger them are, the more important the error is!!
            elseif strcmpi(Spectrum_Type,'Envelope')
%% Outer Envelope or Frequency Demodulation
f_string={'f_o','f_p_s','f_c','f_s'};
eval(gene_name_value(f_string))
err=8*10^(-1);
N_max=[10,10,10,4];
weight_Coef=[1,1,1,1]*0.5;%the bigger them are, the more important the error is!!
            end
        case 'RE'
            if strcmpi(Spectrum_Type,'Original')
%% RE Original
f_string={'f_ps','f_s','f_b','f_cg','f_c'};
eval(gene_name_value(f_string))
err=1*10^(-1.5);
N_max=[2,10,10,10,10];
weight_Coef=[2,1,2,2,2]*0.5;% the bigger them are, the more important the error is!!
            elseif strcmpi(Spectrum_Type,'Envelope')
%% RE Envelope or Frequency Demodulation
f_string={'f_b','f_cg','f_c','f_s'};
eval(gene_name_value(f_string))
err=2*10^(-1.5);
N_max=[10,10,10,3];
weight_Coef=[1,1,1,1]*0.5;% the bigger them are, the more important the error is!!
            end
        case 'Inner'
            if strcmpi(Spectrum_Type,'Original')
%% Inner Original
f_string=['f_ps','f_s','f_i','f_c'];
eval(gene_name_value(f_string))
err=10*10^(-1);
N_max=[2,10,3,10];
weight_Coef=[1,1,5,1]*0.5;%the bigger them are, the more important the error is!!
             elseif strcmpi(Spectrum_Type,'Envelope')
%% Inner Envelope or Frequency Demodulation
f_string={'f_i','f_s','f_c'};
eval(gene_name_value(f_string))
err=1*10^(-1.5);
N_max=[10,10,10];
weight_Coef=[2,1,1]*0.5;%the bigger them are, the more important the error is!!
            end
    case 'All faults'
 f_string={'f_ps','f_o','f_i','f_b','f_s','f_c'}; 
 eval(gene_name_value(f_string))
err=1*10^(-1);
N_max=[10,3,3,3,10,10];
weight_Coef=[3,3,3,3,1,1]*0.5;%the bigger them are, the more important the error is!!
end
%% -----------get cursor location 
[Coef,simi]=peak_pick(f_can,f_name,err,N_max,weight_Coef);

%% ---------support function ---------------
function surrogate_string=gene_name_value(f_string)
Freq_Dic=struct('f_c','f_{\rm c}','f_m','f_{\rm m}','f_ps','f_{\rm g}','f_s', ...
    'f^{\rm (r)}_{\rm s}','f_i','f_{\rm i}','f_o','f_{\rm o}','f_p_s','f^{\rm (s)}_{\rm o}', ...
    'f_cg','f_{\rm cg}','f_b','f_{\rm e}','f_n','f_{\rm n}');
f_can_string='f_can=[';% to be executed later on to generate the values of frequency candidates
f_name_string='f_name={';% to be executed later on to generate the names of frequency candidates
index=1;
for candidate=f_string
    f_can_string=[f_can_string,f_string{index},','];
    index=index+1;
    f_name_string=[f_name_string,'''',eval(['Freq_Dic.',candidate{1}]),'''',','];
end
f_can_string(end)='';f_can_string=[f_can_string,'];'];%the generation code of frequency candidates' values
f_name_string(end)='';f_name_string=[f_name_string,'};'];%generation code of frequency candidates' names
surrogate_string=[f_can_string,f_name_string];
end

function [f_c,f_p_s,f_i,f_o,f_cg,f_b,f_m,f_sf,f_pf,f_rf] = CharacteristicFreq(f_s,Z_s,Z_p,Z_r,N_planet,D_roller,D_pitch,N_roller)
%%%%%%%%%%%%%%%%%%Input arguments %%%%%%%%%%%%%%%%%%%%%
% f_s: sun gear rotating frequency
% Z_s: sun gear tooth
% Z_p: planet tooth
% Z_r: ring gear tooth
% N_planet: planet amount
% D_roller: diameter of planet bearing roller
% D_pitch: diameter of bearing pitch
% N_roller: roller amount
%%%%%%%%%%%%%%%%%Output argments %%%%%%%%%%%%%%%%%%%%%%%
% f_c: frequency of carrier
% f_p_s: planet spinning frequency
% f_i: characteristic frequency of inner race fault
% f_o: characteristic frequency of outer race fault
% f_cg: roller spinning frequency
% f_b: characteristic frequency of roller fault
% f_m: meshing frequency
% f_sf: sun gear fault
% f_pf: planet fault
% f_rf: ring gear fault
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Contact_Angle =0;% contact angle of bearing rollers
f_c=f_s*Z_s/(Z_s+Z_r);
f_m=f_c*Z_r;
f_p_s=Z_r/Z_p*f_c;
f_i=N_roller/2*(1+D_roller/D_pitch*cos(Contact_Angle))*f_p_s;
f_o=N_roller*(1-0.5*(1+D_roller/D_pitch*cos(Contact_Angle)))*f_p_s;
f_b=0.5*D_pitch/D_roller*(1-(D_roller/D_pitch)^2*(cos(Contact_Angle))^2)*f_p_s;
f_cg=0.5*(1+D_roller/D_pitch*cos(Contact_Angle))*f_p_s;
f_sf=N_planet*(f_s-f_c);
f_pf=f_m/Z_p;
f_rf=f_m/Z_r*N_planet;
end