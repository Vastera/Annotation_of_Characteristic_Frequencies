%% Gear frequency
f_s=1;% sun gear frequency
f_c=0.25*f_s;% carrier frequency
f_m=27*f_s;% meshing frequency

f_s_f=2.25*f_s;%sun gear fault frequency
f_s_f_1_3=f_s_f/3;%one third of sun gear fault frequency
f_p_f=0.771428571*f_s;% planet gear fault frequency
f_r_f=0.75*f_s;%Ring gear fault frequency

%% Bearing frequency
f_p_s=0.771428571*f_s;% planet spinning frequency
f_i=4.549450549*f_s;% planet bearing inner race frequency 
f_o=3.164835165*f_s;% planet bearing outer race frequency
f_b=2.079748823*f_s;% planet bearing rolling element frequency
f_cg=0.454945055*f_s;% planet bearing cage spinning frequency

%% gear fault
% f_n=234.3;
f_can=[f_m,f_s,f_s_f,f_s_f_1_3,f_c];
f_name={'f_{\rm meshing}','f_{\rm sun\ shaft}','f_{\rm sun\ gear\ fault}','\frac{1}{3}f_{\rm sun\ gear\ fault}','f_{\rm carrier}'};
err=1*10^(-2);
N_max=[1,10,10,10,10];
%% -----------get cursor location 
[Coef,simi]=peak_pick(f_can,f_name,err,N_max);