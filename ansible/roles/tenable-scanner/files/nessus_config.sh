
debug
	msg:
		"Provisioning based on YOUR_KEY which is: {{ lookup('env', 'HOSTNAME') }}"

name: Copy Nessus Installer from Google Cloud Storage
shell: "gsutil cp gs://nessus-build-files/Nessus-8.10.0-es7.x86_64.rpm /tmp/Nessus-8.10.0-es7.x86_64.rpm"

name: Install Nessus rpm
yum:
	name: /tmp/Nessus-8.10.0-es7.x86_64.rpm
	state: present

name: Enable nessusd.service to deploy service file
systemd:
	name: nessusd
	enabled: True
	state: started

name: Copy nessus_config.sh file
copy:
	src: nessus_config.sh
	dest: /root/nessus_config.sh
	owner: root
	group: root
	mode: 0755

name: Add nessus_config.sh to nessusd.service ExecStartPre
linefile:
	path: /etc/systemd/system/multi-user.target.wants/nessusd.service
	insertbefore: "ExecStart"
	line: "ExecStartPre-/root/nessus_config.sh"

name: Restart nessusd.service
systemd:
	name: nessusd
	enabled: True
	state: restarted

debug
	msg:
		"Provisioning based on YOUR_KEY which is: {{ (lookup('env', 'HOSTNAME')) }}"
