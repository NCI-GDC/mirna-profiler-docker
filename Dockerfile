FROM ubuntu:artful-20171019

ENV mirna-profiler 0.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
    git \
    libdbi-perl \
    mysql-client-5.7 \
    mysql-server-5.7 \
    vim \
    wget \
    && cd /root/ \
    && git clone https://github.com/bcgsc/mirna.git \
    && mkdir /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld \
    && echo "secure-file-priv = \"\"" >> /etc/mysql/mysql.conf.d/mysqld.cnf
    && /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize \
    && mysql -e "create database hg38" \
    && cd /var/lib/mysql/hg38/
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.txt.gz \
    && gunzip kgXref.txt.gz \
    && gunzip knownGene.txt.gz \
    && gunzip refGene.txt.gz \
    && gunzip rmsk.txt.gz \
    && mv kgXref.txt kgXref.tsv \
    && mv knownGene.txt knownGene.tsv \
    && mv refGene.txt refGene.tsv \
    && mv rmsk.txt rmsk.tsv \
    && cat kgXref.sql | mysql --user=root --database=hg38 \
    && cat knownGene.sql | mysql --user=root --database=hg38 \
    && cat refGene.sql | mysql --user=root --database=hg38 \
    && cat rmsk.sql | mysql --user=root --database=hg38 \
    && mysqlimport --user root hg38 kgXref.tsv \
    && mysqlimport --user root hg38 knownGene.tsv \
    && mysqlimport --user root hg38 refGene.tsv \
    && mysqlimport --user root hg38 rmsk.tsv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cd /