import smtplib
from email.mime.text import MIMEText
import os

full_path = os.path.realpath(__file__)
workdir = os.path.dirname(full_path)
os.chdir(workdir)

def getlog():
	os.system("tail -n 4 ../log/xlog_location.log > attachment/xlog_location")
getlog()

with open('attachment/xlog_location') as fp:
	msg = MIMEText(fp.read())
sender = 'noreply@daksa.co.id'
recipients = ['ade.mahmud@daksa.co.id','ahmadgfari@gmail.com']
#recipients = ['ade.mahmud@daksa.co.id']
msg['Subject'] = "[INFO]PostgreSQL Replication Status"
msg['From'] = sender
msg['To'] = ", ".join(recipients)

# Credentials (if needed)
username = 'username'
password = 'password'

# The actual mail send
s = smtplib.SMTP('smtp.gmail.com:587')
#server.ehlo()
s.starttls()
s.login(username,password)
s.set_debuglevel(0)
s.sendmail(sender, recipients, msg.as_string())
s.quit()

