#!/bin/bash
apt-get -y update
apt-get -y install createrepo rpm dpkg-dev python-pip
pip install fuel-plugin-builder

pushd ..

fpb --build fuel-plugin-celebrer
for rpm in $(find . -name *.rpm -print); do
    scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $rpm root@linachan.ru:/var/www/files/artifacts/
done

popd
