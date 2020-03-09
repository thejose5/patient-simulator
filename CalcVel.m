function [p1 p2 p3 p4 p5 p6]= CalcVel(sim_t)
global P_EQNs tym
syms t
i=2;

for i=2:1:length(tym)
    if sim_t<=tym(i)
        break;
    end
end

p1 = subs(diff(P_EQNs(i-1,1),t),[t],[sim_t]);
p2 = subs(diff(P_EQNs(i-1,2),t),[t],[sim_t]);
p3 = subs(diff(P_EQNs(i-1,3),t),[t],[sim_t]);
p4 = subs(diff(P_EQNs(i-1,4),t),[t],[sim_t]);
p5 = subs(diff(P_EQNs(i-1,5),t),[t],[sim_t]);
p6 = subs(diff(P_EQNs(i-1,6),t),[t],[sim_t]);

end