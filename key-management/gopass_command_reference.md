# `gopass` Command Reference

## Introduction
`gopass` is a password manager for your terminal, written in Go, that allows for secure management of your credentials. Below is a comprehensive guide to the commands available in `gopass`, grouped by functionality and options.

---

## Basic Commands

### `gopass show` command

**Description**: Display the content of a secret or all secrets stored under a 
path. The `show` command is the most important and most frequently used command.
It allows displaying and copying the content of the secrets managed by gopass.

**Usage**:

```bash
gopass show <entry> 
gopass show <entry> [key] [flags]
gopass show <entry>  --qr
gopass show <entry> --password
```

#### Modes of operation

* Show the whole entry: `gopass show entry`
* Show a specific key of the given entry: `gopass show entry key` (only works for key-value or YAML secrets)

#### Flags

| Flag          | Aliases | Description                                                                                                                                                              |
|---------------|---------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--clip`      | `-c`    | Copy the password value into the clipboard and don't show the content.                                                                                                   |
| `--alsoclip`  | `-C`    | Copy the password value into the clipboard and show the content.                                                                                                         |
| `--qr`        |         | Encode the password field as a QR code and print it. Note: When combining with `-c`/`-C` the unencoded password is copied. Not the QR code.                              |
| `--unsafe`    | `-u`    | Display unsafe content (e.g. the password) even when the `safecontent` option is set. No-op when `safecontent` is `false`.                                               |
| `--password`  | `-o`    | Display only the password. For use in scripts. Takes precedence over other flags.                                                                                        |
| `--revision`  | `-r`    | Display a specific revision of the entry. Use an exact version identifier from `gopass history` or the special `-<N>` syntax. Does not work with native (e.g. git) refs. |
| `--noparsing` | `-n`    | Do not parse the content, disable YAML and Key-Value functions.                                                                                                          |
| `--chars`     |         | Display selected characters from the password.                                                                                                                           |

#### Details

This section describes the expected behaviour of the `show` command with respect to different combinations of flags and
config options.

Note: This section describes the expected behaviour, not necessarily the observed behaviour.
If you notice any discrepancies please file a bug and we will try to fix it.

TODO: We need to specify the expectations around new lines.

* When no flag is set the `show` command will display the full content of the secret and will parse it to support key-value lookup and YAML entries.
  If the `safecontent` option is set to `true` any secret fields (current default is only `password`) are replaced with a random number of '*' characters (length: 5-10). 
  Using the `--unsafe` flag will reveal these fields even if `safecontent` is enabled. `--password` takes precedence of `safecontent=true` as well and displays only the password.
* The `--noparsing` flag will disable all parsing of the output, this can help debugging YAML secrets for example, where `key: 0123` actually parses into octal for 83. 
* The `--clip` flag will copy the value of the `Password` field to the clipboard and doesn't display any part of the secret.
* The `--alsoclip` option will copy the value of the `Password` field but also display the secret content depending on the `safecontent` setting, i.e. obstructing the `Password` field if `safecontent` is `true` or just displaying it if not.
* The `--qr` flags operates complementary to other flags. It will *additionally* format the value of the `Password` entry as a QR code and display it. Other than that it will honor the other options, e.g. `gopass show --qr` will display the QR code *and* the whole secret content below. One special case is the `-o` flag, this flag doesn't make a lot of sense in combination, so if both `--qr` and `-o` are given only the QR code will be displayed.
* Since gopass plans to supports different RCS backends we do not support arbitrary git refs as arguments to the `--revision` flag. Using those might work, but this is explicitly not supported and bug reports will be closed as `wont-fix`. There are two issues with using arbitrary git refs is that (a) this doesn't work with non-git RCS backends and (b) git versions a whole repository, not single files. So the revision `HEAD^`
  might not have any changes for a given entry. Thus we only support specifc revisions obtained from `gopass history` or our custom syntax `-N` where N is an integer identifying a specific commit before `HEAD` (cf. `HEAD~N`).

#### Parsing and secrets

Secrets are stored on disk as provided, but are parsed upon display to provide extra features such as the ability 
to show the value of a key using:  `gopass show entry key`.

The secrets are split into 3 categories:

 - the plain type, which is just a plain secret without key-value capabilities 
    
   ```
    this is a plain secret
    using multiple lines
    
    and that's it
    ```
   
    gets parsed to the same value


 - the key-value type, which allows to query the value of a specific key. This does not preserve ordering.
    
   ```
    this is a KV secret
    where: the first line is the password
    and: the keys are separated from their value by :
    
    and maybe we have a body text
    below it
    ```
    will be parsed into (with `safecontent` enabled):
   
    ```
    and: the keys are separated from their value by :
    where: the first line is the password
    
    
    and maybe we have a body text
    below it
    ```


 - the YAML type which implements YAML support, which means that secrets are parsed as per YAML standard.
    
   ```
    s3cret
    ---
    invoice: 0123
    date   : 2001-01-23
    bill-to: &id001
        given  : Bob
        family : Doe
    ship-to: *id001
    ```
   will be parsed into (with `safecontent` enabled):

   ```
    bill-to: map[family:Doe given:Bob]
    date: 2001-01-23 00:00:00 +0000 UTC
    invoice: 83
    ship-to: map[family:Doe given:Bob]
    ```
   
   Note how the `0123` is interpreted as octal for 83. If you want to store a string made of digits such as a numerical
   username, it should be enclosed in string delimiters: `username: "0123"` will always be parsed as the string `0123`
   and not as octal.

Both the key-value and the YAML format support so-called "unsafe-keys", which is a key-value that allows you to specify keys that should be hidden when using `gopass show` with `gopass config safecontent` set to true.
E.g:

```
supersecret
---
age: 27
secret: The rabbit outran the tortoise
name: John Smith
unsafe-keys: age,secret
```

will display (with safecontent enabled):

``` 
age: *****
name: John Smith
secret: *****
unsafe-keys: age,secret
```

unless it is called with `gopass show -n` that would disable parsing of the body, but still hide the password, or `gopass show -f` that would show everything that was hidden, including the password.

Notice that if the option `parsing` is disabled in the config, then all secrets are handled as plain secrets.

---

## Secrets Management

---

### `gopass insert` command

**Description**: Insert a new secret or update an existing secret.

**Usage**:

```bash
gopass insert <entry>
gopass insert <entry> [key] [flags]
```

#### Modes of operation

* Create a new entry with a user-supplied password, e.g. a new site with a user-generated password or one picked from `gopass pwgen`: `gopass insert entry`
* Change an existing entry to a user-supplied password
* Create and change any field of a new or existing secret: `gopass insert entry key`
* Read data from STDIN and insert (or append) to a secret

Insert is similar in effect to `gopass edit` with the advantage of not displaying any content of the secret when changing a key.

Note: `insert` will not change anything but the `Password` field (using the `insert entry` invocation) or the specified key (using the `insert entry key` invocation).

#### Flags

| Flag          | Aliases | Description                                                                                                            |
|---------------|---------|------------------------------------------------------------------------------------------------------------------------|
| `--echo`      | `-e`    | Display the secret while typing (default: `false`)                                                                     |
| `--multiline` | `-m`    | Insert using `$EDITOR` (default: `false`). This identical to running `gopass edit entry`. All other flags are ignored. |
| `--force`     | `-f`    | Overwrite any existing value and do not prompt. (default: `false`)                                                     |
| `--append`    | `-a`    | Append to any existing data. Only applies if reading from STDIN. (default: `false`)                                    |

To insert a password for a specific domain name or SSH client in `gopass`, you can use the `gopass insert` command and specify a structured path for your secrets. This allows you to organize passwords by domain name, SSH client, or any other category.

#### Inserting a Password for a Domain

To insert a password for a specific domain (e.g., `example.com`), you can organize it by creating a path under a "domains" directory in your password store.

**Steps**:
1. Run the following command:
   ```bash
   gopass insert domains/example.com
   ```
2. You will be prompted to enter a new secret (password). If you'd like to store 
additional details like username, you can enter those as separate lines.
   
For example, the secret might look like this:

```
username: user@example.com
password: P@ssw0rd123
```

#### Inserting a Password for SSH Client

For SSH passwords, you might want to organize them under an `ssh` directory.

**Steps**:
1. Run the following command:
   ```bash
   gopass insert ssh/client1
   ```
2. Enter the password for the SSH client.

You can also include specific SSH-related information such as the SSH key passphrase.

#### Example of Using Multi-line Secrets

For both domain and SSH passwords, you might want to use multi-line input for extra 
information (like username, IP address, or other SSH details). Use the `--multiline` option:

```bash
gopass insert --multiline ssh/client1
```

Then enter details like this:

```
username: user1
host: 192.168.1.1
password: sshP@ss123
```

This setup allows you to organize your secrets in a structured and searchable way, 
making it easier to manage credentials for different domains and SSH clients.

---

### `gopass generate` command

**Description**: Generate a new random password and optionally store it in a specified path.

Note: If you only want generate a password without storing it in the store, use the `pwgen` command.

**Usage**:

```bash
gopass generate <entry> [length]
gopass generate <entry> [key] [length]
gopass generate <entry> [key] [length] [flags]
# Generate a password without storing it
gopass pwgen [length] [flags]
```

#### Modes of operation

* Generate a new entry with a new password, e.g. a new login. Setting the `Password` field, `gopass generate entry [chars]`
* Re-generating a new password and setting it in the `Password` field of an existing entry
* Generate a new password and setting it to a new key of an existing secret, e.g. `gopass generate entry key [chars]`
* Re-generate a new password for an existing key in an existing entry

#### Flags

| Flag          | Aliases | Description                                                                                                                                                        |
|---------------|---------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--clip`      | `-c`    | Copy the generated password into the clipboard. Default: Value of `autoclip`                                                                                       |
| `--print`     | `-p`    | Print the generated password to the terminal. Default: false.                                                                                                      |
| `--force`     | `-f`    | Force overwriting an existing entry.                                                                                                                               |
| `--edit`      | `-e`    | Generate a password and open the entry for editing in `$EDITOR`.                                                                                                   |
| `--generator` | `-g`    | Choose of of the available password generators, desribed below. Default: `cryptic`                                                                                 |
| `--symbols`   | `-s`    | Include symbols in the generated password (default: `false`)                                                                                                       |
| `--strict`    |         | Ensure each requested character class is actually included. Without this option all requested classes can be included, but not necessarily are. (default: `false`) |
| `--sep`       |         | Word separator for multi-word generators.                                                                                                                          |
| `--lang`      |         | Language for word-based generators.                                                                                                                                |

