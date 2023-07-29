FROM archlinux:latest AS base
RUN pacman-key --init
RUN pacman -Syu --needed --noconfirm openssl-1.1 dnsutils base-devel clang cmake zsh vim wget git unzip jq go rust ruby npm python-pip python-setuptools python-pipenv yarn
RUN useradd -m -G wheel -s /bin/zsh dock
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dock
RUN cd /tmp && git clone -q --depth 1 https://aur.archlinux.org/yay.git && cd yay && makepkg -s && sudo pacman -U --needed --noconfirm $(ls yay-*.zst) && cd .. && rm -rf yay
USER root

FROM base AS gobuilds
RUN go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest
RUN go install github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest
RUN go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install github.com/projectdiscovery/katana/cmd/katana@latest
RUN go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
RUN go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
RUN go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
RUN go install github.com/projectdiscovery/proxify/cmd/proxify@latest
RUN go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
RUN go install github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest
RUN go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest
RUN go install github.com/projectdiscovery/uncover/cmd/uncover@latest
RUN go install github.com/BishopFox/jsluice/cmd/jsluice@latest
RUN go install github.com/edoardottt/cariddi/cmd/cariddi@latest
RUN go install github.com/edoardottt/csprecon/cmd/csprecon@latest
RUN go install github.com/ffuf/ffuf@latest
RUN go install github.com/hahwul/dalfox/v2@latest
RUN go install github.com/hahwul/jwt-hack@latest
RUN go install github.com/lc/gau/v2/cmd/gau@latest
RUN go install github.com/liamg/gitjacker/cmd/gitjacker@latest
RUN go install github.com/rs/curlie@latest
RUN go install github.com/rverton/webanalyze/cmd/webanalyze@latest
RUN go install github.com/sensepost/gowitness@latest
RUN go install github.com/OJ/gobuster/v3@latest
RUN go install github.com/owasp-amass/amass/v4/...@latest
RUN go install github.com/praetorian-inc/fingerprintx/cmd/fingerprintx@latest
RUN git clone --depth 1 https://github.com/trufflesecurity/trufflehog.git && cd trufflehog && go install
RUN git clone --depth 1 https://github.com/zmap/zdns.git && cd zdns && go install

FROM base
USER dock
RUN mkdir /home/dock/bin
RUN mkdir /home/dock/repos
ADD wordlists.tar.xz /
COPY --from=gobuilds /root/go/bin/* /usr/bin/
RUN sudo npm install -g retire
RUN yay -Syu --needed --noconfirm --cleanafter xsv nmap zmap sqlmap wpscan nikto noseyparker metasploit wafw00f zsh-antidote freetype2 mesa massdns google-chrome

WORKDIR /home/dock
COPY --chown=dock .zsh* .vimrc ./
RUN /usr/bin/zsh -c "source /usr/share/zsh-antidote/antidote.zsh && antidote bundle < ~/.zshplugins.txt > ~/.zshplugins" 
#RUN mkdir -p /home/dock/.vim/bundle
#RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s - /home/dock/.vim/bundle

WORKDIR /home/dock/repos
RUN git clone -q --depth 1 https://github.com/wappalyzer/wappalyzer.git && cd wappalyzer && yarn install && yarn run link && echo -e "#/bin/sh\nnode $PWD/src/drivers/npm/cli.js "'$@' > wappalyzer && chmod +x wappalyzer && ln -s $PWD/wappalyzer $HOME/bin/
RUN git clone -q --depth 1 https://github.com/OWASP/Nettacker && cd Nettacker && pipenv install && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/Nettacker\npipenv run python nettacker.py "'$@' > nettacker && chmod +x nettacker
RUN git clone -q --depth 1 https://github.com/ticarpi/jwt_tool.git && cd jwt_tool && pipenv install && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/jwt_tool\npipenv run python jwt_tool.py "'$@' > jwt_tool && chmod +x jwt_tool
RUN git clone -q --depth 1 https://github.com/mzfr/liffy && cd liffy && pipenv install && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/liffy\npipenv run python liffy.py "'$@' > liffy && chmod +x liffy
RUN git clone -q --depth 1 https://github.com/vladko312/SSTImap && cd SSTImap && pipenv install && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/SSTImap\npipenv run python sstimap.py "'$@' > sstimap && chmod +x sstimap
RUN git clone -q --depth 1 https://github.com/santoru/shcheck && cd shcheck && pipenv install . && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/shcheck\npipenv run python shcheck.py "'$@' > shcheck && chmod +x shcheck
RUN git clone -q --depth 1 https://github.com/commixproject/commix && cd commix && pipenv install . && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/commix\npipenv run commix "'$@' > commix && chmod +x commix
RUN git clone -q --depth 1 https://github.com/vulnersCom/getsploit && cd getsploit && pipenv install . && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/getsploit\npipenv run getsploit "'$@' > getsploit && chmod +x getsploit
RUN git clone -q --depth 1 https://github.com/vortexau/dnsvalidator && cd dnsvalidator && pipenv install . && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/dnsvalidator\npipenv run dnsvalidator "'$@' > dnsvalidator && chmod +x dnsvalidator
RUN git clone -q --depth 1 https://github.com/Raghavd3v/CRLFsuite && cd CRLFsuite && pipenv install . && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/CRLFsuite\npipenv run crlfsuite "'$@' > crlfsuite && chmod +x crlfsuite
RUN git clone -q --depth 1 https://github.com/trickest/resolvers
RUN git clone -q --depth 1 https://github.com/projectdiscovery/nuclei-templates
RUN git clone -q --depth 1 https://github.com/projectdiscovery/fuzzing-templates
#ENV PATH="$PATH:/home/dock/.local/bin"

WORKDIR /home/dock
ENTRYPOINT ["/bin/zsh"]
