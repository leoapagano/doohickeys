# sendmail-py

A simple Python script I wrote to automatically send emails to myself via SendGrid's API.

You may find this particularly useful for sending server messages/alerts, automatic messages, reminders, and more. Please don't use this to spam other people.

Before you can start, you will need to [sign up for SendGrid](https://sendgrid.com/pricing/) (full disclosure: you need a valid non-VoIP phone number) and [grab an API key](https://app.sendgrid.com/settings/api_keys). You'll also need to set up the email address you'd like to send with, and [verify your domain](https://www.twilio.com/docs/sendgrid/ui/account-and-settings/how-to-set-up-domain-authentication).

To setup;

```sh
$ echo "export SENDMAIL_PY_API_KEY='SG.YOUR.API-KEY'" >> ~/.bashrc
$ echo "export SENDMAIL_PY_SRC_ADDR='noreply@yourdomain.com'" >> ~/.bashrc
$ echo "export SENDMAIL_PY_DEST_ADDR='you@yourdomain.com'" >> ~/.bashrc
$ source ~/.bashrc
```

To run;

```sh
$ python3 ./sendmail.py "Subject" "Message"
```

Messages should be HTML-formatted (though plaintext also works). You can set a custom header and footer to use when sending emails, via the `email_template(msg)` function.

### Tools Used

- Python
- REST APIs
- SendGrid