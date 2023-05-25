from loader import load_hook

path = "./hooks/test/hooks"

namespaces = load_hook(path)

for namespace in namespaces.values():
    namespace["hook"](10)
