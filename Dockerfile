FROM ubuntu:artful-20171019

ENV mirna-profiler 0.1
ENV mirna_userid 33
ENV mirna_user ubuntu
ENV mirna_groupid 33
ENV mirna_group ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
    git \
    libdbd-mysql-perl \
    libdbi-perl \
    mysql-client-5.7 \
    mysql-server-5.7 \
    r-base-core \
    sudo \
    vim \
    wget \
    && _group=$(getent group $mirna_groupid) && if [ -z $_group ]; then groupadd -g $mirna_groupid $mirna_group; \
    else group=$(echo $_group | cut -d: -f1 ); if [ "$group" != "$mirna_group" ];then groupmod -n $mirna_group $group ;fi;fi \
    && if $(id ${mirna_userid} 2>1 > /dev/null); then user=$(getent passwd "$mirna_userid" | cut -d: -f1 ); \
    if [ "$user" != "$mirna_user"  ]; then usermod -l $mirna_user $user;fi; \
    else adduser --disabled-password --gecos '' --uid $mirna_userid --gid $mirna_userid $mirna_user;fi \
    && adduser $mirna_user sudo && echo "$mirna_user    ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers.d/$mirna_user \
    && cd /usr/ \
    && git clone -b cwl https://github.com/NCI-GDC/mirna.git \
    && echo "hg38\tlocalhost\troot\t" >> /usr/mirna/v0.2.7/config/db_connections.cfg \
    && echo "mirbase\tlocalhost\troot\t" >> /usr/mirna/v0.2.7/config/db_connections.cfg \
    && chown -R ${mirna_user}.${mirna_group} /usr/mirna \
    && cd /root/ \
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
    && mysql -e "create database mirbase" \
    && cd /var/lib/mysql/mirbase/ \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/0_THIS_IS_RELEASE_21 \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/README \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/tables.sql \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/confidence_score.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/confidence.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/dead_mirna.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/experiment_pre_read.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/experiment.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/literature_references.txt.gz \    
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mature_pre_read.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mature_read_count_by_experiment.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mature_read_count.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_2_prefam.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna2wikipedia.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_chromosome_build.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_context.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_database_links.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_mature.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_prefam.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_pre_mature.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_pre_read.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_read_count_by_experiment.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_read_count.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_read_experiment_count.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_read.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_species.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_target_links.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna_target_url.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/mirna.txt.gz \
    && wget ftp://mirbase.org/pub/mirbase/CURRENT/database_files/wikipedia.txt.gz \
    && gunzip confidence_score.txt.gz \
    && gunzip confidence.txt.gz \
    && gunzip dead_mirna.txt.gz \
    && gunzip experiment_pre_read.txt.gz \
    && gunzip experiment.txt.gz \
    && gunzip literature_references.txt.gz \
    && gunzip mature_pre_read.txt.gz \
    && gunzip mature_read_count_by_experiment.txt.gz \
    && gunzip mature_read_count.txt.gz \
    && gunzip mirna_2_prefam.txt.gz \
    && gunzip mirna2wikipedia.txt.gz \
    && gunzip mirna_chromosome_build.txt.gz \
    && gunzip mirna_context.txt.gz \
    && gunzip mirna_database_links.txt.gz \
    && gunzip mirna_mature.txt.gz \
    && gunzip mirna_prefam.txt.gz \
    && gunzip mirna_pre_mature.txt.gz \
    && gunzip mirna_pre_read.txt.gz \
    && gunzip mirna_read_count_by_experiment.txt.gz \
    && gunzip mirna_read_count.txt.gz \
    && gunzip mirna_read_experiment_count.txt.gz \
    && gunzip mirna_read.txt.gz \
    && gunzip mirna_species.txt.gz \
    && gunzip mirna_target_links.txt.gz \
    && gunzip mirna_target_url.txt.gz \
    && gunzip mirna.txt.gz \
    && gunzip wikipedia.txt.gz \
    && mv confidence_score.txt confidence_score.tsv \
    && mv confidence.txt confidence.tsv \
    && mv dead_mirna.txt dead_mirna.tsv \
    && mv experiment_pre_read.txt experiment_pre_read.tsv \
    && mv experiment.txt experiment.tsv \
    && mv literature_references.txt literature_references.tsv \
    && mv mature_pre_read.txt mature_pre_read.tsv \
    && mv mature_read_count_by_experiment.txt mature_read_count_by_experiment.tsv \
    && mv mature_read_count.txt mature_read_count.tsv \
    && mv mirna_2_prefam.txt mirna_2_prefam.tsv \
    && mv mirna2wikipedia.txt mirna2wikipedia.tsv \
    && mv mirna_chromosome_build.txt mirna_chromosome_build.tsv \
    && mv mirna_context.txt mirna_context.tsv \
    && mv mirna_database_links.txt mirna_database_links.tsv \
    && mv mirna_mature.txt mirna_mature.tsv \
    && mv mirna_prefam.txt mirna_prefam.tsv \
    && mv mirna_pre_mature.txt mirna_pre_mature.tsv \
    && mv mirna_pre_read.txt mirna_pre_read.tsv \
    && mv mirna_read_count_by_experiment.txt mirna_read_count_by_experiment.tsv \
    && mv mirna_read_count.txt mirna_read_count.tsv \
    && awk 'BEGIN{FS=OFS="\t"}{print $1,$2,$3,$4}' mirna_read_count.tsv > mirna_read_count.tsv.trunc \
    && mv mirna_read_count.tsv.trunc mirna_read_count.tsv \
    && mv mirna_read_experiment_count.txt mirna_read_experiment_count.tsv \
    && mv mirna_read.txt mirna_read.tsv \
    && mv mirna_species.txt mirna_species.tsv \
    && mv mirna_target_links.txt mirna_target_links.tsv \
    && mv mirna_target_url.txt mirna_target_url.tsv \
    && mv mirna.txt mirna.tsv \
    && mv wikipedia.txt wikipedia.tsv \
    && cat tables.sql | mysql --user=root --database=mirbase \
    && mysqlimport --user root mirbase confidence_score.tsv \
    && mysqlimport --user root mirbase confidence.tsv \
    && mysqlimport --user root mirbase dead_mirna.tsv \
    && mysqlimport --user root mirbase experiment_pre_read.tsv \
    && mysqlimport --user root mirbase experiment.tsv \
    && mysqlimport --user root mirbase literature_references.tsv \
    && mysqlimport --user root mirbase mature_pre_read.tsv \
    && mysqlimport --user root mirbase mature_read_count_by_experiment.tsv \
    && mysqlimport --user root mirbase mature_read_count.tsv \
    && mysqlimport --user root mirbase mirna_2_prefam.tsv \
    && mysqlimport --user root mirbase mirna2wikipedia.tsv \
    && mysqlimport --user root mirbase mirna_chromosome_build.tsv \
    && mysqlimport --user root mirbase mirna_context.tsv \
    && mysqlimport --user root mirbase mirna_database_links.tsv \
    && mysqlimport --user root mirbase mirna_mature.tsv \
    && mysqlimport --user root mirbase mirna_prefam.tsv \
    && mysqlimport --user root mirbase mirna_pre_mature.tsv \
    && mysqlimport --user root mirbase mirna_pre_read.tsv \
    && mysqlimport --user root mirbase mirna_read_count_by_experiment.tsv \
    && mysqlimport --user root mirbase mirna_read_count.tsv \
    && mysqlimport --user root mirbase mirna_read_experiment_count.tsv \
    && mysqlimport --user root mirbase mirna_read.tsv \
    && mysqlimport --user root mirbase mirna_species.tsv \
    && mysqlimport --user root mirbase mirna_target_links.tsv \
    && mysqlimport --user root mirbase mirna_target_url.tsv \
    && mysqlimport --user root mirbase mirna.tsv \
    && mysqlimport --user root mirbase wikipedia.tsv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql/hg38/*.sql /var/lib/mysql/hg38/*.tsv /var/lib/mysql/mirbase/*.sql /var/lib/mysql/mirbase/*.tsv \
    && mysqladmin shutdown \
    && cd /
