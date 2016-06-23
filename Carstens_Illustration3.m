function [p, settings] = Carstens_Illustration3(DATE, OPEN, HIGH, LOW, CLOSE, exposure, settings)

settings.markets     = {'CASH', 'F_CL'};
settings.budget      = 1000000;
settings.slippage    = 0.0;
settings.samplebegin = 20040101;
settings.sampleend   = 20140101;
settings.lookback    = 504;

p = zeros(1,numel(settings.markets));

formatDate = datenum(num2str(DATE(end)),'yyyymmdd');
dayOfWeek = weekday(formatDate);
if dayOfWeek ~= 2
    p(:) = 0;

else
    closeRange = max(CLOSE(end-3:end,2)) - min(CLOSE(end-3:end,2));
    atr = ATR(HIGH, LOW, CLOSE, 4);

    LongRule1 = CLOSE(end,2) < CLOSE(end-1,2) && closeRange < atr(2);
    ShortRule1 = CLOSE(end,2) > CLOSE(end-1,2) && closeRange < atr(2);

    if LongRule1
        p(1) = 0;
        p(2) = 1;
    end

    if ShortRule1
        p(1) = 0;
        p(2) = -1;
    end

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
