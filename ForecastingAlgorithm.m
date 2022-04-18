dataMaxDay = 375;
predictData = 365;
 
 
file1 = ARCLKGemiVerileri1(1:dataMaxDay,1:1);  %loading data using matlab import data.
fullgraph = flip(file1);  %reverse data if dates are reversed.
prices = fullgraph;
 
day = 1:predictData;
 
polynom = polyfit(day',prices(1:predictData),3);    %get 3rd degree polyfit
alldays = (1:1:dataMaxDay)';             % How much day will be used?
eveluatedPolynom=polyval(polynom,alldays);
 
 
difference = prices(1:predictData) - eveluatedPolynom(1:predictData);   % Smoothed curve
FFTResult = fft(difference);
 
 
for n=(predictData+1):dataMaxDay
    interpolation(n)=0;
        for k=1:predictData
            a(k)=real(FFTResult(k));       % Using polynom interpolation to predict future values.
            b(k)=-imag(FFTResult(k));
            const=2*pi*(k-1)/predictData;
            interpolation(n)=interpolation(n)+a(k)*cos(const*(n))+b(k)*sin(const*(n));
           end
    interpolation(n)=-interpolation(n)/predictData;
end
 
 
for i=1:predictData;   % remaking first 365 day same with original values.
    interpolation(i)=difference(i);
end
 
finalResult = eveluatedPolynom + interpolation';  % Making interpolation result smoother using polynomial curve.
plot(alldays, prices,'g')
hold on
plot(alldays,finalResult,'r')
xlabel('Days');
ylabel('Price');
title('Price Of Data And Prediction');
legend({'Original Price','Prediction Price'},'Location','northeast')
hold off
