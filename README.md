# Example projects for Godot game engine 
Personal projects for godot 
 
# Submodules 
More info on submodules: https://git-scm.com/book/en/v2/Git-Tools-Submodules 
 
The following are personal notes 

To clone the project with submodules use the following command 

$ git clone --recurse-submodules git@github.com:FelixRiddle/godot-projects.git 
 
Updating submodules in one command for slackers like me 

$ git submodule update --remote --init --recursive --merge 
 
Working with the project and submodules 

To make git check if the submodule is updated every time we push use 

$ git config push.recurseSubmodules check 
 
The "on-demand" will try to push submodules 

$ git config push.recurseSubmodules on-demand 
 
These are some useful aliases 

$ git config alias.spush 'push --recurse-submodules=on-demand' 

$ git config alias.supdate 'submodule update --remote --init --recursive --merge' 
 
