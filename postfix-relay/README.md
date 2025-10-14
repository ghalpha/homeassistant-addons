# Home Assistant Add-on: Postfix Relay

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

A simple Postfix SMTP relay for sending emails from Home Assistant and other services.

## About

This addon provides a lightweight SMTP relay server that allows Home Assistant and other services on your network to send emails through an external SMTP provider (Gmail, Outlook, SendGrid, etc.). This is useful for:

- 📧 Sending Home Assistant notifications via email
- 🔔 Forwarding alerts from various services
- 📊 Receiving reports and summaries
- 🚨 Security and monitoring alerts

**Why use a relay instead of direct SMTP?**
- Centralized email configuration
- Single point of authentication
- Multiple services can use the same relay
- Better security (credentials stored once)
- Easier troubleshooting

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Postfix Relay" add-on and click it
4. Click on the "INSTALL" button

## How to Use

### Quick Start

1. Configure the addon with your SMTP provider details (see examples below)
2. Start the addon
3. Configure Home Assistant to use `localhost:587` as SMTP server
4. Send a test email!

### Configuring Home Assistant to Use the Relay

Add this to your `configuration.yaml`:

```yaml
notify:
  - name: email
    platform: smtp
    server: localhost
    port: 587
    timeout: 15
    sender: your-email@gmail.com
    recipient: recipient@example.com
```

**Important:** No username/password needed in Home Assistant config - the relay handles authentication!

## Configuration

### Option: `relay_host` (required)

The SMTP server of your email provider.

**Examples:**
- Gmail: `smtp.gmail.com`
- Outlook/Hotmail: `smtp-mail.outlook.com`
- Yahoo: `smtp.mail.yahoo.com`
- SendGrid: `smtp.sendgrid.net`
- Office 365: `smtp.office365.com`

### Option: `relay_port`

The SMTP port to use. Default is `587`.

**Common ports:**
- `587` - STARTTLS (recommended)
- `465` - SSL/TLS
- `25` - Plain (not recommended)

### Option: `relay_username` (required)

Your email account username or email address.

### Option: `relay_password` (required)

Your email account password or app-specific password.

**Security Note:** Many providers require app-specific passwords:
- Gmail: Create at https://myaccount.google.com/apppasswords
- Outlook: Create at https://account.microsoft.com/security
- Yahoo: Create at https://login.yahoo.com/account/security

### Option: `relay_use_tls`

Enable TLS encryption for the relay connection. Default is `true`.

**Always use TLS in production!**

### Option: `allowed_sender_domains`

Restrict which email domains can send through this relay. Leave empty to allow all.

**Example:** `example.com otherdomain.com`

### Option: `message_size_limit`

Maximum email size in bytes. Default is `10485760` (10MB).

### Option: `mynetworks`

Networks allowed to use this relay. Default includes the Home Assistant network.

**Default:** `172.30.32.0/23 127.0.0.0/8 [::1]/128`

### Option: `relay_myhostname`

The hostname used in SMTP greetings. Default is `homeassistant.local`.

### Option: `masquerade_domains` (optional)

Rewrite sender addresses to appear from these domains.

**Example:** `example.com`

### Option: `overwrite_from` (optional)

Force all emails to appear from this address.

**Example:** `noreply@yourdomain.com`

### Option: `always_add_missing_headers` (optional)

Add missing email headers automatically. Default is `false`.

### Option: `log_level` (optional)

Postfix log verbosity (0-9). Default is `1`. Higher = more verbose.

## Configuration Examples

### Gmail

```json
{
  "relay_host": "smtp.gmail.com",
  "relay_port": 587,
  "relay_username": "your-email@gmail.com",
  "relay_password": "your-app-password",
  "relay_use_tls": true,
  "relay_myhostname": "homeassistant.local"
}
```

**Important for Gmail:**
1. Enable 2-factor authentication
2. Create an app password: https://myaccount.google.com/apppasswords
3. Use the app password, not your regular password

### Outlook / Hotmail / Office 365

```json
{
  "relay_host": "smtp-mail.outlook.com",
  "relay_port": 587,
  "relay_username": "your-email@outlook.com",
  "relay_password": "your-password",
  "relay_use_tls": true
}
```

For Office 365 business accounts, use `smtp.office365.com`.

### Yahoo Mail

```json
{
  "relay_host": "smtp.mail.yahoo.com",
  "relay_port": 587,
  "relay_username": "your-email@yahoo.com",
  "relay_password": "your-app-password",
  "relay_use_tls": true
}
```

**Important for Yahoo:**
1. Generate an app password: https://login.yahoo.com/account/security
2. Use the app password

### SendGrid (Transactional Email Service)

```json
{
  "relay_host": "smtp.sendgrid.net",
  "relay_port": 587,
  "relay_username": "apikey",
  "relay_password": "your-sendgrid-api-key",
  "relay_use_tls": true,
  "message_size_limit": 31457280
}
```

### Mailgun

```json
{
  "relay_host": "smtp.mailgun.org",
  "relay_port": 587,
  "relay_username": "postmaster@your-domain.mailgun.org",
  "relay_password": "your-mailgun-smtp-password",
  "relay_use_tls": true
}
```

### Custom SMTP Server

```json
{
  "relay_host": "mail.yourdomain.com",
  "relay_port": 587,
  "relay_username": "noreply@yourdomain.com",
  "relay_password": "your-password",
  "relay_use_tls": true,
  "allowed_sender_domains": "yourdomain.com",
  "masquerade_domains": "yourdomain.com"
}
```

