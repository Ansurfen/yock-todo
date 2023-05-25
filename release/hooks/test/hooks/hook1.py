a = 5


def hook(b):
    print("exec hook1")
    global a
    a = 0
    print('a+b =', a+b)
    print("finish hook1")
