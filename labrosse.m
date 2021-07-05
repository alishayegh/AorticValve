function  x=labrosse (x0, input, DISP)
%function x = labrosse (x0)
%function x = labrosse (status, x0)
	% calculates the geometric parameters for a closed/
	% open aortic valve.
	% x0 = [d0, X_S, alpha]
    %input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	%input.Rb = 12.7; input.Rc = 12.15;

	% A good approximation for x0:
	% x0 = [12,12,.01,11,.44,.12] % angle in radians

	clc
    %if strcmpi(status, 'closed')
	   % fun = @closed;
    %elseif strcmpi(status, 'open')
	   % fun = @openn;
    %end

    options = optimoptions('fsolve','Display','none',...
	'PlotFcn',@optimplotfirstorderopt);	
	%x = fsolve(fun, x0, options);
	d0 = x0(1); X_sa0 = [x0(2), x0(3)];
	d = fsolve(@solveD, d0);
	[R, X_B, beta, Omega] = solveRX_BbO(d, input);
	X_Sa = fsolve(@solveX_sa, X_sa0);
	%x = fsolve(fun, x0);
	[H_S] = solveH_S(input, X_Sa(2), beta);
	x = [d, R, X_B, beta, Omega, X_Sa, H_S];
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

%function F = closed(x, input)
function F = solveD(x)
    input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	input.Rb = 12.7; input.Rc = 12.15;
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
    input.Lf = 30.2; input.H = 17; input.Lh = 12.8;
	input.Rb = 12.7; input.Rc = 12.15;
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

function F = openn(x)
%x0 = [12,12,.01,.44,.12];
	%input
	%	Lf
	%	Lh
	%	H
	%	Rc
	%	Rb
	%output
	%	x1 = p
	%	x2 = R
	%	x3 = Xz
	%	%x4 = Ch 
	%	x4 = alpha % open
	%	%x5 = beta % closed
	%	x5 = gamma

    input.Lf = 30.2; input.H = 22; input.Lh = 12.8;
	input.Rb = 12.7; input.Rc = 12.15;

    F(1) = input.Lf - 2 * sqrt( (x(1))^2 + 3/4 * ...
	(input.Rc)^2 ) * atan(input.Rc * sqrt(3) / (2*x(1)));
    F(2) = x(2) - sqrt( (x(1))^2 + 3/4 * ...
	(input.Rc)^2 );
	F(3) = x(3) - x(2) + x(1);
	%F(4) = (input.Lf)^2 - 4*((input.Rc)^2 + (input.H -...
	%x(4) - input.Rb*tan(x(5)))^2);
	F(4) = x(4) - asin(...
	(x(3)*cos(x(5)) - (input.Rb - input.Rc/2))...
	/...
	input.Lh...
	);
	F(5) = x(5) - asin(...
	((input.Lh)^2 - ((input.Rb - input.Rc/2)^2 + ...
	(input.H)^2 + (x(3))^2))...
	/...
	(2*x(3)*sqrt((input.H)^2 + ...
	(input.Rb - input.Rc/2) ^2))...
	) - ...
	atan((input.Rb - input.Rc / 2) / input.H);
end