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
    && echo "secure-file-priv = \"\"" >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize \
    && mysql -e "create database hg38" \
    && cd /var/lib/mysql/hg38/ \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/chromInfo.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/chromInfo.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/gap.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/gap.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/gold.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/gold.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/grp.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/grp.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/hgFindSpec.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/hgFindSpec.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/kgXref.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/knownGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.txt.gz \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/trackDb.sql \
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/trackDb.txt.gz \
    && gunzip chromInfo.txt.gz \
    && gunzip gap.txt.gz \
    && gunzip gold.txt.gz \
    && gunzip grp.txt.gz \
    && gunzip hgFindSpec.txt.gz \
    && gunzip kgXref.txt.gz \
    && gunzip knownGene.txt.gz \
    && gunzip refGene.txt.gz \
    && gunzip rmsk.txt.gz \
    && gunzip trackDb.txt.gz \
    && mv chromInfo.txt chromInfo.tsv \
    && mv gap.txt gap.tsv \
    && mv gold.txt gold.tsv \
    && mv grp.txt grp.tsv \
    && mv hgFindSpec.txt hgFindSpec.tsv \
    && mv kgXref.txt kgXref.tsv \
    && mv knownGene.txt knownGene.tsv \
    && mv refGene.txt refGene.tsv \
    && mv rmsk.txt rmsk.tsv \
    && mv trackDb.txt trackDb.tsv \
    && cat kgXref.sql | mysql --user=root --database=hg38 \
    && cat knownGene.sql | mysql --user=root --database=hg38 \
    && cat refGene.sql | mysql --user=root --database=hg38 \
    && cat rmsk.sql | mysql --user=root --database=hg38 \
    && mysqlimport --user root hg38 kgXref.tsv \
    && mysqlimport --user root hg38 knownGene.tsv \
    && mysqlimport --user root hg38 refGene.tsv \
    && mysqlimport --user root hg38 rmsk.tsv \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/tables.sql \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/confidence_score.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/confidence.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/dead_mirna.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/experiment_pre_read.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/experiment.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/literature_references.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_chromosome_build.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_mature.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_pre_mature.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_species.txt.gz \
    && gunzip confidence_score.txt.gz \
    && gunzip confidence.txt.gz \
    && gunzip dead_mirna.txt.gz \
    && gunzip experiment_pre_read.txt.gz \
    && gunzip experiment.txt.gz \
    && gunzip literature_references.txt.gz \
    && gunzip mirna_chromosome_build.txt.gz \
    && gunzip mirna_mature.txt.gz \
    && gunzip mirna_pre_mature.txt.gz \
    && gunzip mirna_species.txt.gz \
    && mv confidence_score.txt confidence_score.tsv \
    && mv confidence.txt confidence.tsv \
    && mv dead_mirna.txt dead_mirna.tsv \
    && mv experiment_pre_read.txt experiment_pre_read.tsv \
    && mv experiment.txt experiment.tsv \
    && mv literature_references.txt literature_references.tsv \
    && mv mirna_chromosome_build.txt mirna_chromosome_build.tsv \
    && mv mirna_mature.txt mirna_mature.tsv \
    && mv mirna_pre_mature.txt mirna_pre_mature.tsv \
    && mv mirna_species.txt mirna_species.tsv \
    && cat tables.sql | mysql --user=root --database=hg38 \
    && mysqlimport --user root hg38 confidence_score.tsv \
    && mysqlimport --user root hg38 confidence.tsv \
    && mysqlimport --user root hg38 dead_mirna.tsv \
    && mysqlimport --user root hg38 experiment_pre_read.tsv \
    && mysqlimport --user root hg38 experiment.tsv \
    && mysqlimport --user root hg38 literature_references.tsv \
    && mysqlimport --user root hg38 mirna_chromosome_build.tsv \
    && mysqlimport --user root hg38 mirna_mature.tsv \
    && mysqlimport --user root hg38 mirna_pre_mature.tsv \
    && mysqlimport --user root hg38 mirna_species.tsv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.sql *.tsv \
    && mysqladmin shutdown \
    && cd /