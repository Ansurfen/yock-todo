def hook(tag: str, candidates: list[str], conf: dict[str, dict]) -> None:
    update = False
    import subprocess

    for cand in candidates:
        if cand.startswith('ypm'):
            update = True
            subprocess.run(['rm', f'./tmp/{cand}'], check=True)

    if not update:
        return

    import json
    import os
    import re
    from util.compress import tar, zip

    modules = {}
    with open('./conf/ypm.json', 'r') as fp:
        modules = json.load(fp)

    ypm_modules_path = "../ypm/modules"

    pattern = r'(tag\s*=\s*)("[^"]*")'
    replace_tmpl = r'\1"{0}"'

    for module in modules:
        boot = os.path.join(ypm_modules_path, module, "boot.lua")
        data = ""
        with open(boot, "r") as fp:
            data = fp.read()
            fp.close()

        data = re.sub(pattern, replace_tmpl.format(tag), data)

        with open(boot, 'w') as fp:
            fp.write(data)
            fp.close()

    # compress handle function and suffix
    compress = [[tar, "tar.gz"], [zip, "zip"]]

    for cmp in compress:
        cmp[0](conf["ypm"]["dir"],
               f'./tmp/ypm.{cmp[1]}')
