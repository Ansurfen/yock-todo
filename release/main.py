import json
import os
import subprocess
import time

from util.compress import tar, zip

from util.check import is_new_day, sha256
from util.loader import load_hook

setups = load_hook('./hooks/setup')

for setup in setups.values():
    setup["hook"]()

data: dict[str, dict] = {}

with open('release.json', 'r') as fp:
    data = json.load(fp)
    fp.close()

release_ver = data["_meta"]["version"]
release_ts = data["_meta"]["timestamp"]

# 1) it's assigned to current time when it has not run
# 2) fetch last timestamp to compare with current timestamp, and check whether it's a new day
if release_ts == 0 or is_new_day(release_ts):
    release_ver = 1  # accumulate one if new day, and it'll self-increment at the end of program, which meant the next version
    release_ts = time.time()  # to flush timestamp

# the tag of release consists of date and ver
# they will be concated to form 2023-1-1-v1 format as final tag
release_tag = time.strftime(
    '%Y-%m-%d', time.localtime(release_ts)) + f'-v{release_ver}'

# compress handle function and suffix
compress = [[tar, "tar.gz"], [zip, "zip"]]

# release list
candidates = []

os.mkdir("tmp")

for name, v in data.items():
    if name == "_meta":
        continue

    brfore_hash = data[name]["sha256"]
    after_hash = ""
    for idx, cmp in enumerate(compress):
        pack = f'{name}.{cmp[1]}'
        cmp[0](data[name]["dir"], f'./tmp/{pack}')
        if after_hash == "":
            after_hash = sha256(f'./tmp/{pack}')
        # check whether it's require to update for pack through comparing hash
        if brfore_hash == after_hash:
            break
        candidates.append(pack)
        # update digest based on the first pack
        if idx == 0:
            data[name]["sha256"] = after_hash
            # tag is recorded to synchronize version
            data[name]["tag"] = release_tag

if len(candidates) > 0:
    before_releases = load_hook('./hooks/before_release')

    for before_release in before_releases.values():
        before_release["hook"](release_tag, candidates, data)

    os.chdir("tmp")
    subprocess.run(['gh', 'release', 'create', release_tag] +
                   candidates, check=True)
    os.chdir("..")

    # on_releases = load_hook('./hooks/on_release')

    # for on_release in on_releases.values():
    #     on_release["hook"](release_tag, candidates)

    # subprocess.run(['rm', '-rf', '/tmp'])
    # subprocess.run(['rmdir', 'tmp'])

    # update release.json
    release_ver += 1  # self-increment version to confirm next version
    data["_meta"]["version"] = release_ver
    data["_meta"]["timestamp"] = release_ts
    with open('release.json', 'w+') as fp:
        json.dump(data, fp, indent=4)
        fp.close()
    subprocess.run(['git', 'config', '--global',
                   'user.name', '"ansurfen"'], check=True)
    subprocess.run(['git', 'config', '--global',
                   'user.email', f'"{os.environ["GH_EMAIL"]}"'], check=True)
    subprocess.run(['git', 'add', 'release.json'], check=True)
    subprocess.run(
        ['git', 'commit', '-m', f'{os.environ["GH_SHA"]}'], check=True)
    subprocess.run(['git', 'push', 'origin'], check=True)

# destoryeds = load_hook('./hooks/destoryed')

# for destory in destoryeds.values():
#     destory["hook"]()
