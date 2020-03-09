function [p1 p2 p3 p4 p5 p6]= CalcPos(sim_t)
global P_EQNs tym
syms t
i=2;

for i=2:1:length(tym)
    if sim_t<=tym(i)
        break;
    end
end

p1 = subs(P_EQNs(i-1,1),[t],[sim_t]);
p2 = subs(P_EQNs(i-1,2),[t],[sim_t]);
p3 = subs(P_EQNs(i-1,3),[t],[sim_t]);
p4 = subs(P_EQNs(i-1,4),[t],[sim_t]);
p5 = subs(P_EQNs(i-1,5),[t],[sim_t]);
p6 = subs(P_EQNs(i-1,6),[t],[sim_t]);

end