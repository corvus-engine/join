# join

The launcher for the group's Claude Code setup. Paste into Windows Terminal or PowerShell:

```
irm https://raw.githubusercontent.com/corvus-engine/join/main/j | iex
```

This repo is public so the line can stay short; it holds nothing secret. [`j`](j) installs GitHub CLI if
it is missing, signs you in to GitHub, then fetches and runs the setup from the private
`corvus-engine/rookery` with your own sign-in. You need an invitation to the corvus-engine organization
first.
