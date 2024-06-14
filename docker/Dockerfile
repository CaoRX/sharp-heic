FROM amazonlinux

WORKDIR /var/task

COPY work.sh .
COPY create-layer.sh .
COPY cleanup.sh .

ENV PATH="/opt/bin:${PATH}"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/opt/lib/pkgconfig:${PKG_CONFIG_PATH}"
ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:/opt/lib:${LD_LIBRARY_PATH}"

RUN chmod +x work.sh
RUN ./work.sh
RUN chmod +x create-layer.sh
RUN ./create-layer.sh
RUN chmod +x cleanup.sh
RUN ./cleanup.sh