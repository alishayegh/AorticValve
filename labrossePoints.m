function labrossePoints(x0, input)
	% Returns the coordinates of points A and B in Figures 
	% 2 and 3, Labrosse et al (2006).
	% x0 = [d0, X_S, alpha]
    %input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	%input.Rb = 12.7; input.Rc = 12.15;
	% x = [d, R, X_B, beta, Omega, X_Sa, H_S];
	% Note: X_Sa = [X_S, alpha]
	x = labrosse(x0, input, 0);
	disp('A : (')
	disp(input.Rb - (input.H - x(6))*cot(x(7)/2 + pi/4 + x(4)/2)...
	), disp(sqrt(3)* input.Rc / 2), disp(input.H) 
	disp(')');

	disp('B : (')
	disp(.5 * input.Rc - x(3) * cos(x(5)))
	disp(0), disp(input.H + x(3)*sin(x(5)))
	disp(')');
