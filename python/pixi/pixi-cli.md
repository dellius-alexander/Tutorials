# PIXI Command Line Tool Documentation

## Introduction

PIXI is a fast, modern, and reproducible package management tool developed by prefix.dev. It is designed for developers across various backgrounds, supporting cross-platform, multi-language environments built on the conda ecosystem. PIXI emphasizes reproducibility through lockfiles, task automation, multi-platform configuration, multi-environment management, and global tool installation. It is particularly useful for managing dependencies in projects involving Python, Rust, Node.js, ROS2, and more.

### Key Highlights
- **Reproducibility**: Uses lockfiles to ensure consistent environments across machines and platforms.
- **Tasks**: Built-in task runner for defining and executing custom commands or workflows.
- **Multi-Platform**: Supports configuration for different operating systems and architectures (e.g., linux-64, osx-arm64).
- **Multi-Environment**: Allows multiple environments in a single manifest file.
- **Python Integration**: Seamless management of Python dependencies via `pyproject.toml` and PyPI/conda packages.
- **Global Tools**: Installs CLI tools globally, replacing traditional package managers like apt, homebrew, or winget.

### Installation
To install PIXI, use the following commands:

- **Linux & macOS**:
  ```
  curl -fsSL https://pixi.sh/install.sh | sh
  ```

- **Windows**:
  ```
  irm -useb https://pixi.sh/install.ps1 | iex
  ```

After installation, PIXI is available as `pixi` in your shell. Update PIXI using `pixi self-update`.

### Getting Started
PIXI is easy to start with. Here's a quick demo:

1. Initialize a project:
   ```
   pixi init hello-world
   ```

2. Add dependencies:
   ```
   pixi add python
   ```

3. Run a command:
   ```
   pixi run python -c 'print("Hello World!")'
   ```

4. Install global tools:
   ```
   pixi global install gh nvim ipython btop ripgrep
   ```

For language-specific setups:
- **Python**: `pixi init`, `pixi add cowpy python`, define tasks like `pixi task add start python hello.py`, then `pixi run start`.
- **Rust**: `pixi add rust`, `pixi run cargo init`, `pixi task add start cargo run`.
- **Node.js**: `pixi add nodejs`, `pixi task add start "node hello.js"`.
- **ROS2**: `pixi add ros-humble-desktop -c ros2`, `pixi run rviz2`.
- **Global Tools**: `pixi global install terraform ansible k9s`, then use them directly (e.g., `ansible --version`).

## Best Practices
- **Reproducibility**: Always commit the `pixi.lock` file to version control for consistent environments. Use `--frozen` or `--locked` in CI/CD to enforce lockfile usage.
- **Manifest Management**: Prefer `pyproject.toml` for Python projects to integrate with standard tools. Use features (`--feature`) to organize optional dependencies (e.g., `lint`, `test`).
- **Tasks**: Define complex workflows in `pixi.toml` using tasks with dependencies (`depends-on`) for automation. Use cross-environment tasks for modular projects.
- **Dependency Pinning**: Set a global pinning strategy (e.g., `pixi config set pinning-strategy minor --global`) to control version updates. Use `semver` for semantic versioning packages.
- **Global Tools**: Use PIXI for installing CLI tools to avoid system package manager conflicts. Regularly sync with `pixi global sync`.
- **Security**: Avoid `--run-post-link-scripts` and `--tls-no-verify` unless necessary. Use authentication files (`--auth-file`) for private channels.
- **Performance**: Tune concurrency with `--concurrent-downloads` and `--concurrent-solves` for large projects. Clean caches regularly with `pixi clean cache`.
- **Multi-Environment/Projects**: Use workspaces for monorepos. Define multiple environments in one manifest for dev, test, prod.
- **Updates**: Use `pixi update --dry-run` to preview changes before applying. Exclude critical packages with `--exclude` in upgrades.
- **Shell Usage**: Use `pixi shell` for interactive work, but prefer `pixi run` for scripted commands to avoid persistent shell state.

## Basic Usages
- **Create a Project**: `pixi init myproject --channel conda-forge`.
- **Add Dependency**: `pixi add numpy --platform linux-64`.
- **Run Command**: `pixi run python script.py`.
- **Install Environment**: `pixi install --environment dev`.
- **List Packages**: `pixi list --explicit`.
- **Global Install**: `pixi global install ripgrep`.

## Advanced Usages
- **Multi-Platform**: `pixi add --platform osx-arm64 --platform linux-64 python`.
- **Editable PyPI**: `pixi add --pypi --editable "project @ file:///path/to/project"`.
- **Git Dependencies**: `pixi add --git https://github.com/user/repo --branch main package-name`.
- **Tasks with Dependencies**: Define in `pixi.toml` and run `pixi run build-then-test`.
- **Temporary Execution**: `pixi exec --spec python=3.9 ipython`.
- **Build Conda Package**: `pixi build --target-platform linux-64`.
- **Upload Package**: `pixi upload prefix --channel my-channel package.conda`.
- **Workspace Management**: `pixi workspace channel add conda-forge`.
- **Dependency Tree**: `pixi tree --invert yaml`.
- **Upgrade Dependencies**: `pixi upgrade --feature lint --dry-run`.

