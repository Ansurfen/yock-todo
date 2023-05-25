def hook():
    import os
    import json

    sources = [["gitlab", "https://gitlab.com//Ansurfen/yock-todo/blob/main/ypm/modules"],
               ["github", "https://raw.githubusercontent.com/ansurfen/yock-todo/main/ypm/modules"],
               ["gitee", "https://gitee.com/ansurfen/yock-todo/raw/main/ypm/modules"]]

    ypm_modules = "../ypm/modules/"

    modules = [module for module in os.listdir(
        ypm_modules) if os.path.isdir(os.path.join(ypm_modules, module))]

    for src in sources:
        data = {}
        file = src[0]
        url = src[1]
        for module in modules:
            data[module] = os.path.join(
                url, module, "boot.lua").replace(os.sep, "/")
        with open('../ypm/source/{}.json'.format(file), 'w') as fp:
            json.dump(data, fp)
