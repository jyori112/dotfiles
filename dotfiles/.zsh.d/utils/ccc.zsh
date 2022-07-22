function change-git-credential(){
  local selected_dir=$(find ~ -maxdepth 1 |grep netrc | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
	  cp ${selected_dir} ~/.netrc
	fi
	echo '-----------------------------'
	echo 'view current "~/.netrc" settings'
	echo '-----------------------------'
	sed -n 1,3p ~/.netrc
}
alias ccc='change-git-credential'