#### Password Generators

Use `--generator` to select one of the available password generators:

| Generator   | Description                                                                                                                                                                                                                                                                      |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cryptic`   | The default generator yields cryptic passwords that should work with most sites. Use `--symbols` and `--strict` if the site has specific requirements. Please note that we auto-detect the correct rules for some sites. The length argument specifies the number of characters. |
| `xkcd`      | Use an [XKCD#936](https://xkcd.com/936/) style password. Use `--lang` and `--sep` to refine it's behaviour. The length argument specifies the number of words.                                                                                                                   |
| `memorable` | Generate a memorable password. The length argument specifies the minimum lenght of characters. Please note that the password might be longer if not all necessary rules were satisfied by the minimum length solution.                                                           |
| `external`  | Use the external generator from `$GOPASS_EXTERNAL_PWGEN`                                                                                                                                                                                                                         |

#### Relevant configuration options

* `autoclip` only applies to `generate`. If set the generated password is automatically copied to the clipboard - unless `--clip` is explicitly set to `--clip=false`
* `safecontent` will suppress printing of the password, unless `-p` is set. The password will not be copied, unless `-c` or the `autoclip` option are set.

#### Templates

When creating a new entry gopass will look for the most specific template
by going up in the secret path looking for a file called `.pass-template`.

If any such file is found it will be used to pre-populate the generated
secret.

---

### `gopass edit` command

**Description**: Edit a secret in your favorite text editor.

**Usage**:

```bash
gopass edit <entry>
gopass edit -e /bin/nano <entry> 
# set the editor to nano and open the secret for editing
export EDITOR=/bin/nano 
gopass edit <entry>
```

#### Modes of operation

* Create a new secret
* Edit an existing secret

#### Flags

| Flag       | Aliases | Description                                                                                                                           |
|------------|---------|---------------------------------------------------------------------------------------------------------------------------------------|
| `--editor` | `-e`    | Specify the path to an editor. Must accept the filename as it's first argument.                                                       |
| `--create` | `-c`    | Create a new secret. You can create a new secret with `edit` with or without `-c`, but `-c` will skip searching for existing matches. |

---

### `gopass rm | delete` command

**Description**: Remove a secret or a whole subtree from the store.

**Usage**:

```bash
gopass delete <entry>
gopass delete <entry> [key]
gopass delete <entry> --recursive
gopass delete <entry> --force
gopass rm -r path/to/folder
gopass rm -f <entry>
```

#### Modes of operation

* Delete a single secret
* Delete a single key from an existing secret
* Delete a directoy of secrets

#### Flags

| Flag          | Aliases | Description                           |
|---------------|---------|---------------------------------------|
| `--recursive` | `-r`    | Recursively delete files and folders. |
| `--force`     | `-f`    | Do not ask for confirmation.          |

#### Details

**Removing a single key will need to decrypt the secret**

---

### `gopass mv | copy` command

**Note**: The implementations for `copy` and `move` are exactly the same. The only difference is that `move` will remove the source after a successful copy.

**Description**: Move a secret to another location within the store. The `move` command works like the Unix `mv` or `rsync` binaries. It allows moving either single entries or whole folders around. Moving across mounts is supported.

If the source is a directory, the source directory is re-created at the destination if no trailing slash is found. Otherwise the contained secrets are placed into the destination directory (similar to what `rsync` does).

Please note that `move` will always decrypt the source and re-encrypt at the destination.

Moving a secret onto itself is a no-op.

**Usage**:

```bash
# Move a single secret
gopass mv <source> <destination>
# Overwrite new/leaf
gopass move path/to/leaf new/leaf
# Move the content of path/to/somedir to new/dir/somedir
gopass move path/to/somedirdir new/dir
# Does nothing
gopass move entry entry
# Copy a secret to another secret
gopass copy source/secret destination/secret
```

#### Modes of operation

* Move a single secret from source to destination
* Move a folder of secrets, possibly with sub folders, from source to destination

#### Flags

| Flag      | Aliases | Description                                    |
|-----------|---------|------------------------------------------------|
| `--force` | `-f`    | Overwrite existing destination without asking. |

#### Details

* To simplify the implementation and support multiple backends a `copy` or `move` operation will always decrypt and re-encrypt all affected secrets. Even if moving encrypted files around might be possible.
* You can move a secret to another secret, i.e. overwrite the destination. But `gopass` won't let you move a directory over a file. In that case you have to delete the destination first.

---

## Sync and Backup

---

### `gopass sync` command

**Description**: Synchronize the local store with remote Git repositories. The `sync` command is the preferred way to manually synchronize changes between
your local stores and any configured remotes.

You can also `cd` into a git-based store and manually perform git operations,
or use the `gopass git` command to automatically run a command in the correct
directory.

Note: `gopass sync` only supports one remote per store.

**Usage**:

```bash
gopass sync [flags]
gopass sync --store <store>
```

#### Flags

| Flag              | Alias | Description                                           |
|-------------------|-------|-------------------------------------------------------|
| `--store` [value] |       | Only sync a specific sub store                        |

---

### `gopass git` command

**Description**: Directly interact with Git. Run a git command inside a password store.
If the password store is a git repository, execute a git command specified by git-command-args

**Usage**:

```bash
gopass git [--store=<store>] <git-command>
```

#### Flags

| Flag            | Alias      | Description         |
|-----------------|------------|---------------------|
| --store [value] | -s [value] | Store to operate on |

---

## Configuration

### `gopass config` command

**Description**: Modify or display the current configuration.

**Usage**:
```bash
gopass config [key] [value]
```

**Options**:
- No specific options.

### `gopass init` command

**Description**: Initialize a new password store or reinitialize an existing store.

**Usage**:
```bash
gopass init [--path=<path>]
```

**Options**:
- `-u, --username` : Set the username for git configuration.
- `-r, --recipients` : Set initial recipients for the password store.

---

## Search and Query

### `gopass find`
**Description**: Search for secrets by name or content.

**Usage**:
```bash
gopass find <query>
```

**Options**:
- `-e, --extended` : Use extended search (grep-like).
- `-i, --insensitive` : Case-insensitive search.

---

## Additional Commands

### `gopass audit`
**Description**: Audit the password store for weak or duplicated passwords.

**Usage**:
```bash
gopass audit
```

**Options**:
- No specific options.

### `gopass recipients`
**Description**: Manage the list of recipients for the store.

**Usage**:
```bash
gopass recipients [add|remove] <recipient>
```

**Options**:
- `-f, --force` : Force changes without asking for confirmation.

---

## Help and Version

### `gopass help`
**Description**: Display help information about `gopass`.

**Usage**:
```bash
gopass help [command]
```

**Options**:
- No specific options.

### `gopass version`
**Description**: Display the current version of `gopass`.

**Usage**:
```bash
gopass version
```

**Options**:
- No specific options.

---

## Conclusion
This guide provides a summary of the most important `gopass` commands and their options. For more detailed information, you can refer to the [official gopass documentation](https://github.com/gopasspw/gopass/tree/master/docs/commands).

