clear;clc
a=[0.047656932
0.065765629
0.045499647
0.0472921
0.0419097
0.0328286
0.0431871
0.0395712
0.0414236
0.039825
]'
n=length(a);
k=1:n;
b=zeros(1,n);
b(1)=a(1);
for i=2:n
    b(i)=b(i-1)+a(i)
end

for i=1:(n-1)
    b1(i)=a(i+1)+b(i)
end

c=0.7;
coun=0;
for i=1:(n-1)
    if b1(i)<0.6
        coun=coun+1;
    end
end

if(coun/(n-1))>0.7
disp('The data is smooth')
else
    disp('NO')
end
b2=zeros(1,n-1);
for i=2:n
    b2(i-1)=0.5*b(i-1)+0.5*b(i)
end
A=[(-b2)',ones(n-1,1)]
Y=a(2:n)'
b3=zeros(2,1);
b3=inv(A'*A)*(A'*Y)
b4=zeros(1,n+6);
b4(1)=b(1);
for i=2:n+6
    b4(i)=(b(1)-b3(2)/b3(1))*exp(-b3(1)*(i-1))+b3(2)/b3(1)
end
b5=zeros(1,n+6)
b5(1)=b4(1)
for i=2:n+6
    b5(i)=b4(i)-b4(i-1)
end
m=b5'