function PhaseLagIndexobject = PhaseLagIndex(Signal)
% Phase lag index
%
% Usage:
%   PhaseLagIndexobject = PhaseLagIndex(Signal)
%
%
% Inputs:
%   Signal = Signal matrix
%
% Outputs:
%   PhaseLagIndexobject - update the Phase Lag Index Biomarker
%
% Example:
%    PhaseLagIndexobject = PhaseLagIndex(Signal)
%
%
%% Initialize the biomarker object
numChannels = size(Signal,2);
PhaseLagIndexobject.PLI = nan(numChannels);
phaseSignal = angle(hilbert(Signal));

for i = 1:(numChannels-1)
    for m = (i+1):numChannels
        % See Stam et al, Hum Brain Mapp. 2007 Nov;28(11):1178-93. https://www.ncbi.nlm.nih.gov/pubmed/17266107
        % Equation 6
        PhaseLagIndexobject.PLI(i,m) = abs(mean(sign(sin(phaseSignal(:,i)-phaseSignal(:,m)))));
    end
end

pli = PhaseLagIndexobject.PLI;
pli = triu(pli);
pli = pli+pli';
pli(eye(size(pli))~=0)=1.001;
PhaseLagIndexobject.PLI = pli;

for i=1:numChannels
    pli_chan = pli(i,:);
    PhaseLagIndexobject.Median(i) = median(pli_chan(pli_chan ~= 1));
    PhaseLagIndexobject.Mean(i) = mean(pli_chan(pli_chan ~= 1));
    PhaseLagIndexobject.IQR(i) = iqr(pli_chan(pli_chan ~= 1));
    PhaseLagIndexobject.Std(i) = std(pli_chan(pli_chan ~= 1));
end
end
