FROM archlinux:latest AS base
RUN pacman-key --init
RUN pacman -Syu --needed --noconfirm openssl-1.1 dnsutils base-devel git go zsh vim jq python-pip python-setuptools yarn
RUN useradd -m -G wheel -s /bin/zsh dock
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dock
RUN cd /tmp && git clone -q --depth 1 https://aur.archlinux.org/yay.git && cd yay && makepkg -s && sudo pacman -U --needed --noconfirm $(ls yay-*.zst) && cd .. && rm -rf yay
USER root

FROM base AS gobuilds
RUN go install github.com/projectdiscovery/katana/cmd/katana@latest
RUN go install github.com/projectdiscovery/proxify/cmd/proxify@latest
RUN go install github.com/projectdiscovery/uncover/cmd/uncover@latest
RUN go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest
RUN go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
RUN go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
RUN go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
RUN go install github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest
RUN go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
RUN go install github.com/hahwul/dalfox/v2@latest
RUN go install github.com/ffuf/ffuf@latest
RUN go install github.com/lc/gau/v2/cmd/gau@latest
RUN go install github.com/OWASP/Amass/v3/...@master
RUN git clone --depth 1 https://github.com/trufflesecurity/trufflehog.git && cd trufflehog && go install && cd ..
RUN git clone --depth 1 https://github.com/zmap/zdns.git && cd zdns && go install && cd ..

FROM base
USER dock
RUN yay -Sy --needed --noconfirm xsv nmap zmap sqlmap wpscan nikto metasploit zsh-antidote google-chrome whatweb xsstrike

WORKDIR /home/dock
COPY --chown=dock .zsh* .vimrc ./
RUN /usr/bin/zsh -c "source /usr/share/zsh-antidote/antidote.zsh && antidote bundle < ~/.zshplugins.txt > ~/.zshplugins" 
#RUN mkdir -p /home/dock/.vim/bundle
#RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s - /home/dock/.vim/bundle

RUN mkdir /home/dock/bin
COPY --from=gobuilds /root/go/bin/* /usr/bin/

RUN mkdir /home/dock/repos
WORKDIR /home/dock/repos
RUN git clone -q --depth 1 https://github.com/GerbenJavado/LinkFinder.git && cd LinkFinder && pip install -e . && chmod +x linkfinder.py && ln -s $PWD/linkfinder.py $HOME/bin/linkfinder && cd ..
RUN git clone -q --depth 1 https://github.com/wappalyzer/wappalyzer.git && cd wappalyzer && yarn install && yarn run link && echo -e "#/bin/sh\nnode $PWD/src/drivers/npm/cli.js "'$@' > wappalyzer && chmod +x wappalyzer && ln -s $PWD/wappalyzer $HOME/bin/ && cd ..
RUN git clone -q --depth 1 https://github.com/OWASP/Nettacker && cd Nettacker && pip install -r requirements.txt && chmod +x nettacker.py && ln -s $PWD/nettacker.py $HOME/bin/nettacker && cd ..
RUN git clone -q --depth 1 https://github.com/projectdiscovery/nuclei-templates

WORKDIR /home/dock
ENTRYPOINT ["/bin/zsh"]
