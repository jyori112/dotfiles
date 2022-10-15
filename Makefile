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
########## Zsh Config ##########
zsh: \
	$(HOME)/.bash_profile \
	$(HOME)/.zsh.d \
	$(HOME)/.zshrc
	$(LOG) changing my shell to zsh
	if [ ! $$0 = /bin/zsh ]; then \
		chsh -s /bin/zsh ; \
	fi

########## Oh My Zsh ##########
$(HOME)/.oh-my-zsh: git zsh
	$(LOG) installing oh my zsh
	$(GIT_CLONE) https://github.com/ohmyzsh/ohmyzsh.git $@ || true

oh-my-zsh: $(HOME)/.oh-my-zsh

########## Powerlevel10k ##########
$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k: oh-my-zsh git $(HOME)/.p10k.zsh
	$(LOG) installing powerlevel10k
	$(GIT_CLONE) --depth=1 https://github.com/romkatv/powerlevel10k.git $@ || true

power10k: $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k

##############################
#	Install applications
##############################
########## homebrew ##########
homebrew: zsh
	if [ ! command -v brew &> /dev/null ]; then \
		$(LOG) installing homebrew; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

########## homebrew ##########
peco: homebrew
	brew install peco

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

setup-pyenv4neovim: neovim-install pyenv
	$(LOG) Creating environment for neovim in python3
	pyenv install -s $(NEOVIM_PY3_VERSION) || true
	pyenv virtualenv $(NEOVIM_PY3_VERSION) neovim-py3 || true
	$(LOG) Installing neovim package
	PYENV_VERSION=neovim-py3 pyenv exec pip install neovim

neovim: neovim-install setup-pyenv4neovim

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

########## gh ##########
gh: homebrew
	brew install gh

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

########## direnv ##########
direnv: homebrew
	brew install direnv

########## node ##########
node: homebrew
	brew install node

########## psql ##########
psql: homebrew
	brew install libpq

hammerspoon: homebrew $(HOME)/.hammerspoon
	brew install hammerspoon --cask

##############################
#	configure applications
##############################

configure-matplotlib: $(HOME)/.config/matplotlib

##############################
#	Configure all
##############################
macos: \
	zsh \
	peco \
	power10k \
	homebrew \
	git \
	vscode \
	karabiner \
	pyenv \
	rbenv \
	direnv \
	sdkman \
	hammerspoon \
	neovim \
	gh \
	ghq


cui: \
	zsh \
	homebrew \
	git
