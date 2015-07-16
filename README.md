BDS

----

Haruo Suzuki  
haruo@g-language.org  
Last Update: 2015-07-14

----

# Bioinformatics Data Skills
## Reproducible and Robust Research With Open Source Tools
### Vince Buffalo
“Bioinformatics Data Skills by Vince Buffalo (O’Reilly). Copyright 2015 Vince Buffalo, 978-1-449-36737-4.”
- [Supplementary Material on GitHub] (https://github.com/vsbuffalo/bds-files)

## 書店
- [Amazon.co.jp] (http://www.amazon.co.jp/dp/1449367372)
- [O'Reilly Media] (http://shop.oreilly.com/product/0636920030157.do)
- [Safari Books Online] (https://www.safaribooksonline.com/library/view/bioinformatics-data-skills/9781449367480/)

## 書評
- [Don’t trust your data: reviewing Bioinformatics Data Skills | The Molecular Ecologist] (http://www.molecularecologist.com/2015/04/dont-trust-your-data-reviewing-bioinformatics-data-skills/)
- [Reading the early release of "Bioinformatics Data Skills"Musings from a PhD candidate] (http://davetang.org/muse/2014/04/03/bioinformatics-data-skills/)

* * * 
*** 
***** 
- - -

## メモ
----
### Preface
#### Assumptions This Book Makes
* You have basic Unix command-line skills | cd, ls, pwd, mv, rm, rmdir, and mkdir.

----

## Part I. Ideology: Data Skills for Robust and Reproducible Bioinformatics

### Chapter 1. How to Learn Bioinformatics

#### Reproducible Research | 再現可能な研究
データ、コード、ソフトウェアのバージョンとダウンロードした日時を記録する。

#### Robust Research and the Golden Rule of Bioinformatics
"garbage in, garbage out"  

#### Recommendations for Robust Research | 頑健な研究のススメ

##### Pay Attention to Experimental Design
 To consult the statistician after an experiment is finished is often merely to ask him to conduct a post mortem examination. He can perhaps say what the experiment died of. R.A. Fisher  
「実験が終わった後に統計学者に相談することは、しばしば単に検死を頼むようなものになる。統計学者は、何のせいで実験が死んだのかについて言うことができるかもしれない。R. A.フィッシャー http://id.fnshr.info/2014/12/17/stats-done-wrong-13/

##### Use Existing Libraries Whenever Possible | なるべく既存のライブラリを使う
歴史が長く、閲覧者が多いので、バグが少ない。

##### Treat Data as Read-Only | データを書き換えない

#### Recommendations for Reproducible Research | 再現可能な研究のススメ

##### Release Your Code and Data | データとコードを公開する

##### Document Everything | 全て記録する

##### Make Figures and Statistics the Results of Scripts | 図表を出力するスクリプトを書く

##### Use Code as Documentation | ドキュメントとしてコードを使用

#### Continually Improving Your Bioinformatics Data Skills

----

## Part II. Prerequisites: Essential Skills for Getting Started with a Bioinformatics Project | バイオインフォマティクス・プロジェクトの必須スキル

### Chapter 2. Setting Up and Managing a Bioinformatics Project | バイオインフォマティクス・プロジェクトの設定と管理

#### Project Directories and Directory Structures | ディレクトリ構造
- [計算生物学のプロジェクトの管理法入門 (Noble 2009)](http://5hun.github.io/quickguide_ja/)  
- 例えば、プロジェクト名を'zmays-snps'としてディレクトリを作成する

		mkdir zmays-snps
		cd zmays-snps
		mkdir data
		mkdir data/seqs scripts analysis
		ls -l

----

What’s in a Name?  
ファイル名には、英数字や_や-を使い、スペース（空白）を入れない。拡張子を付ける（例 `gene_2015-07-07.fasta`）。  

----

絶対パス（例 `/home/vinceb/projects/zmays-snps/data/stats/qual.txt`）ではなく相対パス（例 `../data/stats/qual.txt`）を使う。

#### Project Documentation | プロジェクトの記録
- Document your methods and workflows | 全コマンドライン- Document the origin of all data in your project directory | データ入手元（URL）- Document when you downloaded data | データをダウンロードした日付- Record data version information | データのバーション- Describe how you downloaded the data | データのダウンロード方法- Document the versions of the software that you ran | ソフトウェアのバーション（日付,URL）

以上の情報をテキスト形式のREADMEファイルに保存する。  
READMEファイルをプロジェクトの主ディレクトリに格納する。例えば、`data/README`ファイルに、`data/`ディレクトリのデータファイルの説明（いつ・どこから・どのようにダウンロードしたのか）を記載する。touchコマンドでサイズが0の空ファイルを作成する。  

	$ touch README data/README

#### Use Directories to Divide Up Your Project into Subprojects | ディレクトリを使用してプロジェクトをサブプロジェクトに分割

#### Organizing Data to Automate File Processing Tasks
一貫性のあるファイル名

----

Shell Expansion Tips | シェルの展開
`cd ~`でホームディレクトリに移動。ワイルドカード(*)。

Brace expansionの例

	$ echo dog-{gone,bowl,bark}
	dog-gone dog-bowl dog-bark

同様に、`zmays-snps/`プロジェクト・ディレクトリを作成

	$ mkdir -p zmays-snps/{data/seqs,scripts,analysis}

----

3つのサンプル (zmaysA, zmaysB, zmaysC) 毎にペア (R1, R2) の空データファイルを作成するには：

	cd data	touch seqs/zmays{A,B,C}_R{1,2}.fastq	ls seqs/

サンプル名`zmaysB`を持つ全てのファイルを表示するには、ワイルドカード(*)を用いて：
	ls seqs/zmaysB*

----

Wildcards and "Argument list too long"

解決方法は"Using find and xargs"を参照されたい

----

ワイルドカードで限定する。`zmaysB*`の代わりに、`zmaysB*fastq`または`zmaysB_R?.fastq`を用いる（`?`は任意の1文字）。

サンプルCを排除するには：

	ls zmays[AB]_R1.fastq
	ls zmays[A-B]_R1.fastq

ワイルドカードは存在するファイルを展開するのに対して、brace expansion（例 `snps_{10..13}.txt`）はファイルやディレクトリが存在するか否かに関係なく展開する。
Table 2-1. Unixのワイルドカード

|ワイルドカード|マッチする文字|
|:----------:|:----------:|
|*|0文字以上の任意の文字列（隠しファイルは無視）|
|?|任意の1文字（隠しファイルは無視）|
|[A-Z]|AとZの間の1文字（[0-9]は0と9の間の1文字）|

参考：  
[UNIXのワイルドカード](http://www.rsch.tuis.ac.jp/~ohmi/literacy/2002/wildcard.html)

----

Leading Zeros and Sorting

use leading zeros (e.g., file-0021.txt rather than file-21.txt) when naming files.

----

#### Markdown for Project Notebooks
simple plain-text * can be read, searched, and edited from the command line and across network connections to servers. 

##### Markdown Formatting Basics
If you’re placing a code block within a list item, make this eight spaces, or two tabs:

##### Using Pandoc to Render Markdown to HTML
[Pandocインストール](http://pandoc.org/installing.html)  
	$ pandoc --from markdown --to html notebook.md > output.html

----

### Chapter 3. Remedial Unix Shell 補習Unixシェル
https://github.com/vsbuffalo/bds-files/tree/master/chapter-03-remedial-unix

#### Why Do We Use Unix in Bioinformatics? Modularity and the Unix Philosophy
pipes  
redirection  

----

The Many Unix Shells

`echo $SHELL` (`echo $0`) で現在のシェルを確認
`chsh`でログインシェルを変更

----

streams, redirection, pipes, working with processes, and command substitution. 

#### Working with Streams and Redirection | ストリームとリダイレクション

##### Redirecting Standard Out to a File | 標準出力をファイルにリダイレクト
`cat`コマンドで[tb1-protein.fasta](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-03-remedial-unix/tb1-protein.fasta)ファイルを見る。

	$ cat tb1-protein.fasta

複数のファイル tb1-protein.fasta と [tga1-protein.fasta](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-03-remedial-unix/tga1-protein.fasta) の標準出力

	$ cat tb1-protein.fasta tga1-protein.fasta

記号 > （上書き）や >> （追記）を用いて、標準出力を[リダイレクト](https://ja.wikipedia.org/wiki/リダイレクト_(CLI))する。

	$ cat tb1-protein.fasta tga1-protein.fasta > zea-proteins.fasta

最新のファイル (zea-proteins.fasta) を確認

	ls -lrt

##### Redirecting Standard Error | 標準エラー出力をリダイレクト
コマンド ls -l を用いると、存在するファイル([tb1.fasta](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-03-remedial-unix/tb1.fasta))は標準出力に、存在しないファイル(leafy1.fasta)は標準エラー出力に。

	$ ls -l tb1.fasta leafy1.fasta	ls: leafy1.fasta: No such file or directory
	-rw-r--r-- 1 vinceb staff 0 Feb 21 21:58 tb1.fasta

記号 > と 2> を用いて、標準出力と標準エラー出力を別のファイルにリダイレクトする：
	ls -l tb1.fasta leafy1.fasta > listing.txt 2> listing.stderr
	cat listing.txt	cat listing.stderr記号 2> は上書き、 2>> は追記。

----

File Descriptors

----

/dev/null

----

Using tail -f to Monitor Redirected Standard Error

tail -f を用いて、リダイレクトされた標準エラー出力を監視する。Control-C で動作中のプロセスを停止。

----

##### Using Standard Input Redirection

	$ program < inputfile > outputfile

#### The Almighty Unix Pipe: Speed and Beauty in One

##### Pipes in Action: Creating Simple Programs with Grep and Pipes

パイプとgrepコマンドを用いて、FASTAファイルに含まれるATGC以外の文字を探す。

	grep -v "^>" tb1.fasta | \
	grep --color -i "[^ATCG]"

ハイライトされたYはpYrimidine塩基[CT]を示す[参考](https://en.wikipedia.org/wiki/Nucleic_acid_notation)。
正規表現はクオーテーションで囲む。`grep -v > tb1.fasta`はファイルを上書きしてしまう。

##### Combining Pipes and Redirection	$ program1 input.txt 2> program1.stderr | \
	$ program2 2> program2.stderr > results.txt

2>&1は標準エラー出力を標準出力にリダイレクトする

	program1 2>&1 | grep "error"##### Even More Redirection: A tee in Your Pipe

	$ program1 input.txt | tee intermediate-file.txt | program2 > results.txt

#### Managing and Interacting with Processes
the basics of manipulating processes: running and managing processes in the background, killing errant processes, and checking process exit status.

##### Background Processes
(&)でバックグラウンドでプログラムを実行

	$ program1 input.txt > results.txt &
	 [1] 26577

番号はprocess ID or PID

	$ jobs	[1]+ Running program1 input.txt > results.txt`fg`を用いて、background process into the foreground
fg %<num> where <num>
fg and fg %1

	$ fg	program1 input.txt > results.txt

----

Background Processes and Hangup Signals

----



### Chapter 4. Working with Remote Machines
#### Connecting to Remote Machines with SSH
Storing Your Frequent SSH Hosts


#### Quick Authentication with SSH Keys

	$ ssh-keygen -b 2048



#### Maintaining Long-Running Jobs with nohup and tmux

### Chapter 5. Git for Scientists

##### Git Setup: Telling Git Who You Are

	git config --global user.name "Sewall Wright"	git config --global user.email "swright@adaptivelandscape.org"	git config --global color.ui true

	git init

[Seqtk (SEQuence ToolKit)](https://github.com/lh3/seqtk)

	git clone git://github.com/lh3/seqtk.git
	cd seqtk	ls

##### Tracking Files in Git: git add and git status Part I

	git status
	git add README data/README

##### Staging Files in Git: git add and git status Part II

	echo "Zea Mays SNP Calling Project" >> README    # change file README
	git status

	git add README	git status

##### git commit: Taking a Snapshot of Your Project

	git commit -m "initial import"
	git status

テキストエディタを変更
	git config --global core.editor emacs

----

Some Advice on Commit Messages

----

`git commit -a -m "your commit message"`


##### Seeing File Differences: git diff 

例えば、README.mdファイルに一行追加して、`git diff`を実行:

	echo "Project started 2013-01-03" >> README
	git diff

ファイルをステージすると、`git diff`は何も出力しない。
	git add README	git diff # shows nothing直近のコミット　比較	git diff --staged

##### Seeing Your Commit History: git log

We can use git log to visualize our chain of commits:	git log

----

git log and Your Terminal Pager

----

	git commit -a -m "added information about project to README"
	git log


クローンしたseqtkリポジトリで`git log`

##### Moving and Removing Files: git mv and git rm

	git mv README README.md	git mv data/README data/README.md
	ls	git status
	git commit -m "added markdown extensions to README files"

##### Telling Git What to Ignore: .gitignore

無視させたいファイルを記載した .gitignore ファイルを作成
	echo "data/seqs/*.fastq" > .gitignore	git status.gitignoreファイルをステージし、コミット	git add .gitignore	git commit -m "added .gitignore"

バイオインフォマティクス・プロジェクトで無視させたいファイルの例:
- Large files \ 巨大なファイル- Intermediate files | 中間ファイル (SAM or BAM)- Text editor temporary files | テキストエディタ(Emacs や Vim)の一時ファイル(textfile.txt~ や #textfile.txt#)
- Temporary code files | Pythonのoverlap.pyc.

`~/.gitignore_global`にグローバルな`.gitignore`ファイルを作成

	.DS_Store
	*~
	\#*\#

設定する
	git config --global core.excludesfile ~/.gitignore_global

##### Undoing a Stage: git reset

	echo "TODO: ask sequencing center about adapters" >> README.md	git add README.md	git status	git reset HEAD README.md
	git status

#### Collaborating with Git: Git Remotes, git push, and git pull

##### Creating a Shared Central Repository with GitHub
[the Create a New Repository page](https://github.com/new)
zmays-snps

##### Authenticating with Git Remotes

	ssh -T git@github.com

##### Connecting with Git Remotes: git remote

	git remote add origin git@github.com:haruosuz/zmays-snps.git

	git remote -v

`git remote rm <repository-name>`

##### Pushing Commits to a Remote Repository with git push

	git push origin master

##### Pulling Commits from a Remote Repository with git pull

	git clone git@github.com:haruosuz/zmays-snps.git zmays-snps-barbara

両リポジトリは同じコミットを持つ　`git log`で確認

オリジナルのzmay-snps/ローカル・リポジトリのファイルを修正し、コミットし、pushする:	echo "Samples expected from sequencing core 2013-01-10" >> README.md
	git commit -a -m "added information about samples"
	git push origin master

Barbaraのリポジトリ (zmays-snps-barbara) で、セントラル・リポジトリからpullする。

	# in zmays-snps-barbara/	git pull origin master

Barbaraのリポジトリが最新のコミットを含むことを`git log`で確認

	# in zmays-snps-barbara/	git log --pretty=oneline --abbrev-commit

##### Working with Your Collaborators: Pushing and Pulling




##### Merge Conflicts

##### More GitHub Workflows: Forking and Pull Requests



#### Using Git to Make Life Easier: Working with Past Commits
 





### Chapter 6. Bioinformatics Data
#### Retrieving Bioinformatics Data
##### Downloading Data with wget and curl
###### *wget*
###### *Curl*
#### Rsync and Secure Copy (scp)

#### Data Integrity

#### Looking at Differences Between Data データの違い
https://github.com/vsbuffalo/bds-files/tree/master/chapter-06-bioinformatics-data
    $ diff -u gene-1.bed gene-2.bed

#### Compressing Data and Working with Compressed Data データの圧縮
###### *gzip*
##### Working with Gzipped Compressed Files

#### Case Study: Reproducibly Downloading Data

## Part III. Practice: Bioinformatics Data Skills
### Chapter 7. Unix Data Tools
#### Unix Data Tools and the Unix One-Liner Approach: Lessons from Programming Pearls
#### When to Use the Unix Pipeline Approach and How to Use It Safely
##### Inspecting Data with Head and Tail | データを調べる
https://github.com/vsbuffalo/bds-files/tree/master/chapter-07-unix-data-tools

    $ head Mus_musculus.GRCm38.75_chr1.bed 1 3054233 3054733
    $ head -n 3 Mus_musculus.GRCm38.75_chr1.bed 1 3054233 3054733
    $ tail -n 3 Mus_musculus.GRCm38.75_chr1.bed
    $ (head -n 2; tail -n 2) < Mus_musculus.GRCm38.75_chr1.bed
###### *less*
##### Plain-Text Data Summary Information with wc, ls, and awk
##### Working with Column Data with cut and Columns
##### Formatting Tabular Data with column
    $ grep -v "^#" Mus_musculus.GRCm38.75_chr1.gtf | cut -f 1-8 | column -t

##### Sorting Plain-Text Data with Sort
##### Finding Unique Values in Uniq
    $ grep -v "^#" Mus_musculus.GRCm38.75_chr1.gtf | cut -f3 | sort | uniq -c
    $ grep -v "^#" Mus_musculus.GRCm38.75_chr1.gtf | cut -f3 | sort | uniq -c | sort -rn

##### *Join*
##### *Text Processing with Awk*
##### *Bioawk: An Awk for Biological Formats*
##### *Stream Editing with Sed*
    $ wget https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-07-unix-data-tools/chroms.txt
    $ head -n 3 chroms.txt # before sed 
    $ sed 's/chrom/chr/' chroms.txt | head -n 3

#### Advanced Shell Tricks
----
### Chapter 8. A Rapid Introduction to the R Language
#### Getting Started with R and RStudio
#### R Language Basics
##### Simple Calculations in R, Calling Functions, and Getting Help in R
#### Working with and Visualizing Data in R
##### Loading Data into R
##### Merging and Combining Data: Matching Vectors and Merging Dataframes

##### Writing and Applying Functions to Lists with lapply() and sapply()
###### Using lapply()
###### Writing functions
###### Digression: Debugging R Code
###### More list apply functions: sapply() and mapply()
##### Working with the Split-Apply-Combine Pattern
##### Exploring Dataframes with dplyr

#### Developing Workflows with R Scripts
##### Control Flow: if, for, and while
##### Working with R Scripts
##### Workflows for Loading and Combining Multiple Files
##### Exporting Data
 
#### Further R Directions and Resources
----
### Chapter 9. Working with Range Data
----
### Chapter 10. Working with Sequence Data
#### The FASTA Format 
#### The FASTQ Format
#### Nucleotide Codes
#### Base Qualities
#### Example: Inspecting and Trimming Low-Quality Bases
#### A FASTA/FASTQ Parsing Example: Counting Nucleotides
#### Indexed FASTA Files
----
### Chapter 11. Working with Alignment Data
#### Getting to Know Alignment Formats: SAM and BAM
##### The SAM Header
##### The SAM Alignment Section
##### Bitwise Flags
##### CIGAR Strings
##### Mapping Qualities
#### Command-Line Tools for Working with Alignments in the SAM Format
##### Using samtools view to Convert between SAM and BAM
##### Samtools Sort and Index
#### Visualizing Alignments with samtools tview and the Integrated Genomics Viewer
##### Pileups with samtools pileup, Variant Calling, and Base Alignment Quality
----
### Chapter 12. Bioinformatics Shell Scripting, Writing Pipelines, and Parallelizing Tasks
#### Basic Bash Scripting
##### Writing and Running Robust Bash Scripts
###### A robust Bash header
###### Running Bash scripts
##### Variables and Command Arguments 
##### Conditionals in a Bash Script: if Statements
##### Processing Files with Bash Using for Loops and Globbing

#### Automating File-Processing with find and xargs
#### Playing It Safe with find and xargs
#### BSD and GNU xargs
----
### Chapter 13. Out-of-Memory Approaches: Tabix and SQLite
#### Fast Access to Indexed Tab-Delimited Files with BGZF and Tabix
#### Introducing Relational Databases Through SQLite
----
### Chapter 14. Conclusion


###### 

###### 
