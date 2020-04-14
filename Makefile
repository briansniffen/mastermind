description.md: helper.pl
	rm -f description.md
	echo '```' > description.md
	cat helper.pl >> description.md
	echo '```' >> description.md

jcb.html: description.md
	pandoc --standalone -r markdown+smart -w html -o jcb.html description.md
