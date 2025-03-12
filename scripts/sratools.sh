#!/bin/bash

cd /mnt/proj/$WORK_DIR &&
	prefetch $RUN_ID &&
	cd $RUN_ID &&
	fasterq-dump ${RUN_ID}.sra
