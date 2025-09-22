function CoherenceObject = Coherence(Signal,Fs,FrequencyBand)
% Coherence - compute coherence among channels for a given frequency
% range
%
% Usage:
%   CoherenceObject = Coherence(Signal,Fs,FrequencyBand)
%
%
% Inputs:
%   Signal
%   Fs
%   FrequencyBand - vector of dimension 1x2, i.e. [8 13]
%   interval (x) - vector of dimension 1x2, express the time interval (in sec) one wants
%                  to analyse, i.e. [0 100]
%                  warning: the length of the signal must be >> (2?9*Fs)
%                  length in sec of the hamming window used to compute the coherence
%
% Outputs:
%   CoherenceObject - update the Coherence Biomarker
%
% Example:
%    Coherence8_13Hz = Coherence(Signal,Fs,[8 13])
%
%
%
%% input checks
narginchk(3,3)

%% give information to the user
disp(' ')
disp('Command window code:')
disp('CoherenceObject = Coherence(Signal,Fs,FrequencyBand,interval)')
disp(' ')

%% Compute markervalues. Add here your algorithm to compute the biomarker
%--- window function
% WinTime = 2;
% W_length = round(WinTime*Fs);
W_length = round(size(Signal,1)/8);
W = hamming(W_length);
NoverLap = floor(0.5*W_length);
nFFT = 2^nextpow2(W_length*2);
% if length(Signal(:,1))<= W_length
%     error(['The time interval is too short. The minimum time interval for this signal = is )' num2str(round(W_length/Fs))])
% end
%--- extract frequency vector f from coherence function
[~,f]=mscohere(Signal(:,1), Signal(:,1), W, NoverLap, nFFT, Fs);
% assignin("base","f",f)
Index = find(f>= FrequencyBand(1,1) &  f<= FrequencyBand(1,2));
FrequencyIndex= [Index(1) Index(end)];
% assignin("base","FrequencyIndex",FrequencyIndex)
%--- compute coherence matrix
CoherenceMatrix = nan(size(Signal(:,:),2),size(Signal(:,:),2));
ICoherenceMatrix = nan(size(Signal(:,:),2),size(Signal(:,:),2));
disp([' Frequency band ', num2str(FrequencyBand(1,1)), '-', num2str(FrequencyBand(1,2)),' Hz'])

try
    for i=1:size(Signal(:,:),2)
        disp([' channel ', num2str(i), ' ...'])
        [Pxx] = cpsd(Signal(:,i), Signal(:,i), W, NoverLap, W_length, Fs);
        for j=i+1:size(Signal(:,:),2)
            [Pyy] = cpsd(Signal(:,j), Signal(:,j), W, NoverLap, W_length, Fs);
            [Pxy] = cpsd(Signal(:,i), Signal(:,j), W, NoverLap, W_length, Fs);
            Cxy=Pxy./sqrt(Pxx.*Pyy);
            Coh  = (abs(Cxy)).^2;

            ICoh = (imag(Cxy)).^2;
            % mean of the coherence function is computed along each
            % frequency band
            Coh = 0.5*log((1+Coh)./(1-Coh)); %first do Fisher's Z
            CoherenceMatrix(i,j) = mean(Coh(FrequencyIndex(1):FrequencyIndex(2)));
            CoherenceMatrix(i,j) = (exp(2*CoherenceMatrix(i,j))-1)./(exp(2*CoherenceMatrix(i,j))+1); %now do an inverse-Fisher's Z to transform back to coherence
            ICoh = 0.5*log((1+ICoh)./(1-ICoh)); %first do Fisher's Z
            ICoherenceMatrix(i,j) = mean(ICoh(FrequencyIndex(1):FrequencyIndex(2)));
            ICoherenceMatrix(i,j) = (exp(2*ICoherenceMatrix(i,j))-1)./(exp(2*ICoherenceMatrix(i,j))+1); %now do an inverse-Fisher's Z to transform back to coherence
        end
    end
catch Er
    fprintf('Unable to process the Coherence Matrix \n');
    rethrow(Er)
end

CoherenceObject.Coher = CoherenceMatrix;
CoherenceObject.ICoher = ICoherenceMatrix;
CoherenceObject.Coher = triu(CoherenceObject.Coher);
CoherenceObject.Coher = CoherenceObject.Coher + CoherenceObject.Coher';
CoherenceObject.Coher(eye(size(CoherenceObject.Coher))~=0)=1;
CoherenceObject.ICoher = triu(CoherenceObject.ICoher);
CoherenceObject.ICoher = CoherenceObject.ICoher + CoherenceObject.ICoher';
CoherenceObject.ICoher(eye(size(CoherenceObject.ICoher))~=0)=1;

end

