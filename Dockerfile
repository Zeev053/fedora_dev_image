
FROM zeevb/dev_docker:C_14.02__gcc8.5 As GCC8.5-Image

# ---------------------------------------------------

FROM fedora:40

USER 0

COPY --from=GCC8.5-Image /usr/local/gcc/gcc8.5 /usr/local/gcc/gcc8.5

#ARG CMAKE_VERSION=3.26.0
ARG GTEST_VERSION=1.15.2
ARG BOOST_VERSION_DOT=1.86.0
ARG BOOST_VERSION_UNDERSCORE=1_86_0
ARG BENCHMARK_VERSION=1.8.0
#ENV NODE_EXTRA_CA_CERTS=/etc/ca-bundle.crt
#ENV REQUESTS_CA_BUNDLE=/etc/ca-bundle.crt
#ENV SSL_CERT_FILE=/etc/ca-bundle.crt

LABEL name="fedora41" \
	  GoogleTestVersion="$GTEST_VERSION" \
	  BoostVersion="$BOOST_VERSION_DOT" \
	  #CMakeVersion="$CMAKE_VERSION" \
	  BenchmarkVersion="$BENCHMARK_VERSION"

# ADD https://netfree.link/dl/unix-ca.sh /home/netfree-unix-ca.sh 
RUN curl  https://netfree.link/dl/unix-ca.sh | sh && update-ca-trust   
 

RUN dnf -y clean all; dnf -y update ; dnf -y update --refresh  && \
    dnf -y group install "c-development" "development-tools"  && \
    dnf -y install man man-pages man-db --setopt='tsflags='  && \
	dnf -y install python3 python3-pip python3-devel	 && \
	#
	#
	echo which python3: ; \ 
	which python3 ; \ 
	echo python3 --version ; \ 
	python3 --version ; \ 
	python3 -m pip install -U pip ; \ 
	pip3 install wheel ; \
	pip3 install twine ; \
	pip3 install pytest-cov ; \
	pip3 install pytest-spec ; \
	pip3 install conan ; \
	pip3 install  matplotlib  ; \
	pip3 install elasticsearch  ; \
	pip3 install selenium  ; \
	pip3 install pika  ; \
	pip3 install rticonnextdds-connector  ; \
    pip3 install numpy==1.26.4  ; \
	pip3 install junit-xml  ; \
	pip3 install unittest2py3k  ; \
	pip3 install unittest2  ; \
	pip3 install unittest-xml-reporting  ; \
	pip3 install pytest  ; \
	pip3 install nose  ; \
	pip3 install tox  ; \
	pip3 install pandas  ; \
	pip3 install xlrd  ; \
	pip3 install jira  ; \
	pip3 install debugpy  ; \
	pip3 install docker  ; \
	pip3 install kubernetes  ; \
	pip3 install docker-compose  ; \
	pip3 install colorama  ; \
	pip3 install gcovr  ; \
	pip3 install junitparser  ; \
	pip3 install colorlog  ; \
	pip3 install plotly  ; \
	pip3 install yq  ; \
	pip3 install xq  ; \
	pip3 install hq  ; \
	pip3 install pick  ; \
	pip3 install dominate  ; \
	pip3 install python-git  ; \
	pip3 install tk  ; \
	pip3 install west  ; \
	pip3 install mat4py  ; \
	pip3 install matplotlib  ; \
	pip3 install ipython  ; \
	pip3 install jupyter  ; \
	pip3 install sympy  ; \
	pip3 install nose  ; \
	pip3 install python-gitlab  ; \
	pip3 install psutil  ; \
	pip3 install flask  ; \
	pip3 install gitlabber  ; \
	pip3 install conan-package-tools  ; \
	pip3 install python-jenkins  ; \
	pip3 install rtpy  ; \
	pip3 install flake8  ; \
	pip3 install python-engineio  ; \
	pip3 install bidict  ; \
	pip3 install socketio  ; \
	pip3 install Flask-SocketIO  ; \
	pip3 install mypy  ; \
	pip3 install pytest-cov  ; \
	pip3 install scipy ; \
	pip3 install allure-pytest ; \
	pip3 install ansible ; \
	pip3 install git+https://github.com/rancher/client-python.git@master ; \
	pip3 install pygccxml clang pycparser gitpython; \
	python3 -m pip install -U pip ; #  

	#
	# Prepare OneAPI repo
