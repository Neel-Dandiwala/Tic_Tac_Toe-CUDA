IDIR=./
COMPILER=nvcc
COMPILER_FLAGS=-I$(IDIR) -I/usr/local/cuda/include -lcuda --std c++17

.PHONY: clean build run

build: tic_tac_toe.cu
	$(COMPILER) $(COMPILER_FLAGS) tic_tac_toe.cu -o tic_tac_toe.exe -Wno-deprecated-gpu-targets

clean:
	rm -f tic_tac_toe.exe

run:
	./tic_tac_toe.exe

all: clean build run
