
# Update Alternatives

Now that you have both Python 3.9 and Python 3.12 installed, you can use
the `update-alternatives` command to switch between them.

To update the default Python version on your system using the `update-alternatives`
command after upgrading Python from 3.9 to 3.12, follow these steps:

## Step-by-Step Guide:

1. **Check the Installed Python Versions**

   First, check if both Python 3.9 and Python 3.12 are installed on your system:

   ```bash
   ls /usr/bin/python*
   ```

   You should see the paths for both `python3.9` and `python3.12`.

2. **Add Python 3.12 to the Alternatives System**

   Run the following command to add Python 3.12 to the alternatives system, specifying its location and giving it a priority:

   ```bash
   sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 2
   ```

    - `/usr/bin/python3`: The default Python 3 symlink.
    - `python3`: The name for this alternative.
    - `/usr/bin/python3.12`: The path to the new Python 3.12 interpreter.
    - `2`: Priority. You can use any number, but a higher number gives it more priority.

3. **Verify the Installed Python Alternatives**

   After adding Python 3.12, list the available Python alternatives with:

   ```bash
   sudo update-alternatives --config python3
   ```

   You will see a list of Python versions you can choose from.

4. **Set Python 3.12 as the Default**

   Choose the number corresponding to Python 3.12 to make it the default version. You will be prompted to choose an option, like so:

   ```bash
   There are 2 choices for the alternative python3 (providing /usr/bin/python3).

     Selection    Path                Priority   Status
   ------------------------------------------------------------
     1            /usr/bin/python3.9   1         auto mode
   * 2            /usr/bin/python3.12  2         manual mode
   ```

   Enter the number for Python 3.12, in this case, `2`.

5. **Check the Default Python Version**

   Finally, verify that Python 3.12 is now the default version:

   ```bash
   python3 --version
   ```

   This should return `Python 3.12.x`.

---

## Bonus: Set Python `pip3` Alternatives

If you also want to update `pip3` to use the new version of Python 3.12, repeat the steps for `pip3`:

1. **Add pip3 for Python 3.12 to alternatives**:
   ```bash
   sudo update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3 2
   ```

2. **Choose the pip3 version**:
   ```bash
   sudo update-alternatives --config pip3
   ```

By following these steps, you should now have Python 3.12 as your default
version using the `update-alternatives` system on your machine.
