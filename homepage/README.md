# Home Assistant Add-on: Homepage

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

A modern, fully static, fast, secure fully static application dashboard with integrations for over 100 services.

## About

Homepage is a highly customizable application dashboard that provides a clean, organized view of all your self-hosted services. It features beautiful widgets, real-time status monitoring, and integrations with popular services.

**Features:**
- 🎨 Modern and clean interface
- 📊 Real-time service status and statistics
- 🔌 100+ service integrations (Plex, Sonarr, Radarr, etc.)
- 🌡️ System monitoring widgets
- 🐳 Docker container management
- 📱 Fully responsive design
- 🎯 Search functionality
- 🌓 Light and dark themes
- ⚡ Fast and lightweight
- 🔒 No telemetry or external calls

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Homepage" add-on and click it
4. Click on the "INSTALL" button

## How to Use

### Quick Start

1. Start the addon
2. Access Homepage through the Web UI
3. Create your configuration files (see below)
4. Add your services and customize!

### Configuration Files

Homepage uses YAML files for configuration. These are stored in `/addon_configs/homepage_addon/`:

```
/addon_configs/homepage_addon/
├── services.yaml      # Your services/links
├── widgets.yaml       # Dashboard widgets
├── bookmarks.yaml     # Quick access bookmarks
├── settings.yaml      # General settings
└── custom.css         # Custom styling (optional)
```

---

## Configuration

### Basic Configuration

#### 1. Create `services.yaml`

This file defines the services displayed on your dashboard:

```yaml
---
# Homepage Services Configuration

- My Services:
    - Home Assistant:
        icon: home-assistant.png
        href: http://homeassistant.local:8123
        description: Smart Home Hub
        server: my-docker
        container: homeassistant

    - Plex:
        icon: plex.png
        href: http://192.168.1.100:32400
        description: Media Server
        widget:
          type: plex
          url: http://192.168.1.100:32400
          key: your-plex-token

    - Sonarr:
        icon: sonarr.png
        href: http://192.168.1.101:8989
        description: TV Show Management
        widget:
          type: sonarr
          url: http://192.168.1.101:8989
          key: your-sonarr-api-key

- Media:
    - Jellyfin:
        icon: jellyfin.png
        href: http://192.168.1.102:8096
        description: Media System
        
    - Radarr:
        icon: radarr.png
        href: http://192.168.1.103:7878
        description: Movie Management
        widget:
          type: radarr
          url: http://192.168.1.103:7878
          key: your-radarr-api-key

- Network:
    - Pi-hole:
        icon: pi-hole.png
        href: http://192.168.1.104/admin
        description: DNS Ad Blocker
        widget:
          type: pihole
          url: http://192.168.1.104
          key: your-pihole-api-key
```

#### 2. Create `widgets.yaml`

Add informational widgets to your dashboard:

```yaml
---
# Homepage Widgets Configuration

- resources:
    cpu: true
    memory: true
    disk: /
    cputemp: true
    uptime: true

- search:
    provider: google
    target: _blank

- datetime:
    text_size: xl
    format:
      dateStyle: long
      timeStyle: short
      hour12: false
```

#### 3. Create `bookmarks.yaml`

Quick access links:

```yaml
---
# Homepage Bookmarks

- Developer:
    - GitHub:
        - icon: github.png
          href: https://github.com/
    - GitLab:
        - icon: gitlab.png
          href: https://gitlab.com/

- Social:
    - Reddit:
        - icon: reddit.png
          href: https://reddit.com/
    - Twitter:
        - icon: twitter.png
          href: https://twitter.com/

- Entertainment:
    - YouTube:
        - icon: youtube.png
          href: https://youtube.com/
    - Netflix:
        - icon: netflix.png
          href: https://netflix.com/
```

#### 4. Create `settings.yaml`

General settings:

```yaml
---
# Homepage Settings

title: My Dashboard
background: https://images.unsplash.com/photo-1502790671504-542ad42d5189
backgroundOpacity: 0.5
theme: dark
color: slate
headerStyle: clean

layout:
  My Services:
    style: row
    columns: 3
  Media:
    style: row
    columns: 2
  Network:
    style: row
    columns: 4

hideVersion: true
```

