# patient-simulator
This project was a part of a course project for Robot Dynamics. The report for this work can be found [here](https://drive.google.com/file/d/1gtGpLF94630I-FlDSARob_NYjZIFWMft/view?usp=sharing)

This project implements the simulation of a hardware platform that mimics the motion of an organ with involuntary motions. The application of this system is in training autonomous surgical robots or even human surgeons for surgery on organs like the lungs and heart.

_Steps to run the Simscape Model_

1. Save all the files and folders in this drive folder in the same location
2. Open MATLAB
3. In the top bar click ‘Home’ and then ‘Import Data’ and import TrajDataFinal.mat
4. Once the workspace variables have been loaded, rename the variables P_EQNs and tym to P_EQN and ty respectively. Now write the following code in the MATLAB console:

-> global P_EQNs tym

-> P_EQNs = P_EQN;

-> tym = ty;

-> clear P_EQN ty

5. The last variables that need to be loaded into the workspace are the Kp and Kd values for the controller (these are taken to be same for all legs). I defined these variables in the end so you’ll have to manually define them. The values I ran the current simulation with are Kp = 0.1 and Kd = 10.
6. All the required variables are now correctly loaded.
7. Now open the simscape model ‘StewartSimscape.slx’
8. Double click the block titled ‘Base’ and in the ‘File’ field of the ‘Geometry’ section put in the path to the Base.STEP file which is located inside the ‘STEP files for MATLAB’ folder that you just downloaded (You can browse to this file by clicking the 3 dots on the right of the field).
9. Do the same for all other parts of the stewart platform. The block representing the Upper platform is on the right of the simulink model and the blocks representing the servo horn and the connecting link are inside each leg subsystem.
In the STEP files Horn2Up is the name of the STEP file for the connecting link and UpPlate+Mount is the STEP file for the top plate.
10. Once all this is done there shouldn’t be any blocks highlighted in red inside simscape and the simulation should run fine. 
    
Note: The simulation takes a very very long time. If 1 second in the simulation is being processed every 15 to 20 minutes, consider yourself lucky.
    
