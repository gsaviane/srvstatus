python_interpreter = python3
# Watch out! Don't use /snap/bin. It would link to GLIBC outside snap
python_interpreter_path = /usr/bin/$(python_interpreter)
package_name = srvstatus
venv_path=/opt/$(package_name)
current_dir = $(shell pwd)
SHELL := /bin/bash

all:
	@echo "https://github.com/ratibor78/srvstatus"

install:
	@cd && mkdir -p $(venv_path) && \
		$(python_interpreter_path) -m venv --symlinks $(package_name) $(venv_path) && \
		$(venv_path)/bin/$(python_interpreter) -m ensurepip && \
		$(venv_path)/bin/pip3 install --upgrade setuptools wheel pip && \
		$(venv_path)/bin/pip3 install -r $(current_dir)/requirements.txt

	@cp service.py /usr/local/bin/$(package_name).py
	@cp eqiva.py /usr/local/bin/eqiva.py
	@cp -n srvstatus.ini /etc/telegraf/srvstatus.ini
	@cp 010-srvstatus.conf /etc/telegraf/telegraf.d/010-srvstatus.conf
	@cp 020-eqiva.conf /etc/telegraf/telegraf.d/020-eqiva.conf

	@chmod 750 /usr/local/bin/$(package_name).py
	@chmod 750 /usr/local/bin/eqiva.py
	@chown telegraf:telegraf /usr/local/bin/$(package_name).py
	@chown telegraf:telegraf /usr/local/bin/eqiva.py
	@chmod 644 /etc/telegraf/srvstatus.ini

	@systemctl reload telegraf.service

	@echo "srvstatus installed and enabled it in telegraf. Review your service conf in /etc/telegraf/srvstatus.ini"
