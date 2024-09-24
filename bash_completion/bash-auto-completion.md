# <a id="title">bash auto-completion on Linux</a>

Some optional configuration for bash auto-completion on Linux.

---
| Contents |
| --- |
| [Install bash_completion](#install-bash-completion) |
| [Enable Kubectl autocompletion](#enable-kubectl-autocompletion) |
<br/>

---

## <a id="introduction">Introduction</a>

The kubectl completion script for Bash can be generated with the command <code>kubectl completion bash</code>. Sourcing the completion script in your shell enables kubectl autocompletion.
However, the completion script depends on <a href="https://github.com/scop/bash-completion"><strong>bash-completion</strong></a>, which means that you have to install this software first (you can test if you have bash-completion already installed by running <code>type _init_completion</code>).

## <a id="install-bash-completion">Install bash-completion</a>

bash-completion is provided by many package managers (see <a href="https://github.com/scop/bash-completion#installation">here</a>). You can install it with <code>apt-get install bash-completion bash-completion-extras</code> or <code>yum install bash-completion bash-completion-extras</code>, etc.

<p>The above commands create <code>/usr/share/bash-completion/bash_completion</code>, which is the main script of bash-completion. Depending on your package manager, you have to manually source this file in your <code>~/.bashrc</code> file. To find out, reload your shell and run <code>type _init_completion</code>. If the command succeeds, you're already set, otherwise add the following to your <code>~/.bashrc</code> file:</p>

<div class="highlight"><pre style="background-color:#f2f7f7;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-bash" data-lang="bash"><span style="color:#a2f">source</span> <span style="color:#b44">/usr/share/bash-completion/bash_completion</span></code></pre>
</div>
Reload your shell by typing <code>bash</code> on the CLi and verify that bash-completion is correctly installed by typing <code>type _init_completion</code>.

---

## <h2><a id="enable-kubectl-autocompletion">Enable kubectl autocompletion</a></h2>

You now need to ensure that the kubectl completion script gets sourced in all your shell sessions. There are two ways in which you can do this:

<ul><li><p>Source the completion script in your <code>~/.bashrc</code> file:</p>
        <div class="highlight"><pre style="background-color:#f8f8f8;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-bash" data-lang="bash"><span style="color:#a2f">echo</span> <span style="color:#b44">'source &lt;(kubectl completion bash)'</span> &gt;&gt;~/.bashrc</code></pre>
        </div>
    </li>
    <li><p>Add the completion script to the <code>/etc/bash_completion.d</code> directory:</p>
        <div class="highlight"><pre style="background-color:#f8f8f8;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-bash" data-lang="bash" style="color:black">kubectl completion bash &gt;/etc/bash_completion.d/kubectl</code></pre>
        </div>
    </li>
</ul>

<p>If you have an alias for kubectl, you can extend shell completion to work with that alias:</p>

<div class="highlight"><pre style="background-color:#f8f8f8;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-bash" data-lang="bash"><span style="color:#a2f">echo</span> <span style="color:#b44">'alias k=kubectl'</span> &gt;&gt;~/.bashrc
<span style="color:#a2f">echo</span> <span style="color:#b44">'complete -F __start_kubectl k'</span> &gt;&gt;~/.bashrc</code></pre>
</div>

<blockquote class="note callout">
    <div><strong>Note:</strong> bash-completion sources all completion scripts in <code>/etc/bash_completion.d</code>.</div>
</blockquote>

<p>Both approaches are equivalent. After reloading your shell, kubectl autocompletion should be working.</p

---
---

## <h2><a id="Docker-Command-line-completion" href="https://docs.docker.com/compose/completion/">Docker Command-line completion</a> </h2>

### TODO...