RUN echo [oneAPI] > /etc/yum.repos.d/oneAPI.repo ; \ 
	name=Intel® oneAPI repository >> /etc/yum.repos.d/oneAPI.repo ; \ 
	baseurl=https://yum.repos.intel.com/oneapi >> /etc/yum.repos.d/oneAPI.repo ; \ 
	enabled=1 >> /etc/yum.repos.d/oneAPI.repo ; \ 
	gpgcheck=1 >> /etc/yum.repos.d/oneAPI.repo ; \ 
	repo_gpgcheck=1 >> /etc/yum.repos.d/oneAPI.repo ; \ 
	gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB >> /etc/yum.repos.d/oneAPI.repo ; \ 
	#
	# Install all packages
    dnf -y install glibc libstdc++ libstdc++-docs libgcc glibc-langpack-en gcc gcc-c++ gdb sudo openssl openssl-devel net-tools bind-utils gdb-gdbserver ipcgull-devel\
  	   tcpdump  \
	   qt5-qtbase-devel \
	   qt5-qtwebkit-devel libstdc++.i686 glibc.i686 \
	   qt-devel vim-enhanced vim-ansible wget iperf3 iperf nano openssh libXt-devel xorg-x11-server-Xvfb \
       iputils openssh-server openssh-clients rsync nc traceroute nmap \
       graphviz texlive texlive-latex libcgroup libcgroup-tools opencv-devel \
	   ninja-build doxygen doxygen-latex doxygen-doxywizard bash-completion moreutils \
	   tree xmlstarlet nodejs libnsl ansible tcsh python3-tkinter valgrind  \ 
	   qcachegrind hostname motif motif-devel gedit colordiff wdiff meld nfs-utils \
	   cifs-utils samba-client samba xstream perf valgrind java-devel ncurses-devel xterm \
	   flex bison binutils-devel elfutils-devel elfutils-libelf-devel texinfo zlib-devel cmake pkgconfig hotspot rr \
	   numactl-devel numactl-libs numactl numatop tbb-bind topline \
	   castxml clang clang-analyzer clang-devel clang-libs clang-resource-filesystem clang-tools-extra python3-clang clang-tools-extra-devel \
	   helm glab \
	   isl-devel.x86_64 isl-devel.i686 isl.i686 isl.x86_64 gmp gmp-devel \
	   mpfr  mpfr-devel libmpc libmpc-devel \
	   libgphobos-static gcc-gnat gcc-gdc glibc-devel.i686 dejagnu autogen npm && \
    # dnf -y --releasever=37 install kompose  && \
    dnf install -y ngrep hiera lsyncd sshpass lcov jq ccache lapack-devel dwarves  && \
    dnf install -y libasan libasan-static libatomic libatomic-static liblsan liblsan-static libtsan libtsan-static libubsan libubsan-static && \
	#libhwasan libhwasan-static 
	dnf update -y && \
    dnf clean all -y && \
	echo && \
	echo Set gcc alternatives && \
	alternatives --install /usr/local/bin/gcc gcc  /usr/bin/gcc 1 \
      --slave /usr/local/bin/g++ g++ /usr/bin/g++ \
      --slave /usr/local/bin/gcc-ar gcc-ar /usr/bin/gcc-ar \
      --slave /usr/local/bin/gcc-nm gcc-nm /usr/bin/gcc-nm \
      --slave /usr/local/bin/gcc-ranlib gcc-runlib /usr/bin/gcc-ranlib  && \
	alternatives --install /usr/local/bin/gcc gcc /usr/local/gcc/gcc8.5/bin/gcc-8.5 20 \
      --slave /usr/local/bin/g++ g++ /usr/local/gcc/gcc8.5/bin/g++-8.5 \
      --slave /usr/local/bin/gcc-ar gcc-ar /usr/local/gcc/gcc8.5/bin/gcc-ar-8.5 \
      --slave /usr/local/bin/gcc-nm gcc-nm /usr/local/gcc/gcc8.5/bin/gcc-nm-8.5 \
      --slave /usr/local/bin/gcc-ranlib gcc-runlib /usr/local/gcc/gcc8.5/bin/gcc-ranlib-8.5  && \
    alternatives --set gcc /usr/bin/gcc

# Give to root empty password
RUN echo "root:1" | chpasswd

# Install kubectl
RUN pushd /tmp/ && \
	mkdir kubectl && \ 
	cd kubectl && \
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
	curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
	echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
	kubectl version --client && \
	cd .. && \
	rm -f -r kubectl && \
	# echo 'source <(kubectl completion bash)' >> /root/.bashrc && \
	# kubectl completion bash > /etc/bash_completion.d/kubectl && \
	# echo 'alias k=kubectl' >> /root/.bashrc && \
	# echo 'complete -F __start_kubectl k' >> /root/.bashrc && \
	popd

