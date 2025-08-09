
% lb is the lower bound: lb=[lb_1,lb_2,...,lb_d]
% up is the uppper bound: ub=[ub_1,ub_2,...,ub_d]
% dim is the number of variables (dimension of the problem)

function [lb,ub,dim,fobj] = Functions_details(F)
d=10;   %%%dim=10,50,500

switch F
    case 'F1'
        fobj = @F1;
        lb=-100;
        ub=100;
        dim=d;
        
    case 'F2'
        fobj = @F2;
        lb=-10;
        ub=10;
        dim=d;
        
    case 'F3'
        fobj = @F3;
        lb=-10;
        ub=10;
        dim=d;
        
    case 'F4'
        fobj = @F4;
        lb=-10;
        ub=10;
        dim=d;
        

        
    case 'F5'
        fobj = @F5;
        lb=-1.28;
        ub=1.28;
        dim=d;
        
        
    case 'F6'
        fobj = @F6;
        lb=-1;
        ub=1;
        dim=d;
        
    case 'F7'
        fobj = @F7;
        lb=-10;
        ub=10;
        dim=d;
                
    case 'F8'
        fobj = @F8;
        lb=-5;
        ub=10;
        dim=d;
    case 'F9'
        fobj = @F9;
        lb=-100;
        ub=100;
        dim=d;   
           
    case 'F10'
        fobj = @F10;
        lb=-5.12;
        ub=5.12;
        dim=d;
        
    case 'F11'
        fobj = @F11;
        lb=-5.12;
        ub=5.12;
        dim=d;
        
    case 'F12'
        fobj = @F12;
        lb=-50;
        ub=50;
        dim=d;
        
    case 'F13'
        fobj = @F13;
        lb=-600;
        ub=600;
        dim=d;
        
    case 'F14'
        fobj = @F14;
        lb=-10;
        ub=10;
        dim=d;     
        
    case 'F15'
        fobj = @F15;
        lb=-10;
        ub=10;
        dim=d;    
        
    case 'F16'
        fobj = @F16;
        lb=-5;
        ub=5;
        dim=d;    
        
    case 'F17'
        fobj = @F17;
        lb=-2;
        ub=2;
        dim=d;  
    case 'F18'
        fobj = @F18;
        lb=[-5,0];
        ub=[10,15];
        dim=2;  

end
end

function o = F1(x)
o=sum(x.^2);
end
   

function o = F2(x)
o=sum(abs(x))+prod(abs(x));
end


function o = F3(x)
dim=size(x,2);
o=0;
for i=1:dim
    o=o+sum(x(1:i))^2;
end
end


function o = F4(x)
o=max(abs(x));
end 


function o = F5(x)
dim=size(x,2);
o=sum((1:dim).*(x.^4))+rand;
end



function o = F6(x)
dim=size(x,2);
o=0;
for i=1:dim
     o=o+(abs(x(i))^(i+1));
end
end


function o = F7(x)
dim=size(x,2);
o=0;
for i=1:dim
    o=o+i*x(i)^2;
end
end


function o = F8(x)
D = size(x,2);
o = sum(x.^2)+sum(0.5*D*(x.^2))+sum(0.5*D*(x.^4));
end


function o = F9(x)
dim=size(x,2);
o=sum(0.5*dim*x.^4)+rand;
end

function o = F10(x)
dim=size(x,2);
 o=sum(x.^2-10*cos(2*pi.*x))+10*dim;

end


function o = F11(x)
dim=size(x,2);
o=0;
for i=1:dim
    if abs(x(i))<0.5
         o=o+x(i)^2-10*cos(2*pi*x(i))+10;
    else
         o=o+(round(2*x(i))/2)^2-10*cos(2*pi*round(2*x(i))/2)+10;
    end
end
end


function o = F12(x)
dim=size(x,2);
o=-20*exp(-.2*sqrt(sum(x.^2)/dim))-exp(sum(cos(2*pi.*x))/dim)+20+exp(1);
end


function o = F13(x)
dim=size(x,2);
o=sum(x.^2)/4000-prod(cos(x./sqrt(1:dim)))+1;
end


function o = F14(x)
o=sum(abs(x.*sin(x)+0.1.*x));

end


function o = F15(x)
dim=size(x,2);

a = 0.5; 
b = 3;
kmax = 20;

c1(1:kmax+1) = a.^(0:kmax);
c2(1:kmax+1) = 2*pi*b.^(0:kmax);
o=0;
for i=1:dim
o=o+w(x(:,i)',c1,c2);
end

function y = w(x,c1,c2)
y = zeros(length(x),1);
for k = 1:length(x)
	y(k) = sum(c1 .* cos(c2.*(x(:,k)+0.5)))-k*sum(c1 .* cos(c2*0.5));
end
end
end


function o = F16(x)
o=1-cos(2*pi*sqrt(sum(x.^2)))+0.1*sum(x.^2);
end


function o = F17(x)
dim=size(x,2);
o=0;
for i=1:dim-1
o=o+x(i)^2+2.*x(i+1)^2-0.3*cos(2*pi*x(i))-0.4*cos(4*pi*x(i+1))+0.7;
end
end

function o=Ufun(x,a,k,m)
o=k.*((x-a).^m).*(x>a)+k.*((-x-a).^m).*(x<(-a));
end


function o = F18(x)
o=(x(2)-(x(1)^2)*5.1/(4*(pi^2))+5/pi*x(1)-6)^2+10*(1-1/(8*pi))*cos(x(1))+10;
end




