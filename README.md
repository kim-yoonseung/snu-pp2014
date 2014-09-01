# Software Foundations 2014 Fall @ SNU #

TA: Jeehoon Kang (sf-ta at ropas dot snu dot ac dot kr)

## Announcement ##

* *IMPORTANT*: use designated versions of software in this class. Your submission will not be properly graded if you do not follow this instruction. Use *Coq 8.4pl4* to avoid version incompatibility. Download software foundations [here](https://github.com/lunaticas/snu-sf/raw/master/resources/sf.tar) to avoid version incompatibility.

* *IMPORTANT*: create a Git repository for this class.

## Homework ##

TBA

## Reference ##

### Install Coq ###

* Download Coq [here](http://coq.inria.fr/download) and install it.

  + For OS X, download those with CoqIDE bundle. And you may have to
    properly set path variable. add the following in `~/.bashrc`:
    ```
    export PATH=/Applications/CoqIdE_8.4pl4.app/Resources/bin/:$PATH
    ```
    The path may be updated; be cautious before blindly adding the line.

* Test by `coqc -v` in the command line.

### Install Git ###

Download [here](http://git-scm.com/downloads).

### Coq on Emacs ###

If you are interested in using Coq in Emacs, follow this instruction.

* Install Emacs.

  + For OS X, download [here](http://emacsformacosx.com/).

* Edit `.emacs` for Coq.

  + [Here](https://github.com/lunaticas/configurations.git) is a sample `.emacs` forCoq. Lines containing `proof` or `coq` are relavent.

* Open `.v` files in Emacs, and interactively use Coq. Here are some useful commands; try them.

  + `C-c C-n`

  + `C-c C-p`

  + `C-c C-Enter`

  + `C-c C-b`

  + `C-c C-x`

  + `C-c C-a C-c`

  + `C-c C-a C-p`

  + `C-c C-a C-a`

  + Combination that begins with `C-c`
