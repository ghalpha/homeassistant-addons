# Home Assistant Add-on: Dashy

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

A highly customizable, easy to use, privacy-respecting dashboard app.

## About

Dashy is an open-source dashboard that helps you organize your self-hosted services. It features a clean interface, easy configuration, and extensive customization options.

**Features:**
- 🎨 Multiple built-in themes and custom CSS support
- 🔍 Instant search with keyboard shortcuts
- 📱 Responsive design for mobile and desktop
- 🌐 Multi-language support
- 🔐 Optional authentication
- 📊 Status monitoring for your services
- ⚡ Fast and lightweight
- 🎯 Multiple layout options

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Dashy" add-on and click it
4. Click on the "INSTALL" button

## How to Use

### Quick Start

1. Start the add-on
2. Access Dashy through the Web UI
3. The addon will automatically generate a basic configuration
4. Customize your dashboard by editing the configuration (see below)

### Configuration Methods

You have three ways to configure Dashy:

#### Method 1: Addon Options (Recommended for Basic Setup)
Configure basic settings through the addon configuration panel. The addon will automatically generate the `conf.yml` file.

#### Method 2: Direct File Editing (For Advanced Customization)
Edit `/addon_configs/dashy/conf.yml` directly for full control. You can add sections, items, and customize everything according to [Dashy's documentation](https://dashy.to/docs/).

#### Method 3: Custom Configuration File (For Complete Control)
Create `/addon_configs/dashy/conf.yml.custom` - this file will be used instead of the auto-generated one, giving you complete control while preserving your changes across addon updates.

## Configuration

### Option: `page_title`

The title displayed in the browser tab and header. Default is `Dashy`.

**Example:** `"My Home Dashboard"`

### Option: `description`

A subtitle or description for your dashboard.

**Example:** `"Control Center for All My Services"`

### Option: `theme`

Choose from multiple built-in themes:
- `default` - Clean and simple
- `colorful` - Vibrant colors
- `nord` - Nord color palette
- `nord-frost` - Nord with blue accents
- `material` - Material Design light
- `material-dark` - Material Design dark
- `dracula` - Dracula theme
- `high-contrast-light` - High contrast light mode
- `high-contrast-dark` - High contrast dark mode
- `one-dark` - One Dark theme
- `glass` - Glassmorphism effect

### Option: `language`

Set the interface language. Supported languages:
- `en` - English
- `de` - German
- `es` - Spanish
- `fr` - French
- `it` - Italian
- `nl` - Dutch
- `pt` - Portuguese
- `ru` - Russian
- `zh` - Chinese

### Option: `layout`

Choose how items are displayed:
- `auto` - Automatically adjusts based on screen size
- `horizontal` - Items arranged in rows
- `vertical` - Items arranged in columns

### Option: `icon_size`

Size of service icons:
- `small` - Compact view
- `medium` - Default size
- `large` - Larger icons for better visibility

### Option: `hide_settings`

Hide the settings button. Default is `false`.

### Option: `hide_footer`

Hide the footer section. Default is `false`.

### Option: `enable_multi_tasking`

Allow opening multiple items in the background. Default is `true`.

### Option: `custom_css`

Add your own custom CSS to style the dashboard. This will be injected into the page.

**Example:**
```css
body {
  font-family: 'Roboto', sans-serif;
}
.item {
  border-radius: 10px;
}
```

## Example Configurations

### Basic Configuration
```json
{
  "page_title": "My Dashboard",
  "description": "Home Lab Control Center",
  "theme": "nord",
  "language": "en",
  "layout": "auto",
  "icon_size": "medium"
}
```

### Dark Theme with Custom Styling
```json
{
  "page_title": "Control Center",
  "theme": "material-dark",
  "layout": "horizontal",
  "icon_size": "large",
  "custom_css": ".item { box-shadow: 0 4px 6px rgba(0,0,0,0.3); }"
}
```

### Minimal Setup
```json
{
  "page_title": "Services",
  "theme": "default",
  "hide_footer": true,
  "hide_settings": false
}
```

## Adding Your Services

After the addon generates the initial configuration, you'll want to add your own services:

### Option 1: Edit Through Dashy UI
1. Click the settings icon (if not hidden)
2. Click "Edit Config"
3. Add your sections and items
4. Click "Save" to apply changes

### Option 2: Edit Configuration File
1. Access `/addon_configs/dashy/conf.yml`
2. Add sections and items following this structure:

```yaml
sections:
  - name: Media
    icon: fas fa-photo-video
    items:
      - title: Plex
        description: Media Server
        icon: hl-plex
        url: http://192.168.1.100:32400
        target: newtab
      
      - title: Jellyfin
        description: Media System
        icon: hl-jellyfin
        url: http://192.168.1.101:8096
        target: newtab

  - name: Home Automation
    icon: fas fa-home
    items:
      - title: Home Assistant
        description: Smart Home Hub
        icon: hl-home-assistant
        url: http://192.168.1.102:8123
        target: newtab
```

### Available Icons

Dashy supports multiple icon sets:
- **Home Lab Icons**: Use `hl-` prefix (e.g., `hl-plex`, `hl-jellyfin`, `hl-home-assistant`)
- **Font Awesome**: Use `fas`, `fab`, `far` prefix (e.g., `fas fa-home`, `fab fa-github`)
- **Material Design Icons**: Use `mdi-` prefix (e.g., `mdi-home`, `mdi-server`)
- **Custom**: Provide a URL to your own icon image

Browse available icons:
- Home Lab Icons: https://github.com/WalkxCode/dashboard-icons
- Font Awesome: https://fontawesome.com/icons
- Material Design Icons: https://materialdesignicons.com/

## Advanced Features

### Status Checking

Add health checks to monitor service availability:

```yaml
items:
  - title: Plex
    url: http://192.168.1.100:32400
    icon: hl-plex
    statusCheck: true
    statusCheckUrl: http://192.168.1.100:32400/web
```

### Opening Behavior

Control how links open:
- `sametab` - Open in same tab
- `newtab` - Open in new tab (default)
- `modal` - Open in embedded modal
- `workspace` - Open in Dashy workspace

### Widgets

Dashy supports widgets for real-time information:

```yaml
sections:
  - name: System Info
    widgets:
      - type: clock
        options:
          timeZone: America/New_York
          format: en-US
```

## Backup and Restore

Your configuration is stored in `/addon_configs/dashy/`. To backup:

1. Copy the entire `/addon_configs/dashy/` directory
2. Or just backup `conf.yml` / `conf.yml.custom`

To restore, simply replace the files and restart the addon.

## Troubleshooting

### Configuration Not Updating

If changes don't appear:
1. Restart the addon
2. Clear your browser cache
3. Check addon logs for errors

### Icons Not Displaying

- Ensure you're using the correct icon prefix
- Try using a direct icon URL
- Check if your network can access icon CDNs

### Services Not Accessible

- Verify the URLs are correct
- Check that services are running
- Ensure there are no firewall rules blocking access

## Support

- [Dashy Official Documentation](https://dashy.to/docs/)
- [Dashy GitHub](https://github.com/Lissy93/dashy)
- [Report Issues](https://github.com/ghalpha/homeassistant-addons/issues)

## Credits

- Dashy created by [Alicia Sykes](https://github.com/Lissy93)
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
