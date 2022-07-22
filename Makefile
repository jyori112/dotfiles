SHELL = /bin/zsh
ZSH_D = $(HOME)/.zsh.d

##############################
#	Configuration
##############################
PYENV_ROOT = $(HOME)/.pyenv
NEOVIM_PY2_VERSION=2.7.18
NEOVIM_PY3_VERSION=3.9.1

##############################
#	Alias
##############################
# For os specific command (ln has different option)
UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
	LN_OPT=-fs
	OSNAME=ubuntu
endif

ifeq ($(UNAME), Darwin)
	LN_OPT=-Fs
	OSNAME=macos
endif

LN = ln $(LN_OPT)

LOG = echo

GIT_CLONE = [ ! -d $@ ] && git clone

##############################
#	Simply Link Files to HOME directory
##############################
$(HOME)/%: dotfiles/%
	mkdir -p $$(dirname $@)
	$(LN) $(realpath $<) $@

##############################
#	Terminal
##############################
########## Oh My Zsh ##########
$(HOME)/.oh-my-zsh: git
	$(LOG) installing oh my zsh
	$(GIT_CLONE) https://github.com/ohmyzsh/ohmyzsh.git $@ || true

oh-my-zsh: $(HOME)/.oh-my-zsh

########## Powerlevel10k ##########
$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k: oh-my-zsh git
	$(LOG) installing powerlevel10k
	$(GIT_CLONE) --depth=1 https://github.com/romkatv/powerlevel10k.git $@ || true

power10k: \
	$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k \
	$(HOME)/.p10k.zsh

########## Zsh Config ##########
zsh: \
	$(HOME)/.bash_profile \
	power10k \
	$(HOME)/.zsh.d \
	$(HOME)/.zshrc

##############################
#	Install applications
##############################
########## homebrew ##########
homebrew:
	$(LOG) installing homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

########## pyenv ##########
$(PYENV_ROOT): git
	$(LOG) Installing pyenv
	$(GIT_CLONE) https://github.com/yyuu/pyenv.git $@ || true

$(PYENV_ROOT)/plugins/pyenv-virtualenv:
	$(LOG) Installing virtualenv
	$(GIT_CLONE) https://github.com/yyuu/pyenv-virtualenv.git $@ || true

$(PYENV_ROOT)/plugins/pyenv-update:
	$(LOG) Installing pyenv-update
	$(GIT_CLONE) git://github.com/yyuu/pyenv-update.git $@ || true

pyenv: $(PYENV_ROOT) $(PYENV_ROOT)/plugins/pyenv-virtualenv

########## rbenv ##########
rbenv: homebrew
	brew install rbenv ruby-build

########## chromedriver ##########
chromedriver: homebrew
	brew install chromedriver

########## openjdk ##########
openjdk: homebrew
	brew install openjdk@8

########## neovim ##########
install-neovim-on-macos: homebrew
	$(LOG) installing neovim
	brew install neovim

neovim-install: install-neovim-on-$(OSNAME)

setup-pyenv4neovim-py3: install-neovim install-pyenv
	$(LOG) Creating environment for neovim in python3
	pyenv install $(NEOVIM_PY3_VERSION)
	pyenv virtualenv $(NEOVIM_PY3_VERSION) neovim-py3
	$(LOG) Installing neovim package
	pyenv shell neovim-py3 && pip install neovim

setup-pyenv4neovim-py2: install-neovim install-pyenv
	$(LOG) Creating environment for neovim in python2
	pyenv install $(NEOVIM_PY2_VERSION)
	pyenv virtualenv $(NEOVIM_PY2_VERSION) neovim-py2
	$(LOG) Installing neovim package
	pyenv shell neovim-py2 && pip install neovim

setup-pyenv4neovim: setup-pyenv4neovim-py3 setup-pyenv4neovim-py2

neovim: install-neovim setup-pyenv4neovim

########## git ##########
install-git-on-ubuntu:
	apt-get install git-all

install-git-on-macos: homebrew
	brew install git

configure-git: $(HOME)/.gitconfig $(HOME)/.gitignore_global

git: install-git-on-$(OSNAME) configure-git

########## VSCode ##########
vscode: $(HOME)/code homebrew
	brew install visual-studio-code --cask

########## karabiner ##########
karabiner: $(HOME)/.config/karabiner homebrew
	brew install --cask karabiner-elements

########## GHQ ##########
ghq: homebrew
	brew install ghq

########## SL ##########
sl: homebrew
	brew install sl

########## MacTex ##########
mactex: homebrew
	brew install --cask mactex-no-gui

########## Go ##########
go: homebrew
	brew install go

########## Java ##########
sdkman: homebrew
	curl -s "https://get.sdkman.io" | bash

########## graphviz ##########
graphviz: homebrew
	brew install graphviz

##############################
#	configure applications
##############################

configure-matplotlib: $(HOME)/.config/matplotlib

##############################
#	Configure all
##############################
macos: \
	zsh \
	homebrew \
	git \
	vscode \
	karabiner \
	mactex \
	pyenv \
	rbenv

cui: \
	zsh \
	homebrew \
	git
