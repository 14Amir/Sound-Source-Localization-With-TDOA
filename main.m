clc;
clear;
close all;

c = 343; %speed of sound
R = 0.2; %distance between Microphone[meter] 
x1 = [0, 0, 0]; %refrence microphone(middle of Regular hexagon)
x2 = [R, 0, 0];
x3 = [R*cos(pi/3), R*sin(pi/3), 0];
x4 = [-R*cos(pi/3), R*sin(pi/3), 0];
x5 = [-R, 0, 0];
x6 = [-R*cos(pi/3), -R*sin(pi/3), 0];
x7 = [R*cos(pi/3), -R*sin(pi/3), 0];
x_mic = [x1;x2;x3;x4;x5;x6;x7];
x_mic_norm = zeros(length(x_mic));
for i=1:length(x_mic)
    A = x_mic-x_mic(i,:);
    x_mic_norm(:,i) =  vecnorm(A')'.^2;
end

n_mic = length(x_mic(:,1));
X = normrnd(2,0.6, 1,3);   % position of speaker

tmp = struct2array(load('sound.mat'));
data = tmp(2:end); %sound data

% figure(1)
% plot(data)

Fs = tmp(1); % sampling rate

Toa =  round(vecnorm((X - x_mic)')*Fs/c) ; % difference distance between speaker and 
% mics in sample unit


%------------------------------------------------------
h = zeros(length(data) , n_mic);
for i=1:n_mic
   h(Toa(i),i) = 0.1; % transformation function for attenuation and difference in phase of mics
end
mic_capture = zeros(2*length(data)-1 , n_mic);
for i=1:n_mic
    mic_capture(:,i) = conv(data,h(:,i));
end

% figure(2)
% for i=1:n_mic
% subplot(n_mic,1,i);
% plot(mic_capture(:,i))
% end

% dly_max = max(Toa);
% mic_capture = zeros(length(data)+dly_max , length(X_mic'));
% for i=1:length(Toa)
%     mic_capture(:,i) = [zeros(Toa(i),1); data;
%                         zeros(dly_max - Toa(i),1) ]; 
% end

power = rms(mic_capture).^2; %average power 
% delay and attenuation which applied to mics signals are identical so
% powers are identical too.
p_db = db(power)/2;
p_noise = p_db-45;
noise = wgn(length(mic_capture) , length(mic_capture(1,:)),p_noise(1));
mic_capture_noise = noise + mic_capture;

% plot(mic_capture_noise);hold on;plot(data)

N = length(mic_capture_noise);
f = (-N/2:N/2-1)*(Fs/N);
Yf = fftshift(fft(mic_capture));
Yf_noise = fftshift(fft(mic_capture_noise));




%%
% for understanding this segment check xcorr help page.
% this segment give us delay between mics 
tic;
Toa2 = zeros(n_mic);

% interp multiply Fs by the number we call it  
% for i=1:7
%     mic_capture_noise2(:,i) = interp(mic_capture_noise(:,i),4);
% end
for i=1:n_mic
    for j=1:n_mic
        [y,l] = xcorr(abs(mic_capture_noise(:,i)) , abs(mic_capture_noise(:,j)));
        [~, a] = max(y);
        Toa2(i,j) = l(a);
    end
end
Toa2=Toa2/Fs; % Toa2 converted from sample to seconds
toc;

%%
clc
clear;
close all;

N = 50;
X2 = zeros(N,3);
speaker2 = zeros(N,3);
for ii=1:N
    
    temp;
    speaker_position = position(x_mic,x_mic_norm , c , Toa2/Fs*c);
    X2(ii,:) = X;
    speaker2(ii,:) = mean(speaker_position');
end

error = mean((X2 - speaker2).^2);
