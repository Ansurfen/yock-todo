import os


a = 10

hooks = "./hooks"

files = [file for file in os.listdir(hooks)]

for file in files:
    namespace = {}
    with open(os.path.join(hooks, file), 'r') as fp:
        code = fp.read()
        exec(code, namespace)
        namespace["hook"](a)
print(a)
