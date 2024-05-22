PYTESTS = \
    metal_test \
		pl_test \
		wandb_test

SHTESTS = \
		run_overfit_convlstm \
		resume_overfit_convlstm \
		run_multiset_convlstm \
		run_convstar \
		run_unet \

DT = $(shell date "+%Y%m%d_%H%M%S")

.PHONY: $(PYTESTS) $(SHTESTS) run_all test_all

default: run_multiset_convlstm

overfit_lstm:
	make run_overfit_convlstm \
	&& make resume_overfit_convlstm \
	&& make resume_overfit_convlstm

$(PYTESTS):
	make -C test $(@)

$(SHTESTS):
	time bash $(@).sh 2>&1 | uniq | tee logs/$(DT)_$(@).log
	xz logs/$(DT)_$(@).log &

test_all:
	make $(PYTESTS)

run_all:
	make $(SHTESTS)