# Install iperf2 yq rancher cli
RUN pushd /tmp/ && \
	#wget https://iperf.fr/download/fedora/iperf-2.0.8-2.fc23.x86_64.rpm && \
	#yum -y install ./iperf-2.0.8-2.fc23.x86_64.rpm && \
    #rm -rf iperf-2.0.8-2.fc23.x86_64.rpm && \
    #yum clean all -y; \
	wget https://github.com/rancher/cli/releases/download/v2.6.11/rancher-linux-amd64-v2.6.11.tar.gz -O - | \
		tar xz && ls -las ; mv rancher-v2.6.11/rancher /usr/bin/rancher ; ls -lsa /usr/bin ; \
	popd
#	wget https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64.tar.gz -O - | \
#		tar xz && mv yq_linux_amd64 /usr/bin/yq ; ls -lsa /usr/bin ; \

## Install cmake
#RUN pushd /tmp/ && \
#	wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
#	tar xvf cmake-${CMAKE_VERSION}.tar.gz && \
#    cd cmake-${CMAKE_VERSION} && \
#    ./bootstrap --prefix=/usr/local && \
#    make -j$(nproc) && \
#    make install && \
#    rm -rf cmake-3*.* && \
#	cd .. && \
#	rm -r cmake-${CMAKE_VERSION} && \
#	rm -r cmake-${CMAKE_VERSION}.tar.gz && \
#	popd && \
#    dnf clean all -y && \
#	cd /infra ; git clone https://github.com/bilke/cmake-modules.git


# Install google test
RUN pushd /tmp/ && \
    wget https://github.com/google/googletest/releases/download/v${GTEST_VERSION}/googletest-${GTEST_VERSION}.tar.gz  && \
	tar zxvf googletest-${GTEST_VERSION}.tar.gz && \
	mkdir googleBuild  && \
	cd googleBuild  && \
	cmake /tmp/googletest-${GTEST_VERSION}  && \
	cmake -Dgtest_build_samples=ON /tmp/googletest-${GTEST_VERSION}  && \
	make install && \
	make clean	 && \
	cd /tmp/	 && \
	rm -rf v${GTEST_VERSION}.tar.gz && \
	rm -rf googletest-${GTEST_VERSION} && \
	rm -rf googleBuild && \
	popd


## Install google benchmark
RUN pushd /tmp/ && \
	mkdir benchmark_install && cd benchmark_install && \
    wget https://github.com/google/benchmark/archive/refs/tags/v${BENCHMARK_VERSION}.tar.gz  && \
    tar zxvf v${BENCHMARK_VERSION}.tar.gz && \
	cd benchmark-${BENCHMARK_VERSION}  && \
	cmake -E make_directory "build"  && \
	cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=on -DBENCHMARK_ENABLE_ASSEMBLY_TESTS=off -DCMAKE_BUILD_TYPE=Release -S . -B "build" && \
	cmake --build "build" --config Release -- "-j20" && \
	cmake -E chdir "build" ctest --build-config Release && \
	sudo cmake --build "build" --config Release --target install && \
	cmake --build "build" --config Release --target clean && \
	cd /tmp/	 && \
	rm -rf benchmark_install && \
	popd


# wget https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION_DOT}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz  && \
# Install Boost
RUN pushd /tmp/ && \
	echo gcc version: && \
	gcc --version && \
	echo g++ version: && \	
	g++ --version && \	
	wget https://archives.boost.io/release/${BOOST_VERSION_DOT}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz  && \	
    tar zxf boost_${BOOST_VERSION_UNDERSCORE}.tar.gz && \
	cd boost_${BOOST_VERSION_UNDERSCORE} && \
	echo Start boost installation: && \	
	echo Call bootstrap.sh: && \
	./bootstrap.sh --with-toolset=gcc && \
	echo Call b2 install: && \
	./b2 install && \
	cd /tmp/ && \
	rm -rf zxvf boost_${BOOST_VERSION_UNDERSCORE}.tar.gz && \
	rm -rf boost_${BOOST_VERSION_UNDERSCORE} && \
	popd

# Install docker in docker
# RUN dnf install docker-ce --nobest
# RUN curl -sSL https://get.docker.com/ | sh
# 	RUN pushd /tmp/ && \
# 	dnf -y module enable container-tools && \
# 	dnf -y install container-selinux && \
# 	dnf -y module disable container-tools && \
# 	curl -sSL https://get.docker.com/ | sh && \
# 		popd

