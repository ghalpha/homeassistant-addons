# Home Assistant Add-on: Ntfy

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

Send push notifications to your phone or desktop via PUT/POST.

## About

Ntfy (pronounced "notify") is a simple HTTP-based pub-sub notification service. It allows you to send notifications to your phone or desktop via scripts from any computer, using simple HTTP PUT or POST requests. You can use it from your own scripts or directly from Home Assistant.

**Features:**
- 📱 Send notifications to your phone or desktop
- 🔒 Optional authentication and access control
- 📎 Support for attachments, emojis, and actions
- 🌐 Self-hosted or use the public ntfy.sh server
- 🔔 Priority levels and custom icons
- 📧 Email notifications as fallback
- 🔐 End-to-end encryption support

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Ntfy" add-on and click it
4. Click on the "INSTALL" button

## How to Use

1. Start the add-on
2. Check the add-on log output for the result
3. Access Ntfy through the Web UI
4. Install the Ntfy mobile app on your phone (optional)
5. Subscribe to topics in the app or web interface

### Sending Notifications from Home Assistant

You can send notifications using the RESTful service:

```yaml
# configuration.yaml
rest_command:
  ntfy_notification:
    url: http://localhost:8080/mytopic
    method: POST
    payload: '{"message": "{{ message }}", "title": "{{ title }}", "priority": {{ priority | default(3) }}}'
    content_type: 'application/json'
```

Then use it in automations:

```yaml
automation:
  - alias: "Send notification"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door
        to: "on"
    action:
      - service: rest_command.ntfy_notification
        data:
          title: "Front Door"
          message: "Front door opened"
          priority: 4
```

Or use curl from the command line:

```bash
curl -d "Backup successful" http://localhost:8080/mytopic
```

## Configuration

### Option: `base_url` (optional)

The external URL of your ntfy server. Set this if you're accessing ntfy from outside your network.

**Example:** `https://ntfy.yourdomain.com`

### Option: `upstream_base_url` (optional)

Forward poll requests to this upstream server. Default is `https://ntfy.sh`.

### Option: `enable_signup` (optional)

Allow users to sign up via the web app. Default is `false`.

### Option: `enable_login` (optional)

Enable login/authentication. Default is `true`.

### Option: `enable_reservations` (optional)

Allow users to reserve topics. Default is `false`.

### Option: `behind_proxy` (optional)

Set to `true` if ntfy is behind a reverse proxy. Default is `false`.

### Option: `visitor_request_limit_burst` (optional)

Number of requests a visitor can make in a burst. Default is 60.

### Option: `visitor_request_limit_replenish` (optional)

Rate at which request limits replenish. Default is "5s" (5 per second).

## Example Configuration

```json
{
  "base_url": "https://ntfy.yourdomain.com",
  "enable_signup": false,
  "enable_login": true,
  "enable_reservations": true,
  "behind_proxy": true,
  "visitor_request_limit_burst": 100
}
```

## Topics and Subscriptions

Topics are created automatically when you publish to them. No setup required!

**Subscribe to a topic:**
- Via the web interface: http://[HOST]:8080
- Via the mobile app: Add subscription → Enter topic name
- Via curl: `curl -s http://localhost:8080/mytopic/json`

**Publish to a topic:**
```bash
# Simple message
curl -d "Hello World" http://localhost:8080/mytopic

# With title and priority
curl -H "Title: Server Alert" -H "Priority: urgent" -d "CPU usage critical" http://localhost:8080/alerts

# With tags and actions
curl -d '{"message":"Deploy complete","tags":["white_check_mark"],"actions":[{"action":"view","label":"Open","url":"https://example.com"}]}' http://localhost:8080/deployments
```

## Authentication

To enable authentication:

1. Set `enable_login: true` in configuration
2. Access the web interface
3. Click "Sign up" to create the first admin user
4. Use the web interface to manage additional users and access control

## Integration with Home Assistant

### Method 1: Using RESTful Notifications

Add to your `configuration.yaml`:

```yaml
notify:
  - name: ntfy
    platform: rest
    resource: http://localhost:8080/homeassistant
    method: POST_JSON
    title_param_name: title
    message_param_name: message
```

### Method 2: Using REST Command (more flexible)

```yaml
rest_command:
  ntfy:
    url: http://localhost:8080/{{ topic }}
    method: POST
    payload: >
      {
        "message": "{{ message }}",
        "title": "{{ title }}",
        "priority": {{ priority | default(3) }},
        "tags": {{ tags | default([]) | tojson }}
      }
    content_type: 'application/json'
```

## Support

Got questions?

You could [open an issue](https://github.com/ghalpha/homeassistant-addons/issues) on GitHub.

## Official Documentation

- [Ntfy Documentation](https://docs.ntfy.sh/)
- [Ntfy on GitHub](https://github.com/binwiederhier/ntfy)

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
