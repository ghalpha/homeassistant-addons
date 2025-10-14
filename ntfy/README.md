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

### Quick Start

1. Start the addon
2. **Set up authentication** (highly recommended - see "Setting Up Authentication" below)
3. Access Ntfy through the Web UI
4. Subscribe to topics in the app or web interface
5. Send notifications from Home Assistant!

### First-Time Setup

**Step 1:** Configure the addon

```json
{
  "enable_signup": true,
  "enable_login": true,
  "enable_reservations": true
}
```

**Step 2:** Start the addon and open the Web UI

**Step 3:** Create your admin account
- Click Account → Sign up
- Create your username and password
- First user automatically becomes admin!

**Step 4:** Secure your installation
- Change config to `"enable_signup": false`
- Restart addon
- Create additional users via terminal if needed

**Step 5:** Start using!
- Subscribe to topics via web UI or mobile app
- Send notifications from Home Assistant (see integration examples below)

### Sending Notifications from Home Assistant

See the "Integration with Home Assistant" section below for detailed examples with and without authentication.

## Configuration

### Option: `base_url` (optional)

The external URL of your ntfy server. Set this if you're accessing ntfy from outside your network.

**Example:** `https://ntfy.yourdomain.com`

### Option: `enable_signup` (optional)

Allow users to sign up via the web app. 

- `true` - Anyone can create an account through the web interface
- `false` - Only admins can create users via terminal

**Default:** `true`  
**Recommended:** Start with `true` to create your admin account, then set to `false`

### Option: `enable_login` (optional)

Enable login/authentication. When enabled, users must authenticate to access topics.

**Default:** `true`  
**Recommended:** Always `true` for security

### Option: `enable_reservations` (optional)

Allow users to reserve topic names so others can't use them.

**Default:** `true`  
**Recommended:** `true` for better organization

### Option: `cache_file` (optional)

Path to the cache database file.

**Default:** `/data/cache.db`

### Option: `auth_file` (optional)

Path to the authentication database file.

**Default:** `/data/auth.db`

### Option: `attachment_cache_dir` (optional)

Directory to store file attachments.

**Default:** `/data/attachments`

## Example Configuration

```json
{
  "base_url": "",
  "enable_signup": false,
  "enable_login": true,
  "enable_reservations": true,
  "cache_file": "/data/cache.db",
  "auth_file": "/data/auth.db",
  "attachment_cache_dir": "/data/attachments"
}
```

---

## Setting Up Authentication

Authentication is **highly recommended** to prevent unauthorized access to your notifications.

### Method 1: Web UI Signup (Easiest) ✅

This is the simplest method for creating your first admin account.

#### Step 1: Enable Signup

Set in addon configuration:
```json
{
  "enable_signup": true,
  "enable_login": true,
  "enable_reservations": true
}
```

#### Step 2: Restart the Addon

#### Step 3: Create Admin Account

1. Open the Ntfy web interface
2. Click the **Account** icon (top right)
3. Click **Sign up**
4. Enter username and password
5. Click **Sign up**

**Important: The first user created automatically becomes an admin!**

#### Step 4: Disable Public Signup (Recommended)

After creating your admin account, disable public signup for security:

```json
{
  "enable_signup": false,
  "enable_login": true,
  "enable_reservations": true
}
```

This prevents random people from creating accounts on your server.

---

### Method 2: Using Addon Terminal (Most Control) 🔧

For more control and to create multiple users, use the addon terminal.

#### Step 1: Open Addon Terminal

1. Go to **Settings** → **Add-ons** → **Ntfy**
2. Click on the **Terminal** tab

#### Step 2: Create Users

**Create an admin user:**
```bash
ntfy user add --role=admin admin
```

**Create regular users:**
```bash
ntfy user add alice
ntfy user add bob
ntfy user add homeassistant
```

You'll be prompted to enter a password for each user.

#### User Management Commands

**List all users:**
```bash
ntfy user list
```

**Delete a user:**
```bash
ntfy user del username
```

**Change password:**
```bash
ntfy user change-pass username
```

**Change role:**
```bash
ntfy user change-role username admin
```

---

### User Roles Explained

#### Admin Role
- Can manage all users
- Can manage access to topics
- Can view all topics
- Can create/delete/modify users

