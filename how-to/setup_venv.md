# Create virtual environment

In the terminal, update pip and other installation dependencies so you have the latest version as follows:

*Note: for linux users you may have to substitute python3 instead of python and also add a --user flag in the subsequent commands outside the virtual environment*

```sh
$ python -m pip install --upgrade pip setuptools virtualenv
```
## 1. Create virtual environment for your python project

---

Create a new virtual environment for your project. A virtual environment will prevent possible installation conflicts with other Python versions and packages. It’s optional but strongly recommended:

1. Create the virtual environment named my_venv in your current directory or use your own unique name and the desired project directory:

    ```sh
    python -m virtualenv my_venv
    ```

2. Activate the virtual environment. `You will have to do this step from the current directory every time you start a new terminal.` This sets up the environment so the new my_venv Python is used.

    For `Windows default CMD`, in the command line do:

    ```cmd
    my_venv\Scripts\activate
    (my_venv) > 
    ```

    If you are in a bash terminal on Windows, instead do:

    ```bash
    source my_venv/Scripts/activate
    (my_venv) $
    ```

    If you are in linux, instead do:

    ```bash
    source my_venv/bin/activate
    (my_venv) $ 
    ```

    Your terminal should now preface the path with something like (my_venv), indicating that the my_venv environment is active. If it doesn’t say that, the virtual environment is not active and the following won’t work.

## 2. Installing/Remove/List packages from your new my_venv virtual environment

We will install Kivy as an example using one of the following options:

1. Pre-compiled wheels

    The simplest is to install the current stable version of kivy and optionally kivy_examples from the kivy-team provided PyPi wheels. Simply do:

    *Note: for linux users you may have to substitute python3 instead of python and also add a --user flag in the subsequent commands outside the virtual environment*

    **This also installs the minimum dependencies of Kivy. To additionally install Kivy with audio/video support, install either kivy[base,media] or kivy[full]. See Kivy’s dependencies for the list of selectors.**

    ```bash
    (my_venv) $ python -m pip install kivy[base] kivy_examples
    ```

2. From source
   
    If a wheel is not available or is not working, Kivy can be installed from source with some additional steps. Installing from source means that Kivy will be installed from source code and compiled directly on your system.

    First install the additional [system dependencies listed](https://kivy.org/doc/stable/gettingstarted/installation.html#installing-kivy-s-dependencies) for each platform: Windows, OS X, Linux, RPi.

    With the dependencies installed, you can now install Kivy into the virtual environment.

    To install the stable version of Kivy, from the terminal do:

    ```bash
    (my_venv) $ python -m pip install kivy[base] kivy_examples --no-binary kivy
    ```

    To install the latest cutting-edge Kivy from master, instead do:

    ```bash
    (my_venv) $ python -m pip install "kivy[base] @ https://github.com/kivy/kivy/archive/master.zip"
    ```
3. To remove a package:

    ```sh
    (my_venv) $ pip uninstall package_name
    ```

4. To get list of packages required by any given package (using pip):

    ```sh
    (my_venv) $ pip show package_name
    ```

5. This will show you the packages that are required for it to run, and also the packages that require your package for them to run.

    So the best way to uninstall a package with all its dependency packages is to run `pip show package_name` first to see the list of its dependency packages and then uninstall it along with its dependency packages one by one. For example:

    ```sh
    (my_venv) $ pip show package_name
    (my_venv) $ pip uninstall package_name
    (my_venv) $ pip uninstall dependency_package_1
    (my_venv) $ pip uninstall dependency_package_2
    ```