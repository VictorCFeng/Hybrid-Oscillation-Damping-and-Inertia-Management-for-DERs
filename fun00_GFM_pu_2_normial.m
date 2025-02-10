function [Vdc,P_set,Q_set,J,D_p,D_q,...
    kp_vc,ki_vc,kp_i,ki_i,r_f,c_f,l_f,Init]...
    = fun00_GFM_pu_2_normial(Sb,Vb,fb,P_set_pu,Q_set_pu,J_pu,...
    D_p_pu,D_q_pu,kp_vc_pu,ki_vc_pu,kp_i_pu,ki_i_pu,r_f,l_f,c_f)

%%
w_b = fb*2*pi;                         %base angular frequency [rad/s]
%% 
Vb_p_ph = Vb*sqrt(2/3);                %Base low voltage, p-n peak [V]
Ib_p_ph = Sb/Vb/sqrt(3)*sqrt(2);       %L-n peak Converter base current [A]
Zb = Vb^2/Sb;                          %Converter base impedance [Ohm]
Lb = Zb/w_b;                           %base inductance [H]
Cb = 1/(Zb*w_b);                       %base capacitance [F]
%% setting points
P_set = P_set_pu*Sb; Q_set = Q_set_pu*Sb;   %Set points [W] and [V]
%% DC side parameters
Vdc = 3*Vb_p_ph;                               %DC-voltage reference [V]
%% Converter Parameters (already transformed into no-pu values)
% VSM
J = J_pu*(Sb/w_b);                  %inertia 
D_p = D_p_pu * (Sb/w_b);              %active power damping
D_q = D_q_pu * (Sb/Vb_p_ph);           %reactive power damping
%inner voltage control
kp_vc = kp_vc_pu/Vb_p_ph*Ib_p_ph;
ki_vc = ki_vc_pu/Vb_p_ph*Ib_p_ph;
%inner current control loop 
kp_i = kp_i_pu*Vb_p_ph/Ib_p_ph;                           %proportional gain of PI
ki_i = ki_i_pu*Vb_p_ph/Ib_p_ph;                            %integral gain of PI 
%
r_f = r_f*Zb;
c_f = c_f*Cb;                                           %output filter capacitor [pu]
l_f = l_f*Lb;  
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