## Advanced Configuration

### Restricting Sender Domains

Only allow emails from specific domains:

```json
{
  "relay_host": "smtp.gmail.com",
  "relay_port": 587,
  "relay_username": "your-email@gmail.com",
  "relay_password": "your-app-password",
  "allowed_sender_domains": "yourdomain.com example.com"
}
```

### Masquerading Domains

Make all emails appear to come from your domain:

```json
{
  "relay_host": "smtp.gmail.com",
  "relay_port": 587,
  "relay_username": "your-email@gmail.com",
  "relay_password": "your-app-password",
  "masquerade_domains": "yourdomain.com",
  "overwrite_from": "homeassistant@yourdomain.com"
}
```

### High Volume Configuration

For sending many emails:

```json
{
  "relay_host": "smtp.sendgrid.net",
  "relay_port": 587,
  "relay_username": "apikey",
  "relay_password": "your-api-key",
  "message_size_limit": 31457280,
  "log_level": 2
}
```

## Testing the Relay

### From Home Assistant

Create an automation to test:

```yaml
automation:
  - alias: "Test Email"
    trigger:
      - platform: homeassistant
        event: start
    action:
      - service: notify.email
        data:
          title: "Test Email"
          message: "Postfix relay is working!"
```

### From Command Line

If you have access to the Home Assistant host:

```bash
echo "Test email from postfix relay" | mail -s "Test Subject" recipient@example.com
```

### Using Telnet

```bash
telnet localhost 587
EHLO homeassistant
MAIL FROM: sender@example.com
RCPT TO: recipient@example.com
DATA
Subject: Test Email

This is a test email.
.
QUIT
```

## Troubleshooting

### Emails Not Sending

1. **Check addon logs** for error messages
2. **Verify credentials** are correct
3. **Check relay_host** is reachable
4. **Verify port** is correct (587 for most providers)
5. **Check TLS settings** - try with/without TLS
6. **Test provider directly** using a mail client

### Authentication Failed

- Ensure you're using an **app-specific password** (Gmail, Yahoo, Outlook)
- Check if **2FA is required** by your provider
- Verify **username format** (some need email, some just username)
- Check for **typos in password**

### Connection Timeout

- Verify **firewall rules** allow outbound SMTP
- Check if your **ISP blocks port 25**
- Try using **port 587 instead of 25**
- Test connectivity: `telnet smtp.gmail.com 587`

### Relay Access Denied

- Check **mynetworks** includes your Home Assistant network
- Default should work, but verify: `172.30.32.0/23`
- Check addon logs for rejected connections

### Gmail "Less Secure Apps" Error

Gmail no longer supports "less secure apps". You **must** use:
1. 2-factor authentication enabled
2. App-specific password

### TLS/SSL Errors

- Verify **relay_use_tls** is set correctly
- Try **port 465** with TLS or **port 587** with STARTTLS
- Check **certificate validity** on the relay host
- Update CA certificates if needed

## Security Best Practices

1. **Use App-Specific Passwords** - Never use your main email password
2. **Enable TLS** - Always use encryption
3. **Restrict Sender Domains** - Limit who can send emails
4. **Use a Dedicated Account** - Create a separate email account for automation
5. **Monitor Logs** - Watch for unauthorized usage
6. **Limit mynetworks** - Only allow trusted networks
7. **Regular Password Rotation** - Change passwords periodically

## Common Use Cases

### Home Assistant Notifications

```yaml
notify:
  - name: gmail
    platform: smtp
    server: localhost
    port: 587
    sender: homeassistant@yourdomain.com
    recipient: you@example.com
```

### Critical Alerts Only

```yaml
automation:
  - alias: "Critical Alert Email"
    trigger:
      - platform: state
        entity_id: binary_sensor.smoke_detector
        to: "on"
    action:
      - service: notify.gmail
        data:
          title: "🚨 CRITICAL: Smoke Detected!"
          message: "Smoke detector activated at {{ now().strftime('%H:%M:%S') }}"
```

### Daily Summary Email

```yaml
automation:
  - alias: "Daily Summary Email"
    trigger:
      - platform: time
        at: "08:00:00"
    action:
      - service: notify.gmail
        data:
          title: "Daily Home Summary"
          message: >
            Temperature: {{ states('sensor.temperature') }}°C
            Energy Used: {{ states('sensor.daily_energy') }} kWh
            Motion Events: {{ states('counter.motion_events') }}
```

### Multiple Recipients

```yaml
notify:
  - name: family_email
    platform: smtp
    server: localhost
    port: 587
    sender: homeassistant@yourdomain.com
    recipient:
      - family1@example.com
      - family2@example.com
      - family3@example.com
```

## Performance Considerations

- **Connection Pooling**: The relay maintains connections for better performance
- **Queue Management**: Emails are queued if the relay is temporarily unavailable
- **Rate Limiting**: Respect your provider's rate limits
- **Message Size**: Keep attachments reasonable (default 10MB limit)

## Support

- [Report Issues](https://github.com/ghalpha/homeassistant-addons/issues)
- [Postfix Documentation](http://www.postfix.org/documentation.html)
- [Base Image](https://github.com/bokysan/docker-postfix)

## Credits

- Based on [boky/postfix](https://github.com/bokysan/docker-postfix) Docker image
- Home Assistant addon by ghalpha

## License

MIT License

Copyright (c) 2025 ghalpha

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
