cat /opt/logs/task/exchangerate-task.log > /opt/logs/task/exchangerate-1.mail
sed -i 's/\[DefaultQuartzScheduler_Worker-5] INFO  EXCHANGE_RATE - //g' /opt/logs/task/exchangerate-1.mail

MAILTO="kelvin.cheng@travelzen.com,vincent.yu@travelzen.com,alex.cheung@travelzen.com,eddie.lau@travelzen.com,gigi.lau@travelzen.com"
/usr/bin/mutt -s "Exchange Rate Update Log"  $MAILTO  -a /opt/logs/task/exchangerate-1.mail < /dev/null

grep 'outside acceptable range' /opt/logs/task/exchangerate-1.mail > /opt/logs/task/exchangerate-1.mailalert
if [ -s /opt/logs/task/exchangerate-1.mailalert ]; then
        MAILTO="cy.yip@travelzen.com,alex.cheung@travelzen.com,eddie.lau@travelzen"
        /usr/bin/mutt -s "Warning! - Exchange Rate Update Exception"  $MAILTO  -a /opt/logs/task/exchangerate-1.mailalert < /dev/null
fi
You have new mail in /var/spool/mail/root
