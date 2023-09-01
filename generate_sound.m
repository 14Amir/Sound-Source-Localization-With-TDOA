clc;
clear;
close all;

Fs = 100000;
rec = audiorecorder(Fs,24,1);
recordblocking(rec,0.1);
y = getaudiodata(rec);

% [y , Fs] = audioread('test.m4a');
% y = y(:,1); % get the fist channel information
data = [Fs;y]; % insert the sampling rate in the first member
filename = 'sound.mat';
save(filename , 'data');
plot(y)