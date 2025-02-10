%% Robustness test with the solution of the standard problem
clear;clc;
%%
mpc = case_data;                       % load network data 
load case_1_data.mat                   % load M and D result
m = solution.m; d = solution.d;        
t_gfm = 30;                            % the time to switch GFM parameters
t_gfl = 30;                            % the time to switch GFL parameters
%%
Sb = 100*10^6;                         % System Base (W)
fb = 60;                               % fbase (Hz)
wb = 2*pi*fb;                          % fbase (rad/s)
Vb_h = 230*10^3;                       % high-voltage base (V)
trans_l = mpc.trans_l;                 % transformer L (pu)
line = mpc.line*1.1;                   % 1.1*Line parameter (nomial value)
%% GFM Converter Parameters (p.u.)
Vb_gfm = 20*10^3;                      % base low voltage, l-l rms [V]
Vb_p_ph = Vb_gfm*sqrt(2/3);            % Base low voltage, p-n peak [V]
% VSM
D_q_pu = 0.01;                         % reactive power damping [pu]
kp_vc_pu = 0.01;                       % voltage loop P [pu]
ki_vc_pu = 0.1;                        % voltage loop I [pu]
kp_i_pu = 0.3;                         % current loop P [pu]
ki_i_pu = 1;                           % current loop I [pu]
r_f_pu = 0.01;                         % filter R [pu]
c_f_pu = 0.005;                        % filter C [pu]   
l_f_pu = 0.09;                         % filter L [pu]
%%
P_set = [6.000,7.100,2.000,5.700,3.000,2.200,5.000,7.000,2.000]*10^8; % Active Power Set Point [W]
Q_set = [0.743,1.449,0.897,0.364,0.224,-0.108,0.634,1.466,1.498]*10^8;                     % Reactive Power Set Point [W]
theta0 =[0.1781,0,-0.1848,-0.2946,-0.4565,-0.5202,-0.1629,-0.2615,-0.4725];                % Initial Power Angle [rad]
%% *********************** GFMs **********************
JDb = Sb/wb;                            % Inertia and Damping Base
for k =1:9
    J_pu = m(k)*Sb/JDb;                 % Inertia [pu] 
    D_p_pu = d(k)*Sb/JDb*3;             % Active power damping before switching [pu]
    P_set_pu_gfm(k) = P_set(k)/Sb; Q_set_pu_gfm(k) = Q_set(k)/Sb;         % Set Points [pu]
    % Parameters [nomial value]
    [Vdc_gfm(k),P_set_gfm(k),Q_set_gfm(k),J_gfm(k),D_p_gfm(k),D_q_gfm(k),...
        kp_vc_gfm(k),ki_vc_gfm(k),kp_i_gfm(k),ki_i_gfm(k),r_f_gfm(k),c_f_gfm(k),l_f_gfm(k),Init(k)]...
        = fun00_GFM_pu_2_normial(Sb,Vb_gfm,fb,P_set_pu_gfm(k),Q_set_pu_gfm(k),J_pu,...
        D_p_pu,D_q_pu,kp_vc_pu,ki_vc_pu,kp_i_pu,ki_i_pu,r_f_pu,l_f_pu,c_f_pu); 
    %
    if m(k)>0.002   % avoid too small inertia given by optimization numerical results
        VSM(k)=1;   % If inertia is enough, use VSM control
    else
        VSM(k)=2;   % If inertia is so small, use droop control
        J_gfm(k) = 0.001*Sb;  %just to avoid numerical issues in no-used VSM controller
    end
    %
    D_p_gfm_s(k) = d(k)*Sb;             % Active power damping after switching [pu]
end
for k =1:9
    Init(k).theta0 = theta0(k);
end
%% GFL Converter Parameters (p.u.)
kp_i_pu = 0.3;                                         % proportional gain of current control [pu]
ki_i_pu = 10;                                          % integral gain of current control [pu] 
kp_q_pu = 0.1;                                         % proportional gain of reactive power control [pu]
ki_q_pu = 1;                                           % integral gain of reactive power control [pu]
kp_p_pu = 0.1;                                         % proportional gain of active power control [pu]
ki_p_pu = 1;                                           % integral gain of active power control [pu]
r_f_pu = 0.01;                                         % output filter resistor [pu] 
c_f_pu = 0.005;                                        % output filter capacitor [pu] 
l_f_pu = 0.09;                                         % output filter inductance [pu]
%% *********************** GFLs - Converter 1,5,7 **********************
gfl_idx = [1,5,6];                                        % the index of GFL converters
JDb = Sb/wb;                                              % Inertia and Damping Base
for k=1:3
    kk = gfl_idx(k);                                      % the index of GFL converter now
    p_set_pu(k) = P_set(kk)/Sb; v_set_pu(k) =1; q_set_pu(k) = Q_set(kk)/Sb;  % set points [pu]
    Vb(k) = 20*10^3;                                      % base low voltage, l-l rms [V]
    m_gfl(k) = m(kk)*Sb;                                  % inertia
    d_gfl(k) = d(kk)*Sb;                                  % active power damping
    w_pll = d_gfl(k)/m_gfl(k)/sqrt(2);                    % bandwidth of PLL  
    ki_pll_pu = w_pll^2;                                  % integral gain PLL
    kp_pll_pu = sqrt(2*ki_pll_pu);                        % proportional gain PLL 
    %
    [Vdc(k),pset(k),qset(k),kp_pll(k),ki_pll(k),...
        kp_i(k),ki_i(k),kp_q(k),ki_q(k),kp_p(k),ki_p(k),r_f(k),c_f(k),l_f(k),Init_GFL(k)]...
        = fun00_GFL_pu_2_normial(Sb,Vb(k),fb,p_set_pu(k),q_set_pu(k),kp_pll_pu,ki_pll_pu,...
        kp_i_pu,ki_i_pu,kp_q_pu,ki_q_pu,kp_p_pu,ki_p_pu,r_f_pu,c_f_pu,l_f_pu);
    %
    w_pll_s = d_gfl(k)/m_gfl(k)/sqrt(2);                     % bandwidth of PLL (after swithcing)
    ki_pll_pu_s = w_pll_s^2;                                 % integral gain PLL  (after swithcing)
    kp_pll_pu_s = sqrt(2*ki_pll_pu_s);                       % proportional gain PLL (after swithcing)
    [~,~,~,kp_pll_s(k),ki_pll_s(k),~,~,~,~,~,~,~,~,~,~]...
        = fun00_GFL_pu_2_normial(Sb,Vb(k),fb,p_set_pu(k),q_set_pu(k),kp_pll_pu_s,ki_pll_pu_s,...
        kp_i_pu,ki_i_pu,kp_q_pu,ki_q_pu,kp_p_pu,ki_p_pu,r_f_pu,c_f_pu,l_f_pu);
end
for k=1:3
    kk = gfl_idx(k);
    Init_GFL(k).theta0 = theta0(kk);
end
%%
sim("simulation_model.slx",[0 t_gfm+8]);