FROM archlinux:latest
RUN pacman -Syu --needed --noconfirm base-devel zsh git vim go\
	python-pip python-setuptools yarn
RUN chsh -s /bin/zsh root
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -m -G wheel -s /bin/zsh bounty

USER root
WORKDIR /root
COPY .zsh* .vimrc install_env.sh ./
RUN ./install_env.sh

USER bounty
WORKDIR /home/bounty
COPY .zsh* .vimrc install_env.sh ./
RUN sudo chown bounty:bounty .zsh* .vimrc install_env.sh
RUN ./install_env.sh && rm ./install_env.sh

RUN mkdir /home/bounty/bin
RUN mkdir /home/bounty/repos
WORKDIR /home/bounty/repos
RUN git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -s && sudo pacman -U --needed --noconfirm $(ls yay-*.zst) && cd ..
RUN yay -Syu --needed --noconfirm google-chrome metasploit nmap sqlmap nuclei httpx dnsx subfinder shuffledns gau ffuf amass trufflehog xsstrike
RUN go install github.com/hahwul/dalfox/v2@latest
RUN go install github.com/projectdiscovery/katana/cmd/katana@latest
RUN go install github.com/projectdiscovery/proxify/cmd/proxify@latest
RUN go install github.com/projectdiscovery/uncover/cmd/uncover@latest
RUN go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest
RUN git clone https://github.com/GerbenJavado/LinkFinder.git && cd LinkFinder &&\
	pip install -e . && chmod +x linkfinder.py && ln -s $PWD/linkfinder.py $HOME/bin/linkfinder && cd ..
RUN git clone https://github.com/wappalyzer/wappalyzer.git && cd wappalyzer &&\
	yarn install && yarn run link &&\
	echo -e "#/bin/sh\nnode $PWD/src/drivers/npm/cli.js "'$@' > wappalyzer && chmod +x wappalyzer &&\
	ln -s $PWD/wappalyzer $HOME/bin/ && cd ..
RUN git clone https://github.com/trufflesecurity/trufflehog.git && cd trufflehog && go install && cd ..

WORKDIR /home/bounty
ENTRYPOINT ["/bin/zsh"]
