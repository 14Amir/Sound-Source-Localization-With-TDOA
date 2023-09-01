function [x_mic,x_mic_norm , X , Toa] = speaker_simu(c)
    %-------------------------------------------------------------------
    %this function simulate the delay between each microphone
    % x_mic is position of each microphon
    % X position of speaker
    % Toa is delay matrix(sec)
    % c is speed of sounds
    %-------------------------------------------------------------------
    %position of microphone
    R = 0.02; %distance between Microphone[meter] 
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

    %position of speaker
    X = [5,-1,2]; %[x,y]
    %obtain the ideal toa
    r = zeros(length(x_mic),1);
    for i=1:length(x_mic)
        r(i) = norm(x_mic(i,:)-X);
    end
    %delay Matrix([Toa] = (second))
    Toa = (r-r')/c;
end