### Perk: only uses builtin modules!
import http.client
import json
import os
import sys



### Optional: Define an HTML-formatted message template, with a header and footer
def email_template(msg):
	# To bypass this, uncomment;
	# return msg
	return f"""The following is a message from:
<pre style="font-size: 12px;">{os.uname()[1]}</pre>
<br>
{msg}
<br>
<br>
<pre style="font-size: 12px;">
(_)(_)      (_)(_)               (_)(_)(_) 
(_)  (_)  (_)  (_)              (_)        
(_)  (_)  (_)  (_)  (_)  (_)(_)  (_)(_)(_) 
(_)  (_)  (_)  (_)  (_)(_)              (_)
(_)(_)      (_)(_)  (_)          (_)(_)(_) 
(_)            (_)  (_)                    
(_)            (_)  (_)                   
</pre>"""



### API call to SendGrid abstractor
def send_email(subject, message):
	# Open connection
    conn = http.client.HTTPSConnection("api.sendgrid.com")

	# Compose HTTP request
    headers = {
        "Authorization": f"Bearer {os.environ['SENDMAIL_PY_API_KEY']}",
        "Content-Type": "application/json"
    }
    json_data = json.dumps({
        "personalizations": [
            {
                "to": [
                    {
                        "email": os.environ['SENDMAIL_PY_DEST_ADDR']
                    }
                ],
                "subject": subject
            }
        ],
        "from": {
            "email": os.environ['SENDMAIL_PY_SRC_ADDR']
        },
        "content": [
            {
                "type": "text/html",
                "value": email_template(message)
            }
        ]
    })

	# Send it out
    conn.request("POST", "/v3/mail/send", json_data, headers)

	# Get response from SendGrid
    response = conn.getresponse()
    print(f"Response status: {response.status}")
    if response.status == 202:
        print("Sent!")
    else:
        print(f"Failed to send email: {response.status}")
        print(response.read().decode())

	# Close connection
    conn.close()



### Run from terminal
if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("Usage: python3 ./sendmail.py subject message")
	else:
		send_email(sys.argv[1], sys.argv[2])