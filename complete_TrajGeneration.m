% Main function of Stewart Platform model
% Linked to Simulink model of controller
% Zainab 

% Data
clearvars -except Xg Yg Zg R

global Xg Yg Zg R P_EQNs tym
%joint_ang=zeros(480,6);
 Bg =[Xg'; Yg';Zg'];

%%% SIN WAVE %%%% Change Ts to 1
% Zg = [];Xg = [];Yg = [];
% j=1;
% for i=0:0.2:pi
%     Zg = [Zg, 100 + 10*sin(i)];
%     Xg = [Xg,0];
%     Yg = [Yg,0];
%     R(:,:,j) = [1 0 0;0 1 0;0 0 1];
%     j = j+1;
% end
% Bg = [Xg;Yg;Zg];   
%%%%%%%


%% Trajectory Planner
p = [107.43,-27.61,-79.57,-79.82,-27.86,107.43;
        29.86, 108.11,78.11,-77.96,-107.96,-30.14;
        -20.23,-20.23,-20.23,-20.23,-20.23,-20.23];
b = [100.14,-13.59,-86.78,-86.77,-13.58,100.15;
42.39, 108.04,65.78,-65.54,-107.8,-42.13;
9.75,  9.75,  9.75,  9.75, 9.75,  9.75];
r=30;  %mm
d=110.5; %mm
gama = [0*pi/180,120*pi/180,120*pi/180,240*pi/180,240*pi/180,0*pi/180]; %%rad

Ts = 0.25; %Time diff between time steps
n_timesteps = length(Bg); %No. of Time steps
                            %TT = Ts * [0:n_timesteps-1]';
display("Starting Inverse Kinematics");
for i=1:1:n_timesteps
    t1=Bg(:,i);
    R1= R(:,:,i);
    leg = stewart_IK(t1, p, b, R1);
    jang(:,i) = l2theta(leg, d, r,t1, p, b, gama, R1);
end
display("Completed Inverse Kinematics");

tym = (0:1:n_timesteps-1)*Ts; %Actual time instances
dt(1:(n_timesteps-1)) = Ts; %delta t for each segment

[m,n] = size(jang);
TRAJs = [];
P_EQNs = [];
display("Starting Trajectory Generation");
%%
for i=1:1:6
    clear a eqns
    a = sym('a',[(n-1),4]);
    syms t
    %k=1;
    %eqns=zeros(1916,1);
    eqns = [];
    for j = 1:1:(n) %j is each via point
        % The current segment is the one after the current via point
        if j==1
            pos = a(j,1) + a(j,2)*t + a(j,3)*t^2 + a(j,4)*t^3; %Position equation for the current segment
            vel = diff(pos,t);
            eqns = [eqns;subs(pos,[t],0)==jang(i,j)];
            eqns = [eqns;subs(vel,[t],0)==0];
        elseif j==n
            pos = a(j-1,1) + a(j-1,2)*t + a(j-1,3)*t^2 + a(j-1,4)*t^3; %Position equation for the current segment
            vel = diff(pos,t);
            eqns = [eqns;subs(pos,[t],tym(j))==jang(i,j)];
            eqns = [eqns;subs(vel,[t],tym(j))==0];            
        else       
            pos = a(j,1) + a(j,2)*t + a(j,3)*t^2 + a(j,4)*t^3; %Position equation for the current segment
            pos_1 = a(j-1,1) + a(j-1,2)*t + a(j-1,3)*t^2 + a(j-1,4)*t^3; %Position equation for the previous segment
            vel = diff(pos,t);
            vel_1 = diff(pos_1,t);
            acc = diff(vel,t);
            acc_1 = diff(vel_1,t);
            eqns = [eqns;subs(pos,[t],tym(j))==jang(i,j)]; 
            eqns = [eqns;subs(pos_1,[t],tym(j))==jang(i,j)];
            eqns = [eqns;subs(vel,[t],tym(j))==subs(vel_1,[t],tym(j))];
            eqns = [eqns;subs(acc,[t],tym(j))==subs(acc_1,[t],tym(j))]; 
        end
    end
    disp('Out of first for loop');
    [A,B] = equationsToMatrix(eqns,a);
    X = linsolve(A,B); %This gives us the results in a vector. Since a is a matrix rather than a vector, X = [a1_1,a2_1,a3_1.... a2_1,a2_2....] etc
    % So to make this in the form of 'a' we use the following code
    
    [am,an] = size(a);
    xind=1;
    for col=1:1:an
        for row=1:1:am
            a(row,col) = X(xind);
            xind=xind+1;
        end
    end
    disp('Out of second for loop');
    %Now forming our position equations for each section
    %P_EQNs = size(480,1);
    p_eqn = [];
    for seg=1:1:length(jang)-1
        p_eqn = [p_eqn;(a(seg,1)+a(seg,2)*t+a(seg,3)*t^2+a(seg,4)*t^3)];
    end
    P_EQNs = [P_EQNs,p_eqn]; %p_eqn is the vector of position equations for the ith joint and P_EQNs is the set of position equations for all joints
    
    disp('Merging all position equations');
    %Merging all the position equations to get a trajectory
    traj = [];X=[];
    for seg=1:1:length(jang)-1
       for j = 0:0.01:dt(seg)
            traj= [traj,subs(P_EQNs(seg,i),[t],[tym(seg)+j])];
            X = [X,tym(seg)+j];
       end
    end
    TRAJs=[TRAJs;traj];
    i
end
display("Completed Trajectory Generation");
%%
%Plotting
for i = 1:1:6
    plot(X,TRAJs(i,:))
    hold on
    %FFF=[X' eval(traj)'];
end
legend('joint1','joint2','joint3','joint4','joint5','joint6');

%%




%%%%%%%%%%%%%%%%%%%%%%%%
function l = stewart_IK(t,p,b,R)  %Inverse Kinematics - Finds the vector representing leg length for each leg
% t - platform target position wrt base frame, 
% R - rotation matrix of platform wrt base frame, 
% p - position of leg attachment points on platform wrt platform coordinate system 
% b - location of leg attachment points on base wrt base coordinate system.
%l=zeros(18,1);   
for i=1:1:6
        l(:,i) = t+R*p(:,i)-b(:,i); % This is basically just a simple vector relation 
    end
end
function theta = l2theta(l,d,r,t,p,b,gama,R) %Converts leg length vector to joint angle values. 
% r - Length of Link 1 that goes from the motor centre to the first attachment point
% d - Length of Link 2 that goes from first attachment point to platform attachment point
% gama - An angular measure of the position of the base attachment point

    for i=1:1:6
        A(i) = 2*r*(transpose(t+R*p(:,i))*[0;0;1]- b(3,i)); 
        %display(A);
        B(i) = 2*r*(sin(gama(i))*(transpose(t+R*p(:,i))*[1;0;0]- b(1,i))-cos(gama(i))*(transpose(t+R*p(:,i))*[0;1;0]- b(2,i)));
        %display(B);
        C(i) = norm(l(:,i))^2 - d^2 + r^2;
        
        %display(C);
        %theta(i) = asin(C(i)/(sqrt(A(i)^2+B(i)^2))) - atan2(B(i),A(i));
        theta(i) = asin((C(i)*(-1)^(i))/sqrt(A(i)^2+B(i)^2)) - atan2(B(i),A(i));
    end
end
