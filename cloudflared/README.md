# Home Assistant Add-on: Cloudflared

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

Use a Cloudflare Tunnel to remotely connect to Home Assistant without opening any ports.

## About

Cloudflared creates a secure tunnel between your Home Assistant instance and Cloudflare's network, allowing you to access your instance remotely without exposing it directly to the internet. This is more secure than traditional port forwarding or dynamic DNS solutions.

**Benefits:**
- 🔒 No ports to open on your router
- 🌐 Free secure remote access
- 🚀 Fast global CDN performance
- 🛡️ DDoS protection from Cloudflare
- 🔐 Optional Cloudflare Access authentication
- 📱 Access from anywhere with a custom domain
- 🚫 Hide your home IP address

**How it works:**
1. Cloudflared creates an outbound tunnel to Cloudflare
2. Your domain points to Cloudflare
3. Cloudflare routes traffic through the tunnel to your Home Assistant
4. No inbound ports needed!

## Prerequisites

Before installing this addon, you need:

1. **A Cloudflare account** (free tier works)
   - Sign up at https://dash.cloudflare.com/sign-up

2. **A domain name** managed by Cloudflare
   - Add your domain to Cloudflare (free)
   - Update nameservers at your registrar

3. **A Cloudflare Tunnel** (created via Cloudflare Zero Trust)
   - Go to https://one.dash.cloudflare.com/
   - Navigate to Networks → Tunnels
   - Create a new tunnel

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Cloudflared" add-on and click it
4. Click on the "INSTALL" button

## Configuration

### Method 1: Using Tunnel Token (Recommended)

This is the easiest method for most users.

#### Step 1: Create a Tunnel in Cloudflare Dashboard

1. Go to https://one.dash.cloudflare.com/
2. Navigate to **Networks** → **Tunnels**
3. Click **Create a tunnel**
4. Choose **Cloudflared** as the connector
5. Give your tunnel a name (e.g., "homeassistant")
6. Click **Save tunnel**

#### Step 2: Copy the Tunnel Token

On the tunnel configuration page, you'll see an installation command like:
```bash
cloudflared service install eyJhIjoixxxxxxx...
```

Copy everything after `install` - that's your tunnel token.

#### Step 3: Configure the Addon

Add to your addon configuration:
```json
{
  "tunnel_token": "eyJhIjoixxxxxxxxxxxxxxx"
}
```

#### Step 4: Configure the Route in Cloudflare

1. In the Cloudflare tunnel configuration
2. Go to **Public Hostname** tab
3. Click **Add a public hostname**
4. Configure:
   - **Subdomain:** `homeassistant` (or whatever you prefer)
   - **Domain:** `yourdomain.com`
   - **Service Type:** `HTTP`
   - **URL:** `homeassistant.local:8123` or `localhost:8123`
5. Click **Save**

#### Step 5: Start the Addon

1. Start the addon
2. Check the logs for successful connection
3. Access your Home Assistant at `https://homeassistant.yourdomain.com`

---

### Method 2: Using Configuration Options (Advanced)

For more control over routing and multiple services.

#### Configuration Example:

```json
{
  "external_hostname": "homeassistant.yourdomain.com",
  "tunnel_name": "homeassistant",
  "additional_hosts": [
    {
      "hostname": "addon.yourdomain.com",
      "service": "http://localhost:3000"
    },
    {
      "hostname": "files.yourdomain.com",
      "service": "http://localhost:8080"
    }
  ]
}
```

This method requires authenticating with Cloudflare:
1. Run `cloudflared tunnel login` manually
2. Copy the cert.pem file to addon config
3. Create tunnel via CLI

**Most users should use Method 1 (Tunnel Token) instead.**

---

## Configuration Options

### Option: `tunnel_token` (recommended)

The tunnel token from your Cloudflare Zero Trust dashboard. This is the easiest and recommended method.

**Example:** `"tunnel_token": "eyJhIjoixxxxxxxxxxxxxxx"`

### Option: `external_hostname`

Your domain name for accessing Home Assistant.

**Example:** `"external_hostname": "homeassistant.yourdomain.com"`

### Option: `tunnel_name`

Custom name for your tunnel. Used with manual configuration method.

