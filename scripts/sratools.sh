#!/bin/bash

cd /mnt/proj &&
	prefetch $RUN_ID &&
	cd $RUN_ID &&
	fasterq-dump ${RUN_ID}.sra
