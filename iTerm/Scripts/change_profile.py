#!/usr/bin/env python3.7

import iterm2
import sys

async def main(connection):
  app = await iterm2.async_get_app(connection)
  profiles = await iterm2.PartialProfile.async_query(connection)
  to_profile = sys.argv[1]
  for profile in profiles:
    if profile.name == to_profile:
      full_profile = await profile.async_get_full_profile()
      await app.current_terminal_window.current_tab.current_session.async_set_profile(full_profile)
      return

iterm2.run_until_complete(main)
