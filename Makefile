TESTS = \
    metal_test \
		pl_test \
		wandb_test

.PHONY: $(TESTS)

$(TESTS):
	make -C test $(@)
