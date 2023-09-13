$REPO="$0"

git clone -q --depth 1 $REPO cd Nettacker && pipenv install && pipenv --clear && cd $HOME/bin && echo -e "#/bin/sh\ncd $HOME/repos/Nettacker\npipenv run python nettacker.py "'$@' > nettacker && chmod +x nettacker

RUN git clone -q --depth 1 https://github.com/wappalyzer/wappalyzer.git && cd wappalyzer && yarn install && yarn run link && echo -e "#/bin/sh\nnode $PWD/src/drivers/npm/cli.js "'$@' > wappalyzer && chmod +x wappalyzer && ln -s $PWD/wappalyzer $HOME/bin/ && yarn cache clean
