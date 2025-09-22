function CorrelationsObject=Correlations(Signal)
% Coherence - computes correlations between the signals in the Signal
% matrix
%
% Usage:
%   CorrelationsObject = Correlations(Signal)
%
%
% Inputs:
%   Signal = Signal matrix
%
% Outputs:
%   CorrelationsObject - update the Correlations Biomarker
%
% Example:
%    Correlations = Coherence(Signal)
%
%
%% assigning fields:

type='Pearson';% 'Pearson' (the default) to compute Pearson's linear
% correlation coefficient, 'Kendall' to compute Kendall's
% tau, or 'Spearman' to compute Spearman's rho.

disp(' ')
disp('Command window code:')
disp('CorrelationsObject = Correlations(Signal)')
disp(' ')

%% Compute correlations
[R,P]=corr(Signal,'type',type);
% s=size(R,2);
% R(1:s+1:s*s) = NaN;
% P(1:s+1:s*s) = NaN;

CorrelationsObject.Corr = R;
CorrelationsObject.P_value = P;
end