---

## Service Widgets

Homepage can display real-time statistics from many services. Here are some popular ones:

### Plex

```yaml
- Plex:
    icon: plex.png
    href: http://192.168.1.100:32400
    widget:
      type: plex
      url: http://192.168.1.100:32400
      key: your-plex-token
```

**Get Plex token:** Settings → Account → Authorized Devices → Get Token

### Sonarr / Radarr

```yaml
- Sonarr:
    icon: sonarr.png
    href: http://192.168.1.101:8989
    widget:
      type: sonarr
      url: http://192.168.1.101:8989
      key: your-api-key
```

**Get API key:** Settings → General → API Key

### Pi-hole

```yaml
- Pi-hole:
    icon: pi-hole.png
    href: http://192.168.1.104/admin
    widget:
      type: pihole
      url: http://192.168.1.104
      key: your-api-key
```

**Get API key:** Settings → API → Show API token

### Home Assistant

```yaml
- Home Assistant:
    icon: home-assistant.png
    href: http://homeassistant.local:8123
    widget:
      type: homeassistant
      url: http://homeassistant.local:8123
      key: your-long-lived-token
```

**Get token:** Profile → Long-Lived Access Tokens → Create Token

### qBittorrent

```yaml
- qBittorrent:
    icon: qbittorrent.png
    href: http://192.168.1.105:8080
    widget:
      type: qbittorrent
      url: http://192.168.1.105:8080
      username: admin
      password: adminpass
```

### Portainer

```yaml
- Portainer:
    icon: portainer.png
    href: http://192.168.1.106:9000
    widget:
      type: portainer
      url: http://192.168.1.106:9000
      env: 1
      key: your-api-key
```

### AdGuard Home

```yaml
- AdGuard:
    icon: adguard-home.png
    href: http://192.168.1.107
    widget:
      type: adguard
      url: http://192.168.1.107
      username: admin
      password: password
```

---

## Docker Integration

Homepage can show stats from Docker containers. This requires Docker socket access.

### In `services.yaml`:

```yaml
- Docker:
    - Container Name:
        icon: docker.png
        href: http://192.168.1.100:8080
        description: My Docker Container
        server: my-docker
        container: container-name
```

### In `docker.yaml`:

```yaml
---
my-docker:
  host: 192.168.1.100
  port: 2375
```

**Note:** For Home Assistant OS, Docker integration works automatically since the addon has access to the Docker socket.

---

## Customization

### Themes

Available themes: `dark`, `light`

Available colors: `white`, `slate`, `gray`, `zinc`, `neutral`, `stone`, `red`, `orange`, `amber`, `yellow`, `lime`, `green`, `emerald`, `teal`, `cyan`, `sky`, `blue`, `indigo`, `violet`, `purple`, `fuchsia`, `pink`, `rose`

```yaml
theme: dark
color: slate
```

### Custom CSS

Create `/addon_configs/homepage_addon/custom.css`:

```css
/* Custom styling */
body {
  font-family: 'Roboto', sans-serif;
}

.service {
  border-radius: 12px;
}

/* Change service card colors */
.service-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

### Custom Icons

Place custom icons in `/addon_configs/homepage_addon/icons/` and reference them:

```yaml
- My Service:
    icon: /icons/my-custom-icon.png
    href: http://example.com
```

Or use URLs:

```yaml
- My Service:
    icon: https://example.com/icon.png
    href: http://example.com
```

### Background Images

Set a background image in `settings.yaml`:

```yaml
background: https://images.unsplash.com/photo-1506905925346-21bda4d32df4
backgroundOpacity: 0.3
backgroundFilter: blur(0px)
```

Or use a local image:

```yaml
background: /images/my-background.jpg
```

---

## Advanced Configuration

### Layout Options

Control how services are displayed:

```yaml
layout:
  My Services:
    style: row      # or 'column'
    columns: 3      # number of columns
    
  Media:
    style: row
    columns: 2
    
  Network:
    style: row
    columns: 4
