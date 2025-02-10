function [Vdc,pset,qset,kp_pll,ki_pll,...
    kp_i,ki_i,kp_q,ki_q,kp_p,ki_p,r_f,c_f,l_f,Init]...
    = fun00_GFL_pu_2_normial(Sb,Vb,fb,p_set_pu,q_set_pu,kp_pll,ki_pll,...
    kp_i_pu,ki_i_pu,kp_q_pu,ki_q_pu,kp_p_pu,ki_p_pu,r_f,c_f,l_f)

%%
w_b = fb*2*pi;                         %base angular frequency [rad/s]
%% 
Vb_p_ph = Vb*sqrt(2/3);                %Base low voltage, p-n peak [V]
Ib_p_ph = Sb/Vb/sqrt(3)*sqrt(2);       %L-n peak Converter base current [A]
Zb = Vb^2/Sb;                          %Converter base impedance [Ohm]
Lb = Zb/w_b;                           %base inductance [H]
Cb = 1/(Zb*w_b);                       %base capacitance [F]
%% setting points
pset = p_set_pu*Sb; qset = q_set_pu*Sb;   %Set points [W] and [V]
%% DC side parameters
Vdc = 3*Vb_p_ph;                               %DC-voltage reference [V]
%% Converter Parameters (already transformed into no-pu values)
%PLL
kp_pll = kp_pll/Vb_p_ph;                                %proportional gain PLL 
ki_pll = ki_pll/Vb_p_ph;                                %integral gain PLL
%inner current control loop 
kp_i = kp_i_pu*Vb_p_ph/Ib_p_ph;                         %proportional gain of PI
ki_i = ki_i_pu*Vb_p_ph/Ib_p_ph;                         %integral gain of PI 
%outer power and voltage PI-droop controller
kp_q = kp_q_pu/Sb*Ib_p_ph;                              %proportional gain of PI
ki_q = ki_q_pu/Sb*Ib_p_ph;                              %integral gain of PI
kp_p = kp_p_pu/Sb*Ib_p_ph;                              %proportional gain of PI
ki_p = ki_p_pu/Sb*Ib_p_ph;                              %integral gain of PI
r_f = r_f*Zb;                                           %output filter resistor 
c_f = c_f*Cb;                                           %output filter capacitor 
l_f = l_f*Lb;                                           %output filter inductance
%%
P_set =  pset; Q_set = q_set_pu*Sb;
%% P = 3/2*(Vod*Iod+Voq*Ioq), Q = 3/2*(-Vod*Ioq+Voq*Iod), Voq =0
Vod = Vb_p_ph; Voq =0;
Iod = P_set/(3/2)/Vod;
Ioq = -Q_set/(3/2)/Vod;
%稳态VSC端口电压电流的求解
Func = [1           0           -r_f          w_b*l_f;
     0           1           -w_b*l_f     -r_f;
     0           0           1             0;
     0           0           0             1];
b = [1 0 0 0;
    0 1 0 0;
    0 -w_b*c_f 1 0;
    w_b*c_f 0 0 1]*[Vod; Voq; Iod; Ioq];
x = Func \ b;
Vcd = x(1); Vcq = x(2); Icd = x(3); Icq = x(4);
Init.Vod = Vod; Init.Voq = Voq; Init.Iod = Iod; Init.Ioq = Ioq;
Init.Vcd = Vcd; Init.Vcq = Vcq; Init.Icd = Icd; Init.Icq = Icq;
end