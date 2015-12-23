if [[ -f "/etc/centos-release" ]];
  then
    yum install createrepo dpkg-devel dpkg-dev rpm rpm-build
  else
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolf.conf > /dev/null
    sudo apt-get update
    sudo apt-get install createrepo rpm dpkg-dev
fi;

fpb --build .
cp -Rf celebrer*.rpm $HOME/builded_plugin

cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "travis-ci"
git config --global push.default simple
git clone --quiet httsp://${GITHUB_TOKEN}@github.com/molecul/molecul.github.io > /dev/null
cd molecul.github.io
cp -Rf $HOME/builded_plugin/celebrer*.rpm files/fuel-plugin-celebrer_last.rpm
git add -f .
git commit -m "Update fuel-plugin-celebrer (Travis Build: $TRAVIS_BUILD_NUMBER@$TRAVIS_TAG)"
git push -fq origin > /dev/null
