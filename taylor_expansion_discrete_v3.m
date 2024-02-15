clear;clc

syms xx             % a variable symbolic function
c = pi/2;           % center point for Taylor series expansion
x = (-4:0.1:6)';    % x values for the function
y = cos(x);         % y values for a
n = 15;             % order to calculate polynomials

%% Polynomial part

p = polyfit(x,y,n);     % Polynomialcurve fitting
f_poly = polyval(p,x); % reconstructing curve to compare with original curve

%% Now that we obtained the polynomials
%  we are constructing the equation to make it a function
%  to feed into taylor expansion
%  Polynomial equation for order 8 is like this:
%  f(x) = p1*x.^8 + p2*x.^7 ..... + p8*x.^0

% cooking string
f_equ = '@(xx)';
j = length(p)-1;
for i = 1:length(p)
    f_equ = [f_equ,num2str(p(i)),'*xx.^',num2str(j),'+'];
    j = j-1;
end
f_equ(end-6:end) = [];        % cleaning up a bit
f_sym = eval(f_equ(6:end));   % converting into a sym function for Taylor
f_equ = str2func(f_equ);    % converting into function handle so we can plot again

%% plotting original, curve from polyfit, curve from equation

figure(1);clf;hold on;
plot(x,y)
plot(x,f_poly)
plot(x,f_equ(x))
axis tight
legend('Original','Polyfit','Polyfit equ','location','south')

%% plotting error between original vs curve from polyfit and equation
% numerical errors happen 

figure(2);clf;
plot(x,y-f_poly);
yyaxis right
plot(x,y-f_equ(x));

%% Plotting the taylor part

f_tay1 = addy_taylor(f_sym,xx,c,4,x);ylim([-1.5 1.5])
f_tay2 = addy_taylor(f_sym,xx,c,6,x);ylim([-1.5 1.5])
f_tay3 = addy_taylor(f_sym,xx,c,10,x);ylim([-1.5 1.5])

figure(3);clf;
plot(x, y, 'g')
hold on;grid on
plot(x, f_tay1, 'ro')
plot(x, f_tay2, 'b-.')
plot(x, f_tay3, 'k')
axis([-4 6 -3 3])
legend('cos(x)','4 term s','6 terms','10 terms','Location','north')

%% function for taylor expansion and vectorizing 

function y = addy_taylor(f_sym,xx,c,n,x)
y = vectorize(taylor(f_sym,xx,c,'Order',n+1));
xx = x;
y = eval(y);
end
 