## Command Reference

Each section below details a PIXI command or subcommand, including context, rationale, usage, options, examples, and scenarios.

### pixi add
**Context**: Used in a workspace to extend environments with new packages from conda or PyPI.

**Rationale**: Declaratively defines dependencies in the manifest for reproducibility.

**Usage**: `pixi add [OPTIONS] <SPEC>...`

**Options**:
- `--pypi`: Treat as PyPI package.
- `--platform <PLATFORM>`: Target platform (e.g., linux-64).
- `--feature <FEATURE>`: Add to named feature (default: default).
- `--editable`: Editable PyPI install.
- `--git <GIT>`: Git URL.
- `--branch <BRANCH>`, `--tag <TAG>`, `--rev <REV>`, `--subdir <SUBDIR>`: Git specifics.
- `--no-install`: Update lockfile/manifest only.
- `--frozen`, `--locked`: Control lockfile behavior.
- Config options: authentication, concurrency, pinning, etc.

**Examples**:
- `pixi add numpy pandas`.
- `pixi add --pypi boto3 --feature aws`.
- `pixi add --git https://github.com/user/repo package`.

**Scenarios**:
- Basic: Adding core dependencies.
- Advanced: Platform-specific or Git-based dependencies in CI.

### pixi auth
**Context**: For accessing private channels on prefix.dev or anaconda.org.

**Rationale**: Manages authentication tokens for private repositories.

**Usage**: `pixi auth <COMMAND>`

**Subcommands**: logout (remove auth for host).

**Options**: None specific.

**Examples**: `pixi auth logout prefix.dev`.

**Scenarios**: Logging in/out for private package access.

### pixi build
**Context**: In a workspace with package manifest.

**Rationale**: Converts PIXI configs to conda packages.

**Usage**: `pixi build [OPTIONS]`

**Options**:
- `--target-platform <TARGET_PLATFORM>`: Build target (default: current).
- `--build-platform <BUILD_PLATFORM>`: Build platform (default: current).
- `--output-dir <OUTPUT_DIR>`: Artifact output (default: .).
- `--build-dir <BUILD_DIR>`: Incremental build dir.
- `--clean`: Clean build dir.
- `--path <PATH>`: Manifest path.
- Config options: auth, concurrency, etc.

**Examples**: `pixi build --target-platform linux-64`.

**Scenarios**: Building cross-platform conda packages for distribution.

### pixi clean
**Context**: Managing disk space in PIXI environments.

**Rationale**: Removes unused data from `.pixi` folder or caches.

**Usage**: `pixi clean [OPTIONS] [COMMAND]`

**Subcommands**: cache (clean system cache).

**Options**:
- `--environment <ENVIRONMENT>`: Remove specific environment.
- `--activation-cache`: Clear activation cache.
- `--build`: Clear build cache.

**Examples**: `pixi clean --environment dev`, `pixi clean cache`.

**Scenarios**: Post-build cleanup or freeing space in large projects.

### pixi completion
**Context**: Enhancing shell usability.

**Rationale**: Provides autocompletion for PIXI commands.

**Usage**: `pixi completion --shell <SHELL>`

**Options**: `--shell <SHELL>` (bash, zsh, etc., required).

**Examples**: `pixi completion --shell bash > pixi.bash`.

**Scenarios**: Setup in shell config for faster typing.

### pixi config
**Context**: Managing PIXI settings.

**Rationale**: Allows editing, listing, setting configs without file edits.

**Usage**: `pixi config <COMMAND>`

**Subcommands**: edit, list, prepend, append, set, unset.

**Examples**: `pixi config list`, `pixi config set pinning-strategy minor`.

**Scenarios**: Global config for pinning or auth.

### pixi exec
**Context**: Temporary environments for one-off commands.

**Rationale**: Runs commands with ad-hoc dependencies without persistent install.

**Usage**: `pixi exec [OPTIONS] [COMMAND]...`

**Options**:
- `--spec <SPEC>`: Packages to install.
- `--with <WITH>`: Additional packages.
- `--channel <CHANNEL>`: Channels.
- `--platform <PLATFORM>`: Platform.
- `--force-reinstall`: New environment.
- `--list <LIST>`: List packages before run.
- `--no-modify-ps1`: No prompt change.

**Examples**: `pixi exec --spec python=3.9 ipython`, `pixi exec --with numpy python`.

**Scenarios**: Quick testing of packages without project setup.

