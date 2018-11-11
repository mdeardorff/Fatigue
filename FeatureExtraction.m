data = importdata("R041.mat");

[aFeatures,iFeatures,uFeatures] = processSubject(data);

%each feature matrix is 55x(#features * 4), as each emg has unique
%features. Maybe we'd want to average/normalize these somehow.
function [aFeatures,iFeatures,uFeatures] = processSubject(subject)
%I feel like an idiot for not being able to reduce this. If you can think
%of how to do the for loop for the 4 emgs, please fix this
aFeatures = [];
aFeatures1 = [];
aFeatures2 = [];
aFeatures3 = [];
aFeatures4 = [];
iFeatures = [];
iFeatures1 = [];
iFeatures2 = [];
iFeatures3 = [];
iFeatures4 = [];
uFeatures = [];
uFeatures1 = [];
uFeatures2 = [];
uFeatures3 = [];
uFeatures4 = [];
for i = 1:size(subject{1,2}{1,5},1)
    aFeatures1 = vertcat(aFeatures1, extract(subject{1,2}{1,1}(i,:)));
    aFeatures2 = vertcat(aFeatures2, extract(subject{1,2}{1,2}(i,:)));
    aFeatures3 = vertcat(aFeatures3, extract(subject{1,2}{1,3}(i,:)));
    aFeatures4 = vertcat(aFeatures4, extract(subject{1,2}{1,4}(i,:)));
    aFeatures = [aFeatures1,aFeatures2,aFeatures3,aFeatures4];
    
    iFeatures1 = vertcat(iFeatures1, extract(subject{1,3}{1,1}(i,:)));
    iFeatures2 = vertcat(iFeatures2, extract(subject{1,3}{1,2}(i,:)));
    iFeatures3 = vertcat(iFeatures3, extract(subject{1,3}{1,3}(i,:)));
    iFeatures4 = vertcat(iFeatures4, extract(subject{1,3}{1,4}(i,:)));
    iFeatures = [iFeatures1,iFeatures2,iFeatures3,iFeatures4];
    
    uFeatures1 = vertcat(uFeatures1, extract(subject{1,4}{1,1}(i,:)));
    uFeatures2 = vertcat(uFeatures2, extract(subject{1,4}{1,2}(i,:)));
    uFeatures3 = vertcat(uFeatures3, extract(subject{1,4}{1,3}(i,:)));
    uFeatures4 = vertcat(uFeatures4, extract(subject{1,4}{1,4}(i,:)));
    uFeatures = [uFeatures1,uFeatures2,uFeatures3,uFeatures4];
    
end


end

function features = extract(signal)
workingMean = mean(signal);
%Standard Deviation
standardDeviation = std(signal);
%Integrated EMG -- I think this one's right?
iemg = cumtrapz(signal);
iemg = iemg(end);
%Mean Absolute Value;
mav = abs(workingMean);
%Root Mean Squared -- same as std?
rootMS = rms(signal);
%Kurtosis 
kurt = kurtosis(signal);
%Skewness
skew = skewness(signal);
%Max amplitude
mAmp = max(signal);
%I give up
y = fft(signal);
f = (0:length(y) -1)*4000/length(y);
%plot(f,abs(y));
[pks,locs] = findpeaks(abs(y));
A = pks > 10;
freqs = locs(A);
features = [workingMean,standardDeviation,iemg,mav,rootMS,kurt,skew,mAmp];
end