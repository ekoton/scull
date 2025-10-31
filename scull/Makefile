# Comment/uncomment the following line to disable/enable debugging
DEBUG := y

# Add your debugging flag (or not) to CFLAGS
ifeq ($(DEBUG),y)
  DEBFLAGS = -O -g -DSCULL_DEBUG # "-O" is needed to expand inlines
else
  DEBFLAGS = -O2
endif

#[kods]following below instructin, I replace EXTRA_CFLAGS with ccflags-y
#https://www.kernel.org/doc/Documentation/kbuild/makefiles.txt
#EXTRA_CFLAGS += $(DEBFLAGS)
#EXTRA_CFLAGS += -I$(LDDINC)
ccflags-y += $(DEBFLAGS)
ccflags-y += -I$(LDDINC)

ifneq ($(KERNELRELEASE),)
# call from kernel build system

#[kods]since there is a compile error for pipe.c using deprecated crate_proc_read_entry function and replacing it is bit tedious althouth it can be simillar fix to the one in main.c, I comment out pipe.c for now.
#pipe.c:372:9: error: implicit declaration of function ‘create_proc_read_entry’ [-Wimplicit-function-declaration]
#scull-objs := main.o pipe.o access.o
scull-objs := main.o

obj-m	:= scull.o

else

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) LDDINC=$(PWD)/../include modules

endif



clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions

depend .depend dep:
	$(CC) $(CFLAGS) -M *.c > .depend


ifeq (.depend,$(wildcard .depend))
include .depend
endif
