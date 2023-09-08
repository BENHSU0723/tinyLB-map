FROM ubuntu:20.04

RUN apt-get update && \
apt-get install libelf-dev -y && \
apt-get install -y clang llvm vim libelf-dev libpcap-dev python3 gcc-multilib build-essential make sudo linux-tools-$(uname -r) linux-tools-generic

WORKDIR /ianchen

COPY Makefile ./Makefile
COPY libbpf ./libbpf
COPY xdp_lb_kern.h ./xdp_lb_kern.h
COPY xdp_lb_kern.c ./xdp_lb_kern.c
COPY xdp_lb_user.c ./xdp_lb_user.c
COPY main.py ./main.py

# CMD [ "python", "main.py" ]
# CMD ["cd", "libbpf/src"]
# CMD ["make" ,"install"]
# CMD ["cd", "-"]	