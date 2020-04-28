#FROM openjdk:8-jdk
FROM azul/zulu-openjdk
 
LABEL maintainer "Johan van Soest <j.vansoest@maastrichtuniversity.nl>"
 
# Build time arguments
ARG download_link=https://email.ontotext.com/events/public/v1/track/c/*W2g0kbs6vwfGnW6sYY4F5c3FYP0/*W2V2_FC4s_nylW3Vxwdk8bqSYQ0/5/f18dQhb0S1Xn6Xvx7LSp6m2_XzCMW714HfK471mD6W4ndk9T4vNt-tW3TdwlF5B5yrBW1nsNk15ynJRXW3pmDVl6NFPYNW29jBG-14WJwPW3R421Z8wmxK-W3FBng-7YnwXYW6nPYPG3Kd7QWW6ZkxsS5scyVNTpnzj3VlYfLN8yFdTyDb1FvW4tyLmQ4QJG1zW3wry3v7ctP6kW3DyNLV229GpYW4ynt872hrWcGW2pXRSW1KXrPCW1MYct726vk63W1QN2my5l2zbyW4rlvTt6WN8mFN1tvgZGXpMl1W1d9c7v5-gYYXW7K3qMG7BZTfvW4kYT881J1mB6W1MwJyb4st-HsVqVMvm4FD9-SW4LZS2k4s4zX2W2vVYcW2N3XSgW3GYcxC51WpRTV_6BH412XsfmW1mkYQ22HSJbKW7j9ZgK6679PZVkRrFz4qq3XrW5WlvkL548cBrW8qGv0Z4djfyKN8RHfmtpB7k3W8RmLDp8CDWBdW6_grzP2lK58SW6F7kJz6XfmXrW66bHZp3-YYMsW5WRnF-6bQhLyW7JMRNq8DlBykW4zQz2z11NwFtW8gHtQP7k8kl-W53Xz6L7dnm4pW5Sr_M26N134cW8z3dN098bLTZW978ZHl9c5r6JW8FPqcP6Y2qMkN2G_pxwM45f7111?_ud=0d96749c-45e5-4b32-bca2-01c89bd352fc
ARG version=9.2.0
ARG edition=free
 
# Environment variables, to be used for the docker image
ENV GDB_HEAP_SIZE=2g
ENV GDB_MIN_MEM=1g
ENV GDB_MAX_MEM=2g
 
ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home
ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist

RUN apt-get update && \
    apt-get install -y unzip curl

# Copy the installation file recieved after registration
#ADD graphdb-${edition}-${version}-dist.zip /tmp
RUN curl -L -o /tmp/graphdb-${edition}-${version}-dist.zip ${download_link}
 
RUN mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-${edition}-${version}-dist.zip && \
    mv graphdb-${edition}-${version} dist && \
    mkdir -p ${GRAPHDB_HOME} && \
    rm /tmp/graphdb-${edition}-${version}-dist.zip
 
ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH
 
CMD ["-Dgraphdb.home=/opt/graphdb/home -Dorg.xml.sax.driver=com.sun.org.apache.xerces.internal.parsers.SAXParser -Djdk.xml.entityExpansionLimit=1000000"]
 
ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]
 
EXPOSE 7200

