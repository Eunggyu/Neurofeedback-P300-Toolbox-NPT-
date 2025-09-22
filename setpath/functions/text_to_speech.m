function text_to_speech(Text,Pace,Language)
% text_to_speech - convert text to speech
%
% Usage:
%   TextToSpeech = text_to_speech(Text,Pace,Language)
%
%
% Inputs:
%   Text
%   Pace - speech pace
%   Language - installed languages on the computer
%
% outputs:
%
%
%%
NET.addAssembly('System.Speech');
Speaker = System.Speech.Synthesis.SpeechSynthesizer;
Speaker.Volume = 100;
Speaker.Rate = Pace;

% % Check installed languages on the computer
% voices = Speaker.GetInstalledVoices;
% for i = 1 : voices.Count
%     voice = Item(voices,i-1);
%     voice.VoiceInfo.Name
% end

Speaker.SelectVoice(Language)
Speak(Speaker, Text)

end
