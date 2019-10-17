#!/usr/bin/env python3.7

import iterm2

async def main(connection):
    profiles = await iterm2.PartialProfile.async_query(connection)
    for profile in profiles:
        print(profile.name)

iterm2.run_until_complete(main)
