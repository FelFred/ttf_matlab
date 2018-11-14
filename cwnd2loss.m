function [loss,closs] = cwnd2loss(cwnd, time)
detected = 0;
m = 1;
loss = zeros(1,length(cwnd));
closs = zeros(1,length(cwnd));
for n=1:length(cwnd)-1
    if cwnd(n) < cwnd(n+1) % no loss
        detected = 0;
    elseif (cwnd(n) >= cwnd(n+1))&&(~detected) % loss
        loss(m) = time(n);
        closs(m) = cwnd(n);
        m=m+1;
        detected = 1;
    end
end
loss = loss(1:m-1);
closs = closs(1:m-1);