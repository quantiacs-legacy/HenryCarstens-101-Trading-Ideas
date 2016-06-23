function [p, settings] = Carstens_Illustration7(DATE, OPEN, HIGH, LOW, CLOSE, exposure, settings)
settings.markets     = {'CASH','F_NG', 'F_CL'};
settings.budget      = 1000000;
settings.slippage    = 0.0;
settings.samplebegin = 20040101;
settings.sampleend   = 20200101;
settings.lookback    = 504;

if ~any(strcmp('long',fieldnames(settings)))
    settings.long = 0;
    settings.short = 0;
end

p = zeros(1,numel(settings.markets));

holding = 4;

if settings.short ~= 0
    settings.short = rem(settings.short,holding) + 1;
    p(1) = 0;
    p(2) = -1;
end
if settings.short == 0 || settings.short == 4
    p(1) = 1;
    p(2) = 0;
    settings.short = 0;
end
if settings.long ~= 0
    settings.long = rem(settings.long,holding) + 1;
    p(1) = 0;
    p(2) = 1;
end
if settings.long == 0 || settings.long == 4
    p(1) = 1;
    p(2) = 0;
    settings.long = 0;
end

% closeRange = cummax(CLOSE(end-3:end,2));
atr9 = ATR(HIGH, LOW, CLOSE, 9);
atr1 = ATR(HIGH, LOW, CLOSE, 1);

LongRule1 = atr9(2) < atr1(2);
LongRule2 = CLOSE(end,2) <= min(CLOSE(end-8:end,2));
LongRule3 = CLOSE(end,3) > CLOSE(end-8,3);

ShortRule1 = atr9(2) < atr1(2);
ShortRule2 = CLOSE(end,2) >= max(CLOSE(end-8:end,2));
ShortRule3 = CLOSE(end,3) < CLOSE(end-8,3);

if LongRule1 && LongRule2 && LongRule3
    p(1) = 0;
    p(2) = 1;
    settings.long = rem(settings.long,holding) + 1;
    settings.short = 0;
end
if ShortRule1 && ShortRule2 && ShortRule3
    p(1) = 0;
    p(2) = -1;
    settings.short = rem(settings.short,holding) + 1;
    settings.long = 0;
end

end

function out = ATR(fieldHigh, fieldLow, fieldClose, period)
tr = TR(fieldHigh,fieldLow,fieldClose);
out = mean(tr(end-period+1:end,:),1);
end

function out = TR(fieldHigh, fieldLow, fieldClose)
fieldCloseLag = LAG(fieldClose,1);

range1 = fieldHigh - fieldLow;
range2 = abs(fieldHigh-fieldCloseLag);
range3 = abs(fieldLow -fieldCloseLag);

out = max(max(range1,range2),range3);
end

function out = LAG(field, period)
nMarkets = size(field,2);
out = [nan(period,nMarkets); field(1:end-period,:)];
end
