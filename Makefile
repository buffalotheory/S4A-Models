PYTESTS = \
    metal_test \
		pl_test \
		wandb_test

SHTESTS = $(basename $(shell ls run*.sh resume*.sh))

DT = $(shell date "+%Y%m%d_%H%M%S")

.PHONY: $(PYTESTS) $(SHTESTS) run_all test_all make_split show_tests

default: run_multiset_convlstm

overfit_lstm:
	make run_overfit_convlstm \
	&& make resume_overfit_convlstm \
	&& make resume_overfit_convlstm

$(PYTESTS):
	make -C test $(@)

$(SHTESTS):
	time bash $(@).sh 2>&1 | uniq | tee logs/$(DT)_$(@).log
	nice nohup xz logs/$(DT)_$(@).log &

test_all:
	make $(PYTESTS)

run_all:
	make $(SHTESTS)

show_tests:
	@echo "test scripts: $(SH_TEST_FILES)"

make_split:
	python3 coco_data_split.py --how='random' --data_path=../dataset/
