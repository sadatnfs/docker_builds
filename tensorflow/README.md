NOTES:

The dockerfiles and installers necessary to complete several different tensorflow builds are contained here. These images contain python 3.5 and tensorflow 1.4.1 as well as some OS basics. More optimizations are preferrable if your CPU supports it. CPU-Z is a great tool for determining what instruction sets are compatible with your CPU if you are running on a local machine. The plain PyPI tensorflow wheel is meant to be broadly copmatible so it leaves out many instruction sets. Simply building from source without specifiying optimization flags (default -March=native) gets you some extra instructions tossed in, but it missed AVX2 on my test with a Kaby Lake notebook processor. Additionally, such a build may not be readily compatible on different machines since it was optimized for the machine it was built on, and this doesn't match our common workflow around here. This, in conjuction with relatively unknown variability of processor flags across use cases at the institute has led me to produce several different builds with different levels of optimization.

On the cluster, XXX

Each dockerfile includes a test script that will highlight missing instructions as well as, in the case of GPUs, log device placement to show access to the GPUs.


tf-full-cpu-gpu:

tf-vanilla-cpu:
this pip installs tensorflow, which results in the most broadly-compatible build. It has almost no fancy instruction sets. 
This does not include SSE4.1, SSE4.2, AVX, AVX2, and FMA

tf-vanilla-gpu:
This pip installs tensorflow-gpu, which results in th emost broadly-compatible build optimizaed for cuda.

tf-full-cpu:
this image contains 

tf-mkl:


a note about GPU builds:
These builds require a minimum GPU compute capability of 5.0. This is satisfied by the GPUs on the cluster as well as the GPUs I have seen in the Lenovo machines floating around. If you are unsure, CPU-Z (or device manager) yields GPU information and Nvidia provides compute capabilities. Currently, Tensorflow requires cuda toolkit version 8, though version 9 is released and this will likely change within the next version or two. cuda toolkit version 8 is compatible with cuDNN version 6, so that is included here as well. Nvidia doesn't provide an easy URL to download the cuda installers from so I have included them here and copy them in. The cuDNN installation process isn't actually facilitated by an installer, it requires manually copying around a header and libraries. 


Benchmarks don't show this being a significant speedup
https://medium.com/@andriylazorenko/tensorflow-performance-test-cpu-vs-gpu-79fcd39170c