**Create admin:**
```bash
ntfy user add --role=admin adminuser
```

#### User Role (Default)
- Can create and use topics
- Can subscribe to topics
- Cannot manage other users

**Create regular user:**
```bash
ntfy user add regularuser
```

---

### Topic Access Control

Control who can access which topics for better security.

#### Grant Access

**Allow a user to publish to a topic:**
```bash
ntfy access username topicname write
```

**Allow a user to subscribe to a topic:**
```bash
ntfy access username topicname read
```

**Allow full access (read & write):**
```bash
ntfy access username topicname rw
```

#### Examples

```bash
# Allow user "john" to publish alerts
ntfy access john alerts write

# Allow user "jane" to read notifications
ntfy access jane notifications read

# Allow admin full access to system topics
ntfy access admin system rw
```

#### View Permissions

```bash
ntfy access
```

#### Revoke Access

```bash
ntfy access --reset username topicname
```

---

### Recommended Setup Flow

Here's the best way to set up Ntfy authentication:

**1. Enable signup initially:**
```json
{
  "enable_signup": true,
  "enable_login": true,
  "enable_reservations": true
}
```

**2. Create your admin account** (via web UI - first user is auto-admin)

**3. Disable public signup:**
```json
{
  "enable_signup": false,
  "enable_login": true,
  "enable_reservations": true
}
```

**4. Create additional users via terminal:**
```bash
ntfy user add alice
ntfy user add bob
ntfy user add homeassistant
```

**5. Set up topic permissions (optional but recommended):**
```bash
# Let everyone read public topics
ntfy access alice public read
ntfy access bob public read

# Only admin can publish to important topics
ntfy access admin alerts write
ntfy access admin system write
```

---

### Testing Authentication

After setting up users, verify authentication is working:

**Try publishing without credentials (should fail):**
```bash
curl -d "Test message" http://your-ha-ip:8080/test
```
Expected: `401 Unauthorized`

**Try publishing with credentials (should work):**
```bash
curl -u username:password -d "Test message" http://your-ha-ip:8080/test
```
Expected: `200 OK`

**Test in web interface:**
1. Open Ntfy web UI
2. Try subscribing to a topic
3. Should prompt for login
4. Enter credentials
5. Should work!

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

**With authentication:**
```yaml
notify:
  - name: ntfy
    platform: rest
    resource: http://localhost:8080/homeassistant
    method: POST_JSON
    title_param_name: title
    message_param_name: message
    authentication: basic
    username: your-username
    password: your-password
```

### Method 2: Using REST Command (More Flexible)

**Without authentication:**
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

**With authentication (recommended):**
```yaml
rest_command:
  ntfy:
    url: http://localhost:8080/{{ topic }}
    method: POST
    username: homeassistant
    password: your-password
    payload: >
      {
        "message": "{{ message }}",
        "title": "{{ title }}",
        "priority": {{ priority | default(3) }},
        "tags": {{ tags | default([]) | tojson }}
      }
    content_type: 'application/json'
```

### Method 3: Shell Command

**With authentication:**
```yaml
shell_command:
  ntfy_send: 'curl -u homeassistant:your-password -d "{{ message }}" http://localhost:8080/{{ topic }}'
```

### Usage in Automations

**Using notify platform:**
```yaml
automation:
  - alias: "Front Door Alert"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door
        to: "on"
    action:
      - service: notify.ntfy
        data:
          title: "Front Door"
          message: "Front door opened at {{ now().strftime('%H:%M') }}"
```

**Using rest_command:**
```yaml
automation:
  - alias: "Motion Detected"
    trigger:
      - platform: state
        entity_id: binary_sensor.motion
        to: "on"
    action:
      - service: rest_command.ntfy
        data:
          topic: "alerts"
          title: "Motion Alert"
          message: "Motion detected in living room"
          priority: 4
          tags: ["rotating_light"]
```

**Using shell_command:**
```yaml
automation:
  - alias: "Temperature Alert"
    trigger:
      - platform: numeric_state
        entity_id: sensor.temperature
        above: 30
    action:
      - service: shell_command.ntfy_send
        data:
          topic: "alerts"
          message: "Temperature is {{ states('sensor.temperature') }}°C"
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
