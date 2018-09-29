#!/bin/bash

#example cat /proc/cpuinfo | grep flags output:
# flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms


# we will assume allprocessors per node are identical.
# below are the instruction set combinations expected
# to be possible on cluster nodes based on survey

# SSE3 SSE4_1 SSE4_2 FMA AVX
# SSE3 SSE4_1 SSE4_2 FMA AVX AVX2
# SSE3 SSE4_1 SSE4_2 AVX

# these combinations are what I have built against. Others
# may exist, these may change. Further, there are many subtle
# variations of these instructions sets that can appear.

CPU_FLAGS=$(grep -m 1 flags /proc/cpuinfo)
TF_FLAGS=($(echo "$CPU_FLAGS" | egrep -o -m 1 '(sse[34]|avx|fma)[^ ]*'))

# construct associative array of the tf flags
declare -A has_flag
for flag in ${TF_FLAGS[*]}; do has_flag[$flag]=true; done

imgbase="/share/singularity-images/health_fin/tensorflow"

# default image, maximum compatibility
imgname="tf-vanilla-cpu"

if [[ -n ${has_flag[sse3]} && ${has_flag[sse4_1]} && ${has_flag[sse4_2]} && ${has_flag[avx]} ]]
then
    imgname="tf-kirk"
fi

if [[ -n ${has_flag[sse3]} && ${has_flag[sse4_1]} && ${has_flag[sse4_2]} && ${has_flag[fma]} && ${has_flag[avx]} ]]
then
    imgname="tf-picard"
fi

if [[ -n ${has_flag[sse3]} && ${has_flag[sse4_1]} && ${has_flag[sse4_2]} && ${has_flag[fma]} && ${has_flag[avx]} && ${has_flag[avx2]} ]]
then
    imgname="tf-sisko"
fi

printf "$CPU_FLAGS\n\n"
printf "Tensorflow-relevant flags: ${TF_FLAGS[*]}\n\n"
printf "Singularity image run: ${imgbase}/${imgname}.img\n\n"

#singularity exec "${imgbase}/${runimg}" python "$@"

