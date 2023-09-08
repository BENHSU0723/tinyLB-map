TARGET = xdp_lb
MAP_FILE =xdp_map

BPF_TARGET = ${TARGET:=_kern}
BPF_C = ${BPF_TARGET:=.c}
BPF_OBJ = ${BPF_C:.c=.o}

xdp: $(BPF_OBJ)
	bpftool net detach xdpgeneric dev eth0
	rm -f /sys/fs/bpf/$(TARGET)
	sudo bpftool prog load $(BPF_OBJ) /sys/fs/bpf/$(TARGET)
	bpftool net attach xdpgeneric pinned /sys/fs/bpf/$(TARGET) dev eth0
	# bpftool map create /sys/fs/bpf/$(MAP_FILE) type hash key 8 value 4 entries 256 name hash_map

pre: 
	bash -c "cd libbpf/src && make install"
	bash -c "cp libbpf/src/libbpf.so.0.5.0 /lib/x86_64-linux-gnu && cd /lib/x86_64-linux-gnu &&\
	ln -s libbpf.so.0.5.0 libbpf.so.0 && ln -s libbpf.so.0 libbpf.so && cd /ianchen"

run: xdp
	# bash -c "python main.py"
	gcc xdp_lb_user.c -o xdp_lb_user -l bpf
	# ./xdp_lb_user 

$(BPF_OBJ): %.o: %.c
	clang -S \
	    -target bpf \
	    -D __BPF_TRACING__ \
	    -Ilibbpf/src\
	    -Wall \
	    -Wno-unused-value \
	    -Wno-pointer-sign \
	    -Wno-compare-distinct-pointer-types \
	    -Werror \
	    -O2 -emit-llvm -c -o ${@:.o=.ll} $<
	llc -march=bpf -filetype=obj -o $@ ${@:.o=.ll}

clean:
	bpftool net detach xdpgeneric dev eth0
	rm -f /sys/fs/bpf/$(TARGET)
	rm $(BPF_OBJ)
	rm ${BPF_OBJ:.o=.ll}
