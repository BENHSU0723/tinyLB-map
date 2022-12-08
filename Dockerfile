FROM ubuntu:20.04

RUN apt-get update && \
apt-get install -y clang llvm vim libelf-dev libpcap-dev gcc-multilib build-essential make sudo linux-tools-$(uname -r) linux-tools-generic

WORKDIR /ianchen

COPY Makefile ./Makefile
COPY libbpf ./libbpf
COPY xdp_kern.h ./xdp_kern.h
COPY xdp_lb_kern.h ./xdp_lb_kern.h
COPY xdp_lb_kern.c ./xdp_lb_kern.c
COPY xdp_lb_user.c ./xdp_lb_user.c
COPY xdp_lb_user.h ./xdp_lb_user.h

COPY main.py ./main.py

CMD [ "python", "main.py" ]