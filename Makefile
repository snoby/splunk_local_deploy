


.PHONY : compress uncompress
.DEFAULT_GOAL := compress



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

