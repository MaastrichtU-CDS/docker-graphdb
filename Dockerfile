#FROM openjdk:8-jdk
FROM azul/zulu-openjdk
 
LABEL maintainer "Johan van Soest <j.vansoest@maastrichtuniversity.nl>"
 
# Build time arguments
ARG download_link=https://email.ontotext.com/events/public/v1/track/tc/VW41bB7nqF54W5N3Rhx2c7jFJW3hB9jJ4dnhQDN9cd5Jc3p_b1V1-WJV7Cg_3cW2kSTQH10j8TzW7jb7HP6vyrFcW6b2Qv14yxzxSW40qt5h6YlX5NW6LwBJQ46xZdmW2b143T8rc5F6N22P0f1t9xX9V3BVzv41FfFLW746Cg64ryg-7W72Zrsr7KzH0qW9m4HBX1kwkPvW7ldBxC749N2rW91D6Yl25MQMCW1gdFb53zvPgxN7sdN5sDSkyxW241xt-5bzg-LW8f-4Jh6RkRtGW2JPzT65zwqkTW1JvY5T6JVvQbN4JKc21W-zZ7W2zFdvk3GJbF_W8wC_1f72gM_FW5NDcgL5DhCDPW72tnjC2n4jCVW2ChGh61PMW0-W652nN76nckGsW2rxc8n88WCmGW6HkRh25qhhthVLlPQM1dw0HRW1r6bHN63CRpB3fN41?_ud=9db2144b-eda7-4dc9-a4d9-2e56de833119
ARG version=9.3.3
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

