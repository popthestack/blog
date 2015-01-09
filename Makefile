deploy: gen
	rsync -glpPrtvz public/ myhost:/my/path/to/ryanmartinsen.com/public_html

gen:
	rm -rf public/*
	hugo
	# Now remove the taxonomy feeds.
	find public/*/** -name index.xml|xargs rm
	rm -rf public/categories

server:
	rm -rf public/*
	hugo server -w --buildFuture=true

draft_server:
	hugo server -w --buildDrafts=true
