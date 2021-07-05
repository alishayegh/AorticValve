function  x=labrosse (x0, input, DISP)
	%% Description
	% Calculates the geometric parameters for a closed/
	% open aortic valve based on the following paper:
    % "Geometric modeling of functional trileaflet aortic
    % valves: Development and clinical applications",
	% Labrosse et al, 2006.

	%% Usage 
	% In the command window run the following:
	% >> x0 = [1,1,.1];
	% >> input.Rb = 26/2; input.Rc = 12;
	% >> input.Lf = 30; input.H = 16.8; input.Lh = 17;
	% >> labrosse(x0, input, 1);
	% "input" parameters are taken from Fig 4, labrosse
	% et al (2006). The results match very well with
	% the results given under that figure.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	clc
	% x0 = [d0, X_S, alpha]
	d0 = x0(1); X_sa0 = [x0(2), x0(3)];

	% Calculate d
	d = fsolve(@solveD, d0);

	% Calculate R, X_B, beta and Omega
	[R, X_B, beta, Omega] = solveRX_BbO(d, input);

	% Calculate X_S and alpha
	X_Sa = fsolve(@solveX_sa, X_sa0);

	% Calculate H_S
	[H_S] = solveH_S(input, X_Sa(2), beta);

	% Output
	x = [d, R, X_B, beta, Omega, X_Sa, H_S];

	% Show the results in command window
    if DISP
		disp('d = '); disp(d);
		disp('R = '); disp(R);
		disp('X_B = '); disp(X_B);
		disp('beta = '); disp(beta*180/pi);
		disp('Omega = '); disp(Omega*180/pi);
		disp('X_S = '); disp(X_Sa(1));
		disp('alpha = '); disp(X_Sa(2)*180/pi);
		disp('H_S = '); disp(H_S);
	end
end

function F = solveD(x)
	% This function will be used by fsolve, so I could
	% not find a way in order to provide "input" as an
	% input argument. Therefore I define it explicitly:
	input.Rb = 26/2; input.Rc = 12;
    input.Lf = 30; input.H = 16.8; input.Lh = 17;
    %input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	%input.Rb = 12.7; input.Rc = 12.15;
	%d: x(1)
	if input.Lf <= pi * sqrt(3) / 2 * input.Rc
		F(1) = input.Lf - 2*sqrt(x(1)^2 + 3*input.Rc ^ 2/4)*...
		atan(sqrt(3)/2 * input.Rc / x(1));
	elseif input.Lf > pi * sqrt(3) / 2 * input.Rc
		F(1) = input.Lf - 2*sqrt(x(1)^2 + 3*input.Rc ^ 2/4)*...
		(pi - atan(sqrt(3)/2 * input.Rc / x(1)));
	end
end

function [R, X_B, beta, Omega] = solveRX_BbO(d, input)
	%R: x(2)
    R = sqrt( d^2 + 3/4 * ...
	(input.Rc)^2 );
	%X_B: x(3)
	if input.Lf <= sqrt(3)/2 * pi * input.Rc
		X_B = R - d;
	elseif input.Lf > sqrt(3)/2 * pi * input.Rc
		X_B = R + d;
	end
	% Omega: x(5)
	Omega = asin(...
	((input.Lh)^2 - ((input.Rb - input.Rc/2)^2 + ...
	(input.H)^2 + (X_B^2))...
	)...
	/...
	(2*X_B*sqrt((input.H)^2 + ...
	(input.Rb - input.Rc/2) ^2))...
	) + ...
	atan((input.Rb - input.Rc / 2) / input.H);
	%beta: x(8)
	beta =  asin((X_B*cos(Omega) - (input.Rb - input.Rc/2))...
	/input.Lh);
end

function F = solveX_sa(x)
	% This function will be used by fsolve, so I could
	% not find a way in order to provide "input" as an
	% input argument. Therefore I define it explicitly:
	input.Rb = 26/2; input.Rc = 12;
    input.Lf = 30; input.H = 16.8; input.Lh = 17;
    %input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	%input.Rb = 12.7; input.Rc = 12.15;
	%alpha: x(6)
	%X_S: x(7)
	F(1) = -input.Lh + x(1) + input.Rb / cos(x(2));
	F(2) = -input.Lf ^2 + 4* (input.Rc^2 + (input.H - x(1) - ...
	input.Rb*tan(x(2)))^2);
end

function H_S = solveH_S(input, alpha, beta)
	%H_S: x(4)
	% commissures are expected to run parallel to the centreline
	% of the valve.
	H_S = input.H - (input.Rb - input.Rc/2) * ...
	tan((alpha + beta + pi/2)/2);
end