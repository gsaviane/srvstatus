python_interpreter = python3
# Watch out! Don't use /snap/bin. It would link to GLIBC outside snap
python_interpreter_path = /usr/bin/$(python_interpreter)
package_name = srvstatus
current_dir = $(shell pwd)
SHELL := /bin/bash

all:
	@echo "https://github.com/ratibor78/srvstatus"

install:
	@cd && \
		$(python_interpreter_path) -m venv --symlinks $(package_name) && \
		$(package_name)/bin/$(python_interpreter) -m ensurepip && \
		$(package_name)/bin/pip3 install --upgrade setuptools wheel pip && \
		$(package_name)/bin/pip3 install -r $(current_dir)/requirements.txt

	@cp service.py /usr/local/bin/$(package_name).py
	@cp srvstatus.ini /etc/telegraf/srvstatus.ini
	@cp 010-srvstatus.conf /etc/telegraf/telegraf.d/010-srvstatus.conf

	@chmod 750 /usr/local/bin/$(package_name).py
	@chmod 644 /etc/telegraf/srvstatus.ini

	@systemctl reload telegraf.service

	@echo "srvstatus installed and enabled it in telegraf'"
