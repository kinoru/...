#!/usr/bin/env python

import sys
from random import SystemRandom

random = SystemRandom()

flags = {
    'a': 'abcdefghijklmnopqrstuvwxyz',
    'A': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    '0': '0123456789',
    '!': '!@#$%^&*()',
}

choices = ''.join(flags[c] for c in sys.argv[1])

print(''.join(
    random.choice(choices)
    for _ in
    range(int(sys.argv[2]))
))