### pixi global
**Context**: Managing global packages outside workspaces.

**Rationale**: Installs tools in `$PIXI_HOME` (default: ~/.pixi) for system-wide use.

**Usage**: `pixi global <COMMAND>`

**Subcommands**:
- add: Add dependencies.
- edit: Edit manifest.
- install: Install packages globally.
- uninstall: Remove environments.
- remove: Remove dependencies.
- list: List environments/packages.
- sync: Sync manifest with installed.
- expose: Manage binary exposure.
- shortcut: Manage system shortcuts.
- update: Update environments.
- tree: Dependency tree.

**Examples**: `pixi global install ripgrep`, `pixi global list`.

**Scenarios**: Installing CLI tools like gh, nvim globally.

### pixi info
**Context**: Diagnostic info.

**Rationale**: Provides system, workspace, environment details.

**Usage**: `pixi info [OPTIONS]`

**Options**:
- `--extended`: Include sizes.
- `--json`: JSON output.

**Examples**: `pixi info --extended`.

**Scenarios**: Troubleshooting environment issues.

### pixi init
**Context**: Starting new projects.

**Rationale**: Sets up manifest and helpers.

**Usage**: `pixi init [OPTIONS] [PATH]`

**Options**:
- `--channel <CHANNEL>`: Channels.
- `--platform <PLATFORM>`: Platforms.
- `--import <ENVIRONMENT_FILE>`: From environment.yml.
- `--format <FORMAT>`: pixi, pyproject, mojoproject.
- `--scm <SCM>`: github, gitlab, codeberg.
- `--conda-pypi-map <MAP>`: Channel mappings.

**Examples**: `pixi init --channel conda-forge --platform linux-64 myproject`.

**Scenarios**: Bootstrapping Python or multi-platform projects.

### pixi import
**Context**: Integrating external files.

**Rationale**: Imports into existing workspace.

**Usage**: `pixi import [OPTIONS] <FILE>`

**Options**:
- `--format <FORMAT>`: conda-env, pypi-txt.
- `--platform <PLATFORM>`: Platforms.
- `--environment <ENVIRONMENT>`: Name.
- `--feature <FEATURE>`: Feature.

**Examples**: `pixi import --format conda-env environment.yml`.

**Scenarios**: Migrating from conda to PIXI.

### pixi install
**Context**: Setting up environments.

**Rationale**: Updates lockfile and installs.

**Usage**: `pixi install [OPTIONS]`

**Options**:
- `--environment <ENVIRONMENT>`: Specific environment.
- `--all`: All environments.
- `--skip <SKIP>`: Skip packages.
- `--skip-with-deps <SKIP_WITH_DEPS>`: Skip subtree.
- `--only <ONLY>`: Install only specific.
- `--frozen`, `--locked`: Lockfile control.

**Examples**: `pixi install --environment lint`.

**Scenarios**: Initial setup or partial installs.

### pixi list
**Context**: Inspecting packages.

**Rationale**: Views installed packages.

**Usage**: `pixi list [OPTIONS] [REGEX]`

**Options**:
- `--platform <PLATFORM>`: Platform.
- `--json`: JSON.
- `--sort-by <SORT_BY>`: size, name, kind.
- `--fields <FIELDS>`: Fields to show.
- `--environment <ENVIRONMENT>`: Environment.
- `--explicit`: Explicit packages.
- `--frozen`, `--locked`: Lockfile.

**Examples**: `pixi list --sort-by size`.

**Scenarios**: Auditing dependencies.

### pixi lock
**Context**: Updating lockfile.

**Rationale**: Resolves without install.

**Usage**: `pixi lock [OPTIONS]`

**Options**:
- `--json`: JSON changes.
- `--check`: Check for changes.
- `--no-install`: Only lockfile.

**Examples**: `pixi lock --check`.

**Scenarios**: CI lockfile validation.

### pixi reinstall
**Context**: Resetting environments.

**Rationale**: Reinstalls with update.

**Usage**: `pixi reinstall [OPTIONS] [PACKAGE]...`

**Options**: Similar to install, plus package args.

**Examples**: `pixi reinstall numpy`.

**Scenarios**: Fixing corrupted environments.

### pixi remove
**Context**: Cleaning dependencies.

**Rationale**: Removes from manifest.

**Usage**: `pixi remove [OPTIONS] <SPEC>...`

**Options**: Similar to add, for pypi, platform, feature.

**Examples**: `pixi remove --pypi requests`.

**Scenarios**: Slimming environments.

### pixi run
**Context**: Executing tasks/commands.

**Rationale**: Runs in environment with auto-install.

**Usage**: `pixi run [OPTIONS] [TASK]...`

**Options**:
- `--environment <ENVIRONMENT>`: Environment.
- `--clean-env`: Clean PATH (no Windows).
- `--skip-deps`: Skip task deps.
- `--dry-run`: Print command.