**Example:** `"tunnel_name": "homeassistant"`

### Option: `additional_hosts`

Route multiple services through the same tunnel.

**Example:**
```json
"additional_hosts": [
  {
    "hostname": "files.yourdomain.com",
    "service": "http://localhost:8080",
    "disableChunkedEncoding": false
  }
]
```

### Option: `catch_all_service`

Fallback service for requests that don't match any hostname.

**Example:** `"catch_all_service": "http_status:404"`

### Option: `nginx_proxy_manager`

Set to `true` if using Nginx Proxy Manager.

**Default:** `false`

### Option: `post_quantum`

Enable post-quantum cryptography for enhanced security.

**Default:** `false`

### Option: `run_parameters`

Advanced cloudflared command-line parameters.

**Example:** `["--protocol=quic", "--region=us"]`

---

## Example Configurations

### Basic Setup (Home Assistant Only)

```json
{
  "tunnel_token": "eyJhIjoixxxxxxxxxx"
}
```

Then configure the route in Cloudflare dashboard:
- Subdomain: `homeassistant`
- Domain: `yourdomain.com`
- Service: `http://homeassistant.local:8123`

### Multiple Services

```json
{
  "tunnel_token": "eyJhIjoixxxxxxxxxx",
  "additional_hosts": [
    {
      "hostname": "grafana.yourdomain.com",
      "service": "http://localhost:3000"
    },
    {
      "hostname": "plex.yourdomain.com",
      "service": "http://localhost:32400"
    }
  ]
}
```

### With Post-Quantum Encryption

```json
{
  "tunnel_token": "eyJhIjoixxxxxxxxxx",
  "post_quantum": true
}
```

---

## Configuring Home Assistant

After setting up the tunnel, you need to tell Home Assistant about the external URL:

### Edit `configuration.yaml`:

```yaml
homeassistant:
  external_url: https://homeassistant.yourdomain.com
  internal_url: http://homeassistant.local:8123
```

### Add to `http:` section:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.32.0/23
    - 127.0.0.1
    - ::1
```

**Restart Home Assistant** after making these changes.

---

## Security Best Practices

### 1. Enable Cloudflare Access (Recommended)

Add an extra layer of authentication:

1. Go to https://one.dash.cloudflare.com/
2. Navigate to **Access** → **Applications**
3. Click **Add an application**
4. Configure authentication (email OTP, Google, etc.)
5. Apply to your Home Assistant domain

This adds authentication BEFORE reaching Home Assistant.

### 2. Use Strong Passwords

Even with Cloudflare protection, use strong unique passwords for Home Assistant.

### 3. Enable 2FA in Home Assistant

Settings → Users → Your user → Enable two-factor authentication

### 4. Keep Home Assistant Updated

Regular updates include security patches.

### 5. Monitor Access Logs

Check Cloudflare Analytics for suspicious activity.

---

## Troubleshooting

### Tunnel Won't Connect

**Check logs:**
```
Settings → Add-ons → Cloudflared → Log
```

**Common issues:**
- Invalid tunnel token
- Token has expired
- Network connectivity issues
- Firewall blocking outbound connections

**Solution:**
1. Regenerate tunnel token in Cloudflare
2. Update addon configuration
3. Restart addon

### "Unable to reach" Error in Browser

**Symptoms:** Can access tunnel URL but get "unable to reach" error

**Causes:**
- Service URL incorrect in Cloudflare
- Home Assistant not running
- Wrong port configured

**Solution:**
1. Verify Home Assistant is running
2. Check service URL in Cloudflare dashboard
3. Use `homeassistant.local:8123` or `localhost:8123`
4. Ensure port 8123 is correct

### 502 Bad Gateway

**Causes:**
- Home Assistant is down
- Network path from addon to HA broken
- Service configuration incorrect

**Solution:**
1. Restart Home Assistant
2. Check addon logs
3. Verify network connectivity
4. Test `http://homeassistant.local:8123` from addon terminal

### SSL/TLS Certificate Errors

Cloudflare automatically handles SSL certificates. If you see certificate errors:

**Causes:**
- Cloudflare SSL mode set incorrectly
- Browser cache issues

