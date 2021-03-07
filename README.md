# patient-simulator
This project was a part of a course project for Robot Dynamics. The report for this work can be found [here](https://drive.google.com/file/d/1gtGpLF94630I-FlDSARob_NYjZIFWMft/view?usp=sharing)

This project implements the simulation of a hardware platform that mimics the motion of an organ with involuntary motions. The application of this system is in training autonomous surgical robots or even human surgeons for surgery on organs like the lungs and heart.

## Control Workflow
<img src="https://user-images.githubusercontent.com/50763889/109879822-1cef5780-7c44-11eb-998d-6a4518496200.PNG" width="800" height="400" />

## Data Acquisition and Processing
Free breathing motion data was used to obtain xyz position data for the platform simulation. After processing and trimming the data as needed, 480 points were obtained for a sampling time of 0.25s. The following graph shows the plotted xyz points for the data.


<img src="https://user-images.githubusercontent.com/50763889/109881159-cdaa2680-7c45-11eb-85dc-429375bad51c.PNG" width="400" height="400" />


## Inverse Kinematics
The inverse Kinematics to find the required joint angle from the target platform position and orientation is obtained in 2 steps:  
1. Finding Virtual Leg Length, i.e. finding the distance from each lower attachment point to each corresponding upper attachment point. The equation for this is obtained from the following paper:   
*Guo, H.B. and Li, H.R., 2006. Dynamic analysis and simulation of a six degree of freedom Stewart platform manipulator. Proceedings of the Institution of Mechanical Engineers, Part C: Journal of Mechanical Engineering Science, 220(1), pp.61-72.*
<img src="https://user-images.githubusercontent.com/50763889/110243915-739daf80-7f2a-11eb-9da1-314b145d40a2.PNG" width="600" height="400" />

2. Finding Joint angles from the virtual leg length. The equation for this step was obtained from the following paper:  
*Filip Szufnarowski. Stewart platform with fixed rotary actuators: a low cost design study. Tech. rep.*
<img src="https://user-images.githubusercontent.com/50763889/110244059-f7579c00-7f2a-11eb-9435-046199959ad4.PNG" width="800" height="400" />

## Trajectory Planning

## Results
