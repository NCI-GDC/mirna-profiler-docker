rm -f mirna/assets/mysql57.tar.gz
rm -rf mirna/assets/mysql57

cp -R mirna/assets/mysql57_fixed mirna/assets/mysql57
COPYFILE_DISABLE=1 tar -czf mirna/assets/mysql57.tar.gz -C mirna/assets mysql57
rm -rf mirna/assets/mysql57
