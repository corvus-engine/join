# join

The group's Claude Code setup, as one app for Windows.

**[Download Rookery.exe](https://github.com/corvus-engine/join/releases/latest/download/Rookery.exe)**, run it, and
follow the six screens. Before you start:

1. Accept the corvus-engine invitation on GitHub (the email from GitHub, or the bell at github.com).
2. Have the bot token corvo sent you to hand.
3. Have Claude Code installed and signed in. If it isn't, the first screen opens its install page: install it, run
   `claude` once in a terminal to sign in, then click **Check again**.

If Windows says *"Windows protected your PC"*, click **More info**, then **Run anyway** (the app isn't code-signed).

When it finishes, start the bot from the last screen. If the black window asks whether you trust the folder, choose
**Yes**; the development-channel warning is answered for you. Once the app says **Bot online: yes**, write
`@YourBot hello` in `#letters`.

Open Rookery.exe again any time: it is a dashboard from then on (start or stop the bot, change its picture,
**Update**, run the setup again).

## Without the app

The same setup as one line in Windows Terminal or PowerShell:

```
irm https://raw.githubusercontent.com/corvus-engine/join/main/j | iex
```

## What is here

- **Releases**: `Rookery.exe`, built from `app/` in the private `corvus-engine/rookery`. Each release names its asset
  `Rookery.exe`, so the download link above always gets the newest one.
- [`j`](j): the launcher behind the one line. This repo is public so the line can stay short; it holds nothing
  secret. It installs GitHub CLI if missing, signs you in to GitHub, then fetches and runs the setup from the private
  `corvus-engine/rookery` with your own sign-in, which is why you need the organization invitation first.
