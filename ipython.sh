# pip install ipython
ipython profile create
echo "c.TerminalInteractiveShell.confirm_exit = False" >> ~/.ipython/profile_default/ipython_config.py

# ipython
mkdir -p ~/.ipython/profile_default
ln -s ~/repos/dotfiles/shortcuts.py ~/.ipython/profile_default/startup/shortcuts.py