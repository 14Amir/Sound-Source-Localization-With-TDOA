function [speaker] = position(x_mic,x_mic_norm , c , Toa2)
    %-----------------------------------------------------
    % [x,y,z] = estimate position of speaker
    % x_mic = position of microphone
    % c = speed of sound
    % Toa = delay matrix
    %------------------------------------------------------
    n_mic = length(x_mic);
    d = Toa2*c;
    x_speaker = zeros(3,n_mic);
    speaker_position = zeros(3,n_mic);
%     speaker = zeros(3,1);
    for j=1:n_mic 
       A = x_mic-x_mic(j,:);
       Fi =[A(:,1:2) , d(:,j)];  % state number decreasing is very essential in result resolution
       b = 0.5*(x_mic_norm(:,j) - d(:,j).^2);
       a1=Fi'*Fi;
       a2=Fi';
       Fi_dager = a1\a2;
%        Fi_dager = inv(Fi'*Fi)*Fi';
       x_speaker(:,j) = Fi_dager*b;
       speaker_position(1,j) = x_speaker(1,j)+x_mic(j,1);
       speaker_position(2,j) = x_speaker(2,j)+x_mic(j,2);
       speaker_position(3,j) = abs(sqrt(x_speaker(end,j)^2 - x_speaker(1,j)^2 - x_speaker(2,j)^2));
    end
    
%     speaker = mean(speaker_position');
      speaker = mean(speaker_position,2);
    
end