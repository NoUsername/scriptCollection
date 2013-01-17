#!/usr/bin/env python
'''
Simple tool to send files (or just text) via gmail.
Can be used as a commandline tool (e.g. from other scripts).

@author: Paul Klingelhuber www.paukl.at
'''
import smtplib,email,email.encoders,email.mime.text,email.mime.base
import os
import sys

class SimpleMailer(object):
    '''
    simple interface for sending emails via smtp
    '''

    def __init__(self, username="user", password="pass"):
        '''
        Constructor
        '''
        self.username = username
        self.password = password
        
    def send(self, to="", subject="", content="test content", attachment=""):
        msg = email.MIMEMultipart.MIMEMultipart('alternative')
        msg['Subject'] = subject
        msg['To'] = to
        
        html = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" '
        html +='"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">'
        html +='<body style="font-size:12px;font-family:Verdana"><p>'+content+'</p>'
        html += "</body></html>"
        
        msg.attach(email.mime.text.MIMEText(html, 'html'))
        
        if attachment != "":
            fileMsg = email.mime.base.MIMEBase('application','octet-stream')
            fileMsg.set_payload(file(attachment, 'rb').read())
            email.encoders.encode_base64(fileMsg)
            fileMsg.add_header('Content-Disposition','attachment;filename=' + os.path.basename(attachment))
            msg.attach(fileMsg)
        
        server = smtplib.SMTP('smtp.gmail.com:587')
        server.ehlo()
        server.starttls()
        server.ehlo()
        server.login(self.username, self.password)
        try:
            server.sendmail(self.username, to, msg.as_string())
        except:
            print("an error occured while sending mail!")
            return False
        server.quit()
        print "sent!"
        return True

def readUserInput():
    x = raw_input()
    result = ""
    while x != "":
        result = result + "\r\n" + x
        try:
            x = raw_input()
        except (EOFError):
            x = ""
    return result

if __name__=='__main__':
    try:
        import SimpleMailerConf as conf
    except:
        print "error, config file does not exist!"
        print "creating dummy config, please fill out the information in SimpleMailerConf.py"
        with open('SimpleMailerConf.py', 'w') as f:
            f.write("GMAIL_ACCOUNT='YOUR_GMAIL_ADDRESS_HERE@gmail.com'\n")
            f.write("GMAIL_PASSWORD='YOUR_GMAIL_PASSWORD_HERE'\n")
        sys.exit(1)
    if [match for match in [conf.GMAIL_ACCOUNT, conf.GMAIL_PASSWORD] if 'YOUR_GMAIL_' in match]:
        print "you have to change the dummy values in SimpleMailerConf.py to your login information, otherwise it won't work. I mean it!"
        sys.exit(1)
    m = SimpleMailer(conf.GMAIL_ACCOUNT, conf.GMAIL_PASSWORD)

    filename = ""
    content = "see attachment"
    subj = "backup"
    to = ""
    if len(sys.argv)<2:
        print "pass an email address as argument to get to input mode or an email address and a filename to just send off a file"
        print ""
        print "example usage input mode:"
        print "  SimpleMailer.py recipient@gmail.com"
        print ""
        print "example usage attachment mode:"
        print "  SimpleMailer.py recipient@gmail.com attachThisFile.jpg"
        print ""
        sys.exit(1)
        
    to = sys.argv[1]
    if len(sys.argv) == 2:
        subj = "info"
        print "enter your message, finish by entering an empty line"
        content = readUserInput()
        content = content.replace("\r\n", "\n").replace("\n", "<br/>\n")
    if len(sys.argv) > 2:
        filename = sys.argv[2]

    print "sending " + filename
    print m.send(to=to, subject=subj, content=content, attachment=filename)