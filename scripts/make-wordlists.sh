mkdir wordlists
cd wordlists

wget -q https://github.com/danielmiessler/SecLists/archive/master.zip -O SecLists.zip
unzip SecLists
rm SecLists.zip
mv SecLists-master seclists
rm -rf seclists/.github
rm -rf seclists/.bin
rm -rf seclists/Passwords
rm seclists/.gitattributes
rm seclists/.gitignore
rm seclists/SecLists.png
rm seclists/Miscellaneous/security-question-answers/zip-codes.txt


wget -q https://github.com/kkrypt0nn/wordlists/archive/main.zip -O kkrypt0nn.zip
unzip kkrypt0nn.zip
rm kkrypt0nn.zip
mv kkrypt0nn-main kkrypt0nn
rm -rf kkrypt0nn/.github
rm -rf kkrypt0nn/passwords
rm kkrypt0nn/.gitattributes
rm kkrypt0nn/languages/german.txt
rm kkrypt0nn/security_question_answers/zip_codes.txt
rm kkrypt0nn/stressing/5_digits_00000_99999.txt



wget -q https://github.com/ayoubfathi/leaky-paths/archive/main.zip -O leaky-paths.zip 
unzip leaky-paths.zip
rm leaky-paths.zip
mv leaky-paths-main leaky-paths

#mkdir assetnote
#cd assetnote
#wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH -e robots=off
#rm assetnote/manual/raft-*

cd ..
tar -cJf wordlists.tar.xz wordlists/
rm -rf wordlists
