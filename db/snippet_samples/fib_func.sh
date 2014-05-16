#!/bin/bash

fibbo=0;
temp=0;
for i in 'seq 0..20'; do
	echo -n "$fibbo"
	if [ $i = 1]; then
		$((fibbo)) = 1
	elif [ $i -gt 1]; then
		$((fibbo)) =
	fi
done