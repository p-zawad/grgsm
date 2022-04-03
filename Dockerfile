FROM pzawad/gnuradio
MAINTAINER Piotr ZAWADZKI "pzawadzki@polsl.pl"

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get install -y wireshark

RUN groupadd wireshark && usermod -a -G wireshark student

USER student

WORKDIR /home/student

ADD gr-gsm.tar.gz .
#RUN git clone https://github.com/ptrkrysik/gr-gsm
RUN mkdir gr-gsm/build
WORKDIR /home/student/gr-gsm/build
RUN cmake .. && \
    # The parallel build sometimes fails when the .grc_gnuradio
    # and .gnuradio directories do not exist
    mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/ && \
    make -j $(nproc) && \
    echo qwerty | sudo -S make install  && \
    echo qwerty | sudo -S sudo ldconfig  && \
    make CTEST_OUTPUT_ON_FAILURE=1 test
WORKDIR /home/student

ENV PYTHONPATH "${PYTHONPATH}:/usr/local/lib/python3/dist-packages"

CMD bash
