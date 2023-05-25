# 钩子

[English](../../../release/hooks/README.md) | 简体中文

在actions执行的时候，会唤起`/release/main.py`执行，main.py文件主要任务就是release指定的各个模块（具体可以在release.json中查看）。为了拓展main.py的功能，借此引入了钩子系统，他其实就是执行到某一步就拉起文件eval，回调执行。

## 生命周期

