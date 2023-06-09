<p><code>sftp&gt; put blank/*.gz</code></p>
<p>Which would also work (* is pattern match so this would get all files in MetaAir/blank ending in .gz).</p>
</section>
<section id="creating-environments" class="level2">
<h2 class="anchored" data-anchor-id="creating-environments">Creating environments:</h2>
<p>Many of the metagenomic tools you will want to use operate within “environments” to avoid conflicts with existing software. “mamaba” and “conda” are tools that create these environments. This can be done like below:</p>
<section id="environments-with-conda" class="level4">
<h4 class="anchored" data-anchor-id="environments-with-conda">Environments with Conda:</h4>
<p><code>$module load anaconda</code></p>
<p>If you need to create a conda environment, you do it like this:</p>
<p><code>$conda create -n metaair_env</code></p>
<p>Then to activate it:</p>
<p><code>$conda activate /scratch/alpine/\$USER/software/anaconda/envs/metaair_env</code></p>
<p>Note how the input line will change from “(base)” to “(metaair_env)” as an indication of which environment you are using:</p>
<p><code>(base) [emye7956@c3cpu-a5-u30-4]$ conda activate metaair_env</code></p>
<p>changes to:</p>
<p><code>(metaair_env) [emye7956@c3cpu-a5-u30-4]$</code></p>
<p>Once you have activated the environment, you can then install the software you need. For instance, if I want to run mutliqc, I need to install it:</p>
<p><code>$conda install multiqc</code></p>
<p>In most cases, the software you are using will have a github with the specific command options you can run for installation. Often there is a github URL you can copy and use, which makes it super easy. Here is something it might look like:</p>
<p><code>$git clone https://github.com/maxvonhippel/AttackerSynthesis.git $cd AttackerSynthesis $pip install .</code></p>
<p>Sometimes the project does not have instructions to install, but DOES have “releases” listed on the side of the page. In this case, click on the releases, then right-click on the linux one and “copy url”. Then go to the terminal and do something like this:</p>
<p><code>$wget https://github.com/s-andrews/FastQC/archive/refs/tags/v0.12.1.zip</code></p>
<p><code>$unzip v0.12.1</code></p>
<p><code>$cd v0.12.1</code></p>
<p><code>$ls</code></p>
<p>and lo and behold, the compiled binary is in the folder already. (Trimmomatic is also like this!) In other cases, you have to follow some annoying compile instructions from the github README, like in this example:</p>
<p><img src="images/git%20humor.png" class="img-fluid" width="293"></p>
<p><code>$git clone https://github.com/najoshi/sickle.git</code></p>
<p><code>$cd sickle</code></p>
<p><code>$make</code></p>
<p>and you are done. Every once in a while you will encounter some software that does not have a Github. Such software is very frustrating! In general, in these cases you peruse the website to find a download link for binaries for Linux. Then you copy the url just like you did in the github releases example above, and ‘wget’ it. Chances are it’s a zip file and you can unzip it. But, it might be some weird linux alternative, such as a tar file. In this case, I reccomend using ChatGPT to figure out how to “unzip” the annoying file. Or stack overflow.</p>
</section>
<section id="environments-with-yaml-files" class="level4">
<h4 class="anchored" data-anchor-id="environments-with-yaml-files">Environments with yaml files:</h4>
<p>Sometimes it takes a while to configure an environment that has all the right software, dependencies and versions necessary to run the commands you want. Wouldn’t it be so nice if you could save and share EXACTLY how your environment is configured…YOU CAN!</p>
<p>Now you want to make an&nbsp;<code>environment.yaml</code>&nbsp;file that will allow others to recreate the environment from scratch. To make this file, we use the&nbsp;<code>export</code>&nbsp;command and send the output to&nbsp;<code>environment.yaml</code>:</p>
<p>while in metaair_env, export the packages used to an environment file:</p>
<p><code>(``metaair_env``) $ conda env export &gt;``metaair_env``.yaml</code></p>
<p>Now anyone with the “metaair_env.yaml” file will be able to recreate the same metaair_env by running the following:</p>
<p><code>$ conda env create --file environment.yaml</code></p>
<p>A useful command to see all your environments is:</p>
<p><code>$ conda env list</code></p>
<p><img src="images/D8F1FD3F-C57B-4665-8CFF-DAB7FBA1F2E3_1_105_c.jpeg" class="img-fluid"></p>
</section>
</section>
<section id="submitting-jobs-on-the-cluster" class="level2">
<h2 class="anchored" data-anchor-id="submitting-jobs-on-the-cluster">Submitting jobs on the cluster:</h2>
<p>Next, let’s talk about how to run jobs. As a concrete example we will look at how to run a job to build the phyloflash database. The first step is going to be to write a bash script. You have two options: you could write the script on your laptop text editor and then use sftp (or <a href="https://curc.readthedocs.io/en/latest/gateways/OnDemand.html">ondemand</a>) to upload it to the cluster. Or you could do it directly in the terminal using nano, vim, or another text editor that is terminal based. These editors can be very difficult to use because they do not have buttons or anything you can click on so you have to memorize all the commands to use them. For example, in vim, :i allows you to insert, dd deletes a line, d deletes a character, esc :wq writes and quits; etc. I have found nano to be the easiest. Max prefers vim (fancy fancy).</p>
<p>So suppose you make a new file on your laptop with a text editor, and call it very-important-job.sh . In this file, write the following text, using your preferred text editor (I really like <a href="https://www.sublimetext.com">Sublime Text</a>). Note that this is in the bash language.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="co">#!/bin/bash</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--nodes=1</span></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--time=10:00:00</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--partition=amilan</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--qos=normal</span></span>
<span id="cb1-6"><a href="#cb1-6" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--job-name=phyloflash_makedb</span></span>
<span id="cb1-7"><a href="#cb1-7" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--ntasks=20</span></span>
<span id="cb1-8"><a href="#cb1-8" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--mail-type=ALL</span></span>
<span id="cb1-9"><a href="#cb1-9" aria-hidden="true" tabindex="-1"></a><span class="co">#SBATCH \--mail-user=emye7956\@colorado.edu</span></span>
<span id="cb1-10"><a href="#cb1-10" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-11"><a href="#cb1-11" aria-hidden="true" tabindex="-1"></a><span class="ex">module</span> purge</span>
<span id="cb1-12"><a href="#cb1-12" aria-hidden="true" tabindex="-1"></a><span class="ex">module</span> load perl</span>
<span id="cb1-13"><a href="#cb1-13" aria-hidden="true" tabindex="-1"></a><span class="ex">module</span> load anaconda</span>
<span id="cb1-14"><a href="#cb1-14" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-15"><a href="#cb1-15" aria-hidden="true" tabindex="-1"></a><span class="ex">conda</span> activate /projects/\$USER/software/anaconda/envs/metaair_env</span>
<span id="cb1-16"><a href="#cb1-16" aria-hidden="true" tabindex="-1"></a><span class="bu">export</span> <span class="va">PATH</span><span class="op">=</span><span class="dt">\$</span>PATH:/curc/sw/install/bio/bedtools/2.29.1/bin/:/curc/sw/install/bio/bbtools/bbmap/</span>
<span id="cb1-17"><a href="#cb1-17" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-18"><a href="#cb1-18" aria-hidden="true" tabindex="-1"></a><span class="bu">cd</span> /scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2./phyloFlash_makedb.pl <span class="dt">\-</span>-silva_file/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/SILVA_138.1_SSURef_NR99_tax_silva_trunc.fasta.gz\--univec_file/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/UniVec <span class="dt">\-</span>-mem 60</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<p><strong>What does this text do? Let’s go through it step by step.</strong></p>
<p>1: Announce that this is a bash script.</p>
<p>2: Announce that only one node (computer) is needed.</p>
<p>3: Announce that a max of 10 hours are needed.</p>
<p>4: Announce to use the amilan partition scheme (not sure what this is, but it was the reccomended default from the IT folks).</p>
<p>5: Another thing from IT folks that we do not understand and leave as-is.</p>
<p>6: Decide a name for the job. When you get an email saying the job is done it will have this name. Replace “phyloflash_makedb” with a name of your choice. Choose something descriptive, but do not use special characters like “;” or “&amp;”, and maybe avoid space as well.</p>
<p>7: How many cores do you want to use? 20 was reccomended by the IT folks so we stuck with that in this example.</p>
<p>8: Do you want an email when it’s done? (Yes, you do, so leave this line as it is…)</p>
<p>9: What is your email address? The system will email you when the task is done saying if it failed or succeeded. (Hint: “exit code 0” typically means success! Conversely, any other exit code is probably a failure.)</p>
<p>10: “module purge” - Turn off any software that was turned on by prior users which might conflict with the software you need.</p>
<p>11: “module load perl” - In this particular example, we wanted to run a script written in the perl programming language, called phyloFlash_makedb.pl. To do this, we needed to load the perl language! We do this by running module load perl.</p>
<p>12: “module load anaconda” “conda activate /projects/\$USER/software/anaconda/envs/metaair_env”</p>
<p>We made a conda environment with all the required dependencies at the given path, so now, we activate it. Notice that $USER will (in theory) return your username (e.g.&nbsp;emye7956). But you could just write your username instead.</p>
<p>13: “export PATH=” - In bash, the PATH is a variable the terminal uses to find applications. So when you run an application in bash (for example, “sed” or “ls” or “cd” or “tree” or “cat” or “grep” or “git”), it LOOKS for this application in your path (which typically begins with /usr/bin). Therefore, you do not really “install” an application in bash. You just … have the application as an executable file, and either put that file into a folder that is already in your PATH, or, add the folder containing that file to your PATH. So in this step, we want to run phyloflash, which requires some dependencies that we installed previously (not in this tutorial), such as bedtools. Those dependencies are not in /usr/bin or one of those folders that is included in the path to begin with. Hence, we run a command to (temporarily, just for this session …) add the folders containing those dependencies, to the PATH. Note when there are multiple such folders we seperate then with a : . And voila, we can run phyloflash!</p>
<p>14: We cd into the folder containing the phyloflash perl script.</p>
<p>15: We run the phyloflash perl script. And we are done!</p>
<p>So now, you’ve written your script, with the detailed script above as an example. And suppose you’ve saved it as very-important-job.sh. Moreover, you have put it on the cluster somehow. Maybe you used sftp, maybe you used ondemand and then mv’d it to the correct location, or maybe you wrote it directly on the cluster using one of those horrible text editors like nano or vim or emacs. REGARDLESS, let’s assume you have this script in your current directory, i.e.:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true" tabindex="-1"></a>    <span class="ex">$</span> pwd</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="sourceCode" id="cb3"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a>    <span class="op">&gt;</span> /scratch/alpine/emye7956/MetaAir</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="sourceCode" id="cb4"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true" tabindex="-1"></a>    <span class="ex">$</span> ls</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="sourceCode" id="cb5"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true" tabindex="-1"></a>    <span class="op">&gt;</span> very-important-job.sh</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<p>Then the next step is simply:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode bash code-with-copy"><code class="sourceCode bash"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true" tabindex="-1"></a>    <span class="ex">sbatch</span> very-important-job.sh</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<p>And you are done! You will get an email when it is done (or when it fails). Note also, there might be a log file left behind in the directory you’re in when you run sbatch, which you could use to figure out what went wrong, if it does fail (which happens… a lot!!)</p>
<p>Lastly, this tutorial was made by Emily Yeo and Max von Hippel. So please reach out if something isn’t clear.</p>
</section>

</main>
<!-- /main column -->
<script id="quarto-html-after-body" type="application/javascript">
window.document.addEventListener("DOMContentLoaded", function (event) {
  const toggleBodyColorMode = (bsSheetEl) => {
    const mode = bsSheetEl.getAttribute("data-mode");
    const bodyEl = window.document.querySelector("body");
    if (mode === "dark") {
      bodyEl.classList.add("quarto-dark");
      bodyEl.classList.remove("quarto-light");
    } else {
      bodyEl.classList.add("quarto-light");
      bodyEl.classList.remove("quarto-dark");
    }
  }
  const toggleBodyColorPrimary = () => {
    const bsSheetEl = window.document.querySelector("link#quarto-bootstrap");
    if (bsSheetEl) {
      toggleBodyColorMode(bsSheetEl);
    }
  }
  toggleBodyColorPrimary();  
  const icon = "";
  const anchorJS = new window.AnchorJS();
  anchorJS.options = {
    placement: 'right',
    icon: icon
  };
  anchorJS.add('.anchored');
  const clipboard = new window.ClipboardJS('.code-copy-button', {
    target: function(trigger) {
      return trigger.previousElementSibling;
    }
  });
  clipboard.on('success', function(e) {
    // button target
    const button = e.trigger;
    // don't keep focus
    button.blur();
    // flash "checked"
    button.classList.add('code-copy-button-checked');
    var currentTitle = button.getAttribute("title");
    button.setAttribute("title", "Copied!");
    let tooltip;
    if (window.bootstrap) {
      button.setAttribute("data-bs-toggle", "tooltip");
      button.setAttribute("data-bs-placement", "left");
      button.setAttribute("data-bs-title", "Copied!");
      tooltip = new bootstrap.Tooltip(button, 
        { trigger: "manual", 
          customClass: "code-copy-button-tooltip",
          offset: [0, -8]});
      tooltip.show();    
    }
    setTimeout(function() {
      if (tooltip) {
        tooltip.hide();
        button.removeAttribute("data-bs-title");
        button.removeAttribute("data-bs-toggle");
        button.removeAttribute("data-bs-placement");
      }
      button.setAttribute("title", currentTitle);
      button.classList.remove('code-copy-button-checked');
    }, 1000);
    // clear code selection
    e.clearSelection();
  });
  function tippyHover(el, contentFn) {
    const config = {
      allowHTML: true,
      content: contentFn,
      maxWidth: 500,
      delay: 100,
      arrow: false,
      appendTo: function(el) {
          return el.parentElement;
      },
      interactive: true,
      interactiveBorder: 10,
      theme: 'quarto',
      placement: 'bottom-start'
    };
    window.tippy(el, config); 
  }
  const noterefs = window.document.querySelectorAll('a[role="doc-noteref"]');
  for (var i=0; i<noterefs.length; i++) {
    const ref = noterefs[i];
    tippyHover(ref, function() {
      // use id or data attribute instead here
      let href = ref.getAttribute('data-footnote-href') || ref.getAttribute('href');
      try { href = new URL(href).hash; } catch {}
      const id = href.replace(/^#\/?/, "");
      const note = window.document.getElementById(id);
      return note.innerHTML;
    });
  }
  const findCites = (el) => {
    const parentEl = el.parentElement;
    if (parentEl) {
      const cites = parentEl.dataset.cites;
      if (cites) {
        return {
          el,
          cites: cites.split(' ')
        };
      } else {
        return findCites(el.parentElement)
      }
    } else {
      return undefined;
    }
  };
  var bibliorefs = window.document.querySelectorAll('a[role="doc-biblioref"]');
  for (var i=0; i<bibliorefs.length; i++) {
    const ref = bibliorefs[i];
    const citeInfo = findCites(ref);
    if (citeInfo) {
      tippyHover(citeInfo.el, function() {
        var popup = window.document.createElement('div');
        citeInfo.cites.forEach(function(cite) {
          var citeDiv = window.document.createElement('div');
          citeDiv.classList.add('hanging-indent');
          citeDiv.classList.add('csl-entry');
          var biblioDiv = window.document.getElementById('ref-' + cite);
          if (biblioDiv) {
            citeDiv.innerHTML = biblioDiv.innerHTML;
          }
          popup.appendChild(citeDiv);
        });
        return popup.innerHTML;
      });
    }
  }
});
</script>
</div> <!-- /content -->