```

### Header Styles

Available styles: `clean`, `boxed`, `underlined`

```yaml
headerStyle: clean
```

### Service Settings

Per-service customization:

```yaml
- Plex:
    icon: plex.png
    href: http://192.168.1.100:32400
    description: Media Server
    ping: http://192.168.1.100:32400  # Enable ping monitoring
    statusStyle: dot                   # or 'basic'
    target: _blank                     # Open in new tab
```

### Glances Widget (Minimal System Info)

```yaml
- glances:
    url: http://192.168.1.10:61208
    version: 4
    metric: info
```

Requires Glances running on your system.

### Weather Widget

```yaml
- openweathermap:
    label: Home
    latitude: 40.7128
    longitude: -74.0060
    units: imperial
    apiKey: your-api-key
```

Get API key from: https://openweathermap.org/api

---

## Complete Example Configuration

### services.yaml

```yaml
---
- Home:
    - Home Assistant:
        icon: home-assistant.png
        href: http://homeassistant.local:8123
        description: Smart Home Control
        widget:
          type: homeassistant
          url: http://homeassistant.local:8123
          key: your-token

- Media:
    - Plex:
        icon: plex.png
        href: http://192.168.1.100:32400
        description: Stream Movies & TV
        widget:
          type: plex
          url: http://192.168.1.100:32400
          key: your-plex-token
          
    - Jellyfin:
        icon: jellyfin.png
        href: http://192.168.1.102:8096
        description: Open Source Media
        
- Downloads:
    - Sonarr:
        icon: sonarr.png
        href: http://192.168.1.101:8989
        widget:
          type: sonarr
          url: http://192.168.1.101:8989
          key: your-api-key
          
    - Radarr:
        icon: radarr.png
        href: http://192.168.1.103:7878
        widget:
          type: radarr
          url: http://192.168.1.103:7878
          key: your-api-key

- Network:
    - Pi-hole:
        icon: pi-hole.png
        href: http://192.168.1.104/admin
        widget:
          type: pihole
          url: http://192.168.1.104
          key: your-api-key
          
    - Router:
        icon: router.png
        href: http://192.168.1.1
        description: Network Gateway
```

### widgets.yaml

```yaml
---
- resources:
    cpu: true
    memory: true
    disk: /
    cputemp: true
    uptime: true
    units: imperial

- search:
    provider: google
    target: _blank

- datetime:
    text_size: xl
    format:
      dateStyle: long
      timeStyle: short
      hour12: true

- openweathermap:
    label: Home
    latitude: 40.7128
    longitude: -74.0060
    units: imperial
    apiKey: your-api-key
```

### settings.yaml

```yaml
---
title: Home Dashboard
background: https://images.unsplash.com/photo-1519681393784-d120267933ba
backgroundOpacity: 0.4
theme: dark
color: slate
headerStyle: clean

layout:
  Home:
    style: row
    columns: 2
  Media:
    style: row
    columns: 2
  Downloads:
    style: row
    columns: 2
  Network:
    style: row
    columns: 3

hideVersion: false
hideErrors: false
showStats: true
```

---

## Troubleshooting

### Services Not Showing

**Check:**
1. YAML syntax is correct (use https://www.yamllint.com/)
2. Files are in the correct location: `/addon_configs/homepage_addon/`
3. Restart the addon after configuration changes

### Widgets Not Loading

**Check:**
1. API keys are correct
2. URLs are accessible from the addon
3. Service is running and responding
4. Check addon logs for errors

### Icons Not Displaying

**Default icon location:** `/app/public/icons/`

**For custom icons:**
- Place in `/addon_configs/homepage_addon/icons/`
- Reference as `/icons/your-icon.png`

**Use dashboard-icons:**
Homepage includes thousands of icons. Use them like:
```yaml
icon: plex.png
icon: sonarr.png
icon: home-assistant.png
```

### Configuration Not Updating

After changing configuration files:
1. Restart the addon
2. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
3. Check addon logs for parsing errors

### Widget API Errors

**Common causes:**
- Wrong API key
- API endpoint changed
- Service version incompatible
- Network connectivity issues

**Solution:**
Check addon logs for specific error messages.

### Performance Issues

**If Homepage is slow:**
- Reduce number of widget updates
- Use simpler background images
- Disable unused widgets
- Check if any service widget is timing out

---

## Tips & Tricks

### 1. Group Related Services

Organize services logically:
```yaml
- Home Automation:
    - Home Assistant
    - Node-RED
    - Zigbee2MQTT

