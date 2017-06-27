proc optmodel;
set MA={'MI','MAS','IL','CON'};
set DC={'MAR','MI','WI'};
set RE={'WA','NO','KE','COL'};

number MaxP {MA}=[20 33 31 29];

number MaxD {DC}=[37 46 41];

number MinR {RE}=[9 6 27 15];

number Fix {DC}=[600 750 650];
number FixP {MA}=[560 580 420 240];

number incost{MA,DC}=[
31	42	40
27	29	39
36	32	37
35	37	47];

number outcost{DC,RE}=[
24	33	28	24
19	16	21	26
49	30	32	45];

var inflow {MA,DC} >= 0;
var outflow {DC,RE} >= 0;
var Y{DC} binary;
var P{MA} binary;
 
minimize Total_Cost= sum {i in MA,j in DC} incost[i,j]*inflow[i,j] + sum {j in DC,k in RE} outcost[j,k]*outflow[j,k] + sum{i in DC}Y[i]*Fix[i] + sum{h in MA}P[h]*FixP[h];

con cMaxP {i in MA}: sum {j in DC} inflow[i,j] <= MaxP[i];
con cMinR {k in RE}: sum {j in DC} outflow[j,k] >= MinR[k];
con NoStock {j in DC}: sum {i in MA} inflow[i,j] = sum {k in RE} outflow[j,k];
con cMaxD {j in DC}: sum {i in MA} inflow[i,j] <= MaxD[j];
con NewMA {i in MA}: sum{j in DC} inflow[i,j]<=MaxP[i]*P[i];
con NewDC {i in DC}: sum{j in RE} outflow[i,j]<=MaxD[i]*Y[i];

solve;

print Total_Cost;
print inflow;
print outflow;
print {j in DC} (sum {i in MA} inflow[i,j]);
Print Y;

Quit;