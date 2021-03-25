f_s=25;% sun gear frequency
f_c=0.123809524*f_s;% carrier frequency
f_m=11.39047619*f_s;% meshing frequency


%%%%%%%% Original Calculation %%%%%%%%%
f_p_s=0.17593985*f_s;% planet spinning frequency

% f_p_r=0.17593985;% planet revolution frequency
f_i=1.09962406*f_s;% planet bearing inner race frequency 
f_o=0.659774436*f_s;% planet bearing outer race frequency
f_b=0.329887218*f_s;% planet bearing rolling element frequency
f_cg=0.109962406*f_s;% planet bearing cage spinning frequency

%%%%%%%%% readjust calculation %%%%%%%%%%%
% f_p_s=0.299749373*f_s;% planet spinning frequency
% 
% % f_p_r=0.17593985;% planet revolution frequency
% f_i=1.873433584*f_s;% planet bearing inner race frequency 
% f_o=1.12406015*f_s;% planet bearing outer race frequency
% f_b=0.562030075*f_s;% planet bearing rolling element frequency
% f_cg=0.187343358*f_s;% planet bearing cage spinning frequency

Fault_Type='Outer';
Spectrum_Type='Envelope';
switch Fault_Type
    case 'Baseline'
        if strcmp(Spectrum_Type,'Original')
%% Baseline Original
f_n=234.3;
f_can=[f_n,f_s,f_c];
f_name={'{\it f}_{\rm n}','{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm c}'};
err=1*10^(-1.5);
N_max=[1,5,15,15]; 
        elseif strcmp(Spectrum_Type,'Envelope')
%% Baseline Envelope or Frequency Demodulation
f_can=[f_s,f_p_s,f_c];
f_name={'{\it f}^{\rm (r)}_{\rm s}','{\it f}^{\rm (s)}_{\rm o}','{\it f}_{\rm c}'};
err=1*10^(-1);
N_max=[10,10,10]; 
        end
        case 'Outer'
            if strcmp(Spectrum_Type,'Original')
%% Outer Original
f_n=234;
f_can=[f_n,f_s,f_o,f_p_s,f_c];
f_name={'{\it f}_{\rm n}','{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm o}','{\it f}^{\rm (s)}_{\rm o}','{\it f}_{\rm c}'};
err=1*10^(-2.5);
N_max=[1,10,10,10,10];
            elseif strcmp(Spectrum_Type,'Envelope')
%% Outer Envelope or Frequency Demodulation
f_can=[f_s,f_o,f_p_s,f_c];
f_name={'{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm o}','{\it f}^{\rm (s)}_{\rm o}','{\it f}_{\rm c}'};
err=1*10^(-1.5);
N_max=[10,10,10,10];
            end
        case 'RE'
            if strcmp(Spectrum_Type,'Original')
%% RE Original
f_n=234.1;
f_can=[f_n,f_s,f_b,f_cg,f_c];
f_name={'{\it f}_{\rm n}','{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm b}','{\it f}_{\rm cg}','{\it f}_{\rm c}'};
err=1*10^(-1);
N_max=[1,5,10,10,10,10];
            elseif strcmp(Spectrum_Type,'Envelope')
%% RE Envelope or Frequency Demodulation
f_can=[f_s,f_b,f_cg,f_c];
f_name={'{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm b}','{\it f}_{\rm cg}','{\it f}_{\rm c}'};
err=1*10^(-2);
N_max=[10,10,10,10];
            end
        case 'Inner'
            if strcmp(Spectrum_Type,'Original')
%% Inner Original
f_n=234.2;
f_can=[f_n,f_i,f_s,f_c];
f_name={'{\it f}_{\rm n}','{\it f}_{\rm i}','{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm c}'};
err=1*10^(-1);
N_max=[1,5,15,15,15];
             elseif strcmp(Spectrum_Type,'Envelope')
%% Inner Envelope or Frequency Demodulation
f_can=[f_i,f_s,f_c];
f_name={'{\it f}_{\rm i}','{\it f}^{\rm (r)}_{\rm s}','{\it f}_{\rm c}'};
err=1*10^(-1.5);
N_max=[15,15,15];
             end
end
%% -----------get cursor location 
[Coef,simi]=peak_pick(f_can,f_name,err,N_max);

%% ---------support function ---------------
% function f_name=NameVar(f_can)
% Num=length(f_can);
% for i=1:Num
%     switch f_can(i)
%     case 'f_n'
%         f_name{i}='{\it f}_{\rm n}';
%     case 'f_m'
%         f_name{i}='{\it f}_{\rm m}';
%     case  'f_o'
%         f_name{i}='{\it f}_{\rm o}';
%     case 'f_s'
%         f_name{i}='{\it f}_{\rm s}';
%     case 'f_p_s'
%         f_name{i}='{\it f}_{\rm o}^{\rm (s)}';
%     case 'f_c'
%         f_name{i}='{\it f}_{\rm c}';
%     case 'f_i'
%         f_name{i}='{\it f}_{\rm i}';
%     case 'f_b'
%         f_name{i}='{\it f}_{\rm b}';
%     case 'f_cg'
%         f_name{i}='{\it f}_{\rm cg}';
%     otherwise
%         error('unknow variable name!');
%     end
% end

% end
