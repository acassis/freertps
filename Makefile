SYSTEMS=native-posix               \
        #stm32f7_disco-metal        \
				stm32f4_disco-metal        

APPS=listener talker

#				wandrr_rs485_router-metal

.PHONY: all clean $(SYSTEMS)
all: $(SYSTEMS)

BUILT_SYSTEMS:=$(shell ls build)
BUILT_APPS:=$(foreach SYSTEM, $(BUILT_SYSTEMS), $(foreach APP, $(shell ls build/$(SYSTEM)/apps), $(SYSTEM).$(APP)))

$(SYSTEMS): %: build/%
	@echo $@
	cd build/$@ && cmake ../.. -DSYSTEM=$@ && make

build/%:
	mkdir -p $@

clean:
	-rm -rf build* build.*

OPENOCD=/usr/local/bin/openocd -f stm32/openocd/stlink-v2-1.cfg -f stm32/openocd/stm32f7-disco.cfg 
#7-disco.cfg
IMAGE=build.stm32/examples/listener.bin
IMAGE_START=0x08000000

#$(BUILT_APPS)

program:
	$(OPENOCD) -c "init; sleep 100; halt; sleep 100; flash write_image erase $(IMAGE) $(IMAGE_START); verify_image $(IMAGE) $(IMAGE_START); sleep 100; reset run; sleep 100; shutdown"

dump_flash:
	$(OPENOCD) -c "init; halt; flash banks; dump_image dump.bin $(IMAGE_START) 0x1000; reset run; shutdown"

gdb_server:
	$(OPENOCD) -c "init; halt"

gdb:
	arm-none-eabi-gdb build.stm32/examples/listener.elf -x stm32/openocd/gdb_init_commands

reset:
	$(OPENOCD) -c "init; sleep 100; halt; sleep 100; reset run; sleep 100; shutdown"
