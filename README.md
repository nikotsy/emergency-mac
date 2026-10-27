# Emergency Mac

A small menu bar app that watches your Mac's memory, swap and CPU, remembers what chokes it, and, when you ask, starts a Claude Code session to clean up abandoned processes. Afterwards it shows what really improved, using its own measurements.

It lives in the menu bar as one circle:

| Indicator | Means |
|---|---|
| ○ | healthy |
| ◐ | elevated: memory pressure is up, or swap is growing |
| ● 6m | critical for 6 minutes: an incident is being recorded |
| ◌ 2:41 | a cleanup is running |

Monitoring works on its own. The cleanup is optional and needs [Claude Code](https://claude.com/claude-code) installed and signed in.

## Install

**The easy way.** Open Terminal and paste:

```bash
curl -fsSL https://raw.githubusercontent.com/nikotsy/emergency-mac/main/install.sh | bash
```

It downloads the latest release into `/Applications` and opens it. Run the same line again any time to reinstall.

**Or with the disk image.**
1. Download `Emergency-Mac-x.y.z.dmg` from [the latest release](https://github.com/nikotsy/emergency-mac/releases/latest).
2. Open it and drag **Emergency Mac** onto **Applications**.
3. Open it from Applications. The app isn't notarized by Apple, so macOS will refuse the first time: go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** next to Emergency Mac. You only do this once.

Needs macOS 14 Sonoma or later, on Apple silicon or Intel.

## Updates

The app checks for updates on launch and every six hours. It downloads them by itself, checks each one against a signature only the author can make, and shows **Install Update and Relaunch** at the bottom of the panel. You can turn automatic downloads off in settings.

## What it stores, and where

Everything stays on your Mac, in `~/Library/Application Support/Emergency Mac/`.
- Readings and process details are kept for 7 days.
- Incidents, culprits and reports are kept until you delete them.

Command lines are stored with secrets redacted, and environment variables are never read. Nothing is sent anywhere, except the update check to GitHub and, when you start a cleanup, the Claude Code session you started.

## What the cleanup may do

When you click **Start Emergency Cleanup**, the app runs `claude -p` with `--dangerously-skip-permissions` from its own folder. It hands Claude a written brief:
- what the app measured;
- which workloads are heaviest;
- what must never be touched: every Claude session, apps in use, system processes, and anything you protected.

Claude may stop only processes it can confidently call abandoned, such as an orphaned dev server. It never deletes files, clears caches or uses sudo.

These are instructions, not a sandbox. The app checks every claim against the process table afterwards and shows you the difference. You allow this once, in setup, after a test session proves it works.

## Uninstall

Quit it (settings → **Quit Emergency Mac**), then delete `/Applications/Emergency Mac.app` and `~/Library/Application Support/Emergency Mac/`.
