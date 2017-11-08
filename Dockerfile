FROM ubuntu:artful-20171019

ENV mirna-profiler 0.1

RUN apt-get update \
    && apt-get install -y \
    git \
    libdbi-perl \
    mysql-server-5.7 \
    wget \
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
    && wget http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/refGene.txt.gz \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*