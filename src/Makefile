CC:= g++

APP:= videoApp

SRCS:= $(wildcard *.cpp)

INCS:= $(wildcard *.h)

PKGS:= opencv

OBJS:= $(SRCS:.cpp=.o)

CFLAGS:= -I../../../includes

CFLAGS+= `pkg-config --cflags $(PKGS)`

LIBS:= `pkg-config --libs $(PKGS)`

# LIBS+= -lm \
#	-L ../util/json11 -ljson11
       #-Wl,-rpath,/usr/local/deepstream

all: $(APP)

.o: .c $(INCS) Makefile
	$(CC) -c -pthread -std=c++14 $@ $(CFLAGS) $<

$(APP): $(OBJS) Makefile
	$(CC) -o $(APP) $(OBJS) $(LIBS) -lpthread

clean:
	rm -rf $(OBJS) $(APP)
