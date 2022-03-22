#FROM openjdk:8-jdk
FROM azul/zulu-openjdk
 
LABEL maintainer "Johan van Soest <j.vansoest@maastrichtuniversity.nl>"
 
# Build time arguments
ARG download_link=https://email.ontotext.com/events/public/v1/encoded/track/tc/GD+113/cGJhF04/VX50LC576hMFW3xsVTb1qvhM5W5q0Twr4GYTjmN3pwdFN3q3pBV1-WJV7CgWWsW2tZS9G4fbLkQW8Nb3lK47Wbk2F3HWYlD5rjmN7dzp3Mrcv7SW7rckbB1R4Q8jW6KXQKq1s4Yc1W70PDt65QfKhXW3fBC2J5sYXXqW2zy2ph7Fvh2QW7l76R-2BM_J4W43m8Lf3bJNHDW7RMLr13qvvvQW3-s2L87SLL7GW4FSbs87mp7-gW9cZcBL4QHXrDN4Rzv361-xJ6W140Lc51N01mpW2_nmCw8j-7Q5V-RMm17BFlS6W2wX2LD8xfWZwW6l2xJP8g4QVFW2LLYK66-kmYJVJLP-B2wRb9GVTkP634x8WcQW4fK0t46wvCYJW21YTtv5SHCBMW4ZngWy6wqDShW7sc4wv1m0QRSW9jD9gr6Jh548W8dqJCb8ycGwH3byL1?_ud=bd1197c8-fbd9-4479-8992-6ef6dcf48225
ARG version=9.10.3
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

