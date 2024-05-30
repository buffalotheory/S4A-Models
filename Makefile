# Makefile
#
# An original work by Bryant Hansen
#
# This describes a set of tools, techniques, and best-practices for managing
# a Deep-Learning-based Earth Observation project.
#
#  -- type 'make' on the command line, in the current directory, for help --
#
# The tools are generally launched from the command line, which is required
# by the top-level Pytorch Lightning framework.  It is not well-suited
# for notebooks and graphical displays would require significantly-greater
# complexity.
#
# The tools are generally Python commands executed from a shell environment
# These often have many options listed
# The Sen4AgriNet project lists a standard execution requires a list of
#
#
# This Makefile specifies a tab-completable set of commands, which can be
# executed on the bash shell.
#
# The commands are the most-common commands that are currently used in the
# project.  These commands are generally related to:
#
# 1. Building Train/Test Splits
# 2. Executing a model
# 3. Resuming execution after interruption
# 4. Conducting basic self-tests to verify the operating environment
# 5.
#
# This not only automates the general operations of the project, but it also
# serves to document these standard practices in a way that's clear, consise,
# and verifyable.
#
# There are many added benefits to using a Makefile for command-line project
# management:
#
# * Dependencies: lists of dependencies can be required for any stage
#
#   - Allows ordered sequences and dependency trees to be specified and executed
#   - Facilitates the execution of tasks in parallel
#     + Leaves can be executed as a large, parallel list
#     + Branches can also be executed in parallel
#     + All eventually meet at the end target, which may be part of a list
#
# * Parallel execution
#
# * Recursive self-referencing
#
# * Universally-available
#
#   Gnu Make runs on almost every platform, from the tiniest embedded shells,
#   to warehouse-scale computers
#
#
# ## Disadvantages
#
# * Poor support for spaces in file and directory names
#   - It is a long-standing tradition to use spaces as delimiters
#   - Nearly all data types are strings
#   - Some work-arounds are possible, but it becomes error-prone with
#     increasing complexity
#
#
# # Usage
#
# To get started, type 'make', a space, and the tab character twice
#
#    make <tab><tab>
#
# The list of available targets should appear below
#
# user@host -> make
# Makefile                    run_all
# default                     run_bigset1_convlstm
# help                        run_bigset79G_convlstm
# list_tests                  run_checkpoint_resume_test
# make_split                  run_multiset_convlstm
# metal_test                  run_overfit_convlstm
# overfit_lstm                run_pad_convstar
# pl_test                     run_unet
# resume_bigset1_convlstm     show_tests
# resume_bigset79G_convlstm   test_all
# resume_multiset_convlstm    view_paper
# resume_overfit_convlstm     wandb_test
#

REFS = ../references/papers
PAPER = $(REFS)/2022_A-Sentinel-2-multi-year-multi-country-benchmark-dataset-for-crop-classification-and-segmentation.pdf
VIEWER = evince

# A list of tests in the test directory
PYTESTS = \
    metal_test \
		pl_test \
		wandb_test

SHTESTS = $(basename $(shell ls run*.sh resume*.sh))

# Get a reference to the date of execution, in sortable form, with seconds-level
# accuracy
DT = $(shell date "+%Y%m%d_%H%M%S")

# Provide a list of targets that will not be expected to generate a file
.PHONY: \
	$(PYTESTS) \
	$(SHTESTS) \
	run_all \
	test_all \
	make_split \
	show_tests \
	view_paper

# If no options are specified
default: run_multiset_convlstm

help:

overfit_lstm:
	make run_overfit_convlstm \
	&& make resume_overfit_convlstm \
	&& make resume_overfit_convlstm

$(PYTESTS):
	make -C test $(@)

$(SHTESTS):
	time bash $(@).sh 2>&1 | tee logs/$(DT)_$(@).log
	nice nohup xz logs/$(DT)_$(@).log &

test_all:
	make $(PYTESTS)

run_all:
	make $(SHTESTS)

list_tests:
	@echo "test scripts: $(SH_TEST_FILES)"

make_split:
	# Produce a new train/val/test data split based on the entire dataset
	python3 coco_data_split.py --how='random' --data_path=../dataset/

view_paper:
	$(VIEWER) $(PAPER) &

#
# Footnote: calculating the number of options in the recommended form of the command
#
# The command specified in the README:
#
#    python pad_experiments.py --train --model convlstm --parcel_loss --weighted_loss --root_path_coco <coco_folder_path> --prefix_coco <coco_file_prefix> --netcdf_path <netcdf_folder_path> --prefix <run_prefix> --num_epochs 10 --batch_size 32 --bands B02 B03 B04 B08 --saved_medians --img_size 61 61 --requires_norm --num_workers 16 --num_gpus 1 --fixed_window

#
# Calculate the number of options chaining the commands: sed, grep, and wc
#  1. Put the command in a variable
#  2. Echo it to stdout and the pipeline
# ```
# echo "$command" | sed 's/ \-/\n  -/g' | grep -- - | wc -l
# ```
#      17
# _This command specifies 17 options_
#
# Display with line breaks:
#
# python pad_experiments.py
#  --train
#  --model convlstm
#  --parcel_loss
#  --weighted_loss
#  --root_path_coco <coco_folder_path>
#  --prefix_coco <coco_file_prefix>
#  --netcdf_path <netcdf_folder_path>
#  --prefix <run_prefix>
#  --num_epochs 10
#  --batch_size 32
#  --bands B02 B03 B04 B08
#  --saved_medians
#  --img_size 61 61
#  --requires_norm
#  --num_workers 16
#  --num_gpus 1
#  --fixed_window

#
# # References
#
#```
#@ARTICLE{
#  9749916,
#  author={Sykas, Dimitrios and Sdraka, Maria and Zografakis, Dimitrios and Papoutsis, Ioannis},
#  journal={IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing},
#  title={A Sentinel-2 multi-year, multi-country benchmark dataset for crop classification and segmentation with deep learning},
#  year={2022},
#  doi={10.1109/JSTARS.2022.3164771}
#}
#```
