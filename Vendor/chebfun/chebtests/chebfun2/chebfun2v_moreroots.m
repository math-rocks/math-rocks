function pass = chebfun2v_moreroots
% Check that the marching squares and Bezoutian agree with each other. 
% YN, VN & AT, April 2013. Uncomment tests if harder tests should be executed.
%%
tol = 100*chebfun2pref('eps'); 
j = 1; 

%% (Marching squares fails)
f = chebfun2(@(x,y)((x-.3).^2+2*(y+0.3).^2-1)); 
g = chebfun2(@(x,y)((x-.49).^2+(y+.5).^2-1).*((x+0.5).^2+(y+0.5).^2-1).*((x-1).^2+(y-0.5).^2-1)); 
%r1 = roots([f;g]); 
r2 = roots([f;g],'resultant'); 
pass(j) = ~( length(r2) - 4 ); j = j+1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 1e2*tol ); j = j + 1; 

%% (Marching Squares misses a root)
f = chebfun2(@(x,y)((x-0.1).^2+2*(y-0.1).^2-1).*((x+0.3).^2+2*(y-0.2).^2-1).*((x-0.3).^2+2*(y+0.15).^2-1).*((x-0.13).^2+2*(y+0.15).^2-1)); 
g = chebfun2(@(x,y)(2*(x+0.1).^2+(y+0.1).^2-1).*(2*(x+0.1).^2+(y-0.1).^2-1).*(2*(x-0.3).^2+(y-0.15).^2-1).*((x-0.21).^2+2*(y-0.15).^2-1)); 
% r1 = roots([f;g]); 
r2 = roots([f;g],'resultant'); 
pass(j) = ~( length(r2) - 45 ); j = j+1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 100*tol ); j = j + 1; 

%%
f = chebfun2(@(x,y)sin(3*(x+y))); 
g = chebfun2(@(x,y)sin(3*(x-y))); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% Face and apple example
f = chebfun2(@(x,y)((90000*y.^10 + (-1440000)*y.^9 + (360000*x.^4 + 720000*x.^3 + 504400*x.^2 + 144400*x +...
     9971200).*(y.^8) + ((-4680000)*x.^4 + (-9360000)*x.^3 + (-6412800)*x.^2 + (-1732800).*x +...
     (-39554400)).*(y.^7) + (540000*x.^8 + 2160000*x.^7 + 3817600*x.^6 + 3892800*x.^5 +...
     27577600*x.^4 + 51187200*x.^3 + 34257600*x.^2 + 8952800*x + 100084400).*(y.^6) +...
     ((-5400000)*x.^8 + (-21600000)*x.^7 + (-37598400)*x.^6 + (-37195200)*x.^5 +...
     (-95198400)*x.^4 + (-153604800)*x.^3 + (-100484000)*x.^2 + (-26280800).*x +...
     (-169378400)).*(y.^5) + (360000*x.^12 + 2160000*x.^11 + 6266400*x.^10 + 11532000*x.^9 +...
     34831200*x.^8 + 93892800*x.^7 + 148644800*x.^6 + 141984000*x.^5 + 206976800*x.^4 +...
     275671200*x.^3 + 176534800*x.^2 + 48374000*x + 194042000).*(y.^4) + ((-2520000)*x.^12 +...
     (-15120000)*x.^11 + (-42998400)*x.^10 + (-76392000)*x.^9 + (-128887200)*x.^8 + ...
     (-223516800)*x.^7 + (-300675200)*x.^6 + (-274243200)*x.^5 + (-284547200)*x.^4 + ...
     (-303168000)*x.^3 + (-190283200)*x.^2 + (-57471200).*x + (-147677600)).*(y.^3) +...
     (90000*x.^16 + 720000*x.^15 + 3097600*x.^14 + 9083200*x.^13 + 23934400*x.^12 +...
     58284800*x.^11 + 117148800*x.^10 + 182149600*x.^9 + 241101600*x.^8 + 295968000*x.^7 +...
     320782400*x.^6 + 276224000*x.^5 + 236601600*x.^4 + 200510400*x.^3 + 123359200*x.^2 + ...
     43175600*x + 70248800).*(y.^2) + ((-360000)*x.^16 + (-2880000)*x.^15 + (-11812800)*x.^14 +...
     (-32289600)*x.^13 + (-66043200)*x.^12 + (-107534400)*x.^11 + (-148807200)*x.^10 + (-184672800)*x.^9 + (-205771200)*x.^8 + (-196425600)*x.^7 + (-166587200)*x.^6 + (-135043200)*x.^5 + (-107568800)*x.^4 + (-73394400)*x.^3 + (-44061600)*x.^2 + (-18772000)*x + (-17896000)).*y + (144400*x.^18 + 1299600*x.^17 + 5269600*x.^16 + 12699200*x.^15 + 21632000*x.^14 + 32289600*x.^13 + 48149600*x.^12 + 63997600*x.^11 + 67834400*x.^10 + 61884000*x.^9 + 55708800*x.^8 +...
     45478400*x.^7 + 32775200*x.^6 + 26766400*x.^5 + 21309200*x.^4 + 11185200*x.^3 + 6242400*x.^2 + 3465600*x + 1708800)))); 
g = chebfun2(@(x,y)1e-4*(y.^7 + (-3)*y.^6 + (2*x.^2 + (-1)*x + 2).*y.^5 + (x.^3 + (-6)*x.^2 + x + 2).*y.^4 + ...
     (x.^4 + (-2)*x.^3 + 2*x.^2 + x + (-3)).*y.^3 + (2*x.^5 + (-3)*x.^4 + x.^3 + 10*x.^2 + (-1)*x + 1).*y.^2 + ((-1)*x.^5 + 3*x.^4 + 4*x.^3 + (-12)*x.^2).*y + (x.^7 + (-3)*x.^5 + (-1)*x.^4 + (-4)*x.^3 + 4*x.^2))); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% (slow one)
% f = chebfun2(@(x,y)exp(x-2*x.^2-y.^2).*sin(10*(x+y+x.*y.^2))); 
% g = chebfun2(@(x,y)exp(-x+2*y.^2+x.*y.^2).*sin(10*(x-y-2*x.*y.^2))); 
% r1 = roots([f;g]); 
% r2 = roots([f;g]); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
rect = 2*[-1 1 -1 1];
f = chebfun2(@(x,y)2*x.*y.*cos(y.^2).*cos(2*x)-cos(x.*y),rect); 
g = chebfun2(@(x,y)2*sin(x.*y.^2).*sin(3*x.*y)-sin(x.*y),rect); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% Marching squares double counts some solutions. 
f = chebfun2(@(x,y)(y - 2*x).*(y+0.5*x)); 
g = chebfun2(@(x,y) x.*(x.^2+y.^2-1)); 
% r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < 10*sqrt(tol) ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < 10*sqrt(tol) ); j = j + 1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < tol ); j = j + 1; 

%%
f = chebfun2(@(x,y)(y - 2*x).*(y+.5*x)); 
g = chebfun2(@(x,y) (x-.0001).*(x.^2+y.^2-1)); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < 10*tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < 100*tol ); j = j + 1;

%%
f = chebfun2(@(x,y)25*x.*y - 12); 
g = chebfun2(@(x,y)x.^2+y.^2-1); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;


end