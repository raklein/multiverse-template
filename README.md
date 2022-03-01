# multiverse-template

Edit: This repo not being used currently. 

We're building an analysis template that implements 15 researcher degrees of
freedom on an example dataset. The ultimate goal is to develop a template that can be easily modified
and re-used to implement semi-standard sets of multiverse analyses across many
different datasets.

Uses the [Multiverse R package](https://github.com/MUCollective/multiverse).
The 15 degrees of freedom are a [pared-down set](https://docs.google.com/document/d/1aB1enkTeEV9JtVN6WX7Euea0iu0rNL9mwO5UMYv3GQk/edit?usp=sharing) of the degrees of freedom originally proposed by [Wicherts et al., 2016](https://doi.org/10.3389/fpsyg.2016.01832).

Beginner first-time Github setup:
1. Ensure you have R and R Studio installed.  
2. Create a GitHub account.   
3. [Fork](https://help.github.com/articles/fork-a-repo/) the repository into your own account:  
https://github.com/raklein/multiverse-template  
4. If necessary, [Install Git](https://help.github.com/articles/set-up-git/) (comes with MacOS by default)  
5. [Clone](https://help.github.com/articles/cloning-a-repository/) (e.g., download the files and create a Git repository on your local hard disk) the repo locally. To do this, first go to the forked repository on GitHub, click the "Clone or Download" button, copy the link. 
Open a [Terminal](http://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line) (or [cmd prompt](https://www.howtogeek.com/235101/10-ways-to-open-the-command-prompt-in-windows-10/)), navigate to where you want the files to be stored on your hard disk (use the 'cd' command in Terminal, which changes your directory), and run:
`git clone <copied url>`

Replace `<copied url>` with your clipboard. This will create a new directory on your computer: multiverse-template.

6. Navigate on your computer to the new *multiverse-template* folder and open *multiverse-template.rproj* in R Studio. Using R Projects eliminates the need to set a working directory each time (it's automatically set to the folder containing the .rproj file).
7. In the RStudio window, navigate and open /code/template.R. 
8. In the Terminal of R Studio (or your regular command line), [configure the remote repository](https://help.github.com/articles/configuring-a-remote-for-a-fork/) so you can update your local files with changes from the main repo:  
`git remote add upstream https://github.com/raklein/multiverse-template.git`
9. Each time before you start editing the page, [update your local repo](https://help.github.com/articles/syncing-a-fork/) and resolve any conflicts. You can do this in R Studio by using the UI interface in the upper right "Git" tab, or via the R Studio 'terminal' (a tab where the Console usually is):  
`git fetch upstream`  
`git checkout master`  
`git merge upstream/master`

If you get conflicts you will have to resolve them before it will let you merge. IF you want to overwrite your local changes with the main repo you can "stash" your files like this:
`git stash save --keep-index`

If you don't want to keep your stashed files, drop them:
`git stash drop`

10. At this point, you can make your edits to the R script.  
11. Once you're done, you'll "Commit" those changes back to your local repository. In Rstudio, go to the Git tab and click "commit" to bring up a new window. Check off all the files you want to commit (usually all of them), write a brief note that explains what changes were made, and press "Commit" in the new window.  
12. Then, to "Push" these changes back to your fork on GitHub, press the "Push" button.
13. Finally, submit a "Pull Request" to send these changes up to the original repository. Go to GitHub.com, login on your account, and submit a "Pull Request". After this, I'll take a look at the new changes and and merge the pull request into the main repository.  

Each session you should: 
1. Fetch any upstream changes (in RStudio press the blue down arrow on the Git tab).
2. Make your edits.
3. Commit your edits and push them to GitHub.
4. (optional) Create a pull request if you're ready for those edits to go up to the master branch

Note: You need to be authenticated to your GitHub account on your pc or it will give you an error.