# 	RUN pushd /tmp/ && \
# 		dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && \
# 		dnf makecache && \
# 		dnf -y install --nobest docker-ce && \
# 		curl -L https://github.com/docker/compose/releases/download/1.25.1-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
# 		chmod +x /usr/local/bin/docker-compose && \
# 		popd

#        https://github.com/google/googletest/archive/refs/tags/v1.13.0.tar.gz

# Intall vue
# RUN npm install -g @vue/cli yarn 

# Install selenium
 RUN pushd /tmp/ && \
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
	dnf -y install ./google-chrome-stable_current_*.rpm && \
#	yum -y install xorg-x11-server-Xvfb && \
    rm -rf google-chrome-stable_current_*.rpm && \
    dnf clean all -y  && \
	popd


# Copy extra files to the image.
COPY ./root/ /

# ENV HOME=/home/vscode \
#    PATH=${HOME}/bin:/opt/rh/devtoolset-3/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# Create new users
RUN mkdir -p /workspaces && \
	chmod 777 /workspaces && \
	groupadd -f --gid 1000 vscode && \
	adduser --uid 1000 --gid 1000 -d /home/vscode vscode && \
	chown -R 1000:1000 /home/vscode /workspaces /usr/bin/container-entrypoint /usr/bin/usage && \
	chmod u+x /usr/bin/startSSH.sh  && \
	chmod u+x /usr/bin/usage  && \
	chmod u+x /usr/bin/container-entrypoint && \
	echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	sed -i -e 's/^# \(%wheel\s\+.\+\)/\1/gi' /etc/sudoers  && \
    sed -i -e '0,/^\(%wheel\s\+.\+\)/s//#\1/' /etc/sudoers && \
	useradd -G wheel kube && \
	echo "kube:1" | chpasswd  && \
    echo "kube ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# USER 1000

RUN mkdir -p /var/run/sshd; \
    yes|ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''; \
    yes|ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''; \
    yes|ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''; \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
	sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config; \
	sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config; \
    mkdir -p /root/.ssh/; \
    rm -f /var/lib/rpm/.rpm.lock; \
    echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
    echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
#     /usr/bin/ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''; \
#     /usr/bin/ssh-keygen -y -t rsa -f /root/.ssh/id_rsa > ~/.ssh/id_rsa.pub; \
#     /usr/bin/cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys; \
#     cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys; \
#     chmod a-r /root/.ssh/authorized_keys; \
#     chmod g-r /root/.ssh/authorized_keys; \ 

    mkdir -p /home/kube/.ssh/; \
    echo "StrictHostKeyChecking=no" > /home/kube/.ssh/config; \
    echo "UserKnownHostsFile=/dev/null" >> /home/kube/.ssh/config; \
    echo 'source <(kubectl completion bash)' >> /home/kube/.bashrc && \
    echo 'alias k=kubectl' >> /home/kube/.bashrc && \
    echo 'complete -F __start_kubectl k' >> /home/kube/.bashrc && \
    echo "alias ll='ls -lah'" >> /root/.bashrc;  \
    echo "alias ll='ls -lah'" >> /home/kube/.bashrc;
	

### install sonarqube
RUN cd /usr/bin/ && \
	wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip && \
	unzip sonar-scanner-cli-4.6.2.2472-linux.zip && \
	rm -f sonar-scanner-cli-4.6.2.2472-linux.zip && \
	/usr/bin/sonar-scanner-4.6.2.2472-linux/bin/sonar-scanner -v 

# install intel oneapi
RUN cd /tmp && mkdir oneapi_install && cd oneapi_install && \
	#
	wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/e6ff8e9c-ee28-47fb-abd7-5c524c983e1c/l_BaseKit_p_2024.2.1.100_offline.sh && \
	sh ./l_BaseKit_p_2024.2.1.100_offline.sh -f installer/ -a -s --eula accept  && \
	#
	wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/d461a695-6481-426f-a22f-b5644cd1fa8b/l_HPCKit_p_2024.2.1.79_offline.sh  && \
	sh ./l_HPCKit_p_2024.2.1.79_offline.sh -f installer/ -a -s --eula accept && \
	#
	cd /tmp && rm -rf oneapi_install 
	#echo "source /opt/intel/oneapi/setvars.sh" >> ~/.bashrc


EXPOSE 22

# Set the default CMD to print the usage of the language image
CMD ["/usr/bin/startSSH.sh"]

