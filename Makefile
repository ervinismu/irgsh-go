release:
	mkdir -p tmp
	cp chief/main.go tmp/chief-main.go
	cp builder/main.go tmp/builder-main.go
	cp repo/main.go tmp/repo-main.go
	cp cli/main.go tmp/cli-main.go
	cat tmp/chief-main.go | sed "s/IRGSH_GO_VERSION/$$(cat VERSION)/g" > chief/main.go
	cat tmp/builder-main.go | sed "s/IRGSH_GO_VERSION/$$(cat VERSION)/g" > builder/main.go
	cat tmp/repo-main.go | sed "s/IRGSH_GO_VERSION/$$(cat VERSION)/g" > repo/main.go
	cat tmp/cli-main.go | sed "s/IRGSH_GO_VERSION/$$(cat VERSION)/g" > cli/main.go
	make build
	mkdir -p irgsh-go/bin
	cp bin/* irgsh-go/bin/
	mkdir -p irgsh-go/etc/irgsh
	cp config.yml irgsh-go/etc/irgsh/
	mkdir -p irgsh-go/usr/share/irgsh
	cp -R share/* irgsh-go/usr/share/irgsh/
	tar -zcvf release.tar.gz irgsh-go
	rm -rf irgsh-go
	cp tmp/chief-main.go chief/main.go
	cp tmp/builder-main.go builder/main.go
	cp tmp/repo-main.go repo/main.go
	cp tmp/cli-main.go cli/main.go

build:
	mkdir -p bin
	cp chief/config.go builder/config.go
	cp chief/config.go repo/config.go
	go build -o ./bin/irgsh-chief ./chief
	go build -o ./bin/irgsh-builder ./builder
	go build -o ./bin/irgsh-repo ./repo
	go build -o ./bin/irgsh-cli ./cli
	rm builder/config.go
	rm repo/config.go

irgsh-chief:
	go build -o ./bin/irgsh-chief ./chief && ./bin/irgsh-chief

irgsh-builder-init:
	go build -o ./bin/irgsh-builder ./builder && ./bin/irgsh-builder init

irgsh-builder:
	go build -o ./bin/irgsh-builder ./builder && ./bin/irgsh-builder

irgsh-repo-init:
	go build -o ./bin/irgsh-repo ./repo && ./bin/irgsh-repo init

irgsh-repo:
	go build -o ./bin/irgsh-repo ./repo && ./bin/irgsh-repo

redis:
	docker run -d --network host redis

submit:
	curl --header "Content-Type: application/json" --request POST --data '{"sourceUrl":"https://github.com/BlankOn/bromo-theme.git","packageUrl":"https://github.com/BlankOn-packages/bromo-theme.git"}' http://localhost:8080/api/v1/submit
