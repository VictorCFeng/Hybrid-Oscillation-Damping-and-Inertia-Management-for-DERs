function mpc = case_data

mpc.baseMVA = 100*10^6;
mpc.Vb_h = 230*10^3;
fb = 60;                                  %fbase (Hz)
wb = 2*pi*fb;
Zb = (mpc.Vb_h^2)/mpc.baseMVA;            % Zbase for each line (O)
Lb = Zb/wb;

unit_r = 0; unit_x = 1*10^(-3); trans_x = 0.15/9;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
	2	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
	3	1	400	0	0	0	1	1	0	230	1	1.1	0.9;
	4	1	567	300	0	0	1	1	0	230	1	1.1	0.9;
	5	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
    6	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
    7	1	490	0	0	0	1	1	0	230	1	1.1	0.9;
    8	1	1000  450	 0	 0	1	1	0	230	1	1.1	0.9;
    9	1	0   0  0	 0	1	1	0	230	1	1.1	0.9;
    10	1	0   0  0	 0	1	1	0	230	1	1.1	0.9;
    11	1	0   0  0	 0	1	1	0	230	1	1.1	0.9;
    12	1	1570   0  0	 0	1	1	0	230	1	1.1	0.9;
    13	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
    14	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
    15	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
    16	1	0	0	0	0	1	1	0	230	1	1.1	0.9;
];

%% generator data
%    bus    Pg    Qg    Qmax    Qmin    Vg    mBase    status    Pmax    Pmin    Pc1    Pc2    Qc1min    Qc1max    Qc2min    Qc2max    ramp_agc    ramp_10    ramp_30    ramp_q    apf
mpc.gen = [
1    611    164    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
2    1050    284    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
4    1050    284    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
5    719    133    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
6    350    69    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
8    700    208    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
9    700    208    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
10    700    293    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
12    700    293    30    -30    1    100    1    40    0    0    0    0    0    0    0    0    0    0    0    0;
];

%% branch data
%    fbus    tbus    r    x    b    rateA    rateB    rateC    ratio    angle    status    angmin    angmax
mpc.branch = [
1   3   25*unit_r  25*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
2   3   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
3   4   10*unit_r  10*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
4   8   110*unit_r  110*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
4   12   110*unit_r  110*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
5   7   25*unit_r  25*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
6   7   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
7   8   10*unit_r  10*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
8   12   110*unit_r  110*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
9   11   25*unit_r  25*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
10   11   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
11   12   10*unit_r  10*unit_x + 0*trans_x    0   0   0   0    0    0    1    -360    360;
1   13   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
4   14   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
8   15   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
12  16   0*unit_r  0*unit_x + 1*trans_x    0   0   0   0    0    0    1    -360    360;
];

mpc.line = [
1   3   25*unit_r  25*unit_x    0   0   0   0    0    0    1    -360    360;
2   3   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
3   4   10*unit_r  10*unit_x    0   0   0   0    0    0    1    -360    360;
4   8   110*unit_r  110*unit_x    0   0   0   0    0    0    1    -360    360;
4   12   110*unit_r  110*unit_x    0   0   0   0    0    0    1    -360    360;
5   7   25*unit_r  25*unit_x    0   0   0   0    0    0    1    -360    360;
6   7   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
7   8   10*unit_r  10*unit_x    0   0   0   0    0    0    1    -360    360;
8   12   110*unit_r  110*unit_x    0   0   0   0    0    0    1    -360    360;
9   11   25*unit_r  25*unit_x    0   0   0   0    0    0    1    -360    360;
10   11   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
11   12   10*unit_r  10*unit_x    0   0   0   0    0    0    1    -360    360;
1   13   0*unit_r  0*unit_x     0   0   0   0    0    0    1    -360    360;
4   14   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
8   15   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
12  16   0*unit_r  0*unit_x    0   0   0   0    0    0    1    -360    360;
];

mpc.line(:,4) = Lb*mpc.line(:,4);
mpc.branch_nomial = mpc.branch;
mpc.branch_nomial(:,4) = Lb*mpc.branch_nomial(:,4);
mpc.trans_l = trans_x;


end