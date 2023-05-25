import subprocess


def zip(source_dir: str, target_file: str) -> None:
    cmd = ['zip', '-r', '-X', target_file, source_dir]
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        raise Exception(
            f"Failed to compress directory {source_dir}. Error: {e}")

    print(f"Successfully compressed directory {source_dir} into {target_file}")


def tar(source_dir: str, target_file: str) -> None:
    cmd = ['tar', '-czf', target_file, "--mtime='2021-01-01'", source_dir]
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        raise Exception(
            f"Failed to compress directory {source_dir}. Error: {e}")

    print(f"Successfully compressed directory {source_dir} into {target_file}")