**Solution:**
1. Go to Cloudflare dashboard → SSL/TLS
2. Set mode to **Full** (not Full Strict)
3. Clear browser cache
4. Try incognito/private browsing

### Home Assistant Shows "400 Bad Request"

**Cause:** Home Assistant doesn't recognize the external URL

**Solution:** Add `external_url` to `configuration.yaml`:
```yaml
homeassistant:
  external_url: https://homeassistant.yourdomain.com
```

### Slow Performance

**Causes:**
- Distant Cloudflare data center
- Network congestion
- Large file transfers

**Solutions:**
1. Enable Argo Smart Routing in Cloudflare (paid)
2. Use different protocol: `--protocol=quic`
3. Check your internet connection speed

---

## Advanced Topics

### Using Multiple Tunnels

You can run multiple tunnels to different services:

```json
{
  "tunnel_token": "tunnel-1-token",
  "additional_hosts": [
    {
      "hostname": "service1.yourdomain.com",
      "service": "http://localhost:3000"
    },
    {
      "hostname": "service2.yourdomain.com",
      "service": "http://localhost:8080"
    }
  ]
}
```

### Custom Run Parameters

Advanced users can pass cloudflared parameters:

```json
{
  "tunnel_token": "your-token",
  "run_parameters": [
    "--protocol=quic",
    "--region=us",
    "--edge-ip-version=auto"
  ]
}
```

Available parameters:
- `--protocol` - Connection protocol (auto, quic, http2)
- `--region` - Cloudflare region
- `--edge-ip-version` - IP version (auto, 4, 6)
- `--ha-connections` - Number of connections

### Monitoring and Metrics

View tunnel metrics in Cloudflare:
1. Go to your tunnel in Cloudflare dashboard
2. View the **Metrics** tab
3. See bandwidth, requests, and health status

---

## Comparison to Other Methods

| Feature | Cloudflare Tunnel | Port Forwarding | DuckDNS + Let's Encrypt |
|---------|------------------|-----------------|------------------------|
| **Port opening** | ❌ None | ✅ Required | ✅ Required |
| **DDoS protection** | ✅ Included | ❌ No | ❌ No |
| **SSL certificate** | ✅ Auto | ⚠️ Manual | ✅ Auto |
| **IP hidden** | ✅ Yes | ❌ Exposed | ❌ Exposed |
| **Speed** | ✅ Fast (CDN) | ✅ Direct | ✅ Direct |
| **Setup complexity** | ⚠️ Medium | ⚠️ Medium | ⚠️ Medium |
| **Cost** | ✅ Free | ✅ Free | ✅ Free |
| **Additional auth** | ✅ Available | ❌ No | ❌ No |

---

## FAQ

### Q: Is this free?
**A:** Yes! Cloudflare's tunnel service is completely free for personal use.

### Q: Will this work with my ISP that uses CGNAT?
**A:** Yes! That's one of the main benefits - it works even behind CGNAT or restrictive NAT.

### Q: Can I use my own domain?
**A:** Yes, as long as your domain is managed by Cloudflare (free to add).

### Q: Does this work with Home Assistant Cloud (Nabu Casa)?
**A:** You can use both, but you only need one. Cloudflare Tunnel is an alternative to Nabu Casa's remote access.

### Q: Will this slow down my Home Assistant?
**A:** There's minimal overhead. Performance is usually comparable to direct access, and Cloudflare's CDN often makes it faster from remote locations.

### Q: Can I use this for other services besides Home Assistant?
**A:** Yes! Use the `additional_hosts` option to tunnel other services.

### Q: Is this secure?
**A:** Yes, very secure. All traffic is encrypted, and you can add Cloudflare Access for additional authentication.

### Q: What happens if Cloudflare goes down?
**A:** Remote access won't work, but local access is unaffected. This is true of any cloud-based remote access solution.

---

## Support

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Cloudflared GitHub](https://github.com/cloudflare/cloudflared)
- [Report Issues](https://github.com/ghalpha/homeassistant-addons/issues)
- [Cloudflare Community](https://community.cloudflare.com/)

## Credits

- Cloudflared by [Cloudflare](https://www.cloudflare.com/)
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
