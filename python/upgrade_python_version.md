# Upgrade Python Version on CentOS 9

---

1. [Check your current Python version](#1-check-your-current-python-version)
2. [Update your system](#2-update-your-system)
3. [Install development tools](#3-install-required-tools)
4. [Download Python 3.12](#4-download-python-312)
5. [Build and install Python 3.12](#6-build-and-install-python-312)
6. [Switch between Python versions](#8-switching-between-python-versions)

---

### 1. **Check Your Current Python Version**

First, let’s see what version of Python you have on your CentOS 9 right now. Open your terminal and type:

```bash
python3 --version
```

This should show something like:

```
Python 3.9.x
```

Now, let’s upgrade it to Python 3.12.

---

### 2. **Update Your System**
We need to make sure your CentOS 9 is up-to-date before installing the new Python version.

Type this command to update everything:

```bash
sudo dnf update -y
```

This will update your system’s packages. Wait for it to finish.

---

### 3. **Install Required Tools**
Now, we need to install some tools to help us compile (build) the new Python version.

Run these commands:

```bash
sudo dnf groupinstall "Development Tools" -y
sudo dnf install wget openssl-devel bzip2-devel libffi-devel zlib-devel -y
```

- **`Development Tools`**: These help you build software.
- **Other Packages**: These libraries help Python work with things like zip files, security, and compression.

---

### 4. **Download Python 3.12**

Now, we’re going to download the new Python version from the official website.

Type this command to get Python 3.12:

```bash
wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz
```

This command fetches the Python 3.12 source code, which is like the "raw" Python that we will install.

---

### 5. **Extract the Python Files**

The file we just downloaded is a compressed file (like a zip file), so we need to "unzip" it.

Run this command to extract the files:

```bash
tar -xvzf Python-3.12.0.tgz
```

This creates a folder with all the files we need to build Python.

---

### 6. **Build and Install Python 3.12**

Now, we go into the new Python folder and build it. This step tells your system to install Python from the files we downloaded.

Follow these steps:

1. **Go into the Python folder**:
   ```bash
   cd Python-3.12.0
   ```

2. **Configure the build process**:
   ```bash
   ./configure --enable-optimizations
   ```

    - **`--enable-optimizations`**: This makes Python run faster by applying some tweaks.

3. **Build and Install Python**:
   ```bash
   sudo make altinstall
   ```

    - **`make altinstall`**: This compiles Python and installs it alongside your current version (Python 3.9), without replacing it.

This process might take a few minutes. Be patient!

---

### 7. **Check the New Python Version**

After the installation finishes, let’s check if Python 3.12 is installed.

Type:

```bash
python3.12 --version
```

You should see:

```
Python 3.12.0
```

🎉 Yay! You’ve installed Python 3.12!

---

### 8. **Switching Between Python Versions**

Now, you’ll have **both Python 3.9 and Python 3.12** on your system. To use Python 3.12, you’ll need to type `python3.12` instead of just `python3`.

If you want to make Python 3.12 your default, here’s how:

1. Create a symbolic link:
   ```bash
   sudo ln -sf /usr/local/bin/python3.12 /usr/bin/python3
   ```

Now, when you type `python3`, it will use Python 3.12.

---

### 9. **Update `pip` for Python 3.12**

Finally, let’s update `pip`, the package manager for Python. First, check if `pip` is working with Python 3.12:

```bash
python3.12 -m ensurepip --upgrade
```

Then, upgrade `pip`:

```bash
python3.12 -m pip install --upgrade pip
```

Now you’re all set with Python 3.12 and `pip`!


