MatLab with Git Instructions:
'https://www.mathworks.com/help/matlab/matlab_prog/set-up-git-source-control.html'

Windows Setup:
Download Git: https://gitforwindows.org/
Install Default SSH

Git Setup:
$ssh-keygen -t ed25519 -C "EmbedTrev@gmail.com"
$vim ~/.ssh/id___.pub
Copy and paste full .pub file into: https://github.com/settings/keys
$git config -l
$git config user.name "EmbedTrev"
$git config user.email "EmbedTrev@gmail.com"

Repo Setup:
Create github repo
Copy the SSH .git URL ie: git@github.com:EmbedTrev/CellDNA-SVMRBF.git

MatLab Setup:
$touch .gitattributes
In MatLab CMD: copyfile(fullfile(matlabroot,'toolbox','shared','cmlink','git','auxiliary_files', ...
'mwgitattributes'),fullfile(pwd,'.gitattributes'))
In MatLab CMD: edit .gitattributes



