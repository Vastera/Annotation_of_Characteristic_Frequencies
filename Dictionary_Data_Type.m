f_string={'f_ps','f_o','f_i','f_b','f_s','f_c'};
Freq_Dic=struct('f_c','f_{\rm c}','f_m','f_{\rm m}','f_ps','f_{\rm g}','f_s', ...
    'f^{\rm (r)_{\rm s}}','f_i','f_{\rm i}','f_o','f_{\rm o}','f_p_s','f^{\rm (s)}_{\rm o}', ...
    'f_cg','f_{\rm cg}','f_b','f_{\rm e}');
f_can_string='f_can=[';% to be executed later on to generate the values of frequency candidates
f_name_string='f_name={';% to be executed later on to generate the names of frequency candidates
index=1;
for candidate=f_string
    f_can_string=[f_can_string,f_string{index},','];
    index=index+1;
    f_name_string=[f_name_string,eval(['Freq_Dic.',candidate{1}]),','];
end
f_can_string(end)='';f_can_string=[f_can_string,'];'];
f_name_string(end)='';f_name_string=[f_name_string,'};'];
eval(f_can_string);% exectute the generation code of frequency candidates' values
eval(f_name_string);% exectute the generation code of frequency candidates' names