#!/usr/bin/env python3

import urllib.request
import sys
import ssl
import time

def wait_for_firewall(ip):
    url = 'https://{}'.format(ip)
    context = ssl._create_unverified_context()
    while True:
        try:
            urllib.request.urlopen(url, timeout=1, context=context)
            return
        except:
            pass
        time.sleep(10)

wait_for_firewall(sys.argv[1])