**Examples**: `pixi run --skip-deps build`.

**Scenarios**: Task automation in workflows.

### pixi search
**Context**: Finding packages.

**Rationale**: Searches conda packages.

**Usage**: `pixi search [OPTIONS] <PACKAGE>`

**Options**:
- `--channel <CHANNEL>`: Channels.
- `--platform <PLATFORM>`: Platform.
- `--limit <LIMIT>`: Results limit.

**Examples**: `pixi search --channel conda-forge numpy`.

**Scenarios**: Discovering package versions.

### pixi self-update
**Context**: Updating PIXI.

**Rationale**: Keeps CLI current.

**Usage**: `pixi self-update [OPTIONS]`

**Options**:
- `--version <VERSION>`: Specific version.
- `--dry-run`: Show notes.
- `--force`: Force download.
- `--no-release-note`: Skip notes.

**Examples**: `pixi self-update --version 0.46.0`.

**Scenarios**: Version management.

### pixi shell
**Context**: Interactive sessions.

**Rationale**: Works in isolated environment.

**Usage**: `pixi shell [OPTIONS]`

**Options**:
- `--environment <ENVIRONMENT>`: Environment.
- `--change-ps1 <CHANGE_PS1>`: Prompt modify.
- Config: auth, concurrency, etc.

**Examples**: `pixi shell --environment cuda`.

**Scenarios**: Debugging in environment.

### pixi shell-hook
**Context**: Activation scripts.

**Rationale**: Activates without PIXI binary.

**Usage**: `pixi shell-hook [OPTIONS]`

**Options**:
- `--shell <SHELL>`: Shell type.
- `--environment <ENVIRONMENT>`: Environment.
- `--json`: JSON vars.

**Examples**: `pixi shell-hook --shell bash > activate.sh`.

**Scenarios**: Docker without PIXI.

### pixi task
**Context**: Managing tasks.

**Rationale**: Adds/removes task definitions.

**Usage**: `pixi task <COMMAND>`

**Subcommands**: add, remove, alias, list.

**Examples**: `pixi task add build "cargo build"`.

**Scenarios**: Custom workflow scripts.

### pixi tree
**Context**: Visualizing dependencies.

**Rationale**: Shows tree for debugging.

**Usage**: `pixi tree [OPTIONS] [REGEX]`

**Options**:
- `--platform <PLATFORM>`: Platform.
- `--environment <ENVIRONMENT>`: Environment.
- `--invert`: Reverse tree.

**Examples**: `pixi tree --invert yaml`.

**Scenarios**: Dependency analysis.

### pixi update
**Context**: Refreshing dependencies.

**Rationale**: Updates lockfile with newer versions.

**Usage**: `pixi update [OPTIONS] [PACKAGES]...`

**Options**:
- `--environment <ENVIRONMENT>`: Environments.
- `--platform <PLATFORM>`: Platforms.
- `--dry-run`: Simulate.
- `--json`: JSON.

**Examples**: `pixi update --dry-run numpy`.

**Scenarios**: Regular maintenance.

### pixi upgrade
**Context**: Upgrading versions.

**Rationale**: Loosens constraints in manifest.

**Usage**: `pixi upgrade [OPTIONS] [PACKAGES]...`

**Options**:
- `--feature <FEATURE>`: Feature.
- `--exclude <EXCLUDE>`: Exclude.
- `--dry-run`: Simulate.

**Examples**: `pixi upgrade --feature lint python`.

**Scenarios**: Major version bumps.

### pixi upload
**Context**: Publishing packages.

**Rationale**: Uploads to channels.

**Usage**: `pixi upload [OPTIONS] [PACKAGE_FILES]... <COMMAND>`

**Subcommands**: prefix, anaconda, quetz, artifactory, s3.

**Options**: `--allow-insecure-host <HOST>`.

**Examples**: `pixi upload prefix --channel my-channel package.conda`.

**Scenarios**: Package distribution.

### pixi workspace
**Context**: Modifying workspace config.

**Rationale**: CLI for config changes.

**Usage**: `pixi workspace <COMMAND>`

**Subcommands**: channel, description, platform, version, environment, feature, export, name, system-requirements, requires-pixi.

**Examples**: `pixi workspace channel add conda-forge`.

**Scenarios**: Monorepo management.

## Scenarios
- **Data Science Project**: Init with Python, add numpy/pandas, define tasks for data processing, run in shell.
- **Cross-Platform App**: Add platform-specific deps, build packages, upload to channel.
- **CI/CD**: Use frozen/locked for reproducible builds, update lockfile, check with lock --check.
- **Global Tools Setup**: Install editors, version control tools globally.
- **Migration from Conda**: Import environment.yml, add PyPI deps, upgrade versions.<|control12|>
