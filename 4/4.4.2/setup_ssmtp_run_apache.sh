#!/bin/bash
#overwrite the ssmtp-conf and then start apache
rm -f /etc/ssmtp/ssmtp.conf
echo mailhub=${SMTP_MAILHOST}:${SMTP_PORT} >> /etc/ssmtp/ssmtp.conf
echo root=${SMTP_ROOT} >> /etc/ssmtp/ssmtp.conf
echo AuthUser=${SMTP_USER} >> /etc/ssmtp/ssmtp.conf
echo AuthPass=${SMTP_PASS} >> /etc/ssmtp/ssmtp.conf
echo UseTLS=${SMTP_USE_TLS} >> /etc/ssmtp/ssmtp.conf
echo UseSTARTTLS=${SMTP_USE_STARTTLS} >> /etc/ssmtp/ssmtp.conf
echo FromLineOverride=${SMTP_FROM_OVERRIDE} >> /etc/ssmtp/ssmtp.conf
echo hostname=${SMTP_HOSTNAME} >> /etc/ssmtp/ssmtp.conf

#we might need to change the user id for www-data,
#to allow www-data to write to the shared host volume during dev
if [ $CHANGE_USER_ID = "Yes" ]; then
	usermod -u ${WWW_DATA_USER_ID} www-data
fi

#change user back to www-data for linked volume
chown www-data /var/www/html/sites -R

apache2-foreground