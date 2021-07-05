function labrossePoints(x0, input)
	%% Description
	% Returns the coordinates of points A and B in Figs 
	% 2 and 3, Labrosse et al ("Geometric modeling of
	% functional trileaflet aortic valves: Development and
	% clinical applications", 2006).

	%% Usage 
	% In the command window run the following:
	% >> x0 = [1,1,.1];
	% >> input.Rb = 26/2; input.Rc = 12;
	% >> input.Lf = 30; input.H = 16.8; input.Lh = 17;
	% >> labrossePoints(x0, input);
	% "input" parameters are taken from Fig 4, labrosse
	% et al (2006). 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x = labrosse(x0, input, 0);
	disp('A : (')
	disp(input.Rb - (input.H - x(6))*cot(x(7)/2 + pi/4 + x(4)/2)...
	), disp(sqrt(3)* input.Rc / 2), disp(input.H) 
	disp(')');

	disp('B : (')
	disp(.5 * input.Rc - x(3) * cos(x(5)))
	disp(0), disp(input.H + x(3)*sin(x(5)))
	disp(')');
