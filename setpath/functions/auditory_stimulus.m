function auditory_stimulus(soundPace, rampDur, stimulusFs)
% auditory_stimulus - generate pure tone stimulus
%
% Usage:
%   auditoryStimulus = auditory_stimulus(soundPace, rampDur, stimulusFs)
%
%
% Inputs:
%   soundPace - pace of pure tone stimulus
%   rampDur - duration of pure tone stimulus
%   stimulusFs - frequency of pure tone stimulus
%
% outputs:
%
%
%%
sound_fs = 44100;
sound_t = 1/sound_fs;

sound_data = 0:sound_t:soundPace-1*sound_t;
Sound = sin(2*pi*stimulusFs*sound_data);

rampSamps = floor(sound_fs*rampDur);
window = hanning(2*rampSamps)';
w1 = window(1:ceil((length(window))/2));
w2 = window(ceil((length(window))/2)+1:end);
w1 = [w1 ones(1,length(Sound)-length(w1))];
w2 = [ones(1,length(Sound)-length(w2)) w2];

ramped_Sound = Sound.*w1.*w2;
soundsc(ramped_Sound,sound_fs);

end
