


.PHONY : compress uncompress
.DEFAULT_GOAL := compress


capture:
	@mkdir -p output
	echo "compressing active apps"
	@docker exec -u 0 -it splunk /bin/bash -c 'cd /opt/splunk/etc/apps/ && tar czvf /opt/splunk_httpinput.tgz splunk_httpinput'
	@docker exec -u 0 -it splunk /bin/bash -c 'cd /opt/splunk/etc/apps/ && tar czvf /opt/lma.tgz lma'
	@echo "copying compressed configs to temp directory"
	@docker cp splunk:/opt/splunk_httpinput.tgz output/
	@docker cp splunk:/opt/lma.tgz output/
	@echo "You must now copy the files in the output directory to the configs directory... "


uncompress:
	mkdir -p temp
	cd temp && tar zxvf ../configs/lma.tgz
	cd temp && tar zxvf ../configs/splunk_httpinput.tgz
	@echo "You can now work on the files in the temp directory use command make compress to zip back up"

compress:
	mkdir -p output
	cd temp && tar --disable-copyfile -czvf ../output/lma.tgz lma
	cd temp && tar --disable-copyfile -czvf ../output/splunk_httpinput.tgz splunk_httpinput
	@echo "You must now copy the files in the output directory to the configs directory... "

