import smtplib
from email.mime.text import MIMEText

msg = MIMEText("""Replication status = FAILED""")
sender = 'failednoreply'
recipients = ['ade.mahmud@daksa.co.id','ahmadgfari@gmail.com']
msg['Subject'] = "[FAILED]PostgreSQL Replication Status"
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

