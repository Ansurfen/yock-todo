import os


def load_hook(path) -> dict[str, dict]:
    namespaces = {}
    files = [file for file in os.listdir(path)]
    for file in files:
        namespace = {}
        with open(os.path.join(path, file), 'r') as fp:
            code = fp.read()
            exec(code, namespace)
            namespaces[file] = namespace
    return namespaces
