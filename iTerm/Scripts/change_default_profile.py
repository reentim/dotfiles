#!/usr/bin/env python3.7

import iterm2
import sys

async def main(connection):
  all_profiles = await iterm2.PartialProfile.async_query(connection)
  new_default = sys.argv[1]
  for profile in all_profiles:
    if profile.name == new_default:
      await profile.async_make_default()
      return

iterm2.run_until_complete(main)
