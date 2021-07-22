#!/usr/bin/env python3

import sys
import json
from hashlib import md5
from random import SystemRandom

def md5crypt(pw, salt):
    itoa64 = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    pw = pw.encode("utf-8")
    pwlen = len(pw)

    # r = SystemRandom()
    # salt = "".join(r.choice(itoa64) for i in range(8)).encode("ascii")
    salt = salt.encode("ascii")

    p = pw
    pp = pw + pw
    ps = pw + salt
    psp = pw + salt + pw
    sp = salt + pw
    spp = salt + pw + pw

    permutations = [
        (p , psp), (spp, pp), (spp, psp), (pp, ps ), (spp, pp), (spp, psp),
        (pp, psp), (sp , pp), (spp, psp), (pp, psp), (spp, p ), (spp, psp),
        (pp, psp), (spp, pp), (sp , psp), (pp, psp), (spp, pp), (spp, ps ),
        (pp, psp), (spp, pp), (spp, psp)
    ]

    da = md5(pw + b"$1$" + salt)

    db = md5(psp).digest()

    for i in range(pwlen, 0, -16):
        da.update(db if i > 16 else db[:i])
    
    i = pwlen
    while i:
        da.update(b"\x00" if i & 1 else pw[:1])
        i >>= 1
    da = da.digest()

    for r in range(23):
        for i, j in permutations:
            da = md5(j + md5(da + i).digest()).digest()

    for i, j in permutations[:17]:
        da = md5(j + md5(da + i).digest()).digest()

    final = ''
    for x, y, z in ((0, 6, 12), (1, 7, 13), (2, 8, 14), (3, 9, 15), (4, 10, 5)):
        v = da[x] << 16 | da[y] << 8 | da[z]
        for i in range(4):
            final += itoa64[v & 63]
            v >>= 6
    v = da[11]
    for i in range(2):
        final += itoa64[v & 63]
        v >>= 6

    return "$1${}${}".format(salt.decode("utf-8"), final)

def crypt_password():
    query = json.loads(sys.stdin.read())
    sys.stdout.write(json.dumps({
        "crypt_password": md5crypt(
            query.get('password'),
            query.get('salt'),
        )
    }))

if __name__ == "__main__":
    crypt_password()
