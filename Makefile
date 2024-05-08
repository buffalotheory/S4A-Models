PYTESTS = \
    metal_test \
		pl_test \
		wandb_test

SHTESTS = \
		run_convstar \
		run_pad_convlstm \
		run_unet \

#		run_checkpoint_resume_test \

.PHONY: $(PYTESTS) $(SHTESTS) run_all test_all

$(PYTESTS):
	make -C test $(@)

$(SHTESTS):
	time bash $(@).sh 2>&1 | tee logs/$(@).log

test_all:
	make $(PYTESTS)

run_all:
	make $(SHTESTS)
