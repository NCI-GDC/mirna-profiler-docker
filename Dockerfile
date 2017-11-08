FROM ubuntu:artful-20171019

ENV mirna-profiler 0.1

RUN apt-get update \
    && apt-get install -y \
    git \
    libdbi-perl \
    && git clone https://github.com/bcgsc/mirna.git \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*