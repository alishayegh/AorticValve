# AorticValve
## labrosse.m
 Calculates the geometric parameters for a closed/
 open aortic valve based on the following paper:
"Geometric modeling of functional trileaflet aortic
valves: Development and clinical applications",
 Labrosse et al, 2006.

### Usage 
 In the command window run the following:
 ```matlab
 x0 = [1,1,.1];
 input.Rb = 26/2; input.Rc = 12;
 input.Lf = 30; input.H = 16.8; input.Lh = 17;
 labrosse(x0, input, 1);
 ```
 `input` parameters are taken from Fig 4, labrosse
 et al (2006). The results match very well with
 the results given under that figure.

## labrossePoints.m
 Returns the coordinates of point B and the angle of attachment line to the basal planein Figs 
 2 and 3, Labrosse et al ("Geometric modeling of
 functional trileaflet aortic valves: Development and
 clinical applications", 2006).

### Usage 
 In the command window run the following:
 ```matlab
 x0 = [1,1,.1];
 input.Rb = 26/2; input.Rc = 12;
 input.Lf = 30; input.H = 16.8; input.Lh = 17;
 labrossePoints(x0, input);
 ```
 `input` parameters are taken from Fig 4, labrosse
 et al (2006). 