- Media Servers:
    - Plex
    - Jellyfin
    - Emby
```

### 2. Use Status Indicators

Enable ping monitoring:
```yaml
- Service:
    icon: service.png
    href: http://example.com
    ping: http://example.com
    statusStyle: dot
```

### 3. Hide Unused Options

Keep your dashboard clean:
```yaml
hideVersion: true
hideErrors: true
```

### 4. Mobile Optimization

Homepage is responsive by default, but you can optimize:
```yaml
layout:
  MyServices:
    columns: 2  # Shows 2 columns on mobile
```

### 5. Quick Search

Use the search widget for fast navigation:
```yaml
- search:
    provider: google  # or duckduckgo, bing
    target: _blank
```

### 6. Theme Matching

Match Homepage to your Home Assistant theme:
```yaml
theme: dark
color: slate  # Matches many HA themes
```

---

## Integration with Home Assistant

### Method 1: Iframe Card

Add Homepage to a Home Assistant dashboard:

```yaml
type: iframe
url: http://homeassistant.local:3000
aspect_ratio: 100%
```

### Method 2: Webpage Card (Custom Component)

Install the webpage card and add:

```yaml
type: custom:webpage-card
url: http://homeassistant.local:3000
```

### Method 3: Direct Link

Create a button card:

```yaml
type: button
name: Homepage
icon: mdi:view-dashboard
tap_action:
  action: url
  url_path: http://homeassistant.local:3000
```

---

## Supported Services

Homepage supports 100+ services. Here are popular ones:

**Media:**
Plex, Jellyfin, Emby, Tautulli, Overseerr, Ombi

**Downloads:**
Sonarr, Radarr, Lidarr, Readarr, Prowlarr, Bazarr, qBittorrent, Transmission, SABnzbd, NZBGet

**Home Automation:**
Home Assistant, Node-RED, Zigbee2MQTT, ESPHome

**Network:**
Pi-hole, AdGuard Home, Unifi, pfSense, OPNsense

**Monitoring:**
Portainer, Uptime Kuma, Healthchecks, Gotify, Grafana, Prometheus

**Storage:**
Nextcloud, Synology, TrueNAS, PhotoPrism

**And many more!** See full list: https://gethomepage.dev/en/widgets/

---

## FAQ

### Q: Do I need to restart after config changes?
**A:** Yes, restart the addon for configuration changes to take effect.

### Q: Can I use Homepage with reverse proxy?
**A:** Yes! Set `HOMEPAGE_ALLOWED_HOSTS=*` in addon options or configure specific hosts.

### Q: How do I add new services?
**A:** Edit `services.yaml` and add your service under an existing or new group.

### Q: Can I use my own icons?
**A:** Yes! Place them in `/addon_configs/homepage_addon/icons/` and reference as `/icons/filename.png`

### Q: Is there a mobile app?
**A:** No native app, but Homepage is fully responsive and works great as a Progressive Web App (PWA).

### Q: Can I password protect Homepage?
**A:** Homepage doesn't have built-in authentication. Use a reverse proxy with auth, or rely on Home Assistant's authentication if accessed through HA.

### Q: How do I backup my configuration?
**A:** Backup the entire `/addon_configs/homepage_addon/` directory. It contains all your configs.

---

## Support

- [Homepage Official Documentation](https://gethomepage.dev/)
- [Homepage GitHub](https://github.com/gethomepage/homepage)
- [Widget Documentation](https://gethomepage.dev/en/widgets/)
- [Report Issues](https://github.com/ghalpha/homeassistant-addons/issues)

## Credits

- Homepage by [gethomepage](https://github.com/gethomepage)
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
