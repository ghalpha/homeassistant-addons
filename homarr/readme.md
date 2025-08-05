# Home Assistant Add-on: Homarr

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

A sleek, modern dashboard that puts all of your apps and services at your fingertips.

## About

Homarr is a highly customizable dashboard for your self-hosted applications with extensive integrations. It features:

- 🖌️ Highly customizable with an extensive drag and drop grid system
- ✨ Integrates seamlessly with your favorite self-hosted applications
- 📌 Easy and fast app management - no YAML involved
- 👤 Detailed and easy to use user management with permissions and groups
- 🔍 Search through thousands of data points in supported integrations
- 🦞 Icon picker with over 11K icons
- 🚀 Compatible with any major consumer hardware

## Installation

The installation of this add-on is straightforward:

1. Navigate in your Home Assistant frontend to **Supervisor** → **Add-on Store**.
2. Add this repository URL: `https://github.com/ghalpha/homeassistant-addons`
3. Find the "Homarr" add-on and click it.
4. Click on the "INSTALL" button.

## How to use

1. Start the add-on.
2. Check the add-on log output to see the result.
3. Access Homarr through the Web UI or through Home Assistant ingress.

## Configuration

### Option: `secret_encryption_key` (optional)

A 64-character hex string used for encrypting sensitive data. If not provided, one will be generated automatically. **Important**: Save the generated key in your configuration to persist data across restarts.

**Note**: _You can generate a key using: `openssl rand -hex 32`_

### Option: `port`

The port Homarr will run on. Default is `7575`.

### Option: `enable_docker_integration`

Enable Docker integration to manage containers directly from Homarr. Default is `true`.

**Note**: _Docker integration requires the Docker socket to be mounted, which is handled automatically by this add-on._

## Example add-on configuration

```json
{
  "secret_encryption_key": "your_64_character_hex_string_here",
  "port": 7575,
  "enable_docker_integration": true
}
```

## Integrations

Homarr supports integrations with many applications including:
- 📥 Torrent clients (qBittorrent, Transmission, etc.)
- 📥 Usenet clients (SABnzbd, NZBGet, etc.)
- 📺 Media servers (Plex, Jellyfin, Emby, etc.)
- 📚 Media collection managers (Sonarr, Radarr, etc.)
- 🎞️ Media request managers (Overseerr, Ombi, etc.)
- 🚫 DNS ad-blockers (Pi-hole, AdGuard Home, etc.)
- 🖥️ Monitoring tools
- 🐳 Container management

## Support

Got questions?

You could also [open an issue here][issue] on GitHub.

## Authors & contributors

The original setup of this repository is by [Your Name][your-github].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2025 [Your Name][your-github]

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

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[contributors]: https://github.com/ghalpha/homeassistant-addons/graphs/contributors
[your-github]: https://github.com/ghalpha
[issue]: https://github.com/ghalpha/homeassistant-addons/issues