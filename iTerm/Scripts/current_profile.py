#!/usr/bin/env python3.7

import iterm2

async def main(connection):
  app = await iterm2.async_get_app(connection)
  profile = await app.current_terminal_window.current_tab.current_session.async_get_profile()
  print(profile.name)

iterm2.run_until_complete(main)
