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
    && wget --directory-prefix=/usr/local/bin/ http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/hgsql \
    && chmod +x /usr/local/bin/hgsql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.txt.gz \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "db.user=root" >> .hg.conf && echo "db.password=genome" >> .hg.conf && echo "central.user=root" >> .hg.conf && echo "central.password=genome" >> .hg.conf && echo "central.db=hgcentral" >> .hg.conf && chmod 400 .hg.conf \
    && mkdir /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld \
    # && /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize \
    # && mysql -e "create database hg38" \
    # && cat kgXref.sql | mysql --user=root --database=hg38 \
    # && zcat kgXref.txt.gz | mysqlimport --user=root --database=hg38 \
    